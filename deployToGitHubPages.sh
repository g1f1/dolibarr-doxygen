#!/bin/bash

function bell() {
  while true; do
    echo -e "\a"
    sleep 60
  done
}
bell &

GIT_DEPLOY_REPO=https://${GITHUB_API_KEY}@github.com/dolibarr/doxygen.git

echo -e "\nDisabling Git automatic garbage collecting to save some time..."
git config --global gc.auto 0

echo -e "\nDefining Git user name and user email..."
git config --global user.name "Deployment Bot"
git config --global user.email "deploy@travis-ci.org"

echo -e "\nCreating new empty Git repository into 'build' directory..."
cd build
git init

echo -e "\nAdding all Doxygen generated files to local Git repository..."
git add . > /dev/null

echo -e "\nCommitting added files to local Git repository..."
git commit --quiet -m " Deploy jtraulle/dolibarr-doxygen to github.com/dolibarr/doxygen.git:gh-pages"

echo -e "\nPushing local Git repository to remote location (GitHub) to deploy to GitHub Pages..."
git push --force "${GIT_DEPLOY_REPO}" master:gh-pages

exit $?
