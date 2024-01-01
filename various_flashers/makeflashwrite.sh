#oldpwd=$(pwd)
[ "$1" ] && [ -f "$1/macroflashname.asx" ] && cd "$1"
! [ -f macroflashname.asx ] &&
	echo >/dev/stderr "Please cd into any flasher catalog and run ../$0" &&
	echo >/dev/stderr "or run $0 <progcatalog>" &&
	exit 1
noprocess=$2
outfile=$(pwd)
catalog=$(dirname "$outfile")
outfile=$(basename "$outfile")flasher
cd "$dirname"

! mads -m:macroflashname.asx -t -l ../../lib/flashwrite.asx -o:"$outfile".xex && echo >/dev/stderr ERROR! && exit 1

echo >/dev/stderr Created file "$outfile".xex
#cd "$oldpwd"

! [ "$noprocess" == noprocess ] && [ -f ../postprocess.sh ] && [ -x ../postprocess.sh ] && ../postprocess.sh "$outfile".xex
