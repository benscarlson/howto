
Pass in multiple instances of the same parameter
Results in vector of strings

```{r}
'Usage:
docopt_mpar.r [--param=<param>]...
docopt_mpar.r (-h | --help)

Parameters:

Options:
-h --help  Show this screen.
-v --version  Show version.
-p --param=<param>  Zero or more parameteters
' -> doc

library(docopt)

ag <- docopt(doc, version = '0.1\n')

print(ag)
```

```{zsh}

$src/poc/docopt_mpar.r -p A -p B

```
