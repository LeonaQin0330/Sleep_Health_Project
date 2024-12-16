# report-associated rules
Sleep_Project.html:code/06_render_report.R \
  Sleep_Project.Rmd descriptive_analysis output/logistic_table.rds predictive_analysis output/accuracy_table.rds
	Rscript code/06_render_report.R

output/data_clean.rds: code/00_clean_data.R raw_data/Sleep_health_and_lifestyle_dataset.csv	
	Rscript code/00_clean_data.R
	
output/heatmap.png: code/01_make_heatmap.R output/data_clean.rds
	Rscript code/01_make_heatmap.R

output/piechart.png: code/02_make_piechart.R output/data_clean.rds
	Rscript code/02_make_piechart.R
	
.PHONY: descriptive_analysis
descriptive_analysis: output/data_clean.rds output/heatmap.png output/piechart.png

output/logistic_table.rds: code/03_logistic_regression.R output/data_clean.rds
	Rscript code/03_logistic_regression.R
	
output/rf_and_svm_models.rds output/rf_and_svm_confusion_matrix.rds output/rf_accuracy output/svm_accuracy &: \
  code/04_predict_model.R output/data_clean.rds
	Rscript code/04_predict_model.R
	
.PHONY: predictive_analysis
predictive_analysis: output/rf_and_svm_models.rds output/rf_and_svm_confusion_matrix.rds \
  output/rf_accuracy output/svm_accuracy
  
output/accuracy_table.rds: code/05_accuracy_comparison.R output/rf_accuracy.rds output/svm_accuracy.rds
	Rscript code/05_accuracy_comparison.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f output/*.png && rm -f *.html

.PHONY: install	
install:
	Rscript -e "renv::restore(prompt = FALSE)"
	
# docker-associated rules
PROJECTFILES = Sleep_Project.Rmd code/00_clean_data.R code/01_make_heatmap.R code/02_make_piechart.R code/03_logistic_regression.R code/04_predict_model.R code/05_accuracy_comparison.R code/06_render_report.R Makefile
RENVFILES = renv.lock renv/activate.R renv/settings.json


final_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t final_image .
	touch $@

report/Sleep_Project.html_mac: final_image
	docker run -v "$$(pwd)/report":/sleephealth_project/report final_image
	
report/Sleep_Project.html_win: final_image
	docker run -v /"$$(pwd)/report":/sleephealth_project/report final_image

