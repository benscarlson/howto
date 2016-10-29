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

#----
# latex
#------

#change document margins
#http://kb.mit.edu/confluence/pages/viewpage.action?pageId=3907057
\usepackage[margin=0.5in]{geometry}
