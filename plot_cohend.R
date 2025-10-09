library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(gridExtra)

effectsize_f0 <- read_csv("./f0_cohend_results.csv") %>%
  mutate(Feature = "Pitch Height")
effectsize_f0stab <- read_csv("./f0stab_cohend_results.csv") %>%
  mutate(Feature = "Pitch Stability")
effectsize_IOI <- read_csv("./IOI_cohend_results.csv") %>%
  mutate(Feature = "IOI Rate")

combined_data <- bind_rows(effectsize_f0, effectsize_f0stab, effectsize_IOI)
cohen_data <- combined_data %>%
  select(Feature, Cohens_d)
print(cohen_data)

CI_f0 <- read_csv("./f0_extra_results.csv") %>%
  mutate(Feature = "Pitch Height")
CI_f0stab <- read_csv("./f0stab_extra_results.csv") %>%
  mutate(Feature = "Pitch Stability")
CI_IOI <- read_csv("./IOI_extra_results.csv") %>%
  mutate(Feature = "IOI Rate")

combined_data2 <- bind_rows(CI_f0, CI_f0stab, CI_IOI)
CI_data <- combined_data2 %>%
  select(Feature, CI_lower, CI_upper, mu_hat)
CI_data$CI_lower <- sqrt(2) * qnorm(CI_data$CI_lower, 0, 1)
CI_data$CI_upper <- sqrt(2) * qnorm(CI_data$CI_upper, 0, 1)
CI_data$mu_hat <- sqrt(2) * qnorm(CI_data$mu_hat, 0, 1)
print(CI_data)

g <- ggplot(cohen_data, aes(x = Cohens_d, y = Feature, fill = Feature)) +
  geom_violin(fill = "#FCAE1E", alpha = 0.3, width = 0.8) +  
  geom_jitter(aes(fill = Feature), shape = 21, alpha = 0.8, size = 2, stroke = 0.5, height = 0.1) + # 添加抖动点
  geom_vline(xintercept = 0, linetype = 2) +  
  theme_grey() +
  labs(x = "Translated Cohen's D", title = "Alternating Singing Vs. Conversation") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),  
        axis.title.y = element_blank(), 
        axis.text.y = element_text(size = 10, hjust = 0.5),   
        axis.title.x = element_text(size = 12)  
  ) +
  scale_y_discrete(
    labels = c(
      "Pitch Height" = "Pitch Height\n (f0)", 
      "IOI Rate" = "Temporal Rate\n (IOI Rate)", 
      "Pitch Stability" = "Pitch Stability\n (-|Δf0|)"
    ),  
    limits = c("Pitch Stability", "IOI Rate", "Pitch Height")) 

g <- g +
  geom_segment(data = CI_data, aes(x = CI_lower, xend = mu_hat, y = Feature, yend = Feature), position = position_nudge(y = 0.25), show.legend = FALSE) +
  geom_point(data = CI_data, aes(x = CI_lower, y = Feature), shape = "|", size = 4, position = position_nudge(y = 0.25), show.legend = FALSE) +
  geom_point(data = CI_data, aes(x = mu_hat, y = Feature), shape = 23, size = 3, fill = "#d7003a", position = position_nudge(y = 0.25), show.legend = FALSE)

print(g)
