# configure zls: we enable zig fmt, reference and semantic highlighting
hook global WinSetOption filetype=zig %{
    set-option buffer formatcmd 'zig fmt --stdin'
    set-option window lsp_auto_highlight_references true
    set-option global lsp_server_configuration zls.zig_lib_path="/usr/lib/zig"
    set-option -add global lsp_server_configuration zls.warn_style=true
    set-option -add global lsp_server_configuration zls.enable_semantic_tokens=true

    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#semantic-tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

hook global BufSetOption filetype=zig %{
    set-option buffer lintcmd 'zig fmt --color off --ast-check 2>&1'
    # To enable auto linting on buffer write
    #hook -group zig-auto-lint buffer BufWritePre .* lint-buffer
    hook -group zig-auto-lint buffer BufWritePre .* lsp-formatting-sync
}

declare-option str zig_test_watch_pid ''

define-command zig-start-watch %{
  evaluate-commands %sh{
    if [ -n "$kak_opt_zig_test_watch_pid" ] && kill -0 "$kak_opt_zig_test_watch_pid" 2>/dev/null; then
      exit 0
    fi

    # subshell and disown process.  We tag it for easy pgrep later
    # this way the process doesn't hangup when the shell exits
    printf %s\\n "fifo -name '*zig-build-test*' -scroll -script 'setsid env KAKOUNE_ZIG_WATCH=1 zig build test --watch --color on'"

    sleep 0.1

    pid=$(pgrep -f "KAKOUNE_ZIG_WATCH=1 zig build test --watch --color on" | head -n 1)

    if [ -n "$pid" ]; then
      printf %s\\n "
        set-option global zig_test_watch_pid '$pid'
        echo -debug 'RUNNING($pid): zig build test --watch'
      "
    fi
  }
  evaluate-commands %{
      # setting to grep allows us to jump to file refs in the buffer
      set-option buffer filetype grep
      ansi-enable # ansi highlight for current buffer
  }
}

define-command zig-stop-watch %{
  evaluate-commands %sh{
    if [ -n "$kak_opt_zig_test_watch_pid" ] && kill -0 "$kak_opt_zig_test_watch_pid" 2>/dev/null; then
      kill "$kak_opt_zig_test_watch_pid"
    fi
  }
}

hook global BufWritePost filetype=zig %{
  zig-start-watch
}

hook global KakEnd .* %{
  zig-stop-watch
}
