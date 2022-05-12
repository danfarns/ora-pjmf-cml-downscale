# Dockerfile
# docker build --network=host -t danfarns910/cml-training:1 . -f Dockerfile
# Specify an ML Runtime base image
FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-r4.1-standard:2021.12.1-b17

# Upgrade packages in the base image
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

##RUNTIME CUSTOM CONTENT START
#libgdal-dev libssl-dev proj-bin libgmp3-dev libmpfr-dev
# Install telnet in the new image
RUN apt-get update && apt-get install -y libgdal-dev libssl-dev proj-bin libgmp3-dev libmpfr-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

#install.packages("downscale", dependencies = TRUE, quiet = TRUE)
# Install the R packages we will need. 
#(also installing the dependencies ‘sys’, ‘colorspace’, ‘askpass’, ‘farver’, ‘labeling’, ‘munsell’, ‘RColorBrewer’, ‘viridisLite’, ‘triebeard’, ‘openssl’, ‘cli’, ‘crayon’, ‘utf8’, ‘fs’, ‘rappdirs’, ‘digest’, ‘glue’, ‘gtable’, ‘isoband’, ‘rlang’, ‘scales’, ‘withr’, ‘curl’, ‘urltools’, ‘httpcode’, ‘mime’, ‘httr’, ‘plyr’, ‘ellipsis’, ‘fansi’, ‘lifecycle’, ‘pillar’, ‘pkgconfig’, ‘vctrs’, ‘uuid’, ‘stringi’, ‘sass’, ‘base64enc’, ‘fastmap’, ‘Rcpp’, ‘terra’, ‘gmp’, ‘xml2’, ‘ggplot2’, ‘crul’, ‘data.table’, ‘whisker’, ‘magrittr’, ‘jsonlite’, ‘oai’, ‘tibble’, ‘lazyeval’, ‘R6’, ‘conditionz’, ‘wk’, ‘evaluate’, ‘highr’, ‘stringr’, ‘yaml’, ‘xfun’, ‘bslib’, ‘htmltools’, ‘jquerylib’, ‘tinytex’, ‘raster’, ‘cubature’, ‘minpack.lm’, ‘Rmpfr’, ‘sp’, ‘rgeos’, ‘rgdal’, ‘rgbif’, ‘knitr’, ‘rmarkdown’, ‘bookdown’)
RUN Rscript -e "install.packages('downscale', dependencies = TRUE)"
##RUNTIME CUSTOM CONTENT END

# Override Runtime label and environment variables metadata
ENV ML_RUNTIME_EDITION="ORA-PJMF-CML R4.1 - Downscale Edition" \
       	ML_RUNTIME_SHORT_VERSION="1.0" \
        ML_RUNTIME_MAINTENANCE_VERSION=1 \
        ML_RUNTIME_DESCRIPTION="This runtime includes the necessary packages for R with downscale. {Ubuntu Packages: libgdal-dev libssl-dev proj-bin libgmp3-dev libmpfr-dev}"
ENV ML_RUNTIME_FULL_VERSION="${ML_RUNTIME_SHORT_VERSION}.${ML_RUNTIME_MAINTENANCE_VERSION}"
LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION \
        com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION \
        com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION \
        com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION \
        com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION