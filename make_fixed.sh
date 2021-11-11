#!/bin/sh

Am=5
Bm=5
Cm=2
Dm=2
P=0

while getopts "a:b:w:j:s:m:l:n:c:d:p:" opt; do
    case $opt in
        a) A+=("$OPTARG");;
	b) B+=("$OPTARG");;
	w) W=("$OPTARG");;
	s) S+=("$OPTARG");;
	j) J=("$OPTARG");;
	m) M=("$OPTARG");;
	l) Am=("$OPTARG");;
	n) Bm=("$OPTARG");;
	c) Cm=("$OPTARG");;
	d) Dm=("$OPTARG");;
	p) P=("$OPTARG");;
    esac
done
shift $((OPTIND -1))

k=1

if [[ $M == "simple" ]]; then

donefixed=""

# COMPONENT A

for comp in "${A[@]}"; do

subk=1
atoms=$(echo $comp | tr "-" "\n")
set -- $atoms
if [[ $1 -eq 1 ]]; then c1=""; else c1=$1; fi
if [[ $2 -eq 1 ]]; then c2=""; else c2=$2; fi
name=${k}_${S[0]}${c1}H${c2}+${S[1]}
echo $name
if [[ $P -eq 1 ]]; then
~/scripts/pseudobinary/binarysearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $1 0 $2 0 1 0 -f ${J}.2 -n $name -m simple
fi

for i in $(seq 1 $Am); do
if [[ $i -lt $(( $2 / 2 )) ]]; then

C1=$1
C2=$i
C3=$2
subname=${subk}_${C1}-${C2}-${C3}

if [[ $donefixed == *"${C1}-${C2}-${C3}"* ]]; then
 dir=`find . -name "*${C1}-${C2}-${C3}" | head -n 1`
 echo "For the composition ${C1}-${C2}-${C3}, look in the directory ${dir}" >> $name/duplicates.txt
else
echo $subname
~/scripts/pseudobinary/fixedsearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $C1 $C2 $C3 -f ${J}.2 -n $name -s $subname
donefixed="${donefixed} ${C1}-${C2}-${C3}"
subk=$(echo "$subk" | tr "0-9a-zA-Z" "1-9a-zA-Z_")
fi

fi
done

k=$(echo "$k" | tr "0-9a-zA-Z" "1-9a-zA-Z_")

done

# COMPONENT B

for comp in "${B[@]}"; do

subk=1
atoms=$(echo $comp | tr "-" "\n")
set -- $atoms
if [[ $1 -eq 1 ]]; then c1=""; else c1=$1; fi
if [[ $2 -eq 1 ]]; then c2=""; else c2=$2; fi
name=${k}_${S[1]}${c1}H${c2}+${S[0]}
echo $name
if [[ $P -eq 1 ]]; then
~/scripts/pseudobinary/binarysearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c 1 0 0 0 $1 $2 -f ${J}.2 -n $name -m simple
fi

for i in $(seq 1 $Bm); do
if [[ $i -lt $(( $2 / 2 )) ]]; then

C1=$i
C2=$1
C3=$2
subname=${subk}_${C1}-${C2}-${C3}

if [[ $donefixed == *"${C1}-${C2}-${C3}"* ]]; then
 dir=`find . -name "*${C1}-${C2}-${C3}" | head -n 1`
 echo "For the composition ${C1}-${C2}-${C3}, look in the directory ${dir}" >> $name/duplicates.txt
else
echo $subname
~/scripts/pseudobinary/fixedsearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $C1 $C2 $C3 -f ${J}.2 -n $name -s $subname
donefixed="${donefixed} ${C1}-${C2}-${C3}"
subk=$(echo "$subk" | tr "0-9a-zA-Z" "1-9a-zA-Z_")
fi

fi
done

k=$(echo "$k" | tr "0-9a-zA-Z" "1-9a-zA-Z_")

done

echo $donefixed > compositions.txt

elif [[ $M == "extra" ]]; then

donefixed=""

# EXTRA

for compa in "${A[@]}"; do
for compb in "${B[@]}"; do

subk=1
atoms=$(echo $compa"-"$compb | tr "-" "\n")
set -- $atoms
if [[ $1 -eq 1 ]]; then c1=""; else c1=$1; fi
if [[ $2 -eq 1 ]]; then c2=""; else c2=$2; fi
if [[ $3 -eq 1 ]]; then c3=""; else c3=$3; fi
if [[ $4 -eq 1 ]]; then c4=""; else c4=$4; fi
name=${k}_${S[0]}${c1}H${c2}+${S[1]}${c3}H${c4}

if [[ -d `ls -d *${S[0]}${c1}H${c2}+${S[1]}${c3}H${c4}` ]]; then 
name=`ls -d *${S[0]}${c1}H${c2}+${S[1]}${c3}H${c4}`
fi
echo $name

if [[ $P -eq 1 ]]; then
~/scripts/pseudobinary/binarysearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $1 0 $2 0 $3 $4 -f ${J}.3 -n $name
fi

for i in $(seq 1 $Cm); do
for j in $(seq 1 $Dm); do

if [[ ! $i -eq $j ]] || [[ $i -eq 1 ]] || [[ $j -eq 1 ]]; then

C1=$(( $1 * $i ))
C2=$(( $3 * $j ))
C3=$(( $2 * $i + $4 * $j ))

subname=${subk}_${C1}-${C2}-${C3}
echo $subname

if [[ $donefixed == *"${C1}-${C2}-${C3}"* ]]; then
 dir=`find . -name "*${C1}-${C2}-${C3}" | head -n 1`
 echo "For the composition ${C1}-${C2}-${C3}, look in the directory ${dir}" >> $name/duplicates.txt
else
~/scripts/pseudobinary/fixedsearch.sh -a ${S[0]} ${S[1]} ${S[2]} -c $C1 $C2 $C3 -f ${J}.3 -n $name -s $subname
donefixed="${donefixed} ${C1}-${C2}-${C3}"
subk=$(echo "$subk" | tr "0-9a-zA-Z" "1-9a-zA-Z_")
fi


fi

done
done

k=$(echo "$k" | tr "0-9a-zA-Z" "1-9a-zA-Z_")

done
done

echo $donefixed > compositions.txt

fi
