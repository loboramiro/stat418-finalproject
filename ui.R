library(shiny)
library(shinydashboard)
library(DT)

# Load model panel data for dropdowns
dat <- read.csv("data/model_panel.csv")

# Get list of sectors/states
sector_choices <- sort(unique(dat$sector))
state_choices <- sort(unique(dat$state))

ui <- dashboardPage(
  dashboardHeader(title = "Labor Action Predictions in the US", titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predictions", tabName = "predictions",
               icon = icon("chart-line")),
      menuItem("Data", tabName = "data", icon = icon("table")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "predictions",
              fluidRow(
                box(width = 4, title = "Select Inputs", status = "primary",
                    solidHeader = TRUE,
                    selectInput("state", "Select State",
                                choices = state_choices,
                                selected = "Alabama"),
                    selectInput("sector", "Select Labor Sector",
                                choices = sector_choices,
                                selected = "Construction"),
                    radioButtons("input_mode", "Features:",
                                 choices = c("Default", "Custom"),
                                 selected = "Default"),
                    conditionalPanel(
                      condition = "input.input_mode == 'Custom'",
                      sliderInput("state_unempl_rate",
                                  "State Unemployment Rate (%):",
                                  min = 0, max = 30, value = 5),
                      sliderInput("state_labor_part",
                                  "State Labor Participation Rate (%):",
                                  min = 40, max = 80, value = 65),
                      sliderInput("state_labor_force",
                                  "Total State Labor Force (Thousands):",
                                  min = 250, max = 25000, value = 3500),
                      sliderInput("all_employees",
                                  "Sector Employment Level (Thousands):",
                                  min = 0, max = 10000, value = 3000),
                      sliderInput("adjusted_cpi",
                                  "State-Adjusted Consumer Price Index:",
                                  min = 200, max = 400, value = 250)
                    )
                ),
                column(width = 8,
                       box(title = "Prediction", status = "success",
                           solidHeader = TRUE, width = 12,
                           valueBoxOutput("action_prob_box", width = 6)
                       ),
                       box(title = "Strike Trend Plot", status = "warning",
                           solidHeader = TRUE, width = 12,
                           plotOutput("trend_plot_state", height = "350px", width = "100%")
                       )
                )
              ),
              fluidRow(
                box(width = 12, title = "Recent Labor Actions",
                    status = "info", solidHeader = TRUE,
                    uiOutput("recent_actions_ui")
                )
              )
              
      ),
      tabItem(tabName = "data",
              fluidRow(
                box(width = 12, title = "Full Labor Action Dataset",
                    status = "primary", solidHeader = TRUE,
                    DT::dataTableOutput("strike_table")
                )
              )
      ),
      tabItem(tabName = "about",
              box(width = 12, title = "About This Project",
                  status = "info", solidHeader = TRUE,
                  p("This project is part of a STAT 418 final project to model",
                    "and forecast labor unrest in the United States. The",
                    "application allows users to explore sector- and state-level",
                    "strike and protest activity and estimate the probability of",
                    "future actions based on labor market indicators. The app",
                    "combines publicly available strike data with economic",
                    "indicators from the Bureau of Labor Statistics.")
              )
      )
    )
  )
)
