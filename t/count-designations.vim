map C  <Plug>(operator-align-right)
call operator#user#define('align-right', 'Op_count')
function! Op_count(_)
  let s = printf('%d line(s)', line("']") - line("'[") + 1)
  $put =s
endfunction

describe 'operator#user#define'
  before
    new
    read t/fixtures/sample.txt
    1
    function! b:.check(cases)
      for [command, c] in a:cases
        execute 'normal' 'gg'.command
        Expect [command, 'targets', getline('$')]
        \ ==# [command, 'targets', printf('%d line(s)', c)]
      endfor
    endfunction
  end

  after
    close!
  end

  it 'supports a count given to an operator'
    call b:.check([
    \   ['CC', 1],
    \   ['1CC', 1],
    \   ['2CC', 2],
    \   ['6CC', 6],
    \ ])
  end

  it 'supports a count given to a motion'
    call b:.check([
    \   ['C2C', 2],
    \   ['C3C', 3],
    \   ['C6C', 6],
    \ ])
  end

  it 'supports counts given to both an operator and a motion'
    call b:.check([
    \   ['2C3C', 6],
    \   ['4C2C', 8],
    \ ])
  end
end
