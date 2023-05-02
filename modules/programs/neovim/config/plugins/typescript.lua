local typescript_loaded, typescript = pcall(require, "typescript")
if typescript_loaded then
  typescript.setup({})
end
