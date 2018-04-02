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

#---- supress messages ----#
<<echo=FALSE, warning=FALSE, message=FALSE>>=

#---- figures ----#

<<fig.cap='My caption'>>
<<fig.show='hold', out.width='6m'>> #puts figures side-by-side
#out.width is the area that the plot will be written to.
#fig.height is the size the plot is created at. I think plot is scaled if these are different
<<out.width='8in', fig.width=8, fig.align='center'>>=

#---- inline r code ----#
<<>>=
indivName<-'MyAnimal'
@
EDA for \Sexpr{indivName} track

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


