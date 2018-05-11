# Convert 3 digit tuple of RBG to hex. https://stackoverflow.com/questions/31574480/rgb-to-hex-converter
x <- c("165 239 210", "111 45 93")
sapply(strsplit(x, " "), function(x) {
    rgb2(x[1], x[2], x[3], maxColorValue=255)})

rgb2hex <- function(r,g,b) rgb(r, g, b, maxColorValue = 255)#rgb2hex(255,0,0). https://gist.github.com/mbannert/e9fcfa86de3b06068c83

#turn colorname into hex. https://gist.github.com/mbannert/e9fcfa86de3b06068c83
col2hex <- function(col, alpha) rgb(t(col2rgb(col)), alpha=alpha, maxColorValue=255)
col2hex('firebrick') # [1] "#B22222"
col2hex('firebrick', 204) # [1] "#B22222CC"

#working with a color palettes
https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2

col=rainbow(length(x)) #rainbow palette for base R plot. x is a vector.
