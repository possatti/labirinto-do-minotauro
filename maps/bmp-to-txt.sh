#!/bin/sh

## Transform colorful bitmaps, into txts that can be used by the game
hexdump -e '20/4 " %08X" "\n"' -vs 138 $1 | perl -pe 's/000000FF/W/g; s/FFFFFFFF/./g; s/FF0000FF/S/; s/ //g' > $2

# Things I've tried:
hexdump -e '80/1 " %02X" "\n"' -vs 138 20x20-color.bmp | less
hexdump -e '20/1 " %02X" "\n"' -vs 138 20x20-color.bmp | less
hexdump -e '20/4 " %08X" "\n"' -vs 138 20x20-color.bmp | less
hexdump -e '20/1 " %_u" "\n"' -vs 138 20x20-color.bmp | less
hexdump -e '20/4 " %08X" "\n"' -vs 138 20x20-color.bmp | perl -pe 's/000000FF/W/g; s/FFFFFFFF/E/g; s/FF0000FF/S/' | less