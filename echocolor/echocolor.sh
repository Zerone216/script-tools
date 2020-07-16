#!/bin/bash

set -e

function showAllColor()
{
    for fgbg in 38 48 ; do # Foreground / Background
        for color in {0..255} ; do # Colors
            # Display the color
            printf "\e[${fgbg};5;%sm%4s\e[0m" $color $color
            # Display 6 colors per lines
            if [ $((($color + 1) % 6)) == 4 ] ; then
                echo
            fi
        done
        echo
    done

    exit 0
}

function colorstrmap()
{
    [ $# -le 0 ] && echo -1 && return
    if echo $1 | grep -Eo "^[0-9]*$" > /dev/null ; then
        if [ $1 -lt 0 ] || [ $1 -gt 255 ] ; then
            echo -1
        else
            echo $1 
        fi
        return
    fi

    case $1 in
        black)
            echo 16
            ;;
        gray)
            echo 8
            ;;
        silver)
            echo 7
            ;;
        white)
            echo 255
            ;;
        snow)
            echo 15
            ;;
        red)
            echo 9
            ;;
        green)
            echo 22
            ;;
        yellow)
            echo 11
            ;;
        blue)
            echo 4
            ;;
        cyan)
            echo 14
            ;;
        purple)
            echo 56
            ;;
        pink)
            echo 196
            ;;
        brown)
            echo 94
            ;;
        golden)
            echo 226
            ;;
        orange)
            echo 202
            ;;
        violet)
            echo 207
            ;;
        indigo)
            echo 57
            ;;
        slateblue)
            echo 27
            ;;
        darkblue)
            echo 18
            ;;
        skyblue)
            echo 45
            ;;
        aqua)
            echo 51
            ;;
        darkcyan)
            echo 43
            ;;
        turquoise)
            echo 35
            ;;
        springgreen)
            echo 34
            ;;
        seagreen)
            echo 28
            ;;
        lime)
            echo 10
            ;;
        tomato)
            echo 160
            ;;
        default)
            echo -1
            ;;
        *)
            echo 255
            ;;
    esac
    return
}

# $1--bold $2--nendl $3--color $4--expr
function echowithcolor()
{
    eflag=0
    bold=${1} && shift
    nendl=${1} && shift
    forecolor=${1} && shift
    backcolor=${1} && shift
    expr=${@}
    
    [ $forecolor -ge 0 ] && printf "\e[38;5;%sm" $forecolor && ((eflag+=1))
    [ $backcolor -ge 0 ] && printf "\e[48;5;%sm" $backcolor && ((eflag+=1))
    [ "$bold" == "yes" ] && printf "\e[1m" && ((eflag+=1))
    echo -n $expr
    [ $eflag -gt 0 ] && printf "\e[0m"
    [ "$nendl" == "no" ] && printf "\n"

    return
}

function echocolor_usage()
{
    echo "Usage:"
    echo "./echocolor.sh [-a] [-h] [[-nb] -c color expr]"
    echo "    -a                display all colors"
    echo "    -h                display this information"
    echo "    -n                no wrap, without \"\\n\""
    echo "    -b                bold font"
    echo "    -c                format [forecolor:backcolor], colorval{0~255} or name{red, green, yellow ...}"
    echo "                      example: [yellow:blue], [34:66], or [128:], [:69], [12]"
    echo "    expr              output string"
    echo ""
}

function main() 
{
    bold=no
    nendl=no
    color=default:default
    while getopts 'abc:hn' arg "$@" ;
    do
        case $arg in
            'a')
                showAllColor
                exit
                ;;
            'b')
                bold=yes
                ;;
            'n')
                nendl=yes
                ;;  
            'c')
                color=$OPTARG
                ;;  
            'h')
                echocolor_usage
                exit
                ;;  
            ?)
                echo "UNKNWON ARGS: ${OPTARG}"
                exit 1
                ;;
        esac
    done

    shift $(($OPTIND - 1))
    if echo $color | grep -o : > /dev/null ; then
        forecolor=`colorstrmap $(echo $color | cut -d: -f1)`
        backcolor=`colorstrmap $(echo $color | cut -d: -f2)`
    else
        forecolor=`colorstrmap $color`
        backcolor=`colorstrmap default`
    fi

    echowithcolor $bold $nendl $forecolor $backcolor $@
}

main $*
