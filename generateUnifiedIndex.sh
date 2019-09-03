#!/bin/bash

mkdir build_index

cp template_index/doxygen.css build_index/
cp template_index/tab_b.png build_index/
cp template_index/dolibarr.png build_index/
cp template_index/zip.png build_index/
cp template_index/pdf.png build_index/
cp template_index/web.png build_index/
cp template_index/log.png build_index/
cp template_index/lua.png build_index/
cp template_index/tools.png build_index/
cp template_index/git.png build_index/
cp template_index/tag.png build_index/
cat template_index/index-header.html > build_index/index.html
cat template_index/index-header.html > build_index/logs.html

while read version; do

  if [ $version = "develop" ]
  then
     icon="<img style='position:relative; top:6px;' src='git.png' alt='Git icon' />"
  else
     icon="<img style='position:relative; top:3px;' src='tag.png' alt='Tag icon' />"
  fi

  echo "<li><strong style='font-size: large;'>$icon $version</strong><ul style='padding-bottom: 40px;'>" >> build_index/index.html
  echo "<li><a href='$version/index.html'><img style='vertical-align: middle;' alt='Web globe icon' src='web.png' /><strong> browse HTML version (online)</strong></a></li>" >> build_index/index.html
  echo "<li><a href='https://gitlab.com/jtraulle/dolibarr-doxygen/-/archive/gh-pages/dolibarr-doxygen-gh-pages.zip?path=$version'><img style='vertical-align: middle;' alt='Archive file icon' src='zip.png' /> download HTML version .zip archive (for offline usage)</a></li>" >> build_index/index.html
  echo "<li><a href='$version/dolibarr-$version.pdf'><img style='vertical-align: middle;' alt='PDF file icon' src='pdf.png' /> download PDF version (for printing or offline usage)</a></li>" >> build_index/index.html
  echo "</ul></li>" >> build_index/index.html

  echo "<li><strong style='font-size: large;'>$icon $version</strong><ul>" >> build_index/logs.html
  echo "<li><a href='$version/doxygen-warnings.log'><img style='vertical-align: middle;' alt='Log event icon' src='log.png' /> Doxygen warnings</a></li>" >> build_index/logs.html
  echo "<li><a href='$version/lualatex-warnings.log'><img style='vertical-align: middle;' alt='Lua LaTeX icon' src='lua.png' /> LuaLaTeX warnings</a></li>" >> build_index/logs.html
  echo "</ul></li>" >> build_index/logs.html
done <versions/dolibarrVersions

cat template_index/index-footer.html >> build_index/index.html
cat template_index/index-footer.html >> build_index/logs.html

