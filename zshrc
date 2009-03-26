#setenv MAGICK_HOME /usr/local/ImageMagick-6.4.8
#setenv DYLD_LIBRARY_PATH /usr/local/ImageMagick-6.4.8/
#setenv PATH $PATH:$MAGICK_HOME/bin

export LC_CTYPE=en_US.UTF-8
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/Library/Frameworks/Python.framework/Versions/2.4/bin:$PATH"
export EDITOR='mate -w'

#/usr/bin/keychain
#source ~/.keychain/host248-sh > /dev/null

#{{{ Variables-----------------------------------------------

#source /etc/profile.env
# source profile like .bashrc
#if [ -f /etc/profile ]; then
#	source /etc/profile
#fi
export LESS=-cex3M
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
DIRSTACKSIZE=20

watch=(notme)                   # watch for everybody but me
LOGCHECK=300                    # check every 5 min for login/logout activity
WATCHFMT='%n %a %l from %m at %t.'

cdpath=(.. ~)
manpath=($X11HOME/man /usr/man /usr/lang/man /usr/local/man)
export MANPATH

# Hosts to use for completion (see later zstyle)
hosts=(`hostname`
	brian.digitalpulp.com
	nixon.digitalpulp.com
	digitalpulp.com
	etria.com)

users=(`whoami`
	bskahan
	root)

# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

#}}}-------------------------------------------------------



#{{{ Settings-----------------------------------------------

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

umask 022

setopt 	nobeep 			\
	csh_junkie_history 	\
	inc_append_history 	\
	prompt_subst 		\
   	notify 			\
	globdots 		\
	correct 		\
	pushdtohome 		\
	cdablevars 		\
	autolist 		\
	correctall 		\
	autocd 			\
	recexact 		\
	longlistjobs 		\
	autoresume 		\
	histignoredups 		\
	pushdsilent 		\
	noclobber 		\
	autopushd 		\
	pushdminus 		\
	extendedglob 		\
	rcquotes 		\
	mailwarning

unsetopt bgnice 		\
	 autoparamslash

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts
zstyle '*' users $users

zstyle '*ssh*' hosts $(sed -e '/^#/d
s/ .*$//
s/,/ /g' ~/.ssh/known_hosts)

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

#}}}-------------------------------------------------------



#{{{ Aliases-----------------------------------------------

alias ls='gls -F --color=auto'
alias rm='rm -i'
alias vim='nocorrect vim'
alias mate='nocorrect mate'
alias touch='nocorrect touch'
alias mv='nocorrect mv -i'    # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias grep=egrep
alias ll='ls -l'
alias la='ls -a'
alias info='pinfo'

# List only directories and symbolic
# links that point to directories
alias lsd='ls -ld *(-/DN)'

# List only file beginning with "."
alias lsa='ls -ld .*'

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'

#}}}-------------------------------------------------------



#{{{ Prompt------------------------------------------------

#source /usr/share/zsh/4.0.6/functions/Prompts/promptinit
autoload -U promptinit
promptinit
prompt suse

#}}}-------------------------------------------------------



#{{{ Key Bindings------------------------------------------

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

bindkey -v               # vi key bindings

#bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

#}}}-------------------------------------------------------



#{{{ Directory Colors--------------------------------------

LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:'

export LS_COLORS

#}}}-------------------------------------------------------
