autoload -Uz compinit
compinit
#autoload -Uz promptinit
zmodload zsh/complist
autoload -U promptinit
promptinit
if [ x"`whoami`" = x"root" ];
then
	prompt adam1
else
	prompt adam2
fi

[ -r "${HOME}/.zsh/env" ] && source "${HOME}/.zsh/env"
[ -r "${HOME}/.zsh/zsh_local" ] && source "${HOME}/.zsh/zsh_local"

#alias startx="sh -c 'sh -c \"exec /usr/bin/env xinit 2>/dev/null 1>/dev/null\" &' && clear && echo -n `date` && logout"
alias startx="sh -c 'nohup /usr/bin/env xinit 2>/dev/null 1>/dev/null &' && clear && echo -n `date` && logout"
alias ls='ls -G -F -h --color=yes'
alias grep='grep --color=yes'
alias df='df -h'
alias vim='vim -p '
alias du='du -hsc'
alias bc="bc ~/.bcrc"
alias cal="LC_ALL=ru_RU.UTF-8 cal"
alias nohup="nohup $* >/dev/null 2>/dev/null"
alias g="grep -RHn --color=auto"
alias vimpager="vimpager -n"
alias less="less -R"
alias tmux="_z_tmux"
alias su='su -p'

alias ra_bluemars="mplayer2 -cache-min 5 -cache 8192 http://207.200.96.225:8020/"
alias ra_paradise="mplayer2 -cache-min 5 -cache 8192 http://stream-uk1.radioparadise.com:9000/rp_96m.ogg"
alias ra_paradise32="mplayer2 -cache-min 5 -cache 8192 http://stream-tx4.radioparadise.com:9000/rp_32.ogg"
alias ra_doomed="mplayer2 -cache-min 5 -cache 8192  http://sfstream1.somafm.com:8300 http://ice.somafm.com/doomed"

_z_tmux ()
{
	(
		last=$(echo $* | tr ' ' '\n' | tail -n 1)
		case "q${last}" in
			q|q-2|q-8|q-l|q-q|q-u|q-v|q-V)
				;;
			*)
				last=$(echo $* | tr ' ' '\n' | tail -n 2 | head -n 1)
				case "q${last}" in
					q-c|q-f|q-L|q-S)
						;;
					*)
						exec \tmux $*
						;;
				esac
				;;
		esac
		\tmux $* has-session -t z >/dev/null 2>&1
		[ $? -eq 0 ] && exec \tmux $*
		exec \tmux $* attach
	)
}

convert ()
{
	CCMD=
	TCMD=$(whereis convert | awk '{print $2}')
	if [ -z "$TCMD" ];
	then
		TCMD=$(whereis gm | awk '{print $2}')
		if [ -z "$TCMD" ];
		then
			echo "can't locate ImageMagick's convert or GraphicsMagick's gm"\
				>/dev/stderr
			return 1
		fi
		CCMD="convert"
	fi
	if ( [ ! -f $TCMD ] || [ ! -x $TCMD ] );
	then
		echo "$TCMD not an a executable"\
			>>/dev/stderr
		return 1
	fi
	$TCMD $CCMD $@
}

if [ "$USER" = "noktoborus" -o -e "$HOME/.zshrc_as_noktoborus" ];
then
	sscani ()
	{
		OUT="$1"
		if [ "$OUT" = "-" ];
		then
			ssh noktoborus@sirin "scanimage $2 $3 $4 $5 $6 $7 $8 $9"
		elif [ ! -z "$OUT" ];
		then
			FORMAT="tiff"
			INF=$(tempfile)
			[ -z "$INF" ] && exit 2
			ssh -C noktoborus@sirin "scanimage" "--format=$FORMAT" ">>"\
				"/dev/stdout" | pv > $INF
			convert -verbose "$FORMAT:$INF" "$OUT"
			rm -f "$INF"
		else
			echo "not u" >/dev/stderr
		fi
	}
	alias ssh="_z_ssh"
	_z_ssh ()
	{
		SSH_RHOST="$1"
		if ( [ ! -z "$SSH_RHOST" ] && [ -z "$2" ] );
		then
		(
			CAT="cat"
			( echo "" | pv ) >/dev/null 2>&1
			[ $? -eq 0 ] && CAT="pv"
			cd "$HOME"
			LHASH=$(git log --format=format:'%H' 2>/dev/null | tail -n 1)
			LDATE=$(git log --date=raw --format=format:'%cd' 2>/dev/null | head -n 1 | cut -d' ' -f 1)
			RDATE=""
			TMP=${TMP-"/tmp"}
			MPOINT="${TMP}/${USER}/${SSH_RHOST}"
			[ -z "$LHASH" ] && exit 0
			[ ! -z "$(mount | cut -d' ' -f 3 | grep '$MPOINT')" ] && exit 0
			mkdir -p "$MPOINT" 2>/dev/null
			if [ $? -eq 0 ];
			then
				RDATE=$(cat "$MPOINT/.last" 2>/dev/null)
				if [ ! -z "$RDATE" ];
				then
					[ $LDATE -eq $RDATE ] && exit 0
				fi
				echo "push git, R: '$RDATE', L: '$LDATE'" >/dev/stderr
				echo "check ssh mode"
				\ssh -C -o "NumberOfPasswordPrompts 0" -o "ConnectTimeout 2" "${SSH_RHOST}" 'git' '--version'
				if [ $? -eq 0 ];
				then
					FF=$(tempfile)
					(
						( cd "$HOME"; tar -cf ${FF} ".git" 2>/dev/null )
						$CAT ${FF} | \ssh -C -o "NumberOfPasswordPrompts 0" -o "ConnectTimeout 2" "${SSH_RHOST}" 'sh' '-c' '"rm -rf .git; tar -xf - 2>/dev/null; git reset --hard"'
					)
					rm -rf ${FF}
				else
					echo "try sshfs"
					\sshfs -o nonempty,reconnect,NumberOfPasswordPrompts=0,ConnectTimeout=2 "${SSH_RHOST}:" "$MPOINT"
					if [ $? -eq 0 ];
					then
						cd "$MPOINT"
						RHASH=$(git log --format=format:'%H' 2>/dev/null | tail -n 1)
						if [ -z "$RHASH" -o "$RHASH" = "$LHASH" ];
						then
							FF=$(tempfile)
							(
								( cd "$HOME"; tar -cf ${FF} ".git" )
								$CAT ${FF} | tar -xf -
								git reset --hard
							)
							rm -f ${FF}
						fi
						cd "$HOME"
						fusermount -u "$MPOINT"
					fi
				fi
				echo "$LDATE" > "$MPOINT/.last"
			fi
		)
		fi
		\ssh $@
	}
fi

if [ -x "$HOME/.local/lib/barcp.so" ];
then
	alias cp="LD_PRELOAD=$HOME/.local/lib/barcp.so cp -v"
fi
dum ()
{
	du -h --max-depth=1 "$@" | sort -k 1,1hr -k 2,2f;
}

bindkey -s "" "fg 2>/dev/null >/dev/null\nclear\n"
bindkey ""    beginning-of-line
bindkey ""    end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[3~" delete-char
bindkey "\e[A"  history-beginning-search-backward
bindkey "\e[B"  history-beginning-search-forward
setopt PROMPT_SUBST

PROMPT="$(print '%{\e[0m%}%{\e[;34m%}[%{\e[1;34m%}%*%{\e[0m%}%{\e[;34m%}]%{\e[0m%}%{\e[;31m%}#%l(%L)%{\e[;36m%}%#%{\e[0m%}') "
RPROMPT="$(print '%(?.%{\e[;36m%}^_^%{\e[0m%}.%{\e[1;31m%}%?%{\e[0m%})%f')"

setopt CORRECT_ALL
SPROMPT="$(print '%{\e[;31m%}%R%{\e[;0m%}? may be %{\e[;32m%}%r%{\e[;0m%}? (%{\e[1;36m%}y%{\e[0m%}es/%{\e[1;36m%}n%{\e[0m%}o/%{\e[1;36m%}e%{\e[0m%}dit/%{\e[1;36m%}a%{\e[0m%}bort) ')"

setopt autocd
setopt append_history SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt NO_FLOW_CONTROL
setopt notify
setopt check_jobs
setopt menucomplete

# update title
case $TERM in
    rxvt*|xterm)
        function precmd() {
            print -Pn "\e]0;%n@%m: %~\a"
        }

		function preexec() {
			# The full command line comes in as "$1"
			local cmd="$1"
			local -a args

			# add '--' in case $1 is only one word to work around a bug in ${(z)foo}
			# in zsh 4.3.9.
			tmpcmd="$1 --"
			args=${(z)tmpcmd}

			# remove the '--' we added as a bug workaround..
			# per zsh manpages, removing an element means assigning ()
			args[${#args}]=()
			if [ "${args[1]}" = "fg" ] ; then
				local jobnum="${args[2]}"
				if [ -z "$jobnum" ] ; then
			 	# If no jobnum specified, find the current job.
				for i in ${(k)jobtexts}; do
					[ -z "${jobstates[$i]%%*:+:*}" ] && jobnum=$i
			 	done
				fi
				cmd="${jobtexts[${jobnum#%}]}"
			else
			fi
			x=`printf "\e"`
	  		cmd="`echo $cmd | tr $x e | tr \n n | tr \t t | tr \r r | tr % q`"
			print -Pn "\e]0;%n@%m! $cmd\a"
        }
     ;;
 esac

 zstyle ':completion:*:default' list-colors '${LS_COLORS}'
 
 zstyle ':completion:*' menu select=long-list select=0
 zstyle ':completion:*' old-menu false
 zstyle ':completion:*' original true
 zstyle ':completion:*' substitute 1
 zstyle ':completion:*' use-compctl true
 zstyle ':completion:*' verbose true
 zstyle ':completion:*' word true
 zstyle ':completion:*' add-space true 
 
 zstyle ':completion:*:processes' command 'ps -xuf'
 zstyle ':completion:*:processes-names' command 'ps xho command'
 zstyle ':completion:*:processes' sort false

# zstyle ':completion:*:*:kill:*' menu yes select
# zstyle ':completion:*:kill:*' force-list always
# zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
	
 zstyle ':completion:*:cd:*' ignore-parents parent pwd
 zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
 
# remove 'gopher:// ssh:// http:// ...' from list
 zstyle ':completion:*' ignored-patterns '*:*'

function iv
{
	feh -F $* >/dev/null
}

dstat ()
{
	if [ -z "$1" ];
	then
		/usr/bin/dstat --proc --cpu --disk --fs --net --mem --swap --proc-count --cpufreq
	else
		/usr/bin/dstat $@
	fi
	
}
 # ---
# if [ -x /usr/games/fortune ]; then
#    printf '\e[;33m'
#     /usr/games/fortune
#    printf '\e[;0m'
# fi
if [ -x /usr/bin/linux_logo ];
then
	LC_ALL=C /usr/bin/linux_logo
fi
printf "\e[;32m\t\t\t"
 LC_ALL=C date
printf	"\e[0m"

if [ -x /usr/bin/sensors ];
then
	printf '\e[;33m'
	LC_ALL=C /usr/bin/sensors
	printf '\e[;0m'
fi

if [ ! -z "$LOGIN_HOME" ]; then
	alias vim="vim -i \"$HOME/.viminfo\" -u \"$HOME/.vimrc\" -p"
	export HOME=$LOGIN_HOME
	unset LOGIN_HOME
fi

[ -r "${HOME}/.zsh/zsh_local_over" ] && source "${HOME}/.zsh/zsh_local_over"

# show time info (if user && sys time greater then 1 seconds)
REPORTTIME=1
