## RSpec testing
# provides aliases for:
# - test-run-nearest
# - test-run-file
# - test-run-all

# define-command rspec-example %{
	# edit ~/code/github.com/chrisseaton/rhizome/stdout
    	# set-option buffer filetype rspec-progress
# }
# map global user t %{:rspec-example<ret>} -docstring "Open rspec report"

hook global WinSetOption path=*_spec.rb %{
    require-module rspec

    # set-option window static_words %opt{ruby_static_words}

    # hook window ModeChange pop:insert:.* -group ruby-trim-indent ruby-trim-indent
    # hook window InsertChar .* -group ruby-indent ruby-indent-on-char
    # hook window InsertChar \n -group ruby-indent ruby-indent-on-new-line
    # hook window InsertChar \n -group ruby-insert ruby-insert-on-new-line

    alias window test-run-nearest rspec-run-nearest
    alias window test-run-file rspec-run-file
    alias window test-run-all rspec-run-all

    hook -once -always window WinSetOption path=.* %{
        # remove-hooks window rspec-.+
        unalias window rspec-run-nearest test-run-nearest
        unalias window rspec-run-file test-run-file
        unalias window rspec-run-all test-run-all
    }
}

provide-module rspec %§

require-module fifo

declare-option -docstring "shell command run rspec" \
    str rspeccmd 'rspec'
declare-option -hidden int rspec_current_line 0

define-command rspec-run-nearest %{
    fifo -name *rspec-progress* %{
        trap - INT QUIT
        $kak_opt_rspeccmd
    }
    # set-option buffer filetype weather
    set-option buffer jump_current_line 0
}

define-command -params .. -docstring %{
    rspec [<arguments>]: rspec utility wrapper
    All optional arguments are forwarded to the rspec utility
} rspec %{ evaluate-commands %sh{
    # if no arguments are given pass the selection as an argument
     if [ $# -eq 0 ]; then
         set -- "${kak_selection}"
     fi

     output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-rspec.XXXXXXXX)/fifo
     mkfifo ${output}
     ( ${kak_opt_rspeccmd} "$@" | tr -d '\r' > ${output} 2>&1 & ) > /dev/null 2>&1 < /dev/null
     # ( ${kak_opt_rspeccmd} | tr -d '\r' > ${output} 2>&1 & ) > /dev/null 2>&1 < /dev/null

     printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
               edit! -fifo ${output} *rspec*
               set-option buffer filetype rspec-progress
               set-option buffer rspec_current_line 0
               hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname ${output}) } }
           }"
}}

hook global WinSetOption filetype=rspec-progress %{
    hook buffer -group rspec-hooks NormalKey <ret> rspec-jump
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks buffer rspec-hooks }
}

define-command -hidden rspec-jump %{
    evaluate-commands %{ # use evaluate-commands to ensure jumps are collapsed
        try %{
   	    execute-keys 'xs(\.(?:[/a-zA-Z0-9_\.]+)+)(?::(\d+))?<ret>'
            set-option buffer rspec_current_line %val{cursor_line}
            evaluate-commands -try-client %opt{jumpclient} -verbatim -- edit -existing %reg{1} %reg{2} %reg{3}
            try %{ focus %opt{jumpclient} }
        }
    }
}


# Setting up all the highlighters for this syntax
# could be expensive, so we'll define them inside a module
# that won't be loaded until we need it.
#
# Because this module might contain a bunch of regexes with
# unbalanced grouping symbols, we'll use some other character
# as a delimiter.
provide-module rspec-progress-syntax %&

# Regions
# - progress
# - pending
# - failures
# - failed examples
 
    # Define our highlighters in the shared namespace,
    # so we can link them later.
    add-highlighter shared/rspec-progress-syntax regions

    # add-highlighter shared/rspec-progress-syntax/progress region \A.*$ ^(Pending|Failures|Finished|Failed) regex (\.*)(\**)(F*) 1:green 2:yellow 3:red
    add-highlighter shared/rspec-progress-syntax/progress region \A(\.|\*|F)*$ '\n' regex (\.*)(\**)(F*) 1:green 2:yellow 3:red

    # A region from a `#` to the end of the line is a comment.
    add-highlighter shared/rspec-progress-syntax/ region '#' '\n' fill comment

    # A region from a `# ./**/*.rb` to the end of the line is a trace.
    add-highlighter shared/rspec-progress-syntax/trace region ^\s+#\s\./ '\s' group
    add-highlighter shared/rspec-progress-syntax/trace/ fill comment
    # underline filepaths
    add-highlighter shared/rspec-progress-syntax/trace/ regex \.(/([a-zA-z0-9_\.])+)+:\d+ 0:+u

    # A region starting and ending with a double-quote
    # is a group of highlighters.
    add-highlighter shared/rspec-progress-syntax/dqstring region '"' '"' group

    # By default, a double-quoted string is string-coloured.
    add-highlighter shared/rspec-progress-syntax/dqstring/ fill string

    # Some backslash-escaped characters are effectively keywords,
    # but most are errors.
    # add-highlighter shared/rspec-progress-syntax/dqstring/ \
        # regex (\\[\\abefhnrtv\n])|(\\.) 1:keyword 2:Error

    # Everything outside a region is a group of highlighters.
    add-highlighter shared/rspec-progress-syntax/other default-region group

    # Highlighting for numbers.
    # add-highlighter shared/rspec-progress-syntax/other/ \
        # regex (\+|-)?[0-9]+(\.[0-9]+)? 0:value

    # Highlighting for booleans.
    # add-highlighter shared/rspec-progress-syntax/other/ \
        # regex true|false 0:value

    # Highlighting for keywords.
    # add-highlighter shared/rspec-progress-syntax/other/ \
        # regex if|for|while|return|continue 0:keyword
&

# When a window's `filetype` option is set to this filetype...
hook global WinSetOption filetype=rspec-progress %{
    # Ensure our module is loaded, so our highlighters are available
    require-module rspec-progress-syntax

    # Link our higlighters from the shared namespace
    # into the window scope.
    add-highlighter window/rspec-progress-syntax ref rspec-progress-syntax

    # Add a hook that will unlink our highlighters
    # if the `filetype` option changes again.
    hook -once -always window WinSetOption filetype=.* %{
        remove-highlighter window/rspec-progress-syntax
    }
}

# Lastly, when a buffer is created for a new or existing file,
# and the filename ends with `.example`...
hook global BufCreate .+\.example %{
    # ...we recognise that as our filetype,
    # so set the `filetype` option!
    set-option buffer filetype example
}

§
