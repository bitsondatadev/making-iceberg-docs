#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--version) ICEBERG_VERSION="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# change to staging branch
git branch -b "docs-${ICEBERG_VERSION}"

#remove all local files and leave home/ dir
rm ./*
#rm -r ./bin

# move the latest docs to the root and change from 'latest' to 'ICEBERG_VERSION'
mv home/docs/latest "./${ICEBERG_VERSION}"

#delete home directory
rm -r ./home

# update versions in mkdocs.yml
sed -i '' -E "s/(^site\_name:[[:space:]]+docs\/).*$/\1${ICEBERG_VERSION}/" "./${ICEBERG_VERSION}/mkdocs.yml" 
sed -i '' -E "s/(^[[:space:]]*-[[:space:]]+Javadoc:.*\/javadoc\/)latest/\1${ICEBERG_VERSION}/" "./${ICEBERG_VERSION}/mkdocs.yml"

# add exclude search for older documentation

cd "./${ICEBERG_VERSION}"

python3 -c "import os
for f in filter(lambda x: x.endswith('.md'), os.listdir('.')): lines = open(f).readlines(); open(f, 'w').writelines(lines[:2] + ['search:\n', '  exclude: true\n'] + lines[2:]);"

cd ..

git add .

git commit -m "Deploy 1.3.1 Iceberg docs"

git tag "docs-${ICEBERG_VERSION}"

git push "docs-${ICEBERG_VERSION}"

git checkout main

git branch -d "docs-${ICEBERG_VERSION}"
