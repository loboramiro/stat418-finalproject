library(shiny)
library(tidyverse)
library(lubridate)
library(shinydashboard)

strikes <- read.csv("data/strikes/strikes_clean.csv")
strikes_detailed <- read.csv("data/strikes/strikes_detailed.csv")
data <- read.csv("data/model_panel.csv")

data <- data |> 
  filter(if_all(everything(), ~ !is.na(.)))

source("scripts/app_plot.R")
source("model/model.R")

function(input, output, session) {
  default_inputs <- reactive({
    req(input$state, input$sector)
    
    default_row <- data |> 
      filter(year == 2025, 
             state == input$state, 
             sector == input$sector)
    
    if (nrow(default_row) == 0) {
      return(list(
        all_employees = 3000,
        state_unempl_rate = 5,
        state_labor_part = 65,
        state_labor_force = 3500,
        adjusted_cpi = 300
      ))
    } else {
      return(list(
        all_employees = default_row$all_employees[1],
        state_unempl_rate = default_row$state_unempl_rate[1],
        state_labor_part = default_row$state_labor_part[1],
        state_labor_force = default_row$state_labor_force[1],
        adjusted_cpi = default_row$adjusted_cpi[1]
      ))
    }
  })
  
  observeEvent(input$input_mode, {
    if (input$input_mode == "Custom") {
      defaults <- default_inputs()
      updateSliderInput(session, "all_employees", 
                        value = defaults$all_employees)
      updateSliderInput(session, "state_unempl_rate", 
                        value = defaults$state_unempl_rate)
      updateSliderInput(session, "state_labor_part", 
                        value = defaults$state_labor_part)
      updateSliderInput(session, "state_labor_force", 
                        value = defaults$state_labor_force)
      updateSliderInput(session, "adjusted_cpi", 
                        value = defaults$adjusted_cpi)
    }
  })
  
  get_inputs <- reactive({
    if (input$input_mode == "Custom") {
      list(
        all_employees = input$all_employees,
        state_unempl_rate = input$state_unempl_rate,
        state_labor_part = input$state_labor_part,
        state_labor_force = input$state_labor_force,
        adjusted_cpi = input$adjusted_cpi
      )
    } else {
      default_inputs()
    }
  })
  
  output$action_prob_box <- renderValueBox({
    inputs <- get_inputs()
    new_obs <- data.frame(
      state = input$state,
      sector = input$sector,
      all_employees = inputs$all_employees,
      adjusted_cpi = inputs$adjusted_cpi,
      state_unempl_rate = inputs$state_unempl_rate,
      state_labor_part = inputs$state_labor_part,
      state_labor_force = inputs$state_labor_force
    )
    prob <- predict_action(new_obs)
    valueBox(
      paste0(round(prob * 100, 1), "%"),
      subtitle = "Predicted Probability of Strike or Protest in 2025",
      icon = icon("exclamation-triangle"),
      color = "yellow"
    )
  })
  
  output$occurred_note <- renderText({
    default_row <- data |> 
      filter(year == 2025, 
             state == input$state, 
             sector == input$sector)
    occurred <- if (nrow(default_row) > 0 && 
                    default_row$action_occurred[1] == 1) {
      "Yes"
    } else {
      "No"
    }
    paste(occurred)
  })
  
  output$trend_plot_state <- renderPlot({
    req(input$state)
    plot_state_actions_by_sector(strikes, input$state)
  })
  
  output$strike_table <- DT::renderDataTable(
    strikes_detailed, 
    options = list(
      paging = TRUE,
      pageLength = 10,
      scrollX = TRUE,
      scrollY = TRUE
    )
  )
  
  output$recent_actions_ui <- renderUI({  
    recent_actions <- strikes_detailed |> 
      filter(state == input$state, 
             sector == input$sector) |> 
      arrange(desc(start_date)) |> 
      slice_head(n = 3)
    if (nrow(recent_actions) > 0) {
      DT::dataTableOutput("recent_actions_table")
    } else {
      textOutput("recent_actions_msg")
    }
  })
  
  output$recent_actions_table <- DT::renderDataTable({
    strikes_detailed |> 
      filter(state == input$state, 
             sector == input$sector) |> 
      arrange(desc(start_date))
  })
  
  output$recent_actions_msg <- renderText(
    "There are no recent actions in this state and sector."
  )
}
