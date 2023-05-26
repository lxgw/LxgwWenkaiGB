#!/usr/bin/bash

# apply patch of nerdfont

FONT_DIR=$(PWD)/../fonts/TTF/

for F in ${FONT_DIR}/*.ttf; do
	fontforge -script fontpatcher/font-patcher --fontawesome --fontawesomeextension --fontlogos --octicons --codicons --powersymbols --pomicons --powerline --powerlineextra --material --weather -o ${FONT_DIR} $F
done
