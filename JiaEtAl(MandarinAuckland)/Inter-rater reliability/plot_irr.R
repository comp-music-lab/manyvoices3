library(irr)
library(ggplot2)

# change
ANNOTATIONDIR_JIA <- "/Users/betty/Desktop/Rater/Jia/"
ANNOTATIONDIR_SAVAGE <- "/Users/betty/Desktop/Rater/Savage/"
# change
DATAID <- c('p19')
TITLE <- c(conv = "Conversation", sing = "Singing")
TYPE <- c('conv', 'sing')
#change
PLOTNAME <- c(Jia = "Jia", Savage = "Savage")

#change
OUTPUTDIR <- "/Users/betty/Desktop/Rater/"


icc_result <- data.frame()
df_dlt <- data.frame()


for (i in 1:length(DATAID)) {
  for (j in 1:length(TYPE)) {
    ## ICC
    df <- read.csv(paste(ANNOTATIONDIR_JIA, DATAID[i], "_", TYPE[j], ".csv", sep = ""), header = TRUE)
    X <- df$start
    # change
    df <- read.csv(paste(ANNOTATIONDIR_SAVAGE, DATAID[i], "_", TYPE[j], ".csv", sep = ""), header = TRUE)
    Y <- df$start
    
    len <- min(length(X), length(Y))
    X <- X[1:len]
    Y <- Y[1:len]
    
  
    result <- icc(data.frame(onset_1 = X, onset_2 = Y), mode = "twoway", type = "agreement", unit = "single")
    std_diff <- sqrt(var(X - Y)*(length(X) - 1)/length(X))
    mu_diff <- mean(abs(X - Y))
    
    icc_result <- rbind(icc_result,
                        data.frame(dataid = DATAID[i], type = TYPE[j], icc = result$value, pvalue = result$p.value,
                                   N = result$subjects, mu_dlt = mu_diff, sgm_dlt = std_diff))
    cat(">>>", DATAID[i], TYPE[j], "length(X) =", length(X), "length(Y) =", length(Y), "\n")
    
    ## plot data
    df_dlt <- rbind(df_dlt, data.frame(dlt = X - Y, type = TYPE[j], dataid = PLOTNAME[i]))
  }
}


## Save icc results
print(icc_result)
#change
write.table(icc_result, file = paste(OUTPUTDIR, "icc_JIA_SAVAGE.csv", sep = ""), row.names = FALSE, sep = ",")


YL <- c(min(df_dlt$dlt), max(df_dlt$dlt))

# change "Savage" as your name
g <- ggplot(df_dlt, aes(x = dataid, y = dlt)) +
  geom_violin(aes(group = dataid), draw_quantiles = 0.5) +
  geom_point(aes(color = dataid)) +
  scale_color_manual(values = c("Jia" = "#1f77b4", "Savage" = "#ff7f0e")) +
  xlab("Collaborator") +
  ylab("Onset difference [sec.]\n(diff = JIA - SAVAGE)") +
  ggtitle("Onset Difference between Jia and Savage") +
  theme_gray() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) +
  ylim(YL) +
  theme(legend.position = "none")+
  facet_wrap(~ type, ncol = 2, scales = "fixed")

  ggsave(file = paste0(OUTPUTDIR, "onsetdiff_js_combined.png"),
       plot = g, width = 8, height = 4)


print(paste("90% quantile of dur time diff (conv):", quantile(df_dlt$dlt[df_dlt$type == "conv"], prob = 0.9)))
print(paste("90% quantile of dur time diff (sing):", quantile(df_dlt$dlt[df_dlt$type == "sing"], prob = 0.9)))