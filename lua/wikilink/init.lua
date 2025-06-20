local M = {}

local default_config = {
  extension = "md",
  pattern = "%[%[([%w%-%_/%s]+)%]%]",
  location = nil,
}

local function load_project_config()
  local root = vim.fn.getcwd()
  local config_path = root .. "/.wikilink.lua"
  if vim.fn.filereadable(config_path) == 1 then
    local ok, project_config = pcall(dofile, config_path)
    if ok and type(project_config) == "table" then
      return project_config
    end
  end
  return {}
end

local function checkAndUpdate(config)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content = table.concat(lines, "\n")

  for link in content:gmatch(config.pattern) do
    local filename = vim.fn.trim(link):gsub("%s+", "_") .. "." .. config.extension
    local target_dir

    if config.location then
      target_dir = vim.fn.expand(config.location)
    else
      local current_file = vim.api.nvim_buf_get_name(0)
      target_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    local path = target_dir .. "/" .. filename
    if vim.fn.filereadable(path) == 0 then
      vim.fn.mkdir(target_dir, "p")
      local f = io.open(path, "w")
      if f then
        f:write("# " .. link .. "\n")
        f:close()
        vim.notify("Created: " .. path, vim.log.levels.INFO)
      else
        vim.notify("Failed to create: " .. path, vim.log.levels.ERROR)
      end
    end
  end
end

function M.setup(user_config)
  local global_config = vim.tbl_extend("force", default_config, user_config or {})

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*." .. global_config.extension,
    callback = function()
      local project_config = load_project_config()
      local final_config = vim.tbl_extend("force", global_config, project_config)
      checkAndUpdate(final_config)
    end,
  })
end

return M
