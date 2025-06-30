local M = {}

-- Default plugin configuration
local default_config = {
	extension = "md",
	featurePattern = "%[%[([%w%._%-/ ]+)%]%]",
	tagPattern = "#([%w%-_]+)",
	featureLoc = "features",
	tagLoc = "tags",
	wikilink = true,
}

-- Load project-level config from .wikilink.lua
local function load_project_config()
	local root = vim.fn.getcwd()
	local config_path = root .. "/.wikilink.lua"
	if vim.fn.filereadable(config_path) == 1 then
		local ok, project_config = pcall(dofile, config_path)
		if ok and type(project_config) == "table" then
			return project_config
		else
			vim.notify("Failed to load .wikilink.lua", vim.log.levels.WARN)
		end
	end
	return {}
end

-- Extract file-level config from YAML front-matter
local function extract_file_header_config()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, 20, false)
	local config = {}
	local in_header = false

	for _, line in ipairs(lines) do
		if line:match("^%-%-%-") then
			in_header = not in_header
		elseif in_header then
			local key, value = line:match("^(%w+):%s*(.+)$")
			if key and value then
				value = vim.fn.trim(value)
				-- Convert "false" and "true" strings to booleans
				if value == "false" then
					value = false
				elseif value == "true" then
					value = true
				end
				config[key] = value
			end
		end
	end

	return config
end

-- Ensure a file exists with optional content
local function ensure_file(path, title)
	if vim.fn.filereadable(path) == 0 then
		vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
		local f = io.open(path, "w")
		if f then
			f:write("# " .. title .. "\n")
			f:close()
			vim.notify("Created file: " .. path, vim.log.levels.INFO)
		else
			vim.notify("Failed to create file: " .. path, vim.log.levels.ERROR)
		end
	end
end

-- Main logic
local function check_and_create(config)
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local content = table.concat(lines, "\n")

	-- Merge file-level config
	local file_config = extract_file_header_config()
	config = vim.tbl_extend("force", config, file_config)

	if config.wikilink == false then
		return
	end

	-- Debug merged config
	vim.notify("[AutoCreate] Using config: " .. vim.inspect(config), vim.log.levels.DEBUG)

	-- Process features
	for link in content:gmatch(config.featurePattern) do
		local slug = vim.fn.trim(link):gsub("%s+", "_")
		local path = string.format("%s/%s.%s", config.featureLoc, slug, config.extension)
		ensure_file(path, link)
	end

	-- Process tags
	for tag in content:gmatch(config.tagPattern) do
		-- Ensure it's not preceded by another '#' or space (rudimentary lookbehind)
		local valid_tag = content:match("[^#]%#" .. tag) or content:match("^#" .. tag)
		if valid_tag then
			local path = string.format("%s/%s.%s", config.tagLoc, tag, config.extension)
			ensure_file(path, "#" .. tag)
		end
	end
end

-- Setup
function M.setup(user_config)
	local global_config = vim.tbl_extend("force", default_config, user_config or {})

	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*." .. global_config.extension,
		callback = function()
			local project_config = load_project_config()

			local merged = vim.tbl_extend("force", global_config, project_config)
			check_and_create(merged)
		end,
	})
end

return M
