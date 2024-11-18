here::i_am("code/02_make_piechart.R")

library(ggplot2)
library(scales)

sleepdata <- readRDS(
  file = here::here("output/data_clean.rds")
)

# Create a frequency table for Sleep_Disorder
sleep_disorder_counts <- table(sleepdata$Sleep_Disorder)

# Convert the table to a data frame for plotting
sleep_disorder_df <- as.data.frame(sleep_disorder_counts)
colnames(sleep_disorder_df) <- c("Sleep_Disorder", "Count")

# Create a pie chart
piechart <-
ggplot(sleep_disorder_df, aes(x = "", y = Count, fill = Sleep_Disorder)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  
  geom_text(aes(label = paste0(percent(Count / sum(Count)))),  # Only percentage
            position = position_stack(vjust = 0.5), color = "white") +
  
  scale_fill_manual(values = c("#6A0DAD", "#9B30FF", "#DDA0DD")) +
  
  labs(title = "Distribution of Sleep Disorders",
       fill = "Sleep Disorder") +
  
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

ggsave(
  here::here("output/piechart.png"),
  plot = piechart,
  device = "png"
)