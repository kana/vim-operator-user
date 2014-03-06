map L  <Plug>(operator-align-right)
call operator#user#define('align-right', 'Op_command_right')
function! Op_command_right(motion_wiseness)
  '[,']right
endfunction

describe 'Align-right operator'
  before
    new
    read t/fixtures/sample.txt
    1
    setlocal tw=60
  end

  after
    close!
  end

  it 'aligns target lines specified by a motion'
    normal L2j
    Expect getline(1, 4) ==# [
    \   '   Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   '  sed do eiusmod tempor incididunt ut labore et dolore magna',
    \   '  aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]
  end

  it 'aligns target lines specified from Visual mode'
    normal vjL
    Expect getline(1, 4) ==# [
    \   '   Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   '  sed do eiusmod tempor incididunt ut labore et dolore magna',
    \   'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]
  end

  it 'aligns the current line if the operator is typed twice'
    normal jLL
    Expect getline(1, 4) ==# [
    \   'Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   '  sed do eiusmod tempor incididunt ut labore et dolore magna',
    \   'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]
  end
end

