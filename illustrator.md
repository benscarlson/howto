### Wrap text inside text box. 

See second answer: https://graphicdesign.stackexchange.com/questions/3551/illustrator-make-text-wrap-instead-of-scale

### Set text boxes to auto-resize. 

https://community.adobe.com/t5/illustrator/fit-bounding-box-to-text-in-illustrator/m-p/10013336

### Rectangle around text box with white background

* Create text then select it
* Appearance panel. Three dots in Properties/Appearance. Or Window -> Appearance panel
* Upper right corner (three small lines) -> add stroke
* Highlight the stroke entry, then Effect -> convert to shape -> rectangle
* Add fill
* Move fill below characters
* Highlight the fill entry, then Effect -> convert to shape -> rectangle

Add fill to text box: https://graphicdesign.stackexchange.com/questions/19824/illustrator-auto-sized-text-box-with-shaded-background/19828#19828
Add stroke to text box: https://graphicdesign.stackexchange.com/questions/132886/illustrator-auto-sized-text-box-with-a-rectangle-border-no-fill

edit the artboard so that just the elements you want are on the artboard. Then you can delete the other elements.
Try to remove any background rectangles
If you cant delete, then use properties -> appearance, fill. click the square and change it to transparent
To make sure everything is transparent, set the artboard to simulate paper and then pick
View -> show transparancy
Export as a pdf

To change elements so that they show up on a black background
* Shift + click to select multiple elements
* Text - Change fill to white
* Boxes - no fill, white stroke
* Arrows - white stroke

To set the illustrator background to black (note this will not output a black background!)
* Document setup -> Check Simulate colored paper. Pick black for each box of grid
* View -> Show transparancy grid

Pen tool
- Press P as shortcut
- Enter to finish the line
- Hold shift to lock horizontal/vertical/45 deg angle
- Can add new anchor points to existing lines
- Click on anchor point to delete
- Click and drag lets you create a curved line
- Press space on keyboard to move anchor point that you just added
- Tracing an object (example is a bird)
  - When tracing, bring opacity down to more easily see 
  - Remove fill color, 

hold alt and scroll mouse wheel to zoom in/out
press space and click drag to move canvas

Direct select tool to manually edit nodes

Copy object - 1) click on the object to select it. 2) hold down Opt key. 3) drag to copy
### Grid

Change grid lines:
Preferences -> Guides and Grids -> subdivisions -> 8

View -> Show Grid
View -> Snap to Grid. Shift-Cmd-' to toggle

### Objects

Combine two lines into one shape - Select both lines, then ctrl + j

### Pathfinder

To make objects out of all intersecting regions of two or more obects
Window -> Path -> Highlight objects -> Divide
Note the objects are grouped. To move the individual objects, ungroup first

### unit conversion

72 pts in one inch

### Rectangular grid

The rectangular grid tool is with the line segment tool
After selecting, click once on canvas, and properties panel will pop up. Use this to set the number of cells

### Colors

Change hex color: Double click on the background or stroke box. Put the hex code into the textbox.

