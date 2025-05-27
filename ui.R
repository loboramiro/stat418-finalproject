library(shiny)

dat <- read.csv("data/model_panel.csv")

#get list of sectors/states
sector_choices <- sort(unique(dat$sector))
state_choices <- sort(unique(dat$state))

sector_choices <- c(sector_choices)
state_choices <- c(state_choices)

ui <- fluidPage(
  titlePanel("Labor Action Prediction"), 
  
  sidebarLayout(
    sidebarPanel(
      # select labor sector
      selectInput("sector", "Select Labor Sector", 
                  choices = sector_choices,
                  selected = "Education and Health Services"),
      
      # choose state
      selectInput("state", "Select State",
                  choices = state_choices,
                  selected = "California"),
      
      # choose labor action
      selectInput("action_type", "Select Labor Action Type",
                  choices = c("Strike", "Protest", "Either"),
                  selected = "Strike"),
      
      # choose default values or customize
      radioButtons("input_mode", "BLS Features:",
                   choices = c("Default", "Custom"),
                   selected = "Default"),
      
      conditionalPanel(
        condition = "input.input_mode == 'Custom'",
        sliderInput("unemployment_rate", "Unemployment Rate (%):", 
                    min = 0, max = 100, value = 5),
        sliderInput("labor_part_rate", "Labor Participation Rate (%):",
                    min = 0, max = 100, value = 65),
        sliderInput("employment_level", "Employment Level (Thousands):", 
                    min = 0, max = 10000, value = 5000)
      )
    ),
    
    mainPanel(
      h4("Predicted Probability of Labor Action:"),
      textOutput("action_prob"),
      h4("Historical Trends by State and Sector:"),
      div(style = "width: 700px; margin; auto;",
        plotOutput("trend_plot_state", height = "400px")
    )
  )
))

