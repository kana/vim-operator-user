map _  <Plug>(operator-echo)
call operator#user#define('echo', 'OperatorMemorize')
let s:register = ['', '']
function! OperatorMemorize(motion_wise)
  let s:register = [operator#user#register(), v:register]
endfunction

" This :normal! overwrites v:register.
onoremap au  :<C-u>normal! v$<Return>

function! Do(normal_command)
  execute 'normal' a:normal_command
  return s:register
endfunction

let ToUseRegister = {}
function! ToUseRegister.match(actual, expected)
  return a:actual ==# a:expected
endfunction
call vspec#customize_matcher('to_use_register', ToUseRegister)

describe 'operator#user#define'
  before
    new

    " Reset v:register to '"' for ease of testing.
    "
    " Unfortunately, v:register is not reset after executing each operator.
    " But it is reset after executing non-operator command such as h, j, etc.
    " So that 'operatorfunc' might use a wrong v:register value.  Suppose that
    " user types `"ayyg@g@`, v:register should contain '"', but it actually
    " contains 'a'.  The same can be said for `"ayyddg@g@`.
    normal! ""Y
  end

  after
    close!
  end

  it 'supports a register designation'
    Expect Do('__') ==# ['"', '"']
    Expect Do('""_L') ==# ['"', '"']
    Expect Do('"A_w') ==# ['A', 'A']
    Expect Do('3"x_w') ==# ['x', 'x']
    Expect Do('"y8_G') ==# ['y', 'y']
    Expect Do('v_') ==# ['"', '"']
    Expect Do('V""_') ==# ['"', '"']
    Expect Do('v"A_') ==# ['A', 'A']
    Expect Do('V3"x_') ==# ['x', 'x']
    Expect Do('v"y8_') ==# ['y', 'y']
  end

  it 'recognizes the last register even if combined with a custom text object'
    Expect Do('_au') ==# ['"', '"']
    Expect Do('""_au') ==# ['"', '"']
    Expect Do('"A_au') ==# ['A', '"']
    Expect Do('3"x_au') ==# ['x', '"']
    Expect Do('"y8_au') ==# ['y', '"']
  end
end
