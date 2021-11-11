#!/bin/sh

while getopts "a:b:w:j:s:m:" opt; do
    case $opt in
        a) A+=("$OPTARG");;
	b) B+=("$OPTARG");;
	w) W=("$OPTARG");;
	j) J=("$OPTARG");;
	s) S+=("$OPTARG");;
	m) M=("$OPTARG");;
    esac
done
shift $((OPTIND -1))

k=1

if [[ $M == "simple" ]]; then

for comp in "${A[@]}"; do

atoms=$(echo $comp | tr "-" "\n")
set -- $atoms
if [[ $1 -eq 1 ]]; then c1=""; else c1=$1; fi
if [[ $2 -eq 1 ]]; then c2=""; else c2=$2; fi
name=${k}_${S[0]}${c1}H${c2}+${S[1]}
echo $name
~/scripts/pseudobinary/binarysearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $1 0 $2 0 1 0 -w $W -f $J -n $name -m simple
k=$(echo "$k" | tr "0-9a-zA-Z" "1-9a-zA-Z_")

done

for comp in "${B[@]}"; do

atoms=$(echo $comp | tr "-" "\n")
set -- $atoms
if [[ $1 -eq 1 ]]; then c1=""; else c1=$1; fi
if [[ $2 -eq 1 ]]; then c2=""; else c2=$2; fi
name=${k}_${S[1]}${c1}H${c2}+${S[0]}
echo $name
~/scripts/pseudobinary/binarysearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c 1 0 0 0 $1 $2 -w $W -f $J -n $name -m simple
k=$(echo "$k" | tr "0-9a-zA-Z" "1-9a-zA-Z_")

done

elif [[ $M == "extra" ]]; then

for compa in "${A[@]}"; do
for compb in "${B[@]}"; do
atoms=$(echo $compa"-"$compb | tr "-" "\n")
set -- $atoms
if [[ $1 -eq 1 ]]; then c1=""; else c1=$1; fi
if [[ $2 -eq 1 ]]; then c2=""; else c2=$2; fi
if [[ $3 -eq 1 ]]; then c3=""; else c3=$3; fi
if [[ $4 -eq 1 ]]; then c4=""; else c4=$4; fi
name=${k}_${S[0]}${c1}H${c2}+${S[1]}${c3}H${c4}
echo $name
~/scripts/pseudobinary/binarysearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $1 0 $2 0 $3 $4 -w $W -f $J -n $name
k=$(echo "$k" | tr "0-9a-zA-Z" "1-9a-zA-Z_")

done
done

fi
