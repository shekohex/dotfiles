local mini_animate_loaded, mini_animate = pcall(require, "mini.animate")
if mini_animate_loaded then
  mini_animate.setup({})
end

local mini_comment_loaded, mini_comment = pcall(require, "mini.comment")
if mini_comment_loaded then
  mini_comment.setup({})
end

local mini_indentscope_loaded, mini_indentscope = pcall(require, "mini.indentscope")
if mini_indentscope_loaded then
  mini_indentscope.setup({
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
  })
end

local mini_move_loaded, mini_move = pcall(require, "mini.move")
if mini_move_loaded then
  mini_move.setup({})
end

local mini_pairs_loaded, mini_pairs = pcall(require, "mini.pairs")
if mini_pairs_loaded then
  mini_pairs.setup({})
end

local mini_surround_loaded, mini_surround = pcall(require, "mini.surround")
if mini_surround_loaded then
  mini_surround.setup({})
end
