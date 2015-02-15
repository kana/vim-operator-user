map _  <Plug>(operator-echo)
call operator#user#define('echo', 'OperatorEcho')
function! OperatorEcho(motion_wise)
  put =v:register
endfunction

describe 'operator#user#define'
  before
    new
  end

  after
    close!
  end

  it 'supports a register designation'
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
