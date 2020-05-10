function bwu --description "Unlock the Bitwarden session"
    set -xU BW_SESSION (bw unlock --raw $argv[1])
  end

function bwcopy --description "Find and copy a Bitwarden password"
  if command -sq bw and command -sq fzf-tmux and command -sq xclip
    bw get item (
    bw list items \
    | jq -r '.[] | [.name, .login.username // "", .id] | @tsv' \
    | column -t -s \t \
    | fzf-tmux --with-nth 1..-2 --preview-window down:2 \
    --preview 'bw get item (echo {} | awk \'{print $NF}\') | jq -r \'.login.uris | .[] | .uri // empty \'' \
    | awk '{print $NF}'
    ) | jq -r '.login.password' | xclip -selection clipboard
  end
end
