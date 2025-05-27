library(ggplot2)

palette <- c(
  "#E69F00", # orange
  "#56B4E9", # sky blue
  "#009E73", # bluish green
  "#F0E442", # yellow
  "#0072B2", # blue
  "#D55E00", # vermillion
  "#CC79A7", # reddish purple
  "#999999", # gray
  "#117733", # dark green
  "#88CCEE", # light blue
  "#882255"  # dark red
)


plot_state_actions_by_sector <- function(data, selected_state) {
  data %>%
    filter(selected_state == "All States" | state == selected_state) %>%
    group_by(year, sector) %>%
    summarise(n_actions = n(), .groups = "drop") %>%
    ggplot(aes(x = factor(year), y = n_actions, fill = sector)) +
    geom_col() +
    scale_fill_manual(values = rep(palette, length.out = n_distinct(data$sector))) +
    labs(title = paste("Yearly Labor Actions by Sector in", selected_state),
         x = "Year", y = "Count", fill = "Sector") + 
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(size = 20, face = "bold"),
      axis.title = element_text(size = 16),
      axis.text = element_text(size = 14),
      legend.title = element_text(size = 16),
      legend.text = element_text(size = 14))
}

plot_state_actions_by_sector(strikes_clean, "All States")
