" File: _vimrc
" Author: mingcheng<i.feelinglucky@gmail.com>
" Description: mingcheng's personal vim config file.
" Last Modified: $Id: _vimrc 467 2010-05-11 03:49:05Z i.feelinglucky $
" Blog: http://www.gracecode.com/
" Since: 2008-10-07
" Change:
" [+]new feature  [*]improvement  [!]change  [x]bug fix
"
" [*] 2012-02-15
" SnipMate 快捷键 "<tab>"
" ZenCoding 快捷键 "<c-y>,"
" 
" [*] 2010-11-23
"     改进 Vim7.3 相关的配置，使其支持 UNIX 系统
"
" [!] 2010-11-22
"     增加 void 配色，更改配色设置（蛋疼）
"
" [!] 2010-10-14
"     更改配色为 Son of Obsidian，参见 http://studiostyl.es/schemes/son-of-obsidian
"
" [+] 2010-09-13
"     增加永久撤销（for Vim7.3）相关配置
"
" [*] 2010-08-25
"     修改 Vimwiki 命令和快捷键
"
" [!] 2010-07-26
"     修改 status bar 显示 git 状态（已取消）
"
" [*] 2010-06-17
"     重新配置 Mac 下的字体
"
" [+] 2010-05-11
"     给 Win32 下的 gVim 窗口设置透明度
"
" [+] 2010-04-22
"     修改 <Leader> 键为 ','
"
" [+] 2010-04-21
"     增加 wildmenu 选项，同时修改“雅黑”字体为英文名称
"
" [+] 2010-04-09
"     增加各文件类型不同的配色选项
"     设置自动更换当前目录
"
" [+] 2012-02-15
"     设置 F3 为调用出 BufExplorer
"
" [*] 2010-03-26
"     增加 VimWiki 配置选项
"
" [+] 2010-01-20
"     Mac 下使用幼圆字体
"
" [+] 2010-01-18
"     修改部分搜索配置
"
" [*] 2009-12-22
"     Mac 下修改 GUI 界面配置
"
" [*] 2009-12-18
"     增加 Mac 下 jsl 配置
"
" [*] 2009-12-12
"     增加 Mac 下的字体设置
"
" [*] 2009-12-11
"     修复在 Mac 下的部分 Bug
"
" [*] 2009-12-08
"     增加针对 Mac 系统的支持
"
" [*] 2009-12-01
"     更新 Javascript 语言文件，增加自动补全脚本
"
" [!] 2009-10-14
"     调整修改部分配置，@TODO 改进 SelectAll 函数
"
" [!] 2009-09-24
"     为了不与 SinpMate 冲突，使用 VimWiki 插件默认快捷键
"
" [!] 2009-07-10
"     重新整理 Vim 配置文件结构
"
" [*] 2009-07-05
"     增加 ActionScript 语法支持
"     
" [*] 2009-05-31
"     增加 javascript_enable_domhtmlcss 变量，用于 JavaScript 语法高亮
"
" [!] 2009-05-07
"     快捷键： Q 退出；增加、更改 Tab 相关的快捷键
"
" [!] 2009-05-04
"     改进 Windows 字体配置，使其能使用任何中文名称
"
" [!] 2009-04-28
"     更改 Windows 快捷键，直接使用 mswin.vim
"
" [!] 2009-04-21
"     加入相应的 au 命令，避免使用 VimWiki 折叠
"
" [!] 2009-04-01
"     分离配置文件，将私人配置（包括 Twitter 相关的插件）独立出本文件
"
" [+] 2009-04-01
"     增加全屏插件，绑定 <f11>
"
" [+] 2009-02-12
"     初始化版本，啥时开始的无从考证 :^D
"

"if exists("mingcheng")
"    finish
"endif
"let g:mingcheng = 1

"if v:version < 700
"    echoerr 'This _vimrc requires Vim 7 or later.'
"    quit
"endif

" 定义 <Leader> 为逗号
let mapleader = ","
let maplocalleader = ","

"" 用 ` 替换 <ESC>
imap ` <ESC>
" This is totally awesome - remap jj to escape in insert mode.
" You'll never type jj anyway, so it's great!
inoremap jj <Esc>

"使用ALT+[jk]来移动行内容
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

"搜索时全小写相当于不区分大小写，只要有一个大写字母出现，则区分大小写
set ignorecase smartcase

" 获取当前目录
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" 跳过页头注释，到首行实际代码
func! GotoFirstEffectiveLine()
    let l:c = 0
    while l:c<line("$") && (
                \ getline(l:c) =~ '^\s*$'
                \ || synIDattr(synID(l:c, 1, 0), "name") =~ ".*Comment.*"
                \ || synIDattr(synID(l:c, 1, 0), "name") =~ ".*PreProc$"
                \ )
        let l:c = l:c+1
    endwhile
    exe "normal ".l:c."Gz\<CR>"
endf

" 返回当前时期
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endf

" 返回当前时间

" 全选
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endf

" From an idea by Michael Naumann
func! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunc


" ============
" Environment
" ============
" 保留历史记录
set history=500

" 行控制
set linebreak
set nocompatible
set textwidth=80
set wrap

" 标签页
set tabpagemax=9
set showtabline=2

" 控制台响铃
set noerrorbells
set novisualbell
set t_vb= "close visual bell

" 行号和标尺
set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)

" 启动的时候不显示那个援助索马里儿童的提示
set shortmess=atI

" 命令行于状态行
set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%L\ %=\[%P]
set ls=2 " 始终显示状态行
set wildmenu "命令行补全以增强模式运行



" Search Option
set hlsearch  " Highlight search things
set magic     " Set magic on, for regular expressions
set showmatch " Show matching bracets when text indicator is over them
set mat=2     " How many tenths of a second to blink
set noincsearch

" 制表符
set tabstop=4
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" 状态栏显示目前所执行的指令
set showcmd 

" 缩进
set autoindent
set smartindent

" 自动重新读入
set autoread

" 插入模式下使用 <BS>、<Del> <C-W> <C-U>
set backspace=indent,eol,start

" 设定在任何模式下鼠标都可用
set mouse=a

" 自动改变当前目录
if has('netbeans_intg')
    set autochdir
endif

" 备份和缓存
"set nobackup
"set noswapfile

" 自动完成
set complete=.,w,b,k,t,i
set completeopt=longest,menu


" =====================
" 多语言环境
"    默认为 UTF-8 编码
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    language messages zh_CN.utf-8
    set helplang=cn
    
    if has('win32')

        language english
        let &termencoding=&encoding

            " 解决菜单乱码
        set langmenu=zh_CN.utf-8
            language messages zh_CN.utf-8
        source $VIMRUNTIME/delmenu.vim
            source $VIMRUNTIME/menu.vim
    
    endif

    set fencs=utf-8,gbk,chinese,latin1
    set formatoptions+=mM
    set nobomb " 不使用 Unicode 签名

else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

"" 判断 Vim 是否包含多字节语言支持，并且版本号大于 7.3 {{{
if has('multi_byte') && v:version > 703
        " 如果 Vim 的语言（受环境变量 LANG 影响）是中文（zh）、日文（ja）
        " 或韩文（ko）的话，将模糊宽度的 Unicode 字符的宽度设为双宽度（double）
        if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
                set ambiwidth=double
        endif
endif
" }}}
"
" 永久撤销，Vim7.3 新特性
if has('persistent_undo')
    set undofile

    " 设置撤销文件的存放的目录
    if has("unix")
        set undodir=/tmp/,~/tmp,~/Temp
    else
        set undodir=d:/temp/
    endif
    set undolevels=1000
    set undoreload=10000
endif

" Diff 模式的时候鼠标同步滚动 for Vim7.3 {{{
" if has('cursorbind')
"    set cursorbind
" end
"}}}

" =========
" AutoCmd
" =========
if has("autocmd")
    filetype plugin indent on

    " 括号自动补全
    func! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
        :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf

    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf

    "unknown
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=80
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END

    " Auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,javascript,ruby,eruby,c,java exe AutoClose()
    
    " Auto Check Syntax
    au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)

    " JavaScript 语法高亮
    "au FileType html,javascript let g:javascript_enable_domhtmlcss = 1
    "au BufRead,BufNewFile *.js setf jquery

    " 给各语言文件添加 Dict
    " 使用 CTRL+p 提示相关函数 
    if has('win32')
        let s:dict_dir = $VIM.'\vimfiles\dict\'
    else
        let s:dict_dir = $HOME."/.vim/dict/"
    endif
    let s:dict_dir = "setlocal dict+=".s:dict_dir
    
    " where are these dicts from?
    au FileType php exec s:dict_dir."php_funclist.dict"
    au FileType css exec s:dict_dir."css.dict"
    au FileType javascript exec s:dict_dir."javascript.dict"
    au FileType ruby,eruby exec s:dict_dir."ruby.dict"

    " 格式化 JavaScript 文件
    au FileType javascript map <f12> :call g:Jsbeautify()<cr>

    " 增加 ActionScript 语法支持
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.as setf actionscript 

    " CSS3 语法支持
    au BufRead,BufNewFile *.css set ft=css syntax=css3

    " 增加 Objective-C 语法支持
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.m,*.h setf objc

    " 将指定文件的换行符转换成 UNIX 格式
    au FileType php,javascript,html,css,python,vim,vimwiki,ruby,eruby set ff=unix

    " 保存编辑状态
    au BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
    au BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif


    if has("autocmd") && exists("+omnifunc")
         autocmd Filetype *
       \ if &omnifunc == "" |
       \   setlocal omnifunc=syntaxcomplete#Complete |
       \ endif
    endif
    
    " ADD YULIKE 2012-2-15 OMNIFUNC
    " AutoComplPop
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType java set omnifunc=javacomplete#Complete

    " Special for ruby   
    if has("autocmd") && exists("+omnifunc")
         autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
         autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading=1
         autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global=1
         autocmd FileType ruby,eruby let g:rubycomplete_rails=1
    endif     

endif

" =========
" GUI
" =========
if has('gui_running')
    " 只显示菜单
    " set guioptions=mcr
    " REM 2012-02-15

    " 高亮光标所在的行 NOT WORK?
    set cursorline

    if has("win32")
        " Windows 兼容配置WW
        source $VIMRUNTIME/mswin.vim

        " Balloon with Correct Chinese Characters

        " f11 最大化
        " nmap <f11> :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>
        nmap <Leader>ff :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>
        nmap <leader>mw :call libcallnr("vimtweak.dll", "EnableMaximize", 1)<cr>
        nmap <leader>mW :call libcallnr("vimtweak.dll", "EnableMaximize", 0)<cr>
        nmap <leader>et :call libcallnr("vimtweak.dll", "EnableTopMost", 1)<cr>
        nmap <leader>eT :call libcallnr("vimtweak.dll", "EnableTopMost", 0)<cr>

        " 自动最大化窗口
        au GUIEnter * simalt ~
        " 给 Win32 下的 gVim 窗口设置透明度
        au GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", 250)
        nmap <leader>aw :call libcallnr("vimtweak.dll", "SetAlpha", 168)<cr>
        nmap <leader>aW :call libcallnr("vimtweak.dll", "SetAlpha", 255)<cr>

        " 字体配置
        exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h10:cANSI'
        exec 'set guifontwide='.iconv('Microsoft\ YaHei', &enc, 'gbk').':h10'
        
        " 由于 Vim 将字体“强制”等宽显示，所以这个特性非常方便。
        " 具体的高亮颜色在配置色方案里设置。
        " colorcolumn
        map <silent> <leader>cu :if &cursorcolumn =~# '0' <Bar>
                                \set cursorcolumn <Bar>
                                \else <Bar>
                                \set nocursorcolumn <Bar>
                                \endif<CR>
        map <leader>c1 :set cc=+1 <cr>
        map <leader>c2 :set cc= <cr>
        "" noh
        map <leader>nh :noh <cr>
        map <leader>co :colorscheme default<cr>
        " let psc_style='cool'
        "" 把DOS文件格式转成UNIX格式
        " :set ff=unix"
        "" 删除文档中的空行
        " :g/^\s*$/d"
        "" 启动时最大化
        " au GUIEnter * simalt ~x
        " 移动窗口
        map <leader>ce :winpos 88 132 <cr>
        "map <leader>le :winpos 1800 120 <cr>
        "map <leader>ri :winpos -1800 120 <cr>
        map <leader>tt :winpos 0 0 <cr>
        map <leader>sw :winsize 100 30<cr>
        " set lines
        "map <leader>sl :set lines=40 <cr>
        "map <leader>sL :set lines=25 <cr>

	" 隐藏工具栏
	set guioptions+=T
	" 隐藏菜单栏
	set guioptions+=m
	" 隐藏左边滚动条
	set guioptions-=l
	set guioptions-=L
	" 隐藏右边滚动条
	set guioptions+=r
	set guioptions+=R
	"" map
	" 菜单栏 {{{
	map <silent> <leader>gm :if &guioptions =~# 'm' <Bar>
				\set guioptions-=m <Bar>
				\else <Bar>
				\set guioptions+=m <Bar>
				\endif<CR>
	" }}}
	" 工具栏 {{{
	map <silent> <leader>gt :if &guioptions =~# 'T' <Bar>
				\set guioptions-=T <Bar>
				\else <Bar>
				\set guioptions+=T <Bar>
				\endif<CR>
	" }}}
	" 滚动条 {{{
	map <silent> <leader>gl :if &guioptions =~# 'l' <Bar>
				\set guioptions-=l <Bar>
				\else <Bar>
				\set guioptions+=l <Bar>
				\endif<CR>
	map <silent> <leader>gr :if &guioptions =~# 'r' <Bar>
				\set guioptions-=r <Bar>
				\else <Bar>
				\set guioptions+=r <Bar>
				\endif<CR>
	map <silent> <leader>gb :if &guioptions =~# 'b' <Bar>
				\set guioptions-=b <Bar>
				\else <Bar>
				\set guioptions+=b <Bar>
				\endif<CR>
	" }}} 


    endif

    " Under Mac
    if has("gui_macvim")
        " MacVim 下的字体配置
        set guifont=Menlo:h12
        set guifontwide=Hei:h12

        " 半透明和窗口大小
        set transparency=2
        set lines=40 columns=100

        " 使用 MacVim 原生的全屏幕功能
        let s:lines=&lines
        let s:columns=&columns

        func! FullScreenEnter()
            set lines=999 columns=999
            set fu
        endf

        func! FullScreenLeave()
            let &lines=s:lines
            let &columns=s:columns
            set nofu
        endf

        func! FullScreenToggle()
            if &fullscreen
                call FullScreenLeave()
            else
                call FullScreenEnter()
            endif
        endf

        set guioptions+=e
        " Mac 下，按 <Leader>ff 切换全屏
        " nmap <f11> :call FullScreenToggle()<cr>
        " REm 2012-02-15 NO F11
        nmap <Leader>ff  :call FullScreenToggle()<cr>

        " I like TCSH :^)
        set shell=/bin/tcsh

        " Set input method off
        set imdisable

        " Set QuickTemplatePath
        let g:QuickTemplatePath = $HOME.'/.vim/templates/'

        " 如果为空文件，则自动设置当前目录为桌面
        " lcd ~/Desktop/
    endif

    " Under Linux/Unix etc.
    if has("unix") && !has('gui_macvim')
        set guifont=Courier\ 10\ Pitch\ 11
    endif
endif

" =============
" Key Shortcut
" ============={{{
nmap <leader>to   :tabnew<cr>
nmap <Leader>tp   :tabprevious<cr>
nmap <Leader>tc   :tabclose<cr>
nmap <Leader>tn   :tabnext<cr> 
"}}}

"REM BY YULK 2012-02-15
" insert mode shortcut
" inoremap <C-h> <Left>
" inoremap <C-j> <Down>
" inoremap <C-k> <Up>
" inoremap <C-l> <Right>
" inoremap <C-d> <Delete>

"for i in range(1, &tabpagemax)
"    exec 'nmap <A-'.i.'> '.i.'gt'
"endfor

" 插件快捷键
nmap <C-d> :NERDTree<cr>
" 进入BufExplorer后 按<c-^>返回
nmap <C-e> :BufExplorer<cr>
nmap <f3>  :BufExplorer<cr>

" 插入模式按 F4 插入当前时间


" 新建 XHTML 、PHP、Javascript 文件的快捷键
nmap <C-c><C-h> :NewQuickTemplateTab xhtml<cr>
nmap <C-c><C-p> :NewQuickTemplateTab php<cr>
nmap <C-c><C-j> :NewQuickTemplateTab javascript<cr>
nmap <C-c><C-c> :NewQuickTemplateTab css<cr>
nmap <C-c><C-r> :NewQuickTemplateTab ruby<cr>
nmap <Leader>ca :Calendar<cr>
nmap <Leader>mr :MRU<cr>
nmap <Leader>dd :NERDTree<cr>
nmap <Leader>bf :BufExplorer<cr>

" 直接查看第一行生效的代码
nmap <Leader>gff :call GotoFirstEffectiveLine()<cr>

" 按下 Q 不进入 Ex 模式，而是退出
nmap Q :x<cr>


" =================
" Plugin Configure
" =================
" Javascript in CheckSyntax
if has('win32')
    let g:checksyntax_cmd_javascript  = 'jsl -conf '.shellescape($VIM . '\vimfiles\plugin\jsl.conf')
else
    let g:checksyntax_cmd_javascript  = 'jsl -conf ~/.vim/plugin/jsl.conf'
endif
let g:checksyntax_cmd_javascript .= ' -nofilelisting -nocontext -nosummary -nologo -process'

" VIM HTML 插件
" let g:no_html_toolbar = 'yes'

" Don't display NERDComment Menu.
let g:NERDMenuMode = 1

" VimWiki 配置
if !exists("g:vimwiki_list")
    let g:vimwiki_list = [
                \{"path": "~/Wiki/Android/source/", "path_html": "~/Wiki/Android/",  
                \   "html_footer": "~/Wiki/Android/footer.tpl", "html_header": "~/Wiki/Android/header.tpl",
                \   "auto_export": 1}
                \]
    let g:vimwiki_auto_checkbox = 0
    if has('win32')
        " 注意！
        " 1、如果在 Windows 下，盘符必须大写
        " 2、路径末尾最好加上目录分隔符
        let s:vimwiki_root = "d:/My Documents/My Dropbox/Vimwiki"
        let g:vimwiki_list = [
                    \{"path": s:vimwiki_root."/Default/", 
                    \   "html_footer": s:vimwiki_root."/Default/footer.tpl", 
                    \   "html_header": s:vimwiki_root."/Default/header.tpl",
                    \   "path_html": s:vimwiki_root."/Default/_output/", "auto_export": 1}
                    \]
        let g:vimwiki_w32_dir_enc = 'cp936'
    endif

    au FileType vimwiki set ff=unix fenc=utf8 noswapfile nobackup
    "au FileType vimwiki imap <C-t> <c-r>=TriggerSnippet()<cr>

    nmap <C-i><C-i> :VimwikiTabGoHome<cr>
    nmap <Leader>ii :VimwikiTabGoHome<cr>
endif

"" 不要显示 VimWiki 菜单
" 显示 WIKI 菜单 
let g:vimwiki_menu = "VimWiki"

" NERD* plugin menu
let g:NERDMenuMode = 1

" =============
" Color Scheme
" =============
if has('syntax')
    "if has('gui_running')
    "    set background=light
    "else
    "    set background=dark
    "endif

    " ------------------------------------------------------------------
    " Solarized Colorscheme Config
    " ------------------------------------------------------------------
    
    colorscheme solarized
    if has('solarized')
        let g:solarized_bold=0    "default value is 1
        let g:solarized_visibility="high"    "default value is normal
        let g:solarized_hitrail=1    "default value is 0
        let g:solarized_menu=1
    endif
    set background=dark

    " http://ethanschoonover.com/solarized

    " colorscheme zenburn

    " 默认编辑器配色
    au BufNewFile,BufRead,BufEnter,WinEnter * colo solarized

    " 各不同类型的文件配色不同
    au BufNewFile,BufRead,BufEnter,WinEnter *.wiki colo solarized 

    " 保证语法高亮
    syntax on
endif

" vim: set et sw=4 ts=4 sts=4 fdm=marker ft=vim ff=unix fenc=utf8:
au BufNewFile,BufRead *.pc		set filetype=c


" =============
" Zencoding
" =============

  let g:user_zen_settings = {
  \  'lang' : 'ja',
  \  'html' : {
  \    'filters' : 'html',
  \    'indentation' : ' '
  \  },
  \  'perl' : {
  \    'indentation' : '  ',
  \    'aliases' : {
  \      'req' : "require '|'"
  \    },
  \    'snippets' : {
  \      'use' : "use strict\nuse warnings\n\n",
  \      'w' : "warn \"${cursor}\";",
  \    },
  \  },
  \  'php' : {
  \    'extends' : 'html',
  \    'filters' : 'html,c',
  \  },
  \  'css' : {
  \    'filters' : 'fc',
  \  },
  \  'javascript' : {
  \    'snippets' : {
  \      'jq' : "$(function() {\n\t${cursor}${child}\n});",
  \      'jq:each' : "$.each(arr, function(index, item)\n\t${child}\n});",
  \      'fn' : "(function() {\n\t${cursor}\n})();",
  \      'tm' : "setTimeout(function() {\n\t${cursor}\n}, 100);",
  \    },
  \  },
  \ 'java' : {
  \  'indentation' : '    ',
  \  'snippets' : {
  \   'main': "public static void main(String[] args) {\n\t|\n}",
  \   'println': "System.out.println(\"|\");",
  \   'class': "public class | {\n}\n",
  \  },
  \ },
  \}

" =============
" CTags
" =============
"" CTags {{{
if has('win32')
	" 对常用项目使用时可添加这一段 
    " 添加额外的 tags，需要先生成。
	" set tags+=D:/work/railsdemo/tags
	" set path+=D:/work/railsdemo/,D:/work/railsdemo/*
else
	" set tags+=/usr/include/gtk-2.0/gtk/tags,/usr/include/gtk-2.0/gdk/tags
	" set path+=/usr/include/gtk-2.0/gtk/*,/usr/include/gtk-2.0/gdk/*
endif
" }}}

"" taglists {{{
" <CR>		跳到光标下tag所定义的位置，用鼠标双击此tag功能也一样
" o			在一个新打开的窗口中显示光标下tag
" <Space>	显示光标下tag的原型定义
" u			更新taglist窗口中的tag
" s			更改排序方式，在按名字排序和按出现顺序排序间切换
" x			taglist窗口放大和缩小，方便查看较长的tag
" +			打开一个折叠，同zo
" -			将tag折叠起来，同zc
" *			打开所有的折叠，同zR
" =			将所有tag折叠起来，同zM
" [[		跳到前一个文件
" ]]		跳到后一个文件
" q			关闭taglist窗口
" <F1>		显示帮助
" nnoremap <silent> <C-F7> :TlistToggle<CR>
map <F7> :TlistToggle<cr>
" 按照名称排序
let Tlist_Sort_Type = "name"
" 在右侧显示窗口
let Tlist_Use_Right_Window = 1
" 压缩方式
let Tlist_Compart_Format = 1
" 不要关闭其他文件的tags
let Tlist_File_Fold_Auto_Close = 0
" 不要显示折叠树
let Tlist_Enable_Fold_Column = 1
" 不同时显示多个文件的tag，只显示当前文件的，多个 tab 时会出错。
" let Tlist_Show_One_File = 1
let Tlist_Show_One_File = 0
" 如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick=1
let Tlist_File_Fold_Auto_Close=0
" }}}

"" ctags.vim {{{
if has('win32')
	let g:ctags_path='D:/Vim/vim73/ctags.exe'
endif
let g:ctags_title=0			" To show tag name in title bar.
let g:ctags_statusline=0		" To show tag name in status line.
let generate_tags=1			" To start automatically when a supported file is opened.
let g:ctags_regenerate=0
" }}}





"" fold {{{
" 用空格键来开关折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>
set foldenable
set foldlevel=100 " don't autofold anything (but I can still fold manually)
set foldopen -=search " don't open folds when search into them
set foldopen -=undo
" fdm=expr: fde=getline(v\:lnum)=~'.'?1\:0: foldtext=foldtext().v\:folddashes.getline(v\:foldstart+1): foldcolumn=2
" 去除空行
" set foldexpr=getline(v:lnum)=~'\\S'&&getline(v:lnum-1)!~'\\S'?'>1':'='
au FileType fuck set fdm=expr | foldexpr=getline(v:lnum)=~'^\\S!'&&getline(v:lnum-1)!~'\\S'?'>1':'='
au FileType txt,vim,lisp set fdm=expr | set fde=getline(v\:lnum)=~'.'?1:0
			\ | set foldtext=foldtext().v:folddashes.getline(v:foldstart+1)
			\ | set foldcolumn=1
au FileType cpp,c,java set foldmethod=syntax | set foldcolumn=2
au FileType perl,tex,php,html,css,sh,ruby,eruby set foldmethod=indent
			\ | set foldcolumn=2
nmap <leader>fc :set foldcolumn=1<cr>
nmap <leader>fC :set foldcolumn=0<cr>
" }}}

" 代码折叠
"vim 提供以下6种方法来选定折叠方式：
"manual 手工定义折叠
"indent 更多的缩进表示更高级别的折叠
"expr 用表达式来定义折叠
"syntax 用语法高亮来定义折叠
"diff 对没有更改的文本进行折叠
"marker 对文中的标志折叠
"
"按照语法高亮来折叠代码, 其实就是按照代码中的一些括号来定义折叠位置, 比如: "{ }", "/* */". 现在练习一下, 
"就在nomal模式下输入命令"za", 你会发现当前光标所在的最近的一层括号被折叠起来了, 再输入一遍"za"命令, 这个折叠又打开了, 
""za"命令就是打开/关闭当前折叠用的, 下面是常用的一些命令:
"za 打开/关闭当前折叠
"zA 循环地打开/关闭当前折叠
"zo 打开当前折叠
"zc 关闭当前折叠
"zM 关闭所有折叠
"zR 打开所有折叠

""windowsmanage
let g:winManagerWindowLayout='FileExplorer|TagList' 
nmap wm :WMToggle<cr>


"" cscope haha {{{
" 生成一个cscope的数据库, 在项目的根目录运行下面的命令:
" cd /home/wooin/vim71/ 
" $ cscope -Rbq # 
" 此后会生成三个文件 cscope.in.out  cscope.out  cscope.po.out 
"
" 
" 把刚才生成的cscope文件导入到vim中来, 用下面的命令:
" :cs add /home/wooin/vim71/cscope.out /home/wooin/vim71
"
" 查找函数vim_strsave()的定义, 用命令:
" :cs find g vim_strsave
"
" 当光标停在某个你要查找的词上时, 按下<C-_>g(先按"Ctrl+Shift+-", 然后很快再按"g"),就是查找该对象的定义,
if has("cscope")
    if has('win32')
        set csprg='D:\vim\vim73\cscope.exe'
        "set csprg='$VIMRUNTIME\cscope.exe'
	    "let g:ctags_path='D:/Vim/vim73/ctags.exe'
    else    
        set csprg=/usr/local/bin/cscope
    endif

    set csto=0
    set cst
    set nocsverb

    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
    
    nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR> 
    nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> 
    nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif
" }}}


"" 8.QuickFix 窗口 
"" :help quickfix
"" 用下面的命令调出QuickFix窗口:
"" :cw

"" 在编程的时候不可能永远只编辑一个文件, 你肯定会打开很多源文件进行编辑, 如果每个文件都打开一个vim进行编辑的话那操作起来将是多麻烦啊, 所以vim有buffer(缓冲区)的概念, 可以看vim的帮助: :help buffer
""vim自带的buffer管理工具只有:ls, :bnext, :bdelete 等的命令,



"" 9.快速浏览和操Buffer -- 插件: MiniBufExplorer {{{
"===============================================================
"MiniBufExplorer
"===============================================================
" 允许 MiniBuf 使用 Ctrl-Tab 和 Ctrl-S-Tab来向前向后切换标签
""let g:miniBufExplMapCTabSwitchBufs = 1
" 允许 MinBuf 使用 ctrl-h,j,k,l 来上下左右选择窗口
""let g:miniBufExplMapWindowNavVim = 1
" 允许 MinBuf 使用 C-箭头来切换上下左右窗口
""let g:miniBufExplMapWindowNavArrows = 1""""
"}}}


"" 14.加速你的补全 -- 插件: SuperTab
let g:SuperTabDefaultCompletionType="<C-X><C-O>" 
" 设置按下<Tab>后默认的补全方式, 默认是<C-P>,  现在改为<C-X><C-O>. 关于<C-P>的补全方式, 
"  还有其他的补全方式, 你可以看看下面的一些帮助: 
"  :help ins-completion " :help compl-omni
"
let g:SuperTabRetainCompletionType=2 
" 0 - 不记录上次的补全方式
" 1 - 记住上次的补全方式,直到用其他的补全命令改变它 
" 2 - 记住上次的补全方式,直到按ESC退出插入模式为止


"Fuzzyfinder： {{{
"if has("g:fuf_modesDisable")
    " :FufBuffer " launchs Fuzzyfinder as Buffer mode.
    " :FufFile " launchs Fuzzyfinder as File mode.
    " :FufDir " launchs Fuzzyfinder as Directory mode.
    " :FufMruFile " launchs Fuzzyfinder as MRU-File mode.
    " :FufMruCmd " launchs Fuzzyfinder as MRU-Command mode.
    " :FufBookmark " launchs Fuzzyfinder as Bookmark mode.
    " :FufTag " launchs Fuzzyfinder as Tag mode.
    " :FufTaggedFile " launchs Fuzzyfinder as Tagged-File mode.
    let g:fuf_modesDisable = []
    " Command           Mode ~ 
    "|:FufBuffer|       - Buffer mode (|fuf-buffer-mode|) 
    map fb    <esc>:FufBuffer<cr>
    "|:FufFile|         - File mode (|fuf-file-mode|) 
    map ff    <esc>:FufFile<cr>
    "|:FufCoverageFile| - Coverage-File mode (|fuf-coveragefile-mode|) 
    map fc    <esc>:FufCoverageFile<cr>
    "|:FufDir|          - Directory mode (|fuf-dir-mode|) 
    map fd    <esc>:FufDir<cr>
    "|:FufMruFile|      - MRU-File mode (|fuf-mrufile-mode|) 
    map fmf    <esc>:FufMruFile<cr>
    "|:FufMruCmd|       - MRU-Command mode (|fuf-mrucmd-mode|) 
    map fmc    <esc>:FufMruCmd<cr>
    "|:FufBookmarkFile| - Bookmark-File mode (|fuf-bookmarkfile-mode|) 
    map fbf    <esc>:FufBookmarkFile<cr>
    "|:FufBookmarkDir|  - Bookmark-Dir mode (|fuf-bookmarkdir-mode|) 
    map fbd    <esc>:FufBookmarkDir<cr>
    "|:FufTag|          - Tag mode (|fuf-tag-mode|) 
    map ft    <esc>:FufTag<cr>
    "|:FufBufferTag|    - Buffer-Tag mode (|fuf-buffertag-mode|) 
    map fbt    <esc>:FufBufferTag<cr>
    "|:FufTaggedFile|   - Tagged-File mode (|fuf-taggedfile-mode|) 
    map faf   <esc>:FufTaggedFile<cr>
    "|:FufJumpList|     - Jump-List mode (|fuf-jumplist-mode|) 
    map fjl    <esc>:FufJumpList<cr>
    "|:FufChangeList|   - Change-List mode (|fuf-changelist-mode|) 
    map fcl    <esc>:FufChangeList<cr>
    "|:FufQuickfix|     - Quickfix mode (|fuf-quickfix-mode|) 
    map fqf    <esc>:FufQuickfix<cr>
    "|:FufLine|         - Line mode (|fuf-line-mode|) 
    map fl    <esc>:FufLine<cr>
    "|:FufHelp|         - Help mode (|fuf-help-mode|) 
    map fh    <esc>:FufHelp<cr>
    map <silent> <c-\> :FufTag! <c-r>=expand('<cword>')<cr><cr>
    map <c-f12> <esc>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
"endif
"}}}

" AutoComplPop : Automatically opens popup menu for completions {{{
" http://www.vim.org/scripts/script.php?script_id=1879
"
let g:acp_behaviorSnipmateLength = 1
" To enable auto-popup for this completion, add following function to 
" plugin/snipMate.vim: 
" > 
"  fun! GetSnipsInCurrentScope() 
"    let snips = {} 
"    for scope in [bufnr('%')] + split(&ft, '\.') + ['_'] 
"      call extend(snips, get(s:snippets, scope, {}), 'keep') 
"      call extend(snips, get(s:multi_snips, scope, {}), 'keep') 
"    endfor 
"    return snips 
"  endf 
"< 
"And set |g:acp_behaviorSnipmateLength| option to 1. 
"}}}
