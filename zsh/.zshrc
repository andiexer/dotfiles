# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# history
HISTFILE=~/.zsh_history

# theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# source 
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"

# plugins
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/fzf"
plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"
plug "chrishrb/zsh-kubectl"
plug "wintermi/zsh-brew"
plug "romkatv/powerlevel10k"

export PATH="$HOME/.local/bin":$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
