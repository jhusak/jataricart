outfile="$1"

vol=/Volumes/SDCard

echo Copy $outfile to card?
read

while true; do
[ -d "$vol" ] && cp -v "$outfile" "$vol"/ATARI/ && { eject;  exit; }
echo Waiting for card inserted...
sleep 1

done
