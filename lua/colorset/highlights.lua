local M = {}

function M.register_additional_highlights()
	vim.cmd([[hi! link SubCursor Cursor]])
	vim.cmd([[hi! Underlined guisp=fg]])
end

function M.register_lsp_highlights()
	-- -- DefaultErrorLine - ソースコード中のエラー行の強調。通常は薄赤背景。
	-- -- DefaultError - ソースコード中のエラー部分のハイライト。通常は波線。
	-- -- DefaultErrorText - エラーメッセージ等を表示するハイライト。通常は赤色。
	-- -- (Warn, Info, Hint も同様)
	-- vim.cmd [[
	--   hi!      DefaultErrorLine guibg=NONE guifg=NONE
	--   hi!      DefaultWarnLine  guibg=NONE guifg=NONE
	--   hi!      DefaultInfoLine  guibg=NONE guifg=NONE
	--   hi!      DefaultHintLine  guibg=NONE guifg=NONE
	--   hi! link DefaultError SpellBad
	--   hi! link DefaultWarn  SpellCap
	--   hi!      DefaultInfo  guibg=NONE guifg=NONE
	--   hi!      DefaultHint  guibg=NONE guifg=NONE
	--   hi! link DefaultErrorText Error
	--   hi!      DefaultWarnText guibg=NONE guifg=NONE
	--   hi!      DefaultInfoText guibg=NONE guifg=NONE
	--   hi!      DefaultHintText guibg=NONE guifg=NONE
	--   hi! link DefaultErrorTextOnErrorLine DefaultErrorText
	--   hi! link DefaultWarnTextOnWarnLine DefaultWarnText
	--   hi! link DefaultInfoTextOnInfoLine DefaultInfoText
	--   hi! link DefaultHintTextOnHintLine DefaultHintText
	--   hi! link DefaultReference Search
	--
	--   " coc
	--   hi! link CocErrorSign DefaultErrorText
	--   hi! link CocErrorVirtualText DefaultErrorText
	--   hi! link CocErrorHighlight DefaultError
	--   hi! link CocWarningSign DefaultWarnText
	--   hi! link CocWarningVirtualText DefaultWarnText
	--   hi! link CocWarningHighlight DefaultWarn
	--   hi! link CocHintSign DefaultHintText
	--   hi! link CocHintVirtualText DefaultHintText
	--   hi! link CocHintHighlight DefaultHint
	--   hi! link CocInfoSign DefaultInfoText
	--   hi! link CocInfoVirtualText DefaultInfoText
	--   hi! link CocInfoHighlight DefaultInfo
	--   hi! link CocHighlightText DefaultReference
	--   hi! link CocRustChainingHint NonText
	--   hi! link CocRustTypeHint NonText
	--   hi! link CocCodeLens NonText
	--
	--   " Built-in LSP
	--   hi! link DiagnosticError DefaultErrorText
	--   hi! link DiagnosticSignError DefaultErrorText
	--   hi! link DiagnosticUnderlineError DefaultError
	--   hi! link DiagnosticWarn DefaultWarnText
	--   hi! link DiagnosticSignWarn DefaultWarnText
	--   hi! link DiagnosticUnderlineWarn DefaultWarn
	--   hi! link DiagnosticHint DefaultHintText
	--   hi! link DiagnosticSignHint DefaultHintText
	--   hi! link DiagnosticUnderlineHint DefaultHint
	--   hi! link DiagnosticInfo DefaultInfoText
	--   hi! link DiagnosticSignInfo DefaultInfoText
	--   hi! link DiagnosticUnderlineInfo DefaultInfo
	--   hi! link ReferenceText DefaultReference
	--   hi! link ReferenceRead LspReferenceText
	--   hi! link ReferenceWrite LspReferenceText
	--   hi! link LspCodeLens NonText
	--
	--   " vim-lsp
	--   hi! link LspErrorHighlight DefaultError
	--   hi! link LspErrorVirtualText DefaultErrorText
	--   hi! link LspErrorText DefaultErrorText
	--   hi! link LspWarningHighlight DefaultWarn
	--   hi! link LspWarningVirtualText DefaultWarnText
	--   hi! link LspWarningText DefaultWarnText
	--   hi! link LspInformationHighlight DefaultInfo
	--   hi! link LspInformationVirtualText DefaultInfoText
	--   hi! link LspInformationText DefaultInfoText
	--   hi! link LspHintHighlight DefaultHint
	--   hi! link LspHintVirtualText DefaultHintText
	--   hi! link LspHintText DefaultHintText
	--   hi! link lspReference DefaultReference
	-- ]]
end

function M.register_semantic_tokens_highlights()
	vim.cmd([[
    hi link Namespace Include
    hi link Class Type
    hi link Enum Class
    hi link Interface Class
    hi link Struct Class
    hi link TypeParameter Class
    "hi link Type Type
    hi link Parameter Variable
    hi link Variable Identifier
    hi link Property Variable
    hi link EnumMember Constant
    hi link Event Variable
    "hi link Function Function
    hi link Method Function
    "hi link Macro Constant
    hi link Label Constant
    "hi link Comment Comment
    "hi link String String
    "hi link Keyword Keyword
    "hi link Number Number
    hi link Regexp Constant
    "hi link Operator
  ]])
end

function M.register_treesitter_highlights()
	-- -- カラフルすぎるのでハイライトを一部修正する
	-- hi.define('@variable', { gui = 'NONE' })
	-- hi.define('@variable.member', { gui = 'NONE' })
	-- -- hi.define('@variable.builtin', { gui = 'NONE' }) -- 組み込み変数 (例: self, this)
	--
	-- -- 関数名・メソッド名 (例: function my_func() ...)
	-- hi.define('@function', { gui = 'NONE' })
	-- hi.define('@function.call', { gui = 'NONE' })
	-- hi.define('@function.method', { gui = 'NONE' })  -- 組み込み関数 (例: print)
	-- hi.define('@function.method.call', { gui = 'NONE' })
	-- hi.define('@function.builtin', { gui = 'NONE' }) -- 組み込み関数 (例: print)
	-- hi.define('@function.macro', { gui = 'NONE' })   -- マクロ
	-- hi.define('@method', { gui = 'NONE' })           -- メソッド呼び出し
	--
	-- -- 型名 (例: string, MyClass)
	-- hi.define('@type', { gui = 'NONE' })
	-- hi.define('@type.builtin', { gui = 'NONE' }) -- 組み込み型 (例: int, bool)
	--
	-- -- 定数 (例: MY_CONSTANT)
	-- hi.define('@constant', { gui = 'NONE' })
	-- hi.define('@constant.builtin', { gui = 'NONE' }) -- 組み込み定数 (例: true, false, nil)
	--
	-- -- 名前空間・モジュール名 (例: require('my.module'))
	-- hi.define('@namespace', { gui = 'NONE' })
	-- hi.define('@module', { gui = 'NONE' }) -- Lua の require など
	--
	-- -- パラメータ・引数 (例: function(my_param) ...)
	-- hi.define('@parameter', { gui = 'NONE' })
	--
	-- -- プロパティ (例: obj.my_prop)
	-- hi.define('@property', { gui = 'NONE' })
	--
	-- -- タグ (HTML/XML/JSXなど)
	-- hi.define('@tag', { gui = 'NONE' })
	-- hi.define('@tag.attribute', { gui = 'NONE' })
	-- hi.define('@tag.delimiter', { gui = 'NONE' })
	--
	-- -- YAML
	-- hi.define('@string.yaml', { gui = 'NONE' })
	--
	-- -- diff
	-- hi.link('@diff.minus.diff', 'DiffDelete')
	-- hi.link('@diff.plus.diff', 'DiffAdd')
	-- hi.link('@text.diff.delete.diff', 'DiffDelete')
	-- hi.link('@text.diff.add.diff', 'DiffAdd')
end

function M.register_gitsigns()
	vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
	vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
	vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
end

function M.register_coc_highlights()
	vim.api.nvim_set_hl(0, "CocSymbolLine", { link = "StatusLine" })
	vim.api.nvim_set_hl(0, "CocSymbolLineSeparator", { link = "StatusLine" })
	vim.api.nvim_set_hl(0, "CocSymbolLineEllipsis", { link = "StatusLine" })
	vim.api.nvim_set_hl(0, "CocFloatActive", { link = "Special" })
	vim.api.nvim_set_hl(0, "CocUnderline", { sp = "fg" })
	vim.api.nvim_set_hl(0, "CocFloating", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "CocListLine", { link = "CursorLine" })
	vim.api.nvim_set_hl(0, "CocCodeLens", { link = "NonText" })
end

function M.register_notify_highlights()
	vim.api.nvim_set_hl(0, "NotifyERRORBody", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "NotifyWARNBody", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "NotifyINFOBody", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "NotifyTRACEBody", { link = "NormalFloat" })
end

---Get all highlight registration functions
---@return fun()[]
function M.get_default_hooks()
	return {
		M.register_additional_highlights,
		M.register_semantic_tokens_highlights,
		M.register_treesitter_highlights,
		M.register_gitsigns,
		M.register_coc_highlights,
		M.register_lsp_highlights,
		M.register_notify_highlights,
	}
end

return M