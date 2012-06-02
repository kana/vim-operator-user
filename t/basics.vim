" FIXME: Minimize side effect to test.  (Use a temporary buffer.)

describe 'Internal key mappings'
  it 'should be defined in each mode'
    let _ = operator#user#_sid_prefix().'(count)'
    Expect maparg(_, 'c') != '' ==# 0
    Expect maparg(_, 'i') != '' ==# 0
    Expect maparg(_, 'n') != '' ==# 1
    Expect maparg(_, 'o') != '' ==# 0
    Expect maparg(_, 'v') != '' ==# 0
  end
end




describe 'operator#user#define'
  it 'should work with typical usage'
    function! TestOperatorFunction1(motion_wiseness)
      " echo getpos("'[") getpos("']")
      '[,']sort
    endfunction

    map _ <Plug>(operator-sort)
    noremap <Plug>(operator-sort)  xxx
    call operator#user#define('sort', 'TestOperatorFunction1')

    Expect maparg('<Plug>(operator-sort)', 'c') != '' ==# 0
    Expect maparg('<Plug>(operator-sort)', 'i') != '' ==# 0
    Expect maparg('<Plug>(operator-sort)', 'n') != '' ==# 1
    Expect maparg('<Plug>(operator-sort)', 'o') != '' ==# 1
    Expect maparg('<Plug>(operator-sort)', 'v') != '' ==# 1
    Expect maparg('<Plug>(operator-sort)', 'n')
    \      =~# '\<TestOperatorFunction1\>'
    Expect maparg('<Plug>(operator-sort)', 'o') ==# 'g@'
    Expect maparg('<Plug>(operator-sort)', 'v')
    \      =~# '\<TestOperatorFunction1\>'

    Expect maparg('_', 'c') != '' ==# 0
    Expect maparg('_', 'i') != '' ==# 0
    Expect maparg('_', 'n') != '' ==# 1
    Expect maparg('_', 'o') != '' ==# 1
    Expect maparg('_', 'v') != '' ==# 1
    Expect maparg('_', 'n') ==# '<Plug>(operator-sort)'
    Expect maparg('_', 'o') ==# '<Plug>(operator-sort)'
    Expect maparg('_', 'v') ==# '<Plug>(operator-sort)'

    silent put =['a', 'm', 'a', 'n', 'e']
    -4
    normal _4j
    Expect getline('.', line('.')+4) ==# ['a', 'a', 'e', 'm', 'n']

    silent put =['a', 'v', 'r', 'i', 'l']
    -4
    normal v4j_
    Expect getline('.', line('.')+4) ==# ['a', 'i', 'l', 'r', 'v']

    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal _5_
    Expect getline('.', line('.')+4) ==# ['a', 'e', 'g', 'n', 's']
  end

  it 'should support {operator}{operator} usage for a typical definition'
    SKIP 'It can not be tested from a script.'

      " FIXME: This one works as I expect if '5__' is typed interactively,
      "        but it doesn't work via :normal and it selects only the current
      "        line.  Why?
    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal 5__
    Expect getline('.', line('.')+4) ==# ['a', 'e', 'g', 'n', 's']
  end

  it 'should work with {extra}s'
    map _  <Plug>(operator-yank)
    call operator#user#define('yank', 'TestOperatorFunction2',
    \                         'call', 'TestOperatorFunction2Set("yank")')
    function! TestOperatorFunction2Set(command)
      let s:command = a:command
    endfunction
    function! TestOperatorFunction2(motion_wiseness)
      execute "'[,']" s:command
    endfunction

    silent put =['a', 'z', 'u', 's', 'a']
    -4

    silent normal __
    Expect @0 ==# "a\n"

    silent normal _2j
    Expect @0 ==# "a\nz\nu\n"

    silent normal v4j_
    Expect @0 ==# "a\nz\nu\ns\na\n"
  end

  it 'should not work with arbitrary script-local functions'
    SKIP 'It is hard to test.'

    " FIXME: Script-local functions should not be accepted here.
    "
    " Because 'operatorfunc' with any script-local function doesn't work
    " generally for the following reason:
    " ``E120: Using <SID> not in a script context: s:foo''.
    "
    " But this test is passed unexpectedly, because s: in 'operatorfunc' is
    " treated as the context of this test script.

    map @  <Plug>(operator-sort)
    call operator#user#define('sort', 's:test_operator_function_3')
    function! s:test_operator_function_3(motion_wiseness)
      " echo getpos("'[") getpos("']")
      '[,']sort
    endfunction

    Expect maparg('<Plug>(operator-sort)', 'c') != '' ==# 0
    Expect maparg('<Plug>(operator-sort)', 'i') != '' ==# 0
    Expect maparg('<Plug>(operator-sort)', 'n') != '' ==# 1
    Expect maparg('<Plug>(operator-sort)', 'o') != '' ==# 1
    Expect maparg('<Plug>(operator-sort)', 'v') != '' ==# 1
    Expect maparg('<Plug>(operator-sort)', 'n')
    \      =~# '\<test_operator_function_3\>'
    Expect maparg('<Plug>(operator-sort)', 'o') ==# 'g@'
    Expect maparg('<Plug>(operator-sort)', 'v')
    \      =~# '\<test_operator_function_3\>'

    Expect maparg('@', 'c') != '' ==# 0
    Expect maparg('@', 'i') != '' ==# 0
    Expect maparg('@', 'n') != '' ==# 1
    Expect maparg('@', 'o') != '' ==# 1
    Expect maparg('@', 'v') != '' ==# 1
    Expect maparg('@', 'n') ==# '<Plug>(operator-sort)'
    Expect maparg('@', 'o') ==# '<Plug>(operator-sort)'
    Expect maparg('@', 'v') ==# '<Plug>(operator-sort)'

    silent % delete _

    silent put =['a', 'm', 'a', 'n', 'e']
    -4
    normal @4j
    Expect getline('.', line('.')+4) ==# ['a', 'a', 'e', 'm', 'n']

    silent put =['a', 'v', 'r', 'i', 'l']
    -4
    normal v4j@
    Expect getline('.', line('.')+4) ==# ['a', 'i', 'l', 'r', 'v']

    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal @5@
    Expect getline('.', line('.')+4) ==# ['a', 'e', 'g', 'n', 's']

      " FIXME: This one works as I expect if '5@@' is typed interactively,
      "        but it doesn't work via :normal and it selects only the current
      "        line.  Why?
    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal 5@@
    Expect getline('.', line('.')+4) ==# ['a', 'e', 'g', 'n', 's']
  end

  it 'should support count in Visual mode'
    TODO

    function! TestOperatorFunction4(motion_wiseness)
      normal! `[v`]gU
    endfunction
    map _  <Plug>(operator-gU)
    call operator#user#define('gU', 'TestOperatorFunction4')

    silent put =['avril agnes', 'amane alice']
    -1
    normal e_4l
    Expect getline('.', line('.')+1) ==# ['avriL AGnes', 'amane alice']

      " FIXME: count in Visual mode is not supported.
    silent put =['avril agnes', 'amane alice']
    -1
    normal 3lv3_
    Expect getline('.', line('.')+1) ==# ['avrIl agnes', 'amane alice']
  end

  it 'should support register designation for user defined operator'
    map _  <Plug>(operator-echo)
    call operator#user#define('echo', 'TestOperatorFunction6')
    function! TestOperatorFunction6(motion_wise)
      put =v:register
    endfunction

    normal __
    Expect getline('.') ==# '"'

    normal ""_L
    Expect getline('.') ==# '"'

    normal "A_w
    Expect getline('.') ==# 'A'

    normal 3"x_k
    Expect getline('.') ==# 'x'

    normal "y8_G
    Expect getline('.') ==# 'y'

    normal v_
    Expect getline('.') ==# '"'

    normal V""_
    Expect getline('.') ==# '"'

    normal v"A_
    Expect getline('.') ==# 'A'

    normal V3"x_
    Expect getline('.') ==# 'x'

    normal v"y8_
    Expect getline('.') ==# 'y'
  end
end




describe 'operator#user#define_ex_command'
  it 'should work with typical usage'
    map _  <Plug>(operator-join)
    call operator#user#define_ex_command('join', 'join')

    silent put =['a', 'm', 'a', 'n', 'e']
    -4
    normal _3j
    Expect getline('.', line('.')+1) ==# ['a m a n', 'e']

    silent put =['a', 'v', 'r', 'i', 'l']
    -4
    normal v3j_
    Expect getline('.', line('.')+1) ==# ['a v r i', 'l']

    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal _3_
    Expect getline('.', line('.')+2) ==# ['a g n', 'e', 's']

    silent put =['a', 'm', 'a', 'n', 'e']
    -4
    normal v3j_
    Expect getline('.', line('.')+1) ==# ['a m a n', 'e']
  end

  it 'should support {operator}{operator} usage'
    SKIP 'It can not be tested from a script.'

      " FIXME: This one works as I expect if '5__' is typed interactively,
      "        but it doesn't work via :normal and it selects only the current
      "        line.  Why?
    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal 4__
    Expect getline('.', line('.')+1) ==# ['a g n e', 's']
  end

  it 'should support count in Visual mode'
    TODO

      " FIXME: count in Visual mode is not supported.
    silent put =['a', 'g', 'n', 'e', 's']
    -4
    normal v3_
    Expect getline('.', line('.')+4) ==# ['a', 'g', 'n', 'e', 's']
  end

  it 'should accept a one-line script, especially including "''"'
    map _  <Plug>(operator-substitute)
    call operator#user#define_ex_command('substitute', 's/-/''/')

    silent put =['foo-bar-baz']
    Expect getline('.', line('.')+0) ==# ['foo-bar-baz']
    normal V_
    Expect getline('.', line('.')+0) ==# ['foo''bar-baz']
    normal V_
    Expect getline('.', line('.')+0) ==# ['foo''bar''baz']
  end
end




describe 'operator#user#visual_command_from_wise_name'
  it 'should work'
    " Valid usage
    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('char')
    Expect _ ==# 'v'
    Expect v:errmsg ==# ''

    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('char')
    Expect operator#user#visual_command_from_wise_name('line') ==# 'V'
    Expect v:errmsg ==# ''

    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('char')
    Expect operator#user#visual_command_from_wise_name('block') ==# "\<C-v>"
    Expect v:errmsg ==# ''

    " Invalid {wise-name} - completely different
    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('invalid')
    Expect _ ==# 'v'
    Expect v:errmsg =~# 'operator-user:E1:'

    " Invalid {wise-name} - different cases
    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('Char')
    Expect _ ==# 'v'
    Expect v:errmsg =~# 'operator-user:E1:'

    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('lIne')
    Expect _ ==# 'v'
    Expect v:errmsg =~# 'operator-user:E1:'

    let v:errmsg = ''
    silent! let _ = operator#user#visual_command_from_wise_name('lIne')
    Expect _ ==# 'v'
    Expect v:errmsg =~# 'operator-user:E1:'
  end
end
