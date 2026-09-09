" after/indent/astro.vim
"
" Astro の frontmatter (--- ... ---) は TypeScript だが、Neovim 同梱の
" runtime/indent/astro.vim (wuelnerdotexe/vim-astro 由来, "experimental") は
" frontmatter の中身も HTML インデンタ (HtmlIndent) に丸投げする。そのため
"   - 未閉じの ( や [ の中の継続行
"   - 行末カンマでの継続
"   - 閉じ括弧での dedent
" を一切扱えず、閉じ括弧の行や直後の Enter で余計なインデントが入る。
"
" ここでは frontmatter 内の行だけ Neovim 同梱の typescript インデント
" (GetTypescriptIndent) に委譲し、テンプレート部は従来どおり
" GetAstroIndent()（= HTML インデント）に任せる。
"
" indentkeys は astro 標準のまま維持する。余分なトリガ (; や < など) が
" 増えても GetAstroIndentPatched() が呼ばれるだけで、そこで frontmatter /
" template を振り分けるので実害はない。

" 標準 astro インデントは既にロード済み (indentexpr=GetAstroIndent())。
let b:astro_html_indentexpr =
      \ empty(&l:indentexpr) ? '-1' : &l:indentexpr

" 同梱 typescript インデント関数を Neovim セッション中一度だけ読み込む。
" typescript.vim は indentexpr/indentkeys 等を上書きするので astro 用に戻す。
if !exists('*GetTypescriptIndent')
  let s:save_inde = &l:indentexpr
  let s:save_indk = &l:indentkeys
  let s:save_si   = &l:smartindent
  let s:save_undo = get(b:, 'undo_indent', '')
  let s:save_did  = get(b:, 'did_indent', 0)

  unlet! b:did_indent
  runtime indent/typescript.vim

  let &l:indentexpr  = s:save_inde
  let &l:indentkeys  = s:save_indk
  let &l:smartindent = s:save_si
  let b:undo_indent  = s:save_undo
  let b:did_indent   = s:save_did

  unlet s:save_inde s:save_indk s:save_si s:save_undo s:save_did
endif

if exists('*GetTypescriptIndent')
  let b:astro_ts_indentexpr = 'GetTypescriptIndent()'
endif

" frontmatter の閉じ --- は先頭付近にあるのが普通。壊れたファイルで
" 全行走査しないよう上限を設ける。
let s:frontmatter_scan_limit = 500

" a:lnum 行が frontmatter (先頭 --- から次の --- の間) にあるか。
function! s:AstroInFrontmatter(lnum) abort
  if getline(1) !~# '^---\s*$'
    return 0
  endif
  let l:limit = min([line('$'), s:frontmatter_scan_limit])
  let l:i = 2
  while l:i <= l:limit
    if getline(l:i) =~# '^---\s*$'
      " 閉じ --- が見つかった: その手前までが frontmatter
      return a:lnum > 1 && a:lnum < l:i
    endif
    let l:i += 1
  endwhile
  " 閉じ --- がまだ無い (編集途中): 2 行目以降を frontmatter 扱い
  return a:lnum >= 2
endfunction

function! GetAstroIndentPatched() abort
  " フェンス行 (--- 単独) は常に桁 0。編集途中に直前の TS 行へ
  " 引きずられて右にずれるのを防ぐ。
  if getline(v:lnum) =~# '^\s*---\s*$'
    return 0
  endif

  if exists('b:astro_ts_indentexpr') && s:AstroInFrontmatter(v:lnum)
    " frontmatter 本文の先頭行。直前が開始フェンス --- だと
    " GetTypescriptIndent() が --- を継続行とみなして余計にインデント
    " するので、ここは桁 0 に固定する。
    if prevnonblank(v:lnum - 1) <= 1
      return 0
    endif
    execute 'return ' . b:astro_ts_indentexpr
  endif

  execute 'return ' . b:astro_html_indentexpr
endfunction

setlocal indentexpr=GetAstroIndentPatched()
