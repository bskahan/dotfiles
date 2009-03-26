" Brian Skahan's vimrc
" bskahan@etria.com
"Last Updated: <Sun Mar  8 23:57:58 2009> 
" 
" My main vimrc file, it borrows liberally from:
" Sven Guckes excellent example vim files
" http://www.math.fu-berlin.de/~guckes/vim/
"
" Dr Chips vim page, mostly for scripts that this file calls
" http://users.erols.com/astronaut/vim/
"
" the redhat default vimrc, for the [gb]zip autocommands;
"
" about 100 other vimrcs people have been kind enough to post;
"
" things learned from comp.editors, vim-dev mailing list;
"
" the { { { } } } stuff is for folding enabled in vim6
"
"

" Basic settings{{{===================================================


" turns off vi compatibilty, this allows vim to use its best features
set nocompatible 	

" the makes sure we get filetype specific settings
filetype plugin indent on

" turn on auto-indent
set ai			
" (bs) allow backspacing over everything in insert 
" mode.  you want this
set backspace=2		

"set backupdir=~/tmp

" turn on folding, this allows you to "hide" chunks of text into a single line
set foldenable 		

" marker folding condenses everything between 3 {s and 3 }s into one line
set foldmethod=marker   " this explains all the { sets you see in this file

" this starts vim with everything folded so you can quickly find what you want
set foldlevelstart=0 	

" this defines what the visible part of a fold shows
set foldtext=substitute(foldtext(),'\\*','','g')

" keep 50 lines of command line history
set history=50		

" hilight the last word you searched for, I find this really annoying
set nohlsearch 		

" find I or i when you do /i - see smartcase
"set ignorecase 	

" insert 2 space after period with Joined lines :help J
set joinspaces 		

" always show status line
set laststatus=2        

" hint: type :dig
"set listchars=tab:¿¿,trail:¿

" this stops vim from leaving foo~ files all over your computer
set nobackup

" show the cursor position all the time
set ruler		

" if you haven't used zsh I highly recomend it, its much nicer than bash
set shell=zsh		

" show matching bracket, always the source of headaches
set showmatch		

" abbreviate messages, suppress intro
set shortmess=atI	

" better: FOO Foo foo when you /foo but only Foo /Foo
set smartcase 		

" put :split below
set splitbelow		

" never, never wider than 80
set tw=78		

" i hate the fscking beep
set visualbell		

" (vi) read/write a .viminfo file, don't store more
" than 50 lines of registers
set viminfo='20,\"50	

"only do this for gvim
if has("gui_running")
  " show line numbers
  set number 		
  " set guifont=-mozilla-courier-medium-r-normal-*-*-150-*-*-m-*-iso8859-1
  set gfn=Monaco:h12:a
  colorscheme koehler
  set listchars=tab:¿¿,trail:¿
else
  " colorscheme elflord
  colorscheme koehler
endif

if has("syntax") && &t_Co > 2 || has("gui_running")
  syntax on
endif


" this overrides the colorscheme statusline settings
"so ~/.vim/colors/bskahan_default.vim

" limit tab completion of files ending with these suffixes
set suffixes=.bak,.o,.info,.swp,~,.aux,.log,.dvi,.out,.bbl,.png,.jpg,.gif

" settings for various plugins
let g:do_xhtml_mappings = 'yes'
let g:html_map_leader = ';'

let g:vimsh_prompt_override = 0
let g:vimsh_prompt_pty      = "%m%#"
let g:vimsh_split_open      = 1
let g:vimsh_sh              = "/bin/sh"
let g:miniBufExplSplitBelow = 0

"}}}=================================================================



" statusline stuff{{{1===============================================

"so '~/.vim/colors/bskahan_default.vim'
" color highlighting for status line
hi    statusline term=NONE cterm=NONE ctermfg=yellow ctermbg=red guifg=black guibg=red
hi    User1 cterm=NONE    ctermfg=red    ctermbg=grey guifg=red guibg=grey
hi    User2 cterm=NONE    ctermfg=darkgreen  ctermbg=black guifg=darkgreen guibg=black
hi    User3 cterm=NONE    ctermfg=white  ctermbg=blue guifg=white guibg=blue
hi    User4 cterm=NONE    ctermfg=black  ctermbg=grey guifg=black guibg=grey

" this is the line right above the command line
set statusline=\%3*[%02n]%*\ %(%M%R%H%)\ %2*%f%y%*\ %=%{Options()}\ %=%{strftime('\%l:%M%P')}\ %3*<%l,%c%V>%p%%

" statusline that shows ascii value of the current char
"set   statusline=[%n]\ %f\ %(\ %M%R%H)%)\=ASCII=%b\ HEX=%B

fu! Options() "{{{2 from sven guckes's vimrc
            let opt=""
  if !&ai|   let opt=opt." noai"   |endif
  if &et|   let opt=opt." et"   |endif
  if &hls|  let opt=opt." hls"  |endif
  if &paste|let opt=opt." paste"|endif
  "  any but the default foldmarkers
"  if &foldmarker!="{{{,}}}"|let opt=opt." fm=".&foldmarker|endif
" ==========================================
  " fold method
 " if &foldmethod|let opt=opt." method=".&foldmethod|endif
  " fold level
  "if &foldlevel| let opt=opt." fl=".&foldlevel|endif
" ==========================================
  if &shiftwidth!=8|let opt=opt." sw=".&shiftwidth|endif
                    let opt=opt." tw=".&tw
 return opt
endf
"}}}

"}}}=================================================================



" Autocommands{{{1===================================================

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  autocmd BufWritePre *,*.* call UpdateTimeStamp(8)

  " comment out highlighted lines according to file type
  " put a line like the following in your ~/.vim/filetype.vim file
  " and remember to turn on filetype detection: filetype on
  " au! BufRead,BufNewFile *.sh,*.tcl,*.php,*.pl let Comment="#"
  " if the comment character for a given filetype happens to be @
  " then use let Comment="\@" to avoid problems...
  fun CommentLines()
    "let Comment="#" " shell, tcl, php, perl
    exe ":s@^@".g:Comment."@g"
    exe ":s@$@".g:EndComment."@g"
  endfun
    " map visual mode keycombo 'co' to this function
  vmap co :call CommentLines()<CR> 

  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78 nowrap

  augroup cprog "{{{2
    " Remove all cprog autocommands
    au!		
    		" When starting to edit a file:
    		" For C and C++ files set formatting of comments and 
		"	set C-indenting on.
    		" For other files switch it off.
    		" Don't change the order, it's important that the line 
		" 	with * comes first.
  
    autocmd FileType *      set formatoptions=tcql nocindent comments&
    "autocmd BufNewFile *.h	0r ~/.vim/skel/skeleton.h
    "autocmd BufNewFile *.c 	0r ~/.vim/skel/skeleton.c
    autocmd FileType c,cpp  set equalprg='indent' sw=4 cindent comments=sr:/*,mb:*,el:*/,:// cinoptions=:0,t0,c1 cinwords=if,else,while,do,for,switch,case nocp incsearch "cinkeys=0{,0},:,0#,!<Tab>,!^F
    "this file contains my mappings for editing c and c++
    "autocmd FileType c,cpp  source ~/.vim/myC.vim
  augroup END "}}}

  "mail/news stuff
  " remove any quoted signatures
  au BufRead /tmp/mutt* normal /^> -- $/,/^$/-1d^M
  "au BufRead /tmp/mutt* source ~/.vim/mutt.vim
  "autoindent, show nontext chars, make email address words
  "au Filetype mail set nomodeline ai list tw=70 isk+=@,.
  "au Filetype mail G:?^> -- $<CR>d}

  "latex
  "autocmd Filetype tex source ~/.vim/ftplugin/auctex.vim
 
  "python stuff 
  "au FileType python source ~/.vim/scripts/python.vim
  
  au  BufRead *.html se isk+=:,/,~,. 	" expand url as words in html files
  "au  BufNewFile *.html	0r ~/.vim/skel/skeleton.html
 
  " autocmds for gzip or bzip files{{{
  augroup gzip
    " Remove all gzip autocommands
    au!

    " Enable editing of gzipped files
    " read: set binary mode before reading the file
    " uncompress text in buffer after reading
    " write: compress file after writing
    " append: uncompress file, append, compress file
    autocmd BufReadPre,FileReadPre  *.gz set bin
    autocmd BufReadPost,FileReadPost  *.gz let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost  *.gz '[,']!gunzip
    autocmd BufReadPost,FileReadPost  *.gz set nobin
    autocmd BufReadPost,FileReadPost  *.gz let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost  *.gz execute ":doautocmd BufReadPost " . expand("%:r")
 
    autocmd BufWritePost,FileWritePost  *.gz !mv <afile> <afile>:r
    autocmd BufWritePost,FileWritePost  *.gz !gzip <afile>:r
  
    autocmd FileAppendPre     *.gz !gunzip <afile>
    autocmd FileAppendPre     *.gz !mv <afile>:r <afile>
    autocmd FileAppendPost    *.gz !mv <afile> <afile>:r
    autocmd FileAppendPost    *.gz !gzip <afile>:r
  augroup END

  augroup bz2
    " Remove all bz2 autocommands
    au!

    " Enable editing of bzipped files
    " read: set binary mode before reading the file
    " uncompress text in buffer after reading
    " write: compress file after writing
    " append: uncompress file, append, compress file
    autocmd BufReadPre,FileReadPre  *.bz2 set bin
    autocmd BufReadPost,FileReadPost  *.bz2 let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost  *.bz2 '[,']!bunzip2
    autocmd BufReadPost,FileReadPost  *.bz2 set nobin
    autocmd BufReadPost,FileReadPost  *.bz2 let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost  *.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

    autocmd BufWritePost,FileWritePost  *.bz2 !mv <afile> <afile>:r
    autocmd BufWritePost,FileWritePost  *.bz2 !bzip2 <afile>:r

    autocmd FileAppendPre     *.bz2 !bunzip2 <afile>
    autocmd FileAppendPre     *.bz2 !mv <afile>:r <afile>
    autocmd FileAppendPost    *.bz2 !mv <afile> <afile>:r
    autocmd FileAppendPost    *.bz2 !bzip2 <afile>:r
  augroup END
  "}}}

  " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
  " back to positions in previous files more than once.
  if 0
   " When editing a file, always jump to the last cursor position.
   " This must be after the uncompress commands.
    autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
  endif

endif " has("autocmd")
"}}}

" Abreviations and Macros{{{1
"=================================================================
"spalling errors;)
iab teh the
iab fro for

" use ',' to begin macros if you see <leader> in a mapping this is what it is
let mapleader = ","		

" very nice tab mapping
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr> 

" Emacs style command line editing
cnoremap <C-A>		<Home>
cnoremap <C-B>		<Left>
cnoremap <C-E>		<End>
cnoremap <C-F>		<Right>
cnoremap <C-N>		<Down>
cnoremap <C-P>		<Up>
cnoremap <ESC>b		<S-Left>
cnoremap <ESC>f		<S-Right>
	
"quick switch between paste and nopaste
map  :set paste<cr>
map  :set nopaste<cr>
imap  <C-O>:set paste<cr>
imap  <nop>
set pastetoggle=

iab Yname Brian Skahan
iab Yemail bskahan@etria.org
iab Ysign Author: Brian Skahan<CR>Last Updated: <<C-R>=strftime("%c")<CR>>
" date time stamp
iab Ydate <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
" Example: Thu Mar 22 00:28:14 EST 2001 
iab Yupdate Last Updated: <<C-R>=strftime("%c")<CR>>
" Example: Last Updated: <Thu 19 Sep 2002 08:31:48 PM EDT> 
 iab Ytime <C-R>=strftime("%H:%M")<CR>
" Example: 00:28

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

"=================================================================
" Macros
"=================================================================
" add c style comments to selection
vmap ## :s#^#// #<cr>'<O/*<esc>'>o*/<esc>gv

" edit vimrc
nn	<Leader>u	:source <C-R>='~/.vimrc'<CR><CR>
nn	<Leader>v	:split  <C-R>='~/.vimrc'<CR><CR>

" cut all instances of multiple blank lines down to one
map <Leader>kl :v/./.,/./-1join<cr>

" Don't use Ex mode, use Q for formatting
map Q gq		

" instead of suspend create a new login shell, useful for editing shell 
" configs 
map <C-Z> :shell<CR>

" get rid of quoted sigs in mail
map <Leader>kqs G?^> -- $<CR>d}

" change colorscheme to a lightbackground (for glare in the morning
map <leader>csm :colorscheme morning<CR>
map <leader>cse :colorscheme evening<CR>

" ===================================================================
" Buffer controls{{{
" ===================================================================
map <F3> :bp<CR>
map <F4> :bn<CR>
map <F12> :bd<CR>

function! List_Buf(arg1)
  let cur_buf = 1
  let cur_map = 1
  let echostring = ""
  while ( cur_buf <= bufnr("$") && cur_map <= 9 )
    if bufexists(cur_buf) 
      let echostring = echostring . cur_map . "-" .substitute(bufname(cur_buf),".*/","","") . " "
      "exec "map <S-F".cur_map."> :".cur_buf."b<CR>:call List_Buf()<cr>"
      "exec "map <S-F".cur_map."> :".cur_buf."b<CR>"
      let cur_map = cur_map + 1
    endif
    let cur_buf = cur_buf + 1
  endwhile
  if a:arg1 = 1
    echo echostring
  endif
  exec "map <C-l> :call List_Buf(1)<cr>"
  return echostring
endfunction

"autocmd BufEnter * call List_Buf(0)
"}}}


" put /**/ around the cursor
map <leader>x I/*<esc>A*/<esc>hi

" Make macros
map <leader>m :make<CR>
map <leader>wm :w<CR>,m
"}}}

" experiments{{{1							
" many of these don't work correctly!!!!
" Use at your own risk
" ================================================================
"map <C-W> :exec '!echo ' . expand("<cword>")

" trying to hilight c/++ functions
"syn match cprogFunction 	"[a-zA-Z]\+("
"syn match cprogFunction 	")"
"syn match cprogFunction 	"("
  "hi link cprogFunction Special

"fu! Time()
"  let TIME = ""
"  let TIME = strftime("%H:%M") 
"  echo TIME
"  return TIME 
"endf

"cmap <leader>t :call Time()

" get a three paned view
map <leader>tpv :10sp<cr><C-w><C-W>:vs<cr><C-w><c-W><C-w><c-W><C-w>k
" highlight anything past 80 columns, or keep your damn term at 80!
"hi syn match MaxColumn /.\%>81v/

" cut multiple quoted blank lines down to 1
"map <Leader>kl :v/./.,/./-1join<cr>

fun! UpdateTimeStamp(endline) "{{{2
    let datestr = strftime("%c")
    let realname = "Brian Skahan"
    "let timestampstr = datestr . ' ** ' . realname
    let timestampstr = datestr
    let basepattern = '\(\(Time-[sS]tamp\|Last[ -][uU]pdated\):\s\+\)'
    let pattern1 = basepattern . '<.\{-}>'
    let subst1 = '\1<' . timestampstr . '>'
    let pattern2 = basepattern . '".\{-}"'
    let subst2 = '\1"' . timestampstr . '"'
    let patternN = 2
    if a:endline > 0
        let lastline = line("$")
        if lastline > a:endline
            let lastline = a:endline
        endif
        let line = 1
        while line <= lastline
            let str = getline(line)
            let i = 1
            while i <= patternN
                exec "let pattern = pattern" . i
                exec "let subst = subst" . i
                if match(str, pattern) >= 0
                    let str = substitute(str, pattern, subst, '')
                    call setline(line, str)
                    return ""
                endif
                let i = i + 1
            endwhile
            let line = line + 1
        endwhile
    elseif a:endline < 0
        let lastline = line("$") + a:endline
        if lastline < 1
            let lastline = 1
        endif
        let line = line("$")
        while line >= lastline
            let str = getline(line)
            let i = 1
            while i <= patternN
                exec "let pattern = pattern" . i
                exec "let subst = subst" . i
                if match(str, pattern) >= 0
                    let str = substitute(str, pattern, subst, '')
                    call setline(line, str)
                    return ""
                endif
                let i = i + 1
            endwhile
            let line = line - 1
        endwhile
    endif
    return ""
endfun 

" ===============================================

fun! Begin_C_Comment() "{{{2
  let foldstatus = &foldenable
  set nofoldenable
  let fun_name = getline(line("."))
  "echo l:fun_name/_*\|\w*\s_*\w*_*/fun_name/
  put ='/*'.fun_name.'{{{'
  "let ffn_size = strlen(fold_fun_name)
  "let fill_size = 64 - ffn_size
  "echo fill_size
  "put =fold_fun_name

  "s,.*,/*&***********************************************************,
  "s,\(.\{,64}\)\**,\1,
  "while(col(.) < 64)
  "  normal A*
  "endwhile
  normal ddkk
  put =' '
  put =' '
  normal kP
  if (foldstatus != 0)
    set foldenable
  endif
endfun

fun! AddStars()
  let col = col(".")
  let row = line(".")
  let line = getline(row)
  let stars ="***************************************************************"
  let beginline = strpart(line, 0, col)
  let endline = strpart(line, col, strlen(line))
  let string = strpart(stars, col, 65)
  call setline(row, beginline . string . endline)
endfunction

map <leader>cc ma:call Begin_C_Comment()<cr>$:call AddStars()<cr>`a<cr>
"}}}

" =================================================
func! SpellCheck(...) "{{{2
  if a:0 > 0
    " we are being given a string in a:1 to check
  else
    " check current buffer
    update
  endif

  " create a new, blank, spellcheck buffer
  new ==SPELL=CHECK==
  set fenc=latin1
  %d
  " put the sign at the top for ?spell to use 'terse mode'
  put='!'
  " paste in the text we need
  if a:0 > 0
    put=a:1
  else
    r #
  endif

  " at this point, the buffer contains a bang on the first line, plus a
  " bunch of text to be checked.
  update
  let args = '--pipe '
  if (expand("%") =~ 'tex$')
    let args = args . ' --mode=tex '
  endif
  if has("win32")
    let args = args . ' --set-prefix '
  endif
  let args = args . ' check '
  " filter buffer through the spell-checker:
  exe '%! aspell '.args.expand('%')

  " now, what to do with the returned data?  ...
endfunc

"}}}

" ==============================================

fu! Make_Modeline() "{{{2
  let type = &filetype
  let new_mode_line = ''
  if (type == 'vim')
    let new_mode_line = '" vim:tw=78:sw=2:ai'
  elseif (type == 'c')
    let new_mode_line = '/* vim: set tw=78: sw=4: */'
  elseif (type == 'cpp')
    let new_mode_line = '/* vim: set tw=78: sw=4: */'
  elseif (type == html)
    let new_mode_line = '<!-- vim: set tw=78: sw=2: -->'
  else
    return -1
  endif
  norm G
  norm o
  norm <esc>
  let current_line = line(.)
  call append(current_line, new_mode_line)
endfu
"}}} 

fun! Stamp()

        let maintainer = "Brian Skahan"
        let time_format = "%Y-%m-%d %T %Z"
        let file_name = "%:t"

        call append (0, "/*")
        "call append (1, "// " . expand (file_name))
        "call append (2, "//")
        call append (1, "// Maintained by: " . maintainer)
        call append (2, "// Last Modified: " . strftime (time_format))
        call append (3, "*/")
        call append (4, "")
        call append (5, "")
endfun

fun! NewMail()
	exec '!rm ~/tmp/vimmail.mail'
	exec 'sp ~/tmp/vimmail.mail'
endfun

fun! Calendar()
  	:!`cal -y > ~/.vim/.tmp_cal`
	norm <cr>
	norm <cr>
	:10sp ~/.vim/.tmp_cal
	norm <cr>
	set ft=cal
endfun
com Cal :call Calendar()

if &readonly == 1
  set laststatus=0
  map <space> <C-D>
  map b <C-B>
  map q :q!<CR>
endif



fun! VimShRedraw()
    redraw
endfunction


"}}}
"===================================================================
" EOF
" vim: set tw=78 sw=2:
