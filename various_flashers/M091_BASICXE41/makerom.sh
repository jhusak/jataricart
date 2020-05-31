I="BASIC XE 4.1.rom"
O=basicxe_128.rom
i=0
z=""
while [[ $i -lt 512 ]]; do 
z+=FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
(( i = i + 1 ))
done
function out8k() {
echo "$z" | xxd -r -ps
}

echo -n >$O
dd iseek=1 if="$I" of=/dev/stdout bs=4096 count=1 >>$O
dd iseek=0 if="$I" of=/dev/stdout bs=4096 count=1 >>$O


dd iseek=3 if="$I" of=/dev/stdout bs=4096 count=1 >>$O
dd iseek=0 if="$I" of=/dev/stdout bs=4096 count=1 >>$O
for t in 2 3 4 5 6 7 8  ; do out8k >>$O ; done

dd iseek=2 if="$I" of=/dev/stdout bs=4096 count=1 >>$O
dd iseek=0 if="$I" of=/dev/stdout bs=4096 count=1 >>$O

for t in a b c d e f  ; do out8k >>$O ; done


