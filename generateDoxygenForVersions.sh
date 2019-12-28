#!/bin/bash

function bell() {
  while true; do
    echo -e "\a"
    sleep 60
  done
}
bell &

DIRPATH="$(pwd)"

cd versions && split --numeric-suffixes=1 -n l/5 dolibarrVersions versions
cd ..

echo "Using version file versions/$VERSIONSFILE"
echo ""

while IFS= read -r version; do
  cd dolibarr
  echo "Checking out Git branch or tag '$version'"
  echo ""
  git checkout --quiet -f $version
  cd ${DIRPATH}

  echo "Generating Doxygen HTML doc for Dolibarr version $version"
  echo ""
  docker run --user ${UID} --rm -v `pwd`:/home dolibarr/doxygen:1.8.17 /bin/sh -c "( cat dolibarr.doxyfile ; echo 'PROJECT_NUMBER=$version' ; echo 'OUTPUT_DIRECTORY=build_$VERSIONSFILE' ; echo 'HTML_OUTPUT=$version' ) | doxygen -"
  cp doxygen_warnings.log build_$VERSIONSFILE/$version/doxygen-warnings.log 2>/dev/null || :

  echo "Generating Doxygen LaTeX doc for Dolibarr version $version"
  echo ""
  docker run --user ${UID} --rm -v `pwd`:/home dolibarr/doxygen:1.8.17 /bin/sh -c "( cat dolibarr.doxyfile ; echo 'PROJECT_NUMBER=$version' ; echo 'OUTPUT_DIRECTORY=build_$VERSIONSFILE' ; echo 'GENERATE_HTML=NO' ; echo 'GENERATE_LATEX=YES' ; echo 'LATEX_OUTPUT=pdf_$version' ) | doxygen -"

  echo "Generating Doxygen PDF doc (using LuaLaTeX) for Dolibarr version $version"
  echo ""
  sed -i "s/(version)/(version $version)/g" build_$VERSIONSFILE/pdf_$version/refman.tex
  sed -i "s/(version main page)/Version $version/g" build_$VERSIONSFILE/pdf_$version/refman.tex
  docker run --rm -v `pwd`:/home dolibarr/doxygen:1.8.17 /bin/sh -c "cd build_$VERSIONSFILE/pdf_$version/ && make && chmod a+rw refman*"
  cd ${DIRPATH}
  cp build_$VERSIONSFILE/pdf_$version/refman.pdf build_$VERSIONSFILE/$version/dolibarr-$version.pdf
  cp build_$VERSIONSFILE/pdf_$version/refman.log build_$VERSIONSFILE/$version/lualatex-warnings.log
  rm -rf build_$VERSIONSFILE/pdf_$version
done <"versions/$VERSIONSFILE"
