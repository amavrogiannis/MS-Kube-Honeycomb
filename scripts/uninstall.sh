#!/bin/sh

if [[ -e Pipfile.lock ]]
then 
    rm Pipfile.lock
fi
if [[ -e Pipfile ]]
then 
    rm Pipfile 
fi
    echo "Done" 