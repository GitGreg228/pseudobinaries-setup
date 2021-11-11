#!/bin/sh

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-a|--atoms)
	A1="$2"
	A2="$3"
	A3="$4"
	shift
	;;
	-c|--coefficients)
	c1="$2"
        c2="$3"
        c3="$4"
	shift
	;;
	-f|--folder)
	f="$2"
	shift
	;;
	-n|--name)
	n="$2"
	shift
	;;
	-s|--subname)
        s="$2"
        shift
        ;;
	-m|--mode)
        m="$2"
        shift
        ;;
esac
shift
done

number=${n:0:1}
subnumber=${s:0:1}

if [[ ! -d $n/$s ]]; then
mkdir $n/$s
fi
cp -r ../sources/* $n/$s/

cat >$n/$s/INPUT.txt<<!
PARAMETERS EVOLUTIONARY ALGORITHM
******************************************
*      TYPE OF RUN AND SYSTEM            *
******************************************
USPEX : calculationMethod (USPEX, VCNEB, META)
300   : calculationType (dimension: 0-3; molecule: 0/1; varcomp: 0/1)
1     : AutoFrac

% optType
1
% EndOptType

% atomType
$A1 $A2 $A3
% EndAtomType

% numSpecies
$c1 $c2 $c3
% EndNumSpecies

******************************************
*               POPULATION               *
******************************************
60   : populationSize (how many individuals per generation)
80   : initialPopSize
228   : numGenerations (how many generations shall be calculated)
10    : stopCrit
0     : reoptOld
0.6   : bestFrac
******************************************
*          VARIATION OPERATORS           *
******************************************
0.40  : fracGene (fraction of generation produced by heredity)
0.30  : fracRand (fraction of generation produced randomly from space groups)
0.10  : fracAtomsMut (fraction of the generation produced by softmutation)
0.00  : fracTrans
0.10  : fracLatMut (fraction of the generation produced by softmutation)
0.10  : fracPerm
*****************************************
*   DETAILS OF AB INITIO CALCULATIONS   *
*****************************************
% abinitioCode
1 1 1 1 1 1
% ENDabinit

% KresolStart
0.13 0.11 0.09 0.07 0.05 0.04
% Kresolend

% commandExecutable
mpirun vasp_std
% EndExecutable

1       : whichCluster (0: no-job-script, 1: local submission, 2: remote submission)
5      : numParallelCalcs
200     : ExternalPressure
!

sed -i "s/jobname/${f}.${number}.${subnumber}/" $n/$s/script_submit
sed -i "s/USPEX/${f}.${number}.${subnumber}/" $n/$s/Submission/submitJob_local.py
