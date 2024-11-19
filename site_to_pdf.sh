#!/bin/sh
TARGET_SITE="$1"
echo "wget site ..."
wget --spider --force-html -r -l2 "$TARGET_SITE" 2>&1 | grep '^--' | awk '{ print $3 }' | grep -v '\(css\|js\|png\|gif\|jpg\|txt\|rss\|xml\|json\|pdf\|exe\|ico\|administrator.*\|admin.*\|wp-includes.*\|wp-login.*\|wp-admin.*\|wp-json.*\|xmlrpc.php\)$' | sort -u > url-list.txt
echo "Converting to pdf ..."
while read i; do wkhtmltopdf "$i" "$(echo "$i" | sed -e 's/https\?:\/\///' -e 's/\//-/g' ).pdf"; done < url-list.txt
echo "Merging pdfs ..."
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=merged-output.pdf $(ls -1 *.pdf)
echo "ok"
