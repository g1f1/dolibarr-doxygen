#!/bin/bash

mkdir build_index

cp template_index/doxygen.css build_index/
cp template_index/tab_b.png build_index/
cp template_index/dolibarr.png build_index/
cp template_index/zip.png build_index/
cp template_index/pdf.png build_index/
cp template_index/web.png build_index/
cat template_index/index-header.html > build_index/index.html

while read version; do
  echo "<li><strong style='font-size: large;'>→ $version</strong></li><ul>" >> build_index/index.html
  echo "<li><a href="$version/index.html"><img style='vertical-align: middle;' src="web.png" /><strong> online HTML version</strong></a></li>" >> build_index/index.html
  echo "<li><a href="https://gitlab.com/jtraulle/dolibarr-doxygen/-/archive/gh-pages/dolibarr-doxygen-gh-pages.zip?path=$version"><img style='vertical-align: middle;' src="zip.png" /> download .zip offline HTML version</a></li>" >> build_index/index.html
  echo "<li><a href="$version/dolibarr-$version.pdf"><img style='vertical-align: middle;' src="pdf.png" /> PDF version for printing or offline usage</a></li>" >> build_index/index.html
  echo "</ul>" >> build_index/index.html
done <versions/dolibarrVersions

cat template_index/index-footer.html >> build_index/index.html

