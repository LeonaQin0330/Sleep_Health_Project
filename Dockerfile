FROM rocker/r-ubuntu

RUN apt-get update && apt-get install -y \
    pandoc \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    build-essential && apt-get clean
    
RUN R -e "install.packages('renv', repos = 'https://cran.rstudio.com')"

RUN mkdir /sleephealth_project
WORKDIR /sleephealth_project

RUN mkdir code
RUN mkdir output 

COPY code code 
COPY Makefile .
COPY Sleep_Project.Rmd .

COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.json

RUN Rscript -e "renv::restore(prompt = FALSE)"

CMD make && mv report.html final_report