map H  <Plug>(operator-align-left)
map L  <Plug>(operator-align-right)
map M  <Plug>(operator-align-center)

call operator#user#define_ex_command('align-left', 'left')
call operator#user#define_ex_command('align-right', 'right')
call operator#user#define_ex_command('align-center', 'center')

describe 'Align operators'
  before
    new
    read t/fixtures/sample.txt
    1
    setlocal tw=60
  end

  after
    close!
  end

  it 'aligns target lines'
    normal L2j
    Expect getline(1, 4) ==# [
    \   '   Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   '  sed do eiusmod tempor incididunt ut labore et dolore magna',
    \   '  aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]

    normal M2j
    Expect getline(1, 4) ==# [
    \   ' Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   ' sed do eiusmod tempor incididunt ut labore et dolore magna',
    \   ' aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]

    normal H2j
    Expect getline(1, 4) ==# [
    \   'Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   'sed do eiusmod tempor incididunt ut labore et dolore magna',
    \   'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]
  end
end

