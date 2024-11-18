here::i_am("code/03_logistic_regression.R")

library(dplyr)
library(knitr)
library(kableExtra)

sleepdata <- readRDS(
  file = here::here("output/data_clean.rds")
)

sleepdata$Sleep_Disorder_Status <- ifelse(sleepdata$Sleep_Disorder == "None", 0, 1)

# Create a list of predictor variables
predictor_vars <- c("Gender", "Age", "Stress_Level", "BMI_Category", 
                    "Systolic_Pressure", "Diastolic_Pressure", 
                    "Heart_Rate", "Daily_Steps")

# Initialize an empty data frame to store results
results_df <- data.frame(Variable = character(),
                         Estimate = numeric(),
                         Z_value = numeric(),
                         P_value = numeric(),
                         Significant = character(),
                         stringsAsFactors = FALSE)

# Loop through each predictor variable and fit a logistic regression model
for (var in predictor_vars) {
  formula <- as.formula(paste("Sleep_Disorder_Status ~", var))
  model <- glm(formula, data = sleepdata, family = binomial)
  
  model_summary <- summary(model)
  
  # Get the coefficient (Estimate), z-value, and p-value
  estimate <- model_summary$coefficients[2, "Estimate"]
  z_value <- model_summary$coefficients[2, "z value"]
  p_value <- model_summary$coefficients[2, "Pr(>|z|)"]
  
  # Format p-value
  p_value_formatted <- ifelse(p_value < 0.001, "<0.001", round(p_value, 3))
  
  # Determine if the variable is significant
  significant <- ifelse(p_value < 0.001, "Yes", "No")
  
  results_df <- rbind(results_df, data.frame(Variable = var, 
                                             Estimate = estimate, 
                                             Z_value = z_value, 
                                             P_value = p_value_formatted,
                                             Significant = significant))
}

logtable <- 
results_df %>%
  kable("html", caption = "Univariate Logistic Regression Results") %>%
  kable_styling(full_width = FALSE, position = "center")

saveRDS(
  logtable, 
  file = here::here("output/logistic_table.rds") 
)
