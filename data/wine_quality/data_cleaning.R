##
## Data preparation for wine classification
##
## Omar Trejo
## ITAM, 2015
##
setwd("~/Projects/itam/mmn/proyecto_2/ipm_mehrotra_dual/data/")

## Load data and column types
white_wines <- read.table("wine_quality/winequality-white.csv",
                          colClasses=rep("numeric", 12),
                          header=TRUE,
                          sep=";")

white_wines$quality_class <- white_wines$quality

## Create classes
white_wines[white_wines$quality_class < 6, c("quality_class")] <- -1
white_wines[white_wines$quality_class >= 6, c("quality_class")] <- 1

## Remove quality column
white_wines <- white_wines[, !(names(white_wines) %in% c("quality"))]

## Reorder columns to have the class
## to be predicted as the first column
white_wines <- white_wines[, c(
    "quality_class",
    "pH",
    "free.sulfur.dioxide",
    "citric.acid",
    "alcohol",
    "density",
    "chlorides",
    "volatile.acidity",
    "sulphates",
    "total.sulfur.dioxide",
    "residual.sugar",
    "fixed.acidity"
)]

write.table(
    white_wines,
    "wine_quality/white_wines_quality_clean.csv",
    row.names = FALSE,
    col.names = FALSE,
    sep=","
)
