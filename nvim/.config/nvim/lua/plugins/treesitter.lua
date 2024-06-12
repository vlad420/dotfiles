return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- defaults
      "vim",
      "lua",
      "vimdoc",

      -- configs
      "toml",

      -- web dev
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",

      -- scripting
      "python",

      -- low level
      "rust",
    },
  },
}
