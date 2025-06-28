# er-schema
Otobo package to show an ER schema diagram in the Admin UI

## required perl modules:

- Config::General
- Math::Bezier
- SQL::Translator
- GraphViz

## Docker install

```Bash
# get a shell in the web container
docker exec -ti otobo-web-1 bash

# install modules using cpanm and local-lib:
cpanm --local-lib local Config::General
cpanm --local-lib local Math::Bezier
cpanm --local-lib local SQL::Translator
cpanm --local-lib local GraphViz
```

## install the package OPM file from Github
get the Package from the GitHub release.

Current Release:
[er-schema-11.0.1.opm](https://github.com/littlemole/er-schema/releases/download/11.0.1/er-schema-11.0.1.opm)

