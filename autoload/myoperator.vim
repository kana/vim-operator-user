" myoperator - Define your own operator easily
" Version: 0.0.0
" Copyright (C) 2009 kana <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! myoperator#define(operator_keyseq, function_name, ...)  "{{{2
  if 0 < a:0
    let additional_settings = '\|' . join(a:000)
  else
    let additional_settings = ''
  endif

  execute printf(('nnoremap <script> <silent> %s ' .
  \               ':<C-u>set operatorfunc=%s%s<Return><SID>(count)g@'),
  \              a:operator_keyseq, a:function_name, additional_settings)
  execute printf(('vnoremap <script> <silent> %s ' .
  \               '<Esc>:<C-u>set operatorfunc=%s%s<Return>gv<SID>(count)g@'),
  \              a:operator_keyseq, a:function_name, additional_settings)
  execute printf('onoremap %s  g@', a:operator_keyseq)
endfunction




function! myoperator#_sid_prefix()  "{{{2
  return s:SID_PREFIX()
endfunction








" Misc.  "{{{1

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '\%(^\|\.\.\)\zs<SNR>\d\+_\zeSID_PREFIX$')
endfunction


nnoremap <expr> <SID>(count)  v:count == v:count1 ? v:count : ''
vnoremap <expr> <SID>(count)  v:count == v:count1 ? v:count : ''








" __END__  "{{{1
" vim: foldmethod=marker
