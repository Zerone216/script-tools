#!/bin/bash

function showAllColor()
{
    for fgbg in 38 48 ; do # Foreground / Background
        for color in {0..255} ; do # Colors
            # Display the color
            printf "\e[${fgbg};5;%sm%4s\e[0m" $color $color
            # Display 6 colors per lines
            if [ $((($color + 1) % 6)) == 4 ] ; then
                echo #$color
            fi
        done
        echo
    done

    exit 0
}

checkColorVal()
{
    if [ -z "`echo $1 | grep -Eo '^[0-9]+$'`" ]
    then
        echo -e "\e[38;5;9m\e[1mInvalid color value[$1].\e[0m"
        exit 1
    fi

    if [ $1 -lt 0 ] || [ $1 -gt 255 ]
    then
        echo -e "\e[38;5;9m\e[1mcolor value is out of boundary.(0~255)\e[0m"
        exit 1
    fi
}

function testColor()
{
    color=${2} && shift 2
    checkColorVal $color

    if [ -z "$1" ]
    then
        teststr="ABCDEFGHIGKLMNOPQRSTUVWXYZ-0123456789"
    else
        teststr=${@}
    fi

    printf "\e[38;5;%sm" $color
    echo $teststr
    printf "\e[0m"
}

function echocolor()
{
    nendl=${1} && shift
    if [ "$nendl" == -n ]
    then
        bold=${1} && shift
        if [ "$bold" == -b ]
        then
            color=${1} && shift
            checkColorVal $color           

            printf "\e[38;5;%sm\e[1m" $color
            echo -n ${@}
            printf "\e[0m"
        else
            color=$bold
            checkColorVal $color

            printf "\e[38;5;%sm" $color
            echo -n ${@}
            printf "\e[0m"
        fi        
    else
        bold=$nendl
        if [ "$bold" == -b ]
        then
            color=${1} && shift
            checkColorVal $color

            printf "\e[38;5;%sm\e[1m" $color
            echo ${@}
            printf "\e[0m"
        else
            color=$bold
            checkColorVal $color

            printf "\e[38;5;%sm" $color
            echo ${@}
            printf "\e[0m"
        fi
    fi
}

Usage()
{
    echo "Usage:"
    echo "echocolor.sh [-t colorval [teststring]] [--show-all] [-h] [[-n] [-b] colorval expr]"
    echo "    -t                test color, colorval{0~255}"
    echo "    --show-all        display all colors"
    echo "    -h                display this information"
    echo "    -n,no wrap; -b,bold font, colorval{0~255}; expr, output string"
    exit 0
}

main()
{
    if [ $# -lt 1 ]
    then
        Usage
    fi

    case $1 in
        -t)
            testColor $@
            ;;
        -h)
            Usage
            ;;
        --show-all)
            showAllColor
            ;;
        *)
            echocolor $@
            ;;
    esac
}

main $*

exit 0
