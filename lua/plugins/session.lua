local function is_placeholder_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  if vim.bo[buf].buftype ~= "" or vim.bo[buf].modified then
    return false
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" then
    return vim.fn.isdirectory(name) == 1
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return #lines == 1 and lines[1] == ""
end

local function has_persistence_session(persistence)
  local files = {
    persistence.current(),
    persistence.current({ branch = false }),
  }

  for _, file in ipairs(files) do
    if type(file) == "string" and vim.fn.filereadable(file) == 1 then
      return true
    end
  end

  return false
end

return {
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = {
      branch = false,
    },
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

      local startup_group = vim.api.nvim_create_augroup("user-startup", { clear = true })

      vim.api.nvim_create_autocmd("StdinReadPre", {
        group = startup_group,
        callback = function() vim.g.started_with_stdin = true end,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = startup_group,
        callback = function()
          if vim.g.started_with_stdin then
            return
          end

          local argc = vim.fn.argc()
          local target_dir
          local startup_buf = vim.api.nvim_get_current_buf()

          if argc == 0 then
            local lines = vim.api.nvim_buf_get_lines(startup_buf, 0, -1, false)
            local is_empty = #lines == 1 and lines[1] == ""

            if vim.bo[startup_buf].buftype ~= "" or vim.bo[startup_buf].modified or vim.api.nvim_buf_get_name(startup_buf) ~= "" or not is_empty then
              return
            end

            target_dir = vim.uv.cwd()
          elseif argc == 1 then
            local arg = vim.fn.argv(0)
            if vim.fn.isdirectory(arg) == 1 then
              target_dir = vim.fn.fnamemodify(arg, ":p")
              vim.cmd.cd(target_dir)
            end
          end

          if not target_dir then
            return
          end

          vim.schedule(function()
            if has_persistence_session(persistence) then
              persistence.load()

              if is_placeholder_buffer(startup_buf)
                  and vim.api.nvim_get_current_buf() ~= startup_buf
                  and #vim.fn.win_findbuf(startup_buf) == 0 then
                pcall(vim.api.nvim_buf_delete, startup_buf, { force = true })
              end

              return
            end

            require("lazy").load({ plugins = { "snacks.nvim" } })
            Snacks.explorer({ cwd = target_dir })

            if not vim.api.nvim_buf_is_valid(startup_buf) or vim.api.nvim_get_current_buf() == startup_buf then
              return
            end

            if is_placeholder_buffer(startup_buf) then
              pcall(vim.api.nvim_buf_delete, startup_buf, { force = true })
            end
          end)
        end,
      })
    end,
  },
}
