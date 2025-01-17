temp <- read.csv("Data/control_n1_1.csv")
View(temp)
rm(temp)

list.files("Data")
filelist <- list.files("Data")
filelist <- list.files("Data", full.names = TRUE)
# load all files and rbind into big dataframe
df <- do.call(rbind, lapply(filelist, read.csv))
View(df)
# load all files and rbind into big dataframe, add a column to each file to identify the file
df <- do.call(rbind, lapply(filelist, function(x) {temp <- read.csv(x); temp$file <- x; temp}))
df <- do.call(rbind, lapply(filelist, function(x) {temp <- read.csv(x); temp$file <- basename(x); temp}))
# file column has name of the file, name is of the form foo_bar_1.csv, extract foo and bar into two columns
df$cond <- sapply(strsplit(df$file, "_"), "[", 1)
df$expt <- sapply(strsplit(df$file, "_"), "[", 2)

## Graphing ----

library(ggplot2)

ggplot(df, aes(x = Mean, fill = cond)) + geom_histogram()
ggplot(df, aes(x = Mean, fill = cond)) + geom_density(alpha = 0.5)
ggplot(df, aes(x = Mean, fill = cond)) + geom_density(alpha = 0.5) + facet_wrap(~expt)
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

## Analysis ----

# t-test
t.test(summary_df$Mean ~ summary_df$cond)
