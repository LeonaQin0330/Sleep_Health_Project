here::i_am("code/01_make_heatmap.R")

library(dplyr)
library(reshape2)
library(ggplot2)

sleepdata <- readRDS(
  file = here::here("output/data_clean.rds")
)

# Correlations between variables
numeric_columns <- sleepdata %>%
  select(-Person_ID) %>%  
  select_if(is.numeric) %>%
  cor()

# Convert the correlation matrix to a long format
correlation_data <- melt(numeric_columns)

correlation_data$Var1 <- as.character(correlation_data$Var1)
correlation_data$Var2 <- as.character(correlation_data$Var2)

correlation_data <- correlation_data %>%
  filter(Var1 >= Var2)  # Only keep lower triangle

heatmap <- ggplot(correlation_data, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "lightblue", high = "purple", mid = "white",
                       name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10), 
        axis.text.y = element_text(size = 10),
        axis.title.x = element_blank(), 
        axis.title.y = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 14)) +  # Center title
  labs(title = 'Correlation Heatmap')+
  geom_text(aes(label = ifelse(value >= 0.7 | value <= -0.7, round(value, 2), "")),  # Add correlation values
            color = "black", size = 4)

ggsave(
  here::here("output/heatmap.png"),
  plot = heatmap,
  device = "png"
)