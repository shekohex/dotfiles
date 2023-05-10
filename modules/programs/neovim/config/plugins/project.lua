local project_loaded, project = pcall(require, "project_nvim")

if project_loaded then
  project.setup({
    exclude_dirs = {
      "~/.cargo/*",
      "~/.local/*",
      "~/.npm/*",
      "~/.cache/*",
    },
  })
end
