" operator-user - Define your own operator easily
" Version: 0.0.2
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
function! operator#user#define(name, function_name, ...)  "{{{2
  return call('operator#user#_define',
  \           ['<Plug>(operator-' . a:name . ')', a:function_name] + a:000)
endfunction




function! operator#user#define_ex_command(name, ex_command)  "{{{2
  return operator#user#define(
  \        a:name,
  \        'operator#user#_do_ex_command',
  \        'call operator#user#_set_ex_command(''' . a:ex_command . ''')'
  \      )
endfunction




function! operator#user#_define(operator_keyseq, function_name, ...)  "{{{2
  if 0 < a:0
    let additional_settings = '\|' . join(a:000)
  else
    let additional_settings = ''
  endif

  execute printf(('nnoremap <script> <silent> %s ' .
  \               ':<C-u>set operatorfunc=%s%s<Return><SID>(count)g@'),
  \              a:operator_keyseq, a:function_name, additional_settings)
  execute printf(('vnoremap <script> <silent> %s ' .
  \               '<Esc>:<C-u>set operatorfunc=%s%s<Return>gvg@'),
  \              a:operator_keyseq, a:function_name, additional_settings)
  execute printf('onoremap %s  g@', a:operator_keyseq)
endfunction




function! operator#user#_do_ex_command(motion_wiseness)  "{{{2
  execute "'[,']" s:ex_command
endfunction




function! operator#user#_set_ex_command(ex_command)  "{{{2
  let s:ex_command = a:ex_command
endfunction




function! operator#user#_sid_prefix()  "{{{2
  return s:SID_PREFIX()
endfunction








" Misc.  "{{{1

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '\%(^\|\.\.\)\zs<SNR>\d\+_\zeSID_PREFIX$')
endfunction


nnoremap <expr> <SID>(count)  v:count == v:count1 ? v:count : ''

" FIXME: It's hard for user-defined operator to handle count in Visual mode.
" vnoremap <expr> <SID>(count)  v:count == v:count1 ? v:count : ''


" See operator#user#_do_ex_command() and operator#user#_set_ex_command().
" let s:ex_command = ''








" __END__  "{{{1
" vim: foldmethod=marker
