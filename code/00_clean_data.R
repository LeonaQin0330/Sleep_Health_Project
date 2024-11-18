here::i_am("code/00_clean_data.R")
absolute_file_location <-here::here("raw_data", "Sleep_health_and_lifestyle_dataset.csv")
sleepdata = read.csv(absolute_file_location, header = TRUE)

library(dplyr)
library(tidyr)
library(car)

# column names
colnames(sleepdata) <- gsub("\\.", "_", colnames(sleepdata))
colnames(sleepdata)

# BMI Category
sleepdata$BMI_Category <- dplyr::recode(sleepdata$BMI_Category, 
                                        "Normal Weight" = "Normal", 
                                        "Obese" = "Overweight")
# Blood Pressure
sleepdata <- sleepdata %>%
  separate(Blood_Pressure, into = c("Systolic_Pressure", "Diastolic_Pressure"), sep = "/") %>%
  mutate(across(c(Systolic_Pressure, Diastolic_Pressure), as.numeric))

saveRDS(
  sleepdata, 
  file = here::here("output/data_clean.rds") 
)
