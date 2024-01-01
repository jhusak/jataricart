../makeflashwrite.sh . noprocess | grep "^#define" | sed "s/\\$//" >flashgenerator.h
mads	bankpart.asx	| grep "^#define" | sed "s/\\$//" >>flashgenerator.h
