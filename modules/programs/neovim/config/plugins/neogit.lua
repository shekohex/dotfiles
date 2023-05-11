local neogit_loaded, neogit = pcall(require, "neogit")

if neogit_loaded then
  neogit.setup({
    disable_builtin_notifications = false,
    integrations = {
      diffview = pcall(require, "diffview"),
    },
  })
end
