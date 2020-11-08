#!/bin/bash
nums=$(echo {0..9})
states=('Michigan' 'Vermont' 'Washington' 'Oregon' 'DC' 'Colorado' 'New York')
ls_out=$(ls)
for num in ${nums [@]}
do
        if [ $num = 3 ] || [ $num = 5 ] || [ $num = 7 ]
        then
                echo $num
        fi
done
for state in ${states[@]}
do
        if [ $state == 'Vermont' ];
        then
                echo "Watch out for moose!"
        else
                echo "Vermont is too cold."
        fi
done
for x in ${ls_out[@]}
do
        echo $x
done