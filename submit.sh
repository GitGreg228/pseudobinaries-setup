#!/bin/sh

for fold in `ls`
do
cd $PWD/$fold
sbatch script_submit
cd $PWD/../
done
