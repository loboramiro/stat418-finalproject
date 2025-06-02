FROM rstudio/plumber

RUN R -e "install.packages(c('randomForest', 'dplyr'))"

COPY . /app
WORKDIR /app

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=8000)"]
