# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

export PATH="/Users/andiexer/.local/bin:/usr/local/share/dotnet:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/andiexer/Library/Application Support/JetBrains/Toolbox/scripts:$HOME/dotnet"
export DOTNET_ROOT="$HOME/dotnet"
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export VISUAL="$EDITOR"
export MonolithRoot="/Users/andiexer/development/dg/devinite"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# history
HISTFILE=~/.zsh_history

# theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# source 
plug "$HOME/.config/zsh/aliases.zsh"

# plugins
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "zap-zsh/exa"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/andiexer/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
