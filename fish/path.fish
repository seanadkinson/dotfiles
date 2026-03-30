
# Grab $PATHs from ~/.extra
set -l PATH_DIRS (cat "$HOME/.extra" | grep "^PATH" | \
    # clean up bash PATH setting pattern
    sed "s/PATH=//" | sed "s/\\\$PATH://" | \
    # rewrite ~/ to use {$HOME}
    sed "s/~\//{\$HOME}\//")

set -l PA $PATH

for entry in (string split \n $PATH_DIRS)
    # resolve the {$HOME} substitutions
    set -l resolved_path (eval echo $entry)
    if contains $resolved_path $PATH;
        continue; # skip dupes
    end
    if test -d "$resolved_path";
        set PA $PA "$resolved_path"
    end
end

# Google Cloud SDK.
if test -f "$HOME/google-cloud-sdk/path.fish.inc"
    source "$HOME/google-cloud-sdk/path.fish.inc"
end

fish_add_path ~/bin
fish_add_path ~/.maestro/bin
fish_add_path ~/.rvm/bin
fish_add_path ~/.local/bin

set --export PATH $PA
