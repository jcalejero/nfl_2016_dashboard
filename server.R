library(flexdashboard)
library(plotly)
library(shiny)
library(googleVis)

source('model.R')

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

shinyServer(function(input, output, session) {

  GenerateHeatMapData <- reactive({
    params <- c(input$localteam, input$quarter)
    data <- BuildMatrixForHeatMap(params)
    data
  })
  
  GenerateGainedYardsChart <- reactive({
    params <- c(input$localteam, input$quarter)
    data <- BuildDataOffensiveType(params)
    data
  })
  
  output$heatmap <- renderPlotly({
    data <- GenerateHeatMapData()
    p <- plot_ly(z = data, type = "heatmap", colors = "Greens")
    layout(p, title = "Avg Yards Gained: Team vs League")
    
  })
  
  output$GainedYardsTable <- renderGvis ({
    data <- GenerateGainedYardsChart()
    gvisTable(data)
  })
  
  output$GainedYardsChart <- renderPlotly({
    data <- GenerateGainedYardsChart()
    p <- plot_ly(data, x = FirstDown, y = PlayType, name = "FirstDown",
                 mode = "markers", marker = list(color = "green")) %>%
      add_trace(x = SecondDown, name = "SecondDown", y = PlayType, marker = list(color = "yellow"),
                mode = "markers") %>%
      add_trace(x = ThirdDown, name = "ThirdDown", y = PlayType, marker = list(color = "orange"),
                mode = "markers") %>%
      add_trace(x = FourthDown, name = "FourthDown", y = PlayType, marker = list(color = "red"),
                mode = "markers") %>%
      layout(
        title = "Average Yards Gained by PlayType",
        xaxis = list(title = "Avg Yards Gained"),
        margin = list(l = 65)
      )
    p
    
  })
  
})
