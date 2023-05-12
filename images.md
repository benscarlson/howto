Good overview of using imageMagick to resize images: https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/

## Image information

```{bash}
#Width in inches
identify -format "%w/%x\n" myfig.png | bc -l

#Height in inches
identify -format "%h/%y\n" myfig.png | bc -l

#Can see both height and width together using this
identify -verbose myfig.png | grep "Print size"

```

