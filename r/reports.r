#Officer: https://davidgohel.github.io/officer/. Embed tables/figures directly into office docs!
#Bookdown: https://bookdown.org/yihui/rmarkdown/
#Modeldown: http://smarterpoland.pl/index.php/2019/06/modeldown-is-now-on-cran/

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

#---- Child templates ----#

#this is from Yihui: http://r.789695.n4.nabble.com/KnitR-RMarkdown-Is-there-a-way-to-not-print-a-section-of-the-document-td4684262.html
#Similarly, you can split a large input document into child documents in knitr, e.g. 

<<chap1, child="chap1.Rnw">>= 
@ 

#You can comment out this chunk when you do not need it. Or control it programmatically, 

<<setup, include=FALSE>>= 
include_me = TRUE  # or FALSE 
@ 

.... 

<<chap1, child=if (include_me) "chap1.Rnw">>= 
@ 

#How to use a child template in a knitr doc.
#https://github.com/yihui/knitr-examples/blob/master/020-for-loop.Rnw

#can also do a logical statement in the header
<<include=(.p$env$val_type=='discrete')>>

#---- supress messages ----#
<<echo=FALSE, warning=FALSE, message=FALSE>>=

#---- figures ----#

<<fig.cap='My caption'>>
<<fig.show='hold', out.width='6m'>> #puts figures side-by-side
#out.width is the area that the plot will be written to.
#fig.height is the size the plot is created at. I think plot is scaled if these are different
<<out.width='8in', fig.width=8, fig.align='center'>>=

#Insert picture into R Markdown
#https://stackoverflow.com/questions/25166624/insert-picture-table-in-r-markdown
knitr::include_graphics('/path/to/image.png') #This looks like best suggestion

#---- inline r code ----#
<<>>=
indivName<-'MyAnimal'
@
EDA for \Sexpr{indivName} track

#output can't have special characters in them. one is '_'. Need to escape this.
#this might be wrong, might only need \\ to escape. Look at function in model report
\Sexpr{gsub("_","\\\\_","my_var_with_underscores")}

#----
#---- tables ----#
#----

options(knitr.kable.NA = '') #don't print NA in table

kable(x, format.args = list(decimal.mark = '.', big.mark = ","))
kable(x, digits=2)

#-- table that spans multiple pages
# need to load longtable and booktabs in latex
\usepackage{longtable}
\usepackage{booktabs}

dat %>% 
  kable('latex',booktabs=TRUE, longtable=TRUE,digits=1) %>%
  kable_styling(latex_options=c('hold_position','repeat_header')) #this is kableExtra package

#cleaning up tables
# https://webbedfeet.netlify.com/post/cleaning-up-tables/

#---------------#
#---- latex ----#
#---------------#

#---- configuration ----

# get version. all of these do the same thing
pdflatex --version
pdfTeX -v
latex -v

# check 'TeX distribution' in system preferences to see the version and system of TeX installed.

#---- paragraphs ----
\setlength{\parskip}{1em} # set spacing between successive paragraphs.

#---- sections ----
\section*{My section} #Doesn't number section

#change list spacing
\usepackage{enumitem}
\setlist{noitemsep} %remove all space between list items, but leave space before and after the list
\setlist{nosep} %remove all space between list items and don't leave any space before or after the list
\setlist{itemsep=1pt} %change spaceing for all lists (<1 doesn't seem to do anything)
\setitemize{itemsep=1pt} %change spaceing between unordered lists (<1 doesn't seem to do anything)
\setenumerate{itemsep=1pt} %change spaceing between ordered lists (<1 doesn't seem to do anything)

\begin{enumerate}
  \item Some text
   \item Some more text
\end{enumerate}

\begin{itemize}
   \item Some text
   \item Some more text
\end{itemize}

# make a formula. \( and \) start and end the formula
\( (x - mean)/std \) 

# characters that must be escaped with \
_

\textless # '<' sign

#---- include a figure
\graphicspath{ {images/} }
\begin{figure}
  \includegraphics{McCormack2009} %figure is named McCormack2009.png
\end{figure}

\includegraphics[width=\textwidth]{myfigure} %scale myfigure to width of the text

\caption{My caption} # includes a figure label
\caption*{My caption} # don't include the figure label. Requires usepackage{caption}

\begin{figure}[H] # tells latex not to let the figure (or table) float on the page. I.e. place "Here". Required usepackage{float}
#---- knitr ----
\renewenvironment{knitrout}{\vspace{1em}}{} %add space before r chunk
\renewenvironment{knitrout}{}{\vspace{1em}} %add space after r chunk
\renewenvironment{knitrout}{\vspace{1em}}{\vspace{1em}} %add space before and after r chunk

#https://tex.stackexchange.com/questions/9852/what-is-the-difference-between-page-break-and-new-page
\pagebreak #streches out spacing so that text fills up a whole page
\newpage #starts a new page but leaves white space

#---- margins ----#
https://www.sharelatex.com/learn/Page_size_and_margins

<<echo=FALSE, warning=FALSE, message=FALSE, out.width='6in', fig.height=6>>=

#---- TOC ----#
#https://www.latex-tutorial.com/tutorials/table-of-contents/
#https://tex.stackexchange.com/questions/337083/latex-table-of-contents-not-visible-in-sidebar-of-pdf-viewer
#

#---- CPDF ----#
# Use to combine multiple pdfs from command line. Lots of features:
# http://community.coherentpdf.com/

