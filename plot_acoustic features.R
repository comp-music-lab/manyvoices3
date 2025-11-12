library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(gridExtra)

# Set the folder path where the pitch processed files are located
folder_path <- "/Users/betty/Desktop/manyvoices3_pilot/pitch processed/" 
# Get the path of all csv files
file_list <- list.files(folder_path, pattern = "*.csv", full.names = TRUE)
# Read all csv files and store them in a list
data_list <- lapply(file_list, read.csv)
# Add file names to each data frame for easier processing
names(data_list) <- basename(file_list)
# Print the names of the loaded files
print(names(data_list))
# Combine all the data
data1 <- bind_rows(data_list)

# Only keep f0, speaker, condition
data2 <- data1 %>%
  select(f0, speaker, condition, gender) %>%
  group_by(speaker, condition, gender) %>%
  summarise(mean_f0 = mean(f0, na.rm = TRUE), .groups = "drop") %>%
  mutate(f0_cent = 1200 * log2(mean_f0 / 440))  
head(data2)

#Plotting Pitch Height
g1 <- ggplot(data2, aes(x = condition, y = f0_cent, color = condition)) +
  geom_violin(aes(fill = condition), trim = FALSE, alpha = 0.4, draw_quantiles = 0.5, size = 1.2) +
  # Add lines between the same speaker
  geom_line(aes(group = speaker), color = "#0073C2", linetype = "dotdash", alpha = 0.8, size = 1) +
  # Add points
  geom_point(color = "#0073C2", size = 2, na.rm = TRUE) +
  theme_minimal() +
  labs(
    title = "Pitch Height",
    x = "Condition",
    y = "Mean f0 (cent)",
    fill = "Condition",
    color = "Condition"
  ) +
  scale_fill_manual(values = c("sing" = "#FBEDE3", "conv" = "#EFF7E8")) +
  scale_color_manual(values = c("sing" = "#EF7F29", "conv" = "#198E5C")) + 
  guides(
    fill = "none",  
    color = guide_legend(override.aes = list(size = 3))  
  ) +
  scale_x_discrete(labels = c("sing" = "singing", "conv" = "conversation"), limits = c("sing", "conv")) +
  theme(
    plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 8),
    axis.title = element_text(size = 9)
  ) 
show(g1)

# Plotting Pitch Stability
data3 <- data1 %>%
  select(f0stab, speaker, condition, gender) %>%
  group_by(speaker, condition, gender) %>%
  summarise(mean_f0stab = mean(f0stab, na.rm = TRUE), .groups = "drop") 
head(data3)

g3 <- ggplot(data3, aes(x = condition, y = mean_f0stab, color = condition)) +
  geom_violin(aes(fill = condition), trim = FALSE, alpha = 0.4, draw_quantiles = 0.5, size = 1.2) +
  geom_line(aes(group = speaker), color = "#0073C2", linetype = "dotdash", alpha = 0.8, size = 1) +
  geom_point(color = "#0073C2", size = 2, na.rm = TRUE) +
  theme_minimal() +
  labs(
    title = "Pitch Stability",
    x = "Condition",
    y = "Mean -|Δf0| (cents/s)",
    fill = "Condition",
    color = "Condition"
  ) +
  scale_fill_manual(values = c("sing" = "#FBEDE3", "conv" = "#EFF7E8")) +
  scale_color_manual(values = c("sing" = "#EF7F29", "conv" = "#198E5C")) + 
  guides(
    fill = "none",   
    color = guide_legend(override.aes = list(size = 3))  
  ) +
  scale_x_discrete(labels = c("sing" = "singing", "conv" = "conversation"), limits = c("sing", "conv")) +
  theme(
    plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 8),
    axis.title = element_text(size = 9)
  ) 
show(g3)

# Set the path where the interval file is located
data4 <- read.csv("//Users/betty/Desktop/manyvoices3_pilot/All_Speakers_IOI.csv")
data5 <- data4 %>%
  select(duration, speaker, condition) %>%
  group_by(speaker, condition) %>%
  #  summarise(mean_ISI = mean(duration, na.rm = TRUE), .groups = "drop") 
  summarise(
    mean_ISI = mean(duration, na.rm = TRUE),
    ISI_rate = 1 / mean_ISI,  
    .groups = "drop"
  ) 
head(data5)

#Plotting Temporal Rate
g2 <- ggplot(data5, aes(x = condition, y = ISI_rate, color = condition)) +
  geom_violin(aes(fill = condition), trim = FALSE, alpha = 0.4, draw_quantiles = 0.5, size = 1.2) +
  geom_line(aes(group = speaker), color = "#0073C2", linetype = "dotdash", alpha = 0.8, size = 1) +
  geom_point(color = "#0073C2", size = 2, na.rm = TRUE) +
  theme_minimal() +
  labs(
    title = "Temporal rate",
    x = "Condition",
    y = "Mean IOI rate (Hz)",
    fill = "Condition",
    color = "Condition"
  ) +
  scale_fill_manual(values = c("sing" = "#FBEDE3", "conv" = "#EFF7E8")) +
  scale_color_manual(values = c("sing" = "#EF7F29", "conv" = "#198E5C")) + 
  guides(
    fill = "none",   
    color = guide_legend(override.aes = list(size = 3))  
  ) +
  scale_x_discrete(labels = c("sing" = "singing", "conv" = "conversation"), limits = c("sing", "conv")) +
  theme(
    plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 8),
    axis.title = element_text(size = 9)
  )
show(g2)


# Combine the three graphs as one and save it
title_theme <- theme(
  plot.title = element_text(hjust = 0.5, face = "bold") 
)
g1 <- g1 + theme_grey() + title_theme
g2 <- g2 + theme_grey() + title_theme
g3 <- g3 + theme_grey() + title_theme

combined_plot <- grid.arrange(g1 + theme(legend.position = "none"), g2 + theme(legend.position = "none"), g3 + theme(legend.position = "none"), ncol=3, widths = c(0.7, 0.65, 0.7))
ggsave("/Users/betty/Desktop/manyvoices3_pilot/combined_plot_acoustic features.png", plot = combined_plot, width = 12, height = 6)
