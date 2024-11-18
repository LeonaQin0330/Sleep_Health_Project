here::i_am("code/04_predict_model.R")

library(randomForest)
library(e1071)
library(knitr)
library(kableExtra)

sleepdata <- readRDS(
  file = here::here("output/data_clean.rds")
)

## RANDOM FOREST MODEL
# Convert Sleep_Disorder to a factor
sleepdata$Sleep_Disorder <- as.factor(sleepdata$Sleep_Disorder)

# Split the dataset into training and testing sets (70% for training, 30% for testing)
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(sleepdata), 0.7 * nrow(sleepdata))
train_data <- sleepdata[train_index, ]
test_data <- sleepdata[-train_index, ]

# Build the random forest model
rf_model <- randomForest(Sleep_Disorder ~ Gender + Age + Occupation + Sleep_Duration + Stress_Level + BMI_Category + Systolic_Pressure + Diastolic_Pressure + Heart_Rate + Daily_Steps,
                         data = train_data)
# Make predictions on the test set
predictions <- predict(rf_model, newdata = test_data)

# Create a confusion matrix
confusion_matrix_RF <- table(Predicted = predictions, Actual = test_data$Sleep_Disorder)
cm_rf <- kable(confusion_matrix_RF, format = "html", caption = "Confusion Matrix for Random Forest Model") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"), full_width = FALSE, position = "center")


# Calculate accuracy
rf_accuracy <- sum(predictions == test_data$Sleep_Disorder) / nrow(test_data)
cat("Prediction Accuracy (Random Forest):", rf_accuracy, "\n")



## SVM MODEL
# Build the SVM model
svm_model <- svm(Sleep_Disorder ~ Gender + Age + Occupation + Sleep_Duration + Stress_Level + 
                   BMI_Category + Systolic_Pressure + Diastolic_Pressure + Heart_Rate + Daily_Steps,
                 data = train_data, kernel = "linear")
print(svm_model)

# Make predictions on the test set
predictions <- predict(svm_model, newdata = test_data)
svm_accuracy <- sum(predictions == test_data$Sleep_Disorder) / nrow(test_data)
confusion_matrix_SVM <- table(Predicted = predictions, Actual = test_data$Sleep_Disorder)
cm_svm <- kable(confusion_matrix_SVM, caption = "Confusion Matrix for SVM model") %>%
  kable_styling(full_width = FALSE, position = "center")

# Print the accuracy
cat("Prediction Accuracy (SVM):", svm_accuracy, "\n")



both_models <- list(
  primary = rf_model,
  secondary = svm_model
)
saveRDS(
  both_models,
  file = here::here("output/rf_and_svm_models.rds")
)


both_confusion_matrix <- list(
  primary = cm_rf,
  secondary = cm_svm
)
saveRDS(
  both_confusion_matrix,
  file = here::here("output/rf_and_svm_confusion_matrix.rds")
)


saveRDS(
  rf_accuracy,
  file = here::here("output/rf_accuracy.rds")
)

saveRDS(
  svm_accuracy,
  file = here::here("output/svm_accuracy.rds")
)


