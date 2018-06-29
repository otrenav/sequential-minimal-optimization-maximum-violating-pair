##
## Data preparation for forest fire classification
##
## Omar Trejo
## ITAM, 2015
##
setwd("~/Projects/itam/mmn/proyecto_2/ipm_mehrotra_dual/data/")

## Load data and column types
forest_fires <- read.csv(
    "./forest_fires/forestfires.csv",
    header=TRUE,
)

## Choose cutting point
forest_fires$ha_class <- forest_fires$area
## plot(density(forest_fires$ha_class))
## table <- table(forest_fires$ha_class)
## names(table)[table == max(table)] ## => Mode is 0

## Create classes
forest_fires[forest_fires$class == 0, c("ha_class")] <- -1
forest_fires[forest_fires$class > 0, c("ha_class")] <- 1

## Remove unnecesarry columns
removals <- c(
    "month",
    "day",
    "FFMC",
    "DMC",
    "ISI",
    "area"
)
forest_fires <- forest_fires[, !(names(forest_fires) %in% removals)]

## Reorder columns to have the class
## to be predicted as the first column
forest_fires <- forest_fires[, c(
                     "ha_class",
                     "rain",
                     "wind",
                     "RH",
                     "temp",
                     "X",
                     "Y"
                 )]

write.table(
    forest_fires,
    "forest_fires/forest_fires_clean.csv",
    row.names = FALSE,
    col.names = FALSE,
    sep=","
)
