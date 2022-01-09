zmodload zsh/datetime
start=$EPOCHREALTIME

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Paths
path+=('/home/rak/.local/bin')


# Variables

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
export EDITOR=micro
export GIT_EDITOR=micro


# Aliases

alias cp='cp --reflink=auto'
alias nano=micro
alias wake=wol
alias -g server='00:23:24:26:f5:26'
alias -g serverSSH='ssh hoster@31.19.156.183 -p 1475'
alias yay=paru
alias gov='sudo .config/sway/gov.sh'
alias nextbg='pkill swaybg && pkill bg.sh && .config/sway/bg.sh & disown'
alias cat='bat'
alias ls='exa'
#alias grep='rg'

alias brightup="brightnessctl set 1%+ | sed -En 's/.*\(([0-9]+)%\).*/\1/p' > $XDG_RUNTIME_DIR/wob.sock"


# Options

bindkey -e

bindkey -- "$terminfo[kLFT5]"  backward-word
bindkey -- "$terminfo[kRIT5]"  forward-word
bindkey -- "$terminfo[kdch1]"  delete-char

setopt sharehistory autocd extendedglob

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' menu select

# - fzf tab Options

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'


autoload -Uz compinit edit-command-line add-zsh-hook

TRAPUSR1() {
	rehash
}

# End of lines added by compinstall

compinit
zle -N edit-command-line

source $HOME/git/fzf-tab/fzf-tab.plugin.zsh
source $HOME/git/zsh-completions/zsh-completions.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/history-search-multi-word/history-search-multi-word.plugin.zsh

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

source $HOME/.zshenv


bindkey '^X^e' edit-command-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

let "dur = $EPOCHREALTIME - $start"
#echo "Execution time: $dur seconds"
