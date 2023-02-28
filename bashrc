#!/bin/bash
. ~/.bash_profile

export CLICOLOR=1

if [[ -n "$VIM_TERMINAL" ]]; then
    PROMPT_COMMAND='_vim_sync_PWD'
    function _vim_sync_PWD() {
      printf '\033]51;["call", "Tapi_lcd", "%q"]\007' "$PWD"
    }
fi
