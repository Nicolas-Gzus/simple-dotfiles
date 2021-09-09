" let g:OmniSharp_translate_cygwin_wsl = 1

" let g:OmniSharp_selector_findusages = 'fzf'
" let g:OmniSharp_selector_ui = 'fzf'

let g:OmniSharp_diagnostic_showid = 1
let g:OmniSharp_diagnostic_exclude_paths = [
    \ '[Tt]emp',
    \ 'obj',
    \ '[Ll]ibrary',
    \ '**\\Unity\\Hub'
    \]
" IDE0055: Fix formatting - display in ALE as `Warning` style error
" CS8019: Duplicate of IDE0005
" RemoveUnnecessaryImportsFixable: Generic warning that an unused using exists
let g:OmniSharp_diagnostic_overrides = {
    \ 'IDE0055': {'type': 'W', 'subtype': 'Style'},
    \}

" popups 
let g:OmniSharp_popup_position = 'peek'

if has('nvim')
    let g:OmniSharp_popup_options = {
                \ 'winhl': 'Normal:NormalFloat'
                \}
else
    let g:OmniSharp_popup_options = {
                \ 'highlight': 'Normal',
                \ 'padding': [0, 0, 0, 0],
                \ 'border': [1]
                \}
endif

let g:OmniSharp_popup_mappings = {
            \ 'sigNext': '<C-n>',
            \ 'sigPrev': '<C-p>',
            \}

" snippets
if g:using_snippets
    let g:OmniSharp_want_snippet = 1
endif

let g:OmniSharp_highlight_groups = {
            \ 'ExcludedCode': 'NonText'
            \}

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nmap <buffer> <leader>gd <Plug>(omnisharp_go_to_definition)
    autocmd FileType cs nmap <buffer> <leader>fu <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <buffer> <leader>fi <Plug>(omnisharp_find_implementations)
    autocmd FileType cs nmap <buffer> <leader>fs <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <buffer> <leader>pd <Plug>(omnisharp_preview_definition)
    autocmd FileType cs nmap <buffer> <leader>pi <Plug>(omnisharp_preview_implementations)
    autocmd FileType cs nmap <buffer> <leader>tl <Plug>(omnisharp_type_lookup)
    autocmd FileType cs nmap <buffer> <leader>doc <Plug>(omnisharp_documentation)
    autocmd FileType cs nmap <buffer> <leader>xu <Plug>(omnisharp_fix_usings)
    autocmd filetype cs nmap <buffer> <c-\> <Plug>(omnisharp_signature_help)
    autocmd filetype cs imap <buffer> <c-\> <Plug>(omnisharp_signature_help)

    " Navigate up and down by method/property/field
    autocmd FileType cs nmap <buffer> [[ <Plug>(omnisharp_navigate_up)
    autocmd FileType cs nmap <buffer> ]] <Plug>(omnisharp_navigate_down)
    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nmap <buffer> <leader>cc <Plug>(omnisharp_global_code_check)
    " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
    autocmd FileType cs nmap <buffer> <leader>ca <Plug>(omnisharp_code_actions)
    autocmd FileType cs xmap <buffer> <leader>ca <Plug>(omnisharp_code_actions)
    " Repeat the last code action performed (does not use a selector)
    " autocmd FileType cs nmap <buffer> <leader>car <Plug>(omnisharp_code_action_repeat)
    " autocmd FileType cs xmap <buffer> <leader>car <Plug>(omnisharp_code_action_repeat)

    autocmd FileType cs nmap <buffer> <leader>cf <Plug>(omnisharp_code_format)

    autocmd FileType cs nmap <buffer> <leader>r <Plug>(omnisharp_rename)

    autocmd FileType cs nmap <buffer> <leader>osrs <Plug>(omnisharp_restart_server)
    autocmd FileType cs nmap <buffer> <leader>osss <Plug>(omnisharp_start_server)
    autocmd FileType cs nmap <buffer> <leader>osst <Plug>(omnisharp_stop_server)

    function! s:renameUnityFile (newName)
        execute '!mv %.meta %:h/' .. a:newName .. '.cs.meta'
        execute 'Rename ' .. a:newName .. '.cs'
    endfunction

    function! s:deleteUnityFile ()
        execute '!rm %.meta'
        Delete
    endfunction

    command! -nargs=1 RenameUnityFile call <SID>renameUnityFile(<f-args>)
    command! -nargs=0 DeleteUnityFile call <SID>deleteUnityFile(<f-args>)
augroup END
