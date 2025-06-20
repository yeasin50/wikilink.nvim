# wikilink.nvim

---

Automatically creates new note files from custom link patterns in your Markdown
or text files whenever you save the buffer. Created with AI 🙂

Inspired by the `[[wiki-style]]` and `{{templated-style}}` formats from tools like **Obsidian**.

---

## ✨ Features

- Detects custom link patterns like `[[My Note]]` or `{{Another Note}}`
- Automatically creates the target file if it doesn't already exist
- Configurable:
  - File extension (e.g., `md`, `txt`, `org`)
  - Link pattern (e.g., `[[...]]`, `{{...}}`)
  - Target location (e.g., `~/notes`, relative paths, or project-specific folders)
- (TODO)Supports project-specific overrides via `.note-linker.lua`

---

## 🛠 Installation (using `lazy.nvim`)

```lua
{
  "yeasin50/wikilink.nvim",
  config = function()
    require("note-linker").setup({
      extension = "txt", -- optional (default: "md")
      pattern = "%{%{([%w%-%_/%s]+)%}%}", -- optional
      location = "~/notes" -- optional (default: same directory as file)
    })
  end
}
```

## 🔧 Configuration Options

| Option      | Type              | Default                                 | Description                                    |
| ----------- | ----------------- | --------------------------------------- | ---------------------------------------------- |
| `extension` | `string`          | `"md"`                                  | File extension for created notes               |
| `pattern`   | `string`          | `%[%[([%w%-%_/%s]+)%]%]`                | Lua pattern for matching links                 |
| `location`  | `string` \| `nil` | `nil` (uses current buffer's directory) | Where to save new files (absolute or relative) |

---

## 🔍 Link Pattern Reference

- To match `[[My Note]]`, use:

  ```lua
  pattern = "%[%[([%w%-%_/%s]+)%]%]" -- default
  ```

- To match `{{My Note}}`, use:
  ```lua
  pattern = "%{%{([%w%-%_/%s]+)%}%}"
  ```

---

## TODO : 📁 Project-Specific Configuration

You can override settings per project by creating a `.wikilink.lua` file in the root of your project:

```lua
-- .note-linker.lua
return {
  extension = "txt",
  pattern = "%{%{([%w%-%_/%s]+)%}%}",
  location = "./docs"
}
```

This will be automatically loaded and merged with your global config on save.

---

## 📄 License

MIT

---

Made with ❤️ for Neovim users who love note-taking.
