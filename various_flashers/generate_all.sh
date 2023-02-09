
for i in *; do
	! [ -f "$i/macroflashname.asx" ] && continue
	echo GENERATE $i ...
	./makeflashwrite.sh "$i" noprocess
	echo "press RETURN"
	read
	done
	
