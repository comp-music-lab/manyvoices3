library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(gridExtra)

# Set the folder path where the pitch processed files are located
folder_path <- "./JiaEtAl(MandarinAuckland)/Confirmatory analysis/data/pitch processed zero/" #Modify the path to the location where the ***pitch processed folder*** is stored on your local computer
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
  scale_fill_manual(values = c("sing" = "#FFA500", "conv" = "#4CAF50")) +  
  scale_color_manual(values = c("sing" = "#FF7F0E", "conv" = "#2E8B57")) +
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
  scale_fill_manual(values = c("sing" = "#FFA500", "conv" = "#4CAF50")) +  
  scale_color_manual(values = c("sing" = "#FF7F0E", "conv" = "#2E8B57")) +
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

# Set the folder path where the IOI files are located
folder_path2 <- "./JiaEtAl(MandarinAuckland)/Confirmatory analysis/data/IOI/" #Modify the path to the location where the ***IOI files*** are stored on your local computer
# Get the path of all csv files
file_list2 <- list.files(folder_path2, pattern = "*_IOI.csv", full.names = TRUE)
# Read all csv files and store them in a list
data_list2 <- lapply(file_list2, read.csv)
# Add file names to each data frame for easier processing
names(data_list2) <- basename(file_list2)
# Print the names of the loaded files
print(names(data_list2))
# Combine all the data
data4 <- bind_rows(data_list2)
# Set the path where the interval file is located
data5 <- data4 %>%
  dplyr::select(duration, speaker, condition) %>%
  group_by(speaker, condition) %>%
  summarise(
    mean_IOI = mean(duration, na.rm = TRUE),
    IOI_rate = 1 / mean_IOI,  
    .groups = "drop"
  ) 
head(data5)

#Plotting Temporal Rate
g2 <- ggplot(data5, aes(x = condition, y = IOI_rate, color = condition)) +
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
  scale_fill_manual(values = c("sing" = "#FFA500", "conv" = "#4CAF50")) +  
  scale_color_manual(values = c("sing" = "#FF7F0E", "conv" = "#2E8B57")) +
  guides(
    fill = "none",   
    color = guide_legend(override.aes = list(size = 3))  
  ) +
  scale_x_discrete(labels = c("sing" = "singing", "conv" = "conversation"), limits = c("sing", "conv")) +
  scale_y_continuous(breaks = seq(0, 10, by = 3), limits = c(0, 10))+
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
ggsave("./JiaEtAl(MandarinAuckland)/Confirmatory analysis/figures/combined_plot_acoustic features.png", plot = combined_plot, width = 12, height = 6) #Modify the path to the location where you want to save the images on your local computer
