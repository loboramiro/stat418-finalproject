library(shiny)
library(tidyverse)
library(lubridate)


#load clean strike data
strikes <- read.csv("data/strikes_clean.csv")

#load panel data sets


#load plotting function
source("scripts/app_plot.R")

# Server logic
function(input, output, session) {
  
  # ---- Plot: Yearly Actions by Sector in Selected State ----
  output$trend_plot_state <- renderPlot({
    req(input$state)
    plot_state_actions_by_sector(strikes, input$state)
  })
  
  # ---- Placeholder: Predicted Strike Probability ----
  output$action_prob <- renderText({
    "0.00 (model not connected yet)"
  })
}
