#Officer: https://davidgohel.github.io/officer/. Embed tables/figures directly into office docs!
#Bookdown: https://bookdown.org/yihui/rmarkdown/
#Modeldown: http://smarterpoland.pl/index.php/2019/06/modeldown-is-now-on-cran/

#----------------#
#---- Quarto ----#
#----------------#

#---- Output ----#

#if text is output like 'y ~ a*p + b*p' then 'p + b' will be in italics in the output
#need to replace this with 'y ~ a\\*p + b\\*p'

dat %>% mutate(formula=gsub('*','\\*', dat$formula, fixed=TRUE)) %>% able

#Or use escQmdText() in funs/quarto_funs.r
mods %>% mutate(formula=escQmdText(formula)) %>% kable

#header
# Can't have more than one blank line at the end of the header, or it seems all header settings are ignored.

# Set options using dynamic elements
# Need to have !expr (a & b), not a & b
# Need to have a space. !expr (a & b), not !expr(a & b)

#| eval: !expr (a & b)

#| eval: NA <!-- If expression is NA, the chunk will be evaluated -->

#Can write to the console using message()
message('This will write to the console while kniting')

#print() will write to seperate lines but will put line numbers [1] at the begining
print('word')

#cat() plus \n\n will print to it's own line. and does not include [1] at the beginning
cat('word\n\n') 

#to write strings that are rendered directly as markdown, use asis and cat
#| output: asis
cat('this line rendered as markdown\n')
cat(myvar,'\n')

#---- Figures ----#

#Automatic figure numbers. Need to indlude the #fig-label and also include a caption
![My Caption](myplot.png){#fig-myplot}
  
#To add multiple attributes to a quarto image, seperate by spaces.
![Confidence Intervals](myplot.png){#fig-ci_dens width=5in}
  
# HTML options: https://quarto.org/docs/reference/formats/html.html
#| fig-height: 2 <!— It seems units are in inches —>

#Can’t set fig-height twice in the same chunk. Here, both plots will have height of 2

#| fig-height: 2 
plot()
#| fig-height: 5
plot()

#Seems I need to set any options before executing any r code. Fig-height will not apply here:

cat(‘output’)
#| fig-height: 2
plot()

#---- Parameters ----#

---
params:
  hs_name: "NA"
---
.hsName <- params$hs_name
invisible(assert_that(!is.na(.hsName) & .hsName != "NA"))

#Pass into render using the -P flag. Use another -P flag for a second parameter
# when using -p parameter in render, the passed in value overrides the value that is set in the qmd header
quarto render $qmd -P hs_name:$hs -P another_param:$v2

#To pass in a parameter, you need to put it into the qmd header (like above).
#If you don't define it there, attempting to pass with -P will results in "params object not found"
#Note that whatever you sent as the default in the section header will be overwritten by the -P flag
#Params defined in the header but *not* passed in using -P will retain the default value

#---- Rendering ----#

qmd=$src/poc/segment/reports/seg_counts/seg_counts.qmd
out=$wd/reports/seg_counts.html

mkdir -p ${out%/*}

quarto render $qmd
mv ${qmd%.*}.html $out
open $out

#---- Tables ----#

#gt package, from posit
# https://gt.rstudio.com/

#---- debugging ----#

#Use this to print to the console.

```{r}

stop(x)

```

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

#Change default font size
#https://texblog.org/2012/08/29/changing-the-font-size-in-latex/
\documentclass[12pt]{report}

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
# https://github.com/yihui/knitr-examples/blob/master/020-for-loop.Rnw
#How to use a child template in an Rmd doc.
#https://drmowinckels.io/blog/2021-12-17-rmarkdown-child-templates/

#can also do a logical statement in the header
<<include=(.p$env$val_type=='discrete')>>

#---- Chunk options ----#


<<echo=FALSE, warning=FALSE, message=FALSE>>= # supress messages

{r echo=TRUE, results='hide'} #Show code but not output


#---- figures ----#

<<fig.cap='My caption'>>
<<fig.show='hold', out.width='6m'>> #puts figures side-by-side
#out.width is the area that the plot will be written to.
#fig.height is the size the plot is created at. I think plot is scaled if these are different
<<out.width='8in', fig.width=8, fig.align='center'>>=

#Insert picture into R Markdown
#https://stackoverflow.com/questions/25166624/insert-picture-table-in-r-markdown
knitr::include_graphics('/path/to/image.png') #This looks like best suggestion

#ggmap plots are always too small. The trick is to use *both* fig.height and fig.width
# Setting just one will still result in a small figure. 
{r, fig.width=10, fig.height=10}

#---- inline r code ----#
<<>>=
indivName<-'MyAnimal'
@
EDA for \Sexpr{indivName} track

#output can't have special characters in them. one is '_'. Need to escape this.
#I think gsub processes one set of \\, so need to add \\\\ in order to write out \\
#NOTE: see my function rfuns/escapeForLatex.r
\Sexpr{gsub("_","\\\\_","my_var_with_underscores")}

#If error (a boolean variable) is true, print the message. Otherwise there is no output
\Sexpr{ifelse(error,msg,'')}

#----
#---- tables ----#
#----

#Good documentaion on kableExtra
#https://haozhu233.github.io/kableExtra/awesome_table_in_html.html

options(knitr.kable.NA = '') #don't print NA in table

kable(x, format.args = list(decimal.mark = '.', big.mark = ","))
kable(x, digits=2)

#If you have one non-numeric column, 'digits' won't work
# in this case, you have to do rounding yourself
dat %>% mutate(across(where(is.numeric),~round(.x,2))) %>% kable

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

#---- Merge multiple files to pdf ----#

# Various methods here: https://askubuntu.com/questions/246647/convert-a-directory-of-jpeg-files-to-a-single-pdf-document

#---- CPDF ----#
# Use to combine multiple pdfs from command line. Lots of features:
# http://community.coherentpdf.com/

cpdf one.pdf two.pdf three.pdf -o merged.pdf

#---- pngs -> pdf ----#

#Merges png files into one pdf
dir=$wd/segtest2/reports/donana

files=`ls $dir/png/`

mkdir $dir/png_off

for file in $files
do
  convert $dir/png/$file -background white -alpha remove -alpha off $dir/png_off/$file
done

img2pdf $dir/png_off/* -o $dir/bpm_donana.pdf
