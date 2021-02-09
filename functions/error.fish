function error --description='\
A simple, light-weight, user-friendly error message handler/printer.'
    # If the first argument is an integer, use it as the error code:
    if string match -qr '^\d+$' -- $argv[1]
        set code $argv[1]
        set argv $argv[2..-1]
    # If not, the error code defaults to 1:
    else
        set code 1
    end
    # The next argument is the error message:
    set message $argv[1]
    # All other arguments are the error value:
    # This makes is possible to leave a variable unquoted as the last parameter:
    #     error $status 'An error occured.' $argv
    # This would otherwise only show the first entry of $argv.
    set value $argv[2..-1]

    # If the error code is 0, do nothing – 0 indicates success:
    if test $code -eq 0
        return
    end

    # Write out the error message:
    if test -n "$message"
        echo (status current-command): $message >&2
    end
    # Write out the specific error value if specified:
    if test -n "$value"
        echo "Specifically: $value" >&2
    end
    if set -q code
        # If error is used inside command substitution, it makes sense to echo
        # the error code, so that it will be the result of the substitution:
        if status is-command-substitution
            echo $code
        end
        return $code
    end
end
