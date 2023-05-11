local diffview_loaded, diffview = pcall(require, "diffview")

if diffview_loaded then
  diffview.setup({})
end
