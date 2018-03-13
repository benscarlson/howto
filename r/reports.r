#----------
# rmarkdown
#----------

# to include latex in an rmarkdown file, just put the latex directly in the document
# don't include the \begin{document} ... \end{document} tags.
# also \usepackage needs to go in the YAML at the top:
# http://tex.stackexchange.com/questions/171711/how-to-include-latex-package-in-r-markdown
---
title: "Bavaria Static Niche"
output: pdf_document
header-includes:
  - \usepackage{graphicx}
  - \usepackage{caption}
  - \usepackage{subcaption}
---

#------------
# latex/knitr
#------------

#change document margins
#http://kb.mit.edu/confluence/pages/viewpage.action?pageId=3907057
\usepackage[margin=0.5in]{geometry} #can also use pt instead of in

#to rotate column headers
\usepackage{rotating} #need to specifically include this, or else xtable will fail

<<table, echo=FALSE, results='asis'>>=
library(xtable)
dat <- data.frame(`column name 1`=rnorm(3),`column name 2`=rnorm(3))
#make an xtable out of dat, then pass into print.xtable()
#this function allows for a bunch of parameters, such as rotate.colnames
print.xtable(xtable(dat),rotate.colnames=TRUE)
@

#How to use a child template in a knitr doc.
#https://github.com/yihui/knitr-examples/blob/master/020-for-loop.Rnw

#
<<fig.cap='My caption'>>
<<fig.show='hold', out.width='6m'>> #puts figures side-by-side

#supress messages

#make sure message=FALSE
<<echo=FALSE, warning=FALSE, message=FALSE>>=
