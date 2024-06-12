return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "typescript-language-server",
      "tailwindcss-language-server",
      "stylua",
      "html-lsp",
      "css-lsp",
      "prettierd",
      -- "ruff",
      "pyright",
      "black",
      "rust-analyzer",
      "eslint-lsp",
    },
  },
}
