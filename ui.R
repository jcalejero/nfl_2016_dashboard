library(shiny)
library(plotly)
library(plyr)
library(googleVis)
source('model.R')

#rsconnect::deployApp('/Volumes/moneta/Personal/nfl_2016_dashboard/')
shinyUI(pageWithSidebar(
  headerPanel('NFL 2015-16 Analysis'),
  sidebarPanel(
    selectInput("localteam", label = h3("Team selector"), 
                choices = GetTeams(), 
                selected = "PIT"),
    selectInput("quarter", label = h3("Please, select a quarter"), 
                choices = list("Q1" = 1, "Q2" = 2, "Q3" = 3, "Q4" = 4, "All quarters" = 0), 
                selected = 1)
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Drive",  plotlyOutput('heatmap')), 
      tabPanel("Offensive", plotlyOutput('GainedYardsChart'),
               h6("Summary Data"),
               htmlOutput("GainedYardsTable"))
    )
  )
))