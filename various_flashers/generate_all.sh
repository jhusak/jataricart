
for i in *; do
	! [ -f "$i/macroflashname.asx" ] && continue
	./makeflashwrite.sh "$i" noprocess
	echo "press RETURN"
	read
	done
	
