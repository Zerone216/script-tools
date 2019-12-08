#!/bin/bash





displayDir()
{
    curdir=`pwd`
    for f in ./*
    do
        fullpath="$curdir/`basename $f`"
        if [ -d $fullpath ]
        then
            cd $fullpath
            displayDir $fullpath
        elif [ -f $fullpath ]
        then
            echo $fullpath    
        fi
    done

    cd ..
}



main()
{
    curdir=`pwd`
    echo curdir=$curdir
    old_IFS=$IFS
    IFS=

    cd $1
    displayDir $1

    IFS=$old_IFS

    cd $curdir
}

main $*