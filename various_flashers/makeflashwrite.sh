#oldpwd=$(pwd)
[ "$1" ] && [ -f "$1/macroflashname.asx" ] && cd "$1"
! [ -f macroflashname.asx ] &&
	echo "Please cd into any flasher catalog and run ../$0" &&
	echo "or run $0 <progcatalog>" &&
	exit 1
noprocess=$2
outfile=$(pwd)
catalog=$(dirname "$outfile")
outfile=$(basename "$outfile")flasher
cd "$dirname"

mads ../../lib/flashwrite.asx -m:macroflashname.asx -o:"$outfile".xex || exit

echo Created file "$outfile".xex
#cd "$oldpwd"

! [ "$noprocess" == noprocess ] && [ -f ../postprocess.sh ] && [ -x ../postprocess.sh ] && ../postprocess.sh "$outfile".xex
