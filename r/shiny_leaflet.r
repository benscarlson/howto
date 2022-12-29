# Dynamic Leaflet maps in Shiny applications. https://riptutorial.com/r/example/16144/dynamic-leaflet-maps-in-shiny-applications
# Shiny articles - reactivity. https://shiny.rstudio.com/articles/#reactivity

#---- Simplest shiny app ----#
#File must be called app.R (can't be app.r)
library(shiny)
ui <- fluidPage(
  "Hello, world!"
)
server <- function(input, output, session) {
}
shinyApp(ui, server)

#---- UI Elements ----#

#Floating, draggable panel. Can set draggable = TRUE
# https://shiny.rstudio.com/reference/shiny/0.11/absolutePanel.html

#---- Layouts ----#

fluidPage(splitLayout(htmlOutput('startDoy'),htmlOutput('endDoy'))) #put two elements side-by-side

#---- Javascript ----#
# Javascript function directly in ui declaration
ui <- fluidPage(
  tags$script('
    $(document).on("shiny:inputchanged", function(event) {
      if (event.name === "doySlider") {
        alert("inputchanged event: Change");
      }
    });
  ')
)

# To load external js script, store script under www/myscript.js
ui <- fluidPage(
  tags$script(src="script.js"))

#www/script.js
$(document).on("shiny:inputchanged", function(event) {
  if (event.name === "doySlider") {
    alert('moved');
  }
});

#---- Observer ----#

# Observe Function in R Shiny — How to Implement a Reactive Observer. medium.com

#---- Javascript Events ----#

# event has name, value, and some other properties


#How to set a UI element using javascript
#This updates label with value of slider whenever slider moves

#ui.r
fluidpage(sliderInput('myslider'), htmlOutput('mylabel'));

#script.js
$(document).on("shiny:inputchanged", function(event) {
  if (event.name === "myslider") {
    document.getElementById("mylabel").innerHTML = event.value
  }
});

#---- Leaflet ----#

#use to zoom the map to the bounds of the dataset
leaflet() %>% fitBounds(min(dat$lon), min(dat$lat), max(dat$lon), max(dat$lat))
