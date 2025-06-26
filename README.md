---
wikilink: false
---

# wikilink.nvim

Automatically creates new note files from custom link patterns in your Markdown
or text files whenever you save the buffer. Created with AI 🙂

Inspired by the `[[wiki-style]]` format from tools like **Obsidian**.

- `[[featureFileName]]` will create feature on `featureLocation`.
- `#TagName` will use to create tags, if missing will create under `tagLocation`
- Every file can have custom tag and feature location on top of md files. E.g gonna check on top section

## ✨ Features

If missing files name or tag, create one

- [x] auto create feature files `[[featureName]]` in featureFolder
- [x] auto create tag files `#tagName` in tags folder.
- [x] optional root/project level config
- [x] optional file level config which will be on top
- [x] ignore level

## 🛠 Installation (using `lazy.nvim`)

Create a `wikilink.lua` inside plugins and paste,

```lua
return {
  "yeasin50/wikilink.nvim",
  config = function()
    require("wikilink").setup({
      extension = "md",                      -- optional (default: "md")
      featurePattern = "%[%[([%w%-%_/%s]+)%]%]", -- optional (default pattern for features)
      tagPattern = "#([%w%-_]+)",           -- optional (default pattern for tags)
      featureLoc = "features",              -- optional (default: "features" folder)
      tagLoc = "tags",                      -- optional (default: "tags" folder)
      -- wikilink = true,                   -- optional: enable/disable globally (default: true), better use enable at top
    })
  end,
  ft = { "markdown", "md" },                -- optional: lazy load on markdown files only
}
```

## 📁 Project-Specific Configuration

Create `.wikilink.lua` on root of your project and return lua table.

```
return {
	extension = "md",
	featurePattern = "%[%[([%w%-%_/%s]+)%]%]", -- default feature link pattern
	tagPattern = "#([%w%-_]+)", -- default tag pattern
	featureLoc = "test/project_features", -- relative path from project root
	tagLoc = "test/project_tags", -- relative path from project root
	wikilink = true, -- enable wikilink globally by default
}
```

## File level Configuration

Top of your markdown file. You can simple disable for file with `wikilink: false`.
Others Configuration

```md
---
wikilink: true
featureLoc: /home/yeasin/github/wikilink.nvim/test/features
tagLoc: /home/yeasin/github/wikilink.nvim/test/tags
---

Keep writing and this [[feature1]] will create inside featureLoc's folder.
And #myTag inside tagLoc.

Lets have another [[feature2]]
```

---

Made with ❤️ for Neovim users who love note-taking.
