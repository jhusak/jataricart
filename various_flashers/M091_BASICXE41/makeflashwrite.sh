outfile=BASICXEflashwrite
cd `dirname $0`
mads flashwrite.asx -m:macroflashname.asx -o:"$outfile".xex
rm "$outfile".lst


