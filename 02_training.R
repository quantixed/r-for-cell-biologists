# we will use this script to learn how to use R

# Typically, we would analyse data in ImageJ and then analyse the outputs in R
# for calculations and visualisation.
# The R project stage can be divided into three parts:
# (0. Setup RStudio project)
# 1. Load data
# 2. Calculations
# 3. Visualisation

## 0. Setup RStudio project ----
## Setup preferred directory structure in wd
ifelse(!dir.exists("Data"), dir.create("Data"), "Folder exists already")
ifelse(!dir.exists("Output"), dir.create("Output"), "Folder exists already")
ifelse(!dir.exists("Output/Data"), dir.create("Output/Data"), "Folder exists already")
ifelse(!dir.exists("Output/Plots"), dir.create("Output/Plots"), "Folder exists already")
ifelse(!dir.exists("Script"), dir.create("Script"), "Folder exists already")

## 1. Load data ----
# read one csv file into R as an object called temp
temp <- read.csv("Data/control_n1_1.csv")
# have a look at it
View(temp)
# remove the object
rm(temp)

# we want to load all files, so we need to get a list of all files
list.files("Data")
# assign this list as an object
filelist <- list.files("Data")
# use the path to the file
filelist <- list.files("Data", full.names = TRUE)

# load all files and rbind into big dataframe
df <- do.call(rbind, lapply(filelist, read.csv))
View(df)
# load all files and rbind into big dataframe, add a column to each file to identify each file
df <- do.call(rbind, lapply(filelist, function(x) {temp <- read.csv(x); temp$file <- x; temp}))
# this can be written on multiple lines
df <- do.call(rbind, lapply(filelist, function(x) {
  temp <- read.csv(x)
  temp$file <- x
  temp
}))
# this is close to what we want but remember that we used full paths to load the files, we only want the file name
# we can use the basename function to extract the file name
df <- do.call(rbind, lapply(filelist, function(x) {
  temp <- read.csv(x);
  temp$file <- basename(x);
  temp
}))
# file column has name of the file, name is of the form foo_bar_1.csv, extract foo and bar into two columns
df$cond <- sapply(strsplit(df$file, "_"), "[", 1)
df$expt <- sapply(strsplit(df$file, "_"), "[", 2)
# explain why the above works
# strsplit(df$file, "_") returns a list of vectors, each vector is the result of splitting the string by "_"
# we can extract the first element of each vector using "[", 1
# we can extract the second element of each vector using "[", 2
# sapply applies the function to each element of the list
# what does "[" do? it extracts elements from a vector
# what does "[[" do? it extracts elements from a list

## 2. Calculations ----
# normalise the data in the Mean column - just as an example
df$MeanNorm <- df$Mean / max(df$Mean)
# standardise the data in the Mean column - just as an example
df$MeanStand <- (df$Mean - mean(df$Mean)) / sd(df$Mean)

# since we have messed things up a bit, we can remake the df easily
# run the top part again to remake the df and then save the output
filelist <- list.files("Data", full.names = TRUE)
df <- do.call(rbind, lapply(filelist, function(x) {
  temp <- read.csv(x);
  temp$file <- basename(x);
  temp
}))
df$cond <- sapply(strsplit(df$file, "_"), "[", 1)
df$expt <- sapply(strsplit(df$file, "_"), "[", 2)
# write data to file
write.csv(df, "Output/Data/df.csv")

## 3. Visualisation ----
# we will use ggplot2 for visualisation
# note that library loading usually goes at the top of the script!
library(ggplot2)

# histogram to look at the data
ggplot(df, aes(x = Mean, fill = cond)) + geom_histogram()
# density plot to look at the data
ggplot(df, aes(x = Mean, fill = cond)) + geom_density(alpha = 0.5)
# facetting, make plots by expt
ggplot(df, aes(x = Mean, fill = cond)) + geom_density(alpha = 0.5) + facet_wrap(~expt)
# themes
ggplot(df, aes(x = Mean, fill = cond)) + geom_density(alpha = 0.5) + facet_wrap(~expt) + theme_minimal()
ggplot(df, aes(x = Mean, fill = cond)) + geom_density(alpha = 0.5) + facet_wrap(~expt) + theme_bw()

# superplot
ggplot(df, aes(x = cond, y = Mean, colour = expt)) + geom_jitter()
library(ggforce)
ggplot(df, aes(x = cond, y = Mean, colour = expt)) + geom_sina()
ggplot(df, aes(x = cond, y = Mean, colour = expt)) + geom_sina(position = "auto")
# calculate experiment means
summary_df <- aggregate(Mean ~ cond + expt, data = df, FUN = mean)
# add to plot
ggplot(df, aes(x = cond, y = Mean, colour = expt)) +
  geom_sina(position = "auto", alpha = 0.5) +
  geom_point(data = summary_df, aes(x = cond, y = Mean, colour = expt), shape = 15, size = 3)
# keep adding to this or
p <- ggplot(df, aes(x = cond, y = Mean, colour = expt)) +
  geom_sina(position = "auto", alpha = 0.5) +
  geom_point(data = summary_df, aes(x = cond, y = Mean, colour = expt), shape = 15, size = 3)
p + theme_minimal()
p + theme_bw()
p + theme_bw() +
  scale_color_manual(values = c("#4477aa", "#ccbb44", "#ee6677","#228833"))

# save plot
ggplot(df, aes(x = cond, y = Mean, colour = expt)) +
  geom_sina(position = "auto", alpha = 0.5, maxwidth = 0.2) +
  geom_point(data = summary_df, aes(x = cond, y = Mean, colour = expt), shape = 15, size = 3) +
  scale_color_manual(values = c("#4477aa", "#ccbb44", "#ee6677","#228833")) +
  labs(x = "", y = "Mitochondria Fluorescence (A.U.)") +
  theme_bw(10) +
  theme(legend.position = "none")
ggsave("Output/Plots/output.png", width = 6, height = 4, dpi = 300)
# this is an easy way

# stats
# t-test
t.test(summary_df$Mean ~ summary_df$cond)
