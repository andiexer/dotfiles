# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

export PATH="/Users/andiexer/.local/bin:/usr/local/share/dotnet:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/andiexer/Library/Application Support/JetBrains/Toolbox/scripts:$HOME/dotnet:$PATH:/Users/andiexer/.dotnet/tools"
export DOTNET_ROOT="$HOME/dotnet"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export MonolithRoot="/Users/andiexer/development/dg/devinite"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export DOCKER_HOST=unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock 
export TESTCONTAINERS_RYUK_CONTAINER_PRIVILEGED=true


# history
HISTFILE=~/.zsh_history

# theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# source
plug "$HOME/.config/zsh/aliases.zsh"

# dotfiles bare repo
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# plugins
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "jeffreytse/zsh-vi-mode"
source <(kubectl completion zsh)
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/andiexer/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source <(fzf --zsh)

# bun completions
[ -s "/Users/andiexer/.bun/_bun" ] && source "/Users/andiexer/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/andiexer/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/andiexer/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/andiexer/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/andiexer/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
