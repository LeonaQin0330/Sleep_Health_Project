here::i_am("code/05_accuracy_comparison.R")

library(knitr)

rf_accuracy <- readRDS(
  file = here::here("output/rf_accuracy.rds")
)

svm_accuracy<- readRDS(
  file = here::here("output/svm_accuracy.rds")
)

accuracy_table <- data.frame(
  Model = c("Random Forest", "SVM"),
  Accuracy = c(rf_accuracy, svm_accuracy)
)

accuracytable <- kable(accuracy_table, caption = "Model Accuracy Comparison", format = "markdown")

saveRDS(
  accuracytable,
  file = here::here("output/accuracy_table.rds")
)