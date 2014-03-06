describe 'operator#user#define_ex_command'
  before
    new
  end

  after
    close!
  end

  it 'accepts a one-line script, especially including "''"'
    map <buffer> _  <Plug>(operator-substitute)
    call operator#user#define_ex_command('substitute', 's/-/''/')

    silent put =['foo-bar-baz']
    Expect getline('.', line('.')+0) ==# ['foo-bar-baz']
    normal V_
    Expect getline('.', line('.')+0) ==# ['foo''bar-baz']
    normal V_
    Expect getline('.', line('.')+0) ==# ['foo''bar''baz']
  end
end

