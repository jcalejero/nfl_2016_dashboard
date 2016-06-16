library(flexdashboard)
library(plotly)
library(shiny)

source('model.R')

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

shinyServer(function(input, output, session) {

  GenerateHeatMapData <- reactive({
    params <- c(input$localteam, input$quarter)
    data <- BuildMatrixForHeatMap(params)
    data
  })
  
  output$heatmap <- renderPlotly({
    data <- GenerateHeatMapData()
    p <- plot_ly(z = data, type = "heatmap", colors = "Greens")
    layout(p, title = "Avg Yards Gained: Team vs League")
    
  })
  
})
