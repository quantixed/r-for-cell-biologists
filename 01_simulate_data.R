# This script will simulate some microscopy analysis data and
# format it so that it resembles the ImageJ measurement window
# i.e. the typical output from a cell biology experiment

## variables ----
set.seed(123)
filerows <- 20
files <- 10

## functions ----
generate_df <- function (area = 1248, meas = 100, rows = filerows) {
  df <- data.frame(
    Area = rep(area, rows),
    Mean = rnorm(rows, mean = meas, sd = meas/5),
    StdDev = rnorm(rows, mean = meas/5, sd = 2),
    Min = rep(0, rows),
    Max = rep(255, rows)
  )
  df$IntDen <- floor(df$Mean * df$Area)
  df$RawIntDen <- floor(df$Mean * df$Area)
  return(df)
}

make_csv <- function (files = files, fname = "file", measure = 100) {
  for (i in 1:files) {
    df <- generate_df(meas = measure)
    write.csv(df, file = paste0("Output/Data/", fname, "_", i, ".csv"))
  }
}

## generate data ---
# we will make 10 files for each of the control and rapamycin treated groups
# each file will have 20 rows of data (cells)
# the mean intensity will be different for each group
# we will make four sets that mimic four experimental repeats
# n4 is simulated to be an experiment where the treatment didn't work well
make_csv(files = files, fname = "control_n1", measure = 55)
make_csv(files = files, fname = "control_n2", measure = 52)
make_csv(files = files, fname = "control_n3", measure = 48)
make_csv(files = files, fname = "control_n4", measure = 50)
make_csv(files = files, fname = "rapa_n1", measure = 192)
make_csv(files = files, fname = "rapa_n2", measure = 202)
make_csv(files = files, fname = "rapa_n3", measure = 180)
make_csv(files = files, fname = "rapa_n4", measure = 75)