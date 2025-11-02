let &makeprg='cd cmake-build-$BUILD && conan build ..'
let $VIMCOMPILER='all'
call CompilerChanged()
