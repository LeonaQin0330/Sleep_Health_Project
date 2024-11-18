Descriptions of the sleep project
================
Haowen Qin

`code/00_clean_data.R`

- read raw data from `raw_data/` folder
- save clean data as `.rds` in `output/` folder

`code/01_make_heatmap.R`

- read clean data (data_clean.rds) from `output/` folder
- save heatmap as `.png` in `output/` folder

`code/02_make_piechart.R`

- read clean data (data_clean.rds) from `output/` folder
- save piechart as `.png` in `output/` folder

`code/03_logistic_regression.R`

- read clean data (data_clean.rds) from `output/` folder
- save the results of logistic regression as `.rds` in `output/` folder

`code/04_predict_model.R`

- read clean data (data_clean.rds) from `output/` folder
- save two models as `.rds` in `output/` folder
- save the confusion matrix of two models as `.rds` in `output/` folder
- save the accuracy of two models as `.rds` in `output/` folder

`code/05_accuracy_comparison.R`

- read the accuracy of two models from `output/` folder
- save the table of accuracy comparison as `.rds` in `output/` folder

`code/06_render_report.R`

- render `Sleep_Project.Rmd` 
- save compiled report

`Sleep_Project.Rmd`

- this is the code file of final report for this project
- read data, table, figures, and analysis results from respective locations
- display results for production report

`Makefile`

- contains rules for building the final report
- `make Sleep_Project.html` will render the whole report
- `make output/data_clean.rds` will save the cleaned data in `output/` folder
- `make output/heatmap.png` will generate a heat map figure of all independent variables to compile the report
- `make output/piechart.png` will generate a pie chart of target variable to compile the report
- `make descriptive_analysis` will generate the results of descriptive analysis (including data_clean.rds, heatmap.png and piechart.png) to compile the report
- `make output/logistic_table.rds` will generate the results of the univariate logistic regression to compile the report
- `make output/rf_and_svm_models.rds` or `make output/rf_and_svm_confusion_matrix.rds` or `make output/rf_accuracy` or `make output/svm_accuracy` will generate the results of two predictive models (Random Forest and SVM model) to compile the report
- `make predictive_analysis` will generate the results of two predictive models (including rf_and_svm_models.rds, rf_and_svm_confusion_matrix.rds, rf_accuracy output, and svm_accuracy) to compile the report
- `make output/accuracy_table.rds` will generate the accuracy comparison table to compile the report
- `make clean` will remove all generated files, including `.rds`, `.png` and `.html` files
