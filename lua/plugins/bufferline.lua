return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        always_show_bufferline = true,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Files",
            text_align = "left",
          },
        },
      },
    },
  },
}
