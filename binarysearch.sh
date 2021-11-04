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
        c4="$5"
        c5="$6"
        c6="$7"
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
esac
shift
done

minat=$(( $c1 + $c2 + $c3 + $c4 + $c5 + $c6 ))
maxat=$(( $minat * 2 ))
number=${n:0:1}

mkdir $n
cp -r ../sources/* $n/

cat >$n/INPUT.txt<<!
PARAMETERS EVOLUTIONARY ALGORITHM
******************************************
*      TYPE OF RUN AND SYSTEM            *
******************************************
USPEX : calculationMethod (USPEX, VCNEB, META)
301   : calculationType (dimension: 0-3; molecule: 0/1; varcomp: 0/1)
1     : AutoFrac

% optType
1
% EndOptType

% atomType
$A1 $A2 $A3
% EndAtomType

% numSpecies
$c1 $c2 $c3
$c4 $c5 $c6
% EndNumSpecies

$minat  : minAt
$maxat : maxAt

******************************************
*               POPULATION               *
******************************************
120   : populationSize (how many individuals per generation)
140   : initialPopSize
228   : numGenerations (how many generations shall be calculated)
20    : stopCrit
0     : reoptOld
0.6   : bestFrac
******************************************
*          VARIATION OPERATORS           *
******************************************
0.40  : fracGene (fraction of generation produced by heredity)
0.30  : fracRand (fraction of generation produced randomly from space groups)
0.20  : fracAtomsMut (fraction of the generation produced by softmutation)
0.10  : fracTrans
0.00  : fracLatMut (fraction of the generation produced by softmutation)
0.00  : fracPerm
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
10      : numParallelCalcs
200     : ExternalPressure
!

cat >$n/script_submit <<!
#!/bin/sh
#SBATCH -o out
#SBATCH -e err
#SBATCH -p cpu
#SBATCH -J ${f}.${number}
#SBATCH -n 1

while true; do
   date >> log
   USPEX -r >> log
   sleep 60
done
!

sed -i "s/jobname/${f}.${number}/" $n/script_submit

sed -i "s/USPEX/${f}.${number}/" $n/Submission/submitJob_local.py
