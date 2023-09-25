#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--version) ICEBERG_VERSION="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

GIT_BRANCH="docs-stg-${ICEBERG_VERSION}"
GIT_TAG="docs-${ICEBERG_VERSION}"

# change to staging branch
git checkout -b $GIT_BRANCH

#remove all local files and leave home/ dir
rm ./*

# move the latest docs to the root and change from 'latest'
mv home/docs/latest/* .

#delete dirs
rm -r ./home .github/

# update versions in mkdocs.yml
sed -i '' -E "s/(^site\_name:[[:space:]]+docs\/).*$/\1${ICEBERG_VERSION}/" "./mkdocs.yml" 
sed -i '' -E "s/(^[[:space:]]*-[[:space:]]+Javadoc:.*\/javadoc\/)latest/\1${ICEBERG_VERSION}/" "./mkdocs.yml"

# add exclude search for older documentation
python3 -c "import os
for f in filter(lambda x: x.endswith('.md'), os.listdir('.')): lines = open(f).readlines(); open(f, 'w').writelines(lines[:2] + ['search:\n', '  exclude: true\n'] + lines[2:]);"

git add .

git commit -m "Deploy ${ICEBERG_VERSION} Iceberg docs"

git tag $GIT_TAG

git push origin $GIT_TAG

git reset --hard main

git checkout main

git branch -d $GIT_BRANCH
