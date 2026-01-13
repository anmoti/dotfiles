return {
  {
    "nvim-mini/mini.icons",
    opt = {
      style = "glyph",
    },
    opts = {
      style = "glyph",
    },
    config = function(_, opts)
      local icons = require("mini.icons")
      icons.setup(opts)
      -- 他のプラグインが nvim-web-devicons を探したときに mini.icons を返すようにする
      icons.mock_nvim_web_devicons()
    end,
  },
}
