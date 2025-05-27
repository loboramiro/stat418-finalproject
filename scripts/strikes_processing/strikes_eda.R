library(tidyverse)

strikes_df <- read.csv("data/strikes.csv")

#strikes vs protest
table(strikes_df$action_type)

#industries for all actions
table(strikes_df$industry)


#actions by industry grouped into strikes vs protests
industry_actions <- strikes_df |> 
  group_by(industry, action_type) |> 
  summarise(n=n()) 

#industries sorted by most actions
top_industries <- strikes_df |>
  group_by(industry) |>
  summarise(n=n()) |>
  arrange(desc(n))

#names of top industries  
top_industries_names <- top_industries |>
  filter(!(is.na(industry))) |>
  slice_head(n=8) |>
  select(industry)
  
  
#top 10 industries with most actions
industry_actions_plot <- industry_actions |>
  filter(industry %in% top_industries_names$industry) |>
  mutate(industry = fct_reorder(industry, n, .fun = sum, .desc = TRUE),
         industry = str_wrap(industry, width = 12)) |>
  ggplot(aes(fill = action_type, y = n, x=industry)) +
  geom_bar(position = "dodge", stat = "identity") +
  ggtitle("Labor Actions by Industry (Top 8)") +
  xlab("Industry") + ylab("Number of Labor Actions") +
  labs(fill="Action Type") +
  theme_minimal()

print(industry_actions_plot)

#actions by states
strikes_df |> group_by(state) |>
  summarise(n=n()) |>
  arrange(desc(n))
  
  
state_actions <- strikes_df |> 
  group_by(state) |>
  summarise(n=n())

#actions by state grouped into strikes vs protests
state_actions_dis <- strikes_df |>
  group_by(state, action_type) |>
  summarise(n=n())

#labor actions by year
table(strikes_df$year)

#table with actions by year, month, industry
actions_over_time <- strikes_df |>
  filter(industry %in% top_industries_names$industry) |>
  mutate(month_year = floor_date(as.Date(start_date), unit="month")) |>
  group_by(month_year, industry) |>
  summarise(n=n())

#plot monthly data by industry
actions_monthly_plot <- actions_over_time |>
  ggplot(aes(x=month_year, y=n, group = industry, colour = industry)) +
  geom_line(linewidth=0.6) +
  theme_minimal() +
  labs(colour="Industry") +
  labs(title="Labor Actions over time by industry", x="", y="Number of Labor Actions")

print(actions_monthly_plot)
