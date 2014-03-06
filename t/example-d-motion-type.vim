map vd  <Plug>(operator-void-delete)
call operator#user#define('void-delete', 'OperatorVoidDelete')
function! OperatorVoidDelete(motion_wise)
  let v = operator#user#visual_command_from_wise_name(a:motion_wise)
  execute 'normal!' '`[' . v . '`]"_d'
endfunction

describe 'Void-delete operator'
  before
    new
    read t/fixtures/sample.txt
    1
  end

  after
    close!
  end

  it 'operates on a right region with a characterwise motion'
    Expect @" ==# ''

    normal wvdiw

    Expect getline(1, 1) ==# [
    \   'Lorem  dolor sit amet, consectetur adipisicing elit,',
    \ ]
    Expect @" ==# ''
  end

  it 'operates on a right region with a linewise motion'
    Expect @" ==# ''

    normal wvdj

    Expect getline(1, 2) ==# [
    \   'aliqua. Ut enim ad minim veniam, quis nostrud exercitation',
    \   'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    \ ]
    Expect @" ==# ''
  end

  it 'operates on a right region with a blockwise motion'
    Expect @" ==# ''

    execute 'normal' "jwwvd\<C-v>/laboris\\zs\<Return>"

    Expect getline(1, 5) ==# [
    \   'Lorem ipsum dolor sit amet, consectetur adipisicing elit,',
    \   'sed do tempor incididunt ut labore et dolore magna',
    \   'aliqua. ad minim veniam, quis nostrud exercitation',
    \   'ullamco nisi ut aliquip ex ea commodo consequat.',
    \   'Duis aute irure dolor in reprehenderit in voluptate velit',
    \ ]
    Expect @" ==# ''
  end
end
