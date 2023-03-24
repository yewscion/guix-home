### Color Variables
YewColor_End='\033[0m'
YewColor_Black='\033[0;30m'
YewColor_Red='\033[0;31m'
YewColor_Green='\033[0;32m'
YewColor_Yellow='\033[0;33m'
YewColor_Blue='\033[0;34m'
YewColor_Magenta='\033[0;35m'
YewColor_Cyan='\033[0;36m'
YewColor_White='\033[0;37m'
YewColor_Emph_On='\033[4m'
YewColor_Emph_Off='\033[24m'
YewColor_BG_Black='\033[40m'
YewColor_BG_Red='\033[41m'
YewColor_BG_Green='\033[42m'
YewColor_BG_Yellow='\033[43m'
YewColor_BG_Blue='\033[44m'
YewColor_BG_Magenta='\033[45m'
YewColor_BG_Cyan='\033[46m'
YewColor_BG_White='\033[47m'

### Options and Arguments

YewOptA=false
YewOptB=false
YewOptC=false
YewOptD=false
YewOptE=false
YewOptF=false
YewOptG=false
YewOptH=false
YewOptI=false
YewOptJ=false
YewOptK=false
YewOptL=false
YewOptM=false
YewOptN=false
YewOptO=false
YewOptP=false
YewOptQ=false
YewOptR=false
YewOptS=false
YewOptT=false
YewOptU=false
YewOptV=false
YewOptW=false
YewOptX=false
YewOptY=false
YewOptZ=false
YewOpt0=false
YewOpt1=false
YewOpt2=false
YewOpt3=false
YewOpt4=false
YewOpt5=false
YewOpt6=false
YewOpt7=false
YewOpt8=false
YewOpt9=false
YewArgs=()


hiddenText() {
    echo -e "${YewColor_Black}${YewColor_BG_Black}${1}${YewColor_End}"
}
redText() {
    echo -e "${YewColor_Red}${1}${YewColor_End}"
}
greenText() {
    echo -e "${YewColor_Green}${1}${YewColor_End}"
}
yellowText() {
    echo -e "${YewColor_Yellow}${1}${YewColor_End}"
}
blueText() {
    echo -e "${YewColor_Blue}${1}${YewColor_End}"
}
magentaText() {
    echo -e "${YewColor_Magenta}${1}${YewColor_End}"
}
cyanText() {
    echo -e "${YewColor_Cyan}${1}${YewColor_End}"
}
whiteText() {
    echo -e "${YewColor_White}${1}${YewColor_End}"
}

formatText() {
    if test -n "$1"; then
        fmt -50 -t -u <<< "${*}"
    elif test ! -t 0; then
        fmt -50 -t -u /dev/stdin
    else
        echo "No input to formatText on ${BASH_LINENO[*]}"
        exit 1
    fi
}

emph() {                   
    echo -e "${YewColor_Emph_On}${1}${YewColor_Emph_Off}";
}

keyTerm() {
    length="${#1}"
    echo -e "\e7${YewColor_Magenta}${1}\e8\033[${length}C";
}

narrate() {
    blueText "--------------------------------------------------"
    blueText "${*}" | formatText
    blueText "--------------------------------------------------"
}

report() {
    cyanText "--------------------------------------------------"
    cyanText "${*}" | formatText
    cyanText "--------------------------------------------------"
}

warn() {
    redText "--------------------------------------------------"
    redText "${*}" | formatText
    redText "--------------------------------------------------"
}

instruct() {
    yellowText "--------------------------------------------------"
    yellowText "${*}" | formatText
    yellowText "--------------------------------------------------"
}

celebrate() {
    greenText "--------------------------------------------------"
    greenText "${*}" | formatText
    greenText "--------------------------------------------------"
}

setupScript() {
    set -o errexit;
    set -o nounset;
    set -o pipefail;
    if [ "${TRACE-0}" -eq "1" ]; then set -o xtrace; fi;
}

checkArguments() {
    if [[ $1 != $2 ]]; then
        instruct \
        "This script should be run with the following arguments:\n\n${3}";
        exit 1;
    fi
}

yesOrNo() {
    read -r -p "$(yellowText "${1} ")" response;
    case "$response" in
        [yY][eE][sS]|[yY])
            true;
            ;;
        *)
            false;
            ;;
    esac
}

confirm() {
    report "${1}"
    echo ""
    return yesOrNo "Is this reasonable? [y/N]"
}

confirmPrompt() {
    if confirm "${1}"; then
        ${2};
    else
        narrate "Aborting due to possible user-identified unreasonability…";
        exit 1;
    fi
}

checkForCommand() {
    command -v $1 &> /dev/null || {
        warn "The command '${1}' could not be found";
        exit 127;
    }
}


checkForFile() {
    if [ ! -f "${1}" ]; then
        warn "Cannot find file:\n${1}";
    exit 2;
    fi
}

copyDirectoryContentsAsNew() {
    checkForCommand cp
    cp -Rv --no-preserve=all -LT  "${1}/" "${2}/"
}

sanitizeFilename() {
    checkForCommand sed

    echo "${1}" | sed 's/[A-Z]/\L&/g;s/ /-/g;s/(/./g;s/)//g;s/-\././g'
}


listMIMEtypes() {
    checkForCommand file
    checkForCommand sed

    for i in "$@"; do
        file --mime-type "${i}" | sed 's/.*: //g'
    done
}

yewGetOpts() {
    while [ $# -gt 0 ]; do
        while getopts "abcdefghijklmnopqrstuvwxyz1234567890" flag; do
            case $flag in
                a)
                    YewOptA=true
                    ;;
                b)
                    YewOptB=true
                    ;;
                c)
                    YewOptC=true
                    ;;
                d)
                    YewOptD=true
                    ;;
                e)
                    YewOptE=true
                    ;;
                f)
                    YewOptF=true
                    ;;
                g)
                    YewOptG=true
                    ;;
                h)
                    YewOptH=true
                    ;;
                i)
                    YewOptI=true
                    ;;
                j)
                    YewOptJ=true
                    ;;
                k)
                    YewOptK=true
                    ;;
                l)
                    YewOptL=true
                    ;;
                m)
                    YewOptM=true
                    ;;
                n)
                    YewOptN=true
                    ;;
                o)
                    YewOptO=true
                    ;;
                p)
                    YewOptP=true
                    ;;
                q)
                    YewOptQ=true
                    ;;
                r)
                    YewOptR=true
                    ;;
                s)
                    YewOptS=true
                    ;;
                t)
                    YewOptT=true
                    ;;
                u)
                    YewOptU=true
                    ;;
                v)
                    YewOptV=true
                    ;;
                w)
                    YewOptW=true
                    ;;
                x)
                    YewOptX=true
                    ;;
                y)
                    YewOptY=true
                    ;;
                z)
                    YewOptZ=true
                    ;;
                0)
                    YewOpt0=true
                    ;;
                1)
                    YewOpt1=true
                    ;;
                2)
                    YewOpt2=true
                    ;;
                3)
                    YewOpt3=true
                    ;;
                4)
                    YewOpt4=true
                    ;;
                5)
                    YewOpt5=true
                    ;;
                6)
                    YewOpt6=true
                    ;;
                7)
                    YewOpt7=true
                    ;;
                8)
                    YewOpt8=true
                    ;;
                9)
                    YewOpt9=true
                    ;;
                *)
                    continue
            esac
        done
        [ $? -eq 0 ] || exit 1
        [ $OPTIND -gt $# ] && break   # we reach end of parameters
        shift $[$OPTIND - 1] # free processed options so far
        OPTIND=1             # we must reset OPTIND
        YewArgs[${#YewArgs[*]}]=$1 # save first non-option argument (a.k.a. positional argument)
        shift                # remove saved arg
    done
}

syncToRemoteServer() {
    checkForCommand rsync
    checkForCommand pagr
    
    for i in "${1}"; do
        rsync -rpv "${i}/" "${2}:${i}";
    done 

    pagr -p "$HOME/Documents" "${3}" "trunk"
}
