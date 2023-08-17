# making-iceberg-docs

Testbed for the Iceberg docs.

## Requirements 

* Python >=3.9
* pip

## Install

```
python -m venv mkdocs_env
source mkdocs_env/bin/activate

pip install -r requirements.txt
```

## Add git worktrees

For now, I'm just adding a single version

```
git worktree add home/docs/1.3.1 docs-1.3.1
git worktree add home/javadoc javadoc
```

## Build

```
mkdocs build
mkdocs serve
```

## Validate Links

Due to the delayed aggregation of subdocs of `mkdocs-monorepo-plugin` there are some warnings that display for subdocs that mkdocs are not able to connect due to being off by a single directory when the version directory is added, which doesn't mirror the directory layout on disk.

To ensure the links work, I am temporarily using a tool called linkchedker, which will traverse the links on the livesite. 
```
pip install linkchecker

./linkchecker http://localhost:8000 -r1 -Fcsv/link_warnings.csv
```



## Things to consider

 - Do not use static links to the public iceberg site.
 - Only use relative links. If you want to reference the root (the directory where the main mkdocs.yml is located `home` in our case) use "spec.md" vs "/spec.md". Also, static sites should only reference the `docs/*` (see next point), but docs can reference the static content normally (e.g. `branching.md` page which is a versioned page linking to `spec.md` which is a static page).
 - Avoid statically linking a specific version of the documentation ('latest', '1.3.1', etc...) unless it is absolutely relevant to the context being provided. This should almost never be the case unless referencing legacy functionality.
 - When internally linking markdown files to other markdown files, [always use the `.md` suffix](https://github.com/mkdocs/mkdocs/issues/2456#issuecomment-881877986). That will indicate to mkdocs exactly how to treat that link depending on the mode the link is compiled with, e.g. if it becomes a <filename>/index.html or <filename>.html. Using the `.md` extension will work with either mode. 
