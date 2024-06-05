if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Enable starship theme
starship init fish | source

# Disable greeting message
set -U fish_greeting
