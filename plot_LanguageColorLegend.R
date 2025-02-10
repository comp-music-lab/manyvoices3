###
library(ggplot2)
library(ggpubr)

###
LANGCOLORMAP <- read.csv("./data/LangColorMap.csv")
LANGCOLORMAP$rgb <- paste("#", LANGCOLORMAP$rgb, sep = "")

### Language
info <- read.csv('./data/CollaboratorsPlotData.csv')
df_dummy = data.frame(x = 0, y = 0, lang = unique(info$ProvidedLanguageName))

df_dummy$lang[df_dummy$lang == "Amamidialect"] <- "Amami"
df_dummy$lang[df_dummy$lang == "DutchFlemish"] <- "Flemish (Dutch)"
LANGCOLORMAP$lang_filename[LANGCOLORMAP$lang_filename == "Amamidialect"] <- "Amami"
LANGCOLORMAP$lang_filename[LANGCOLORMAP$lang_filename == "DutchFlemish"] <- "Flemish (Dutch)"

g <- ggplot(data = df_dummy, aes(x = x, y = y)) +
  geom_point(aes(fill = lang), position = position_jitter(width = 1, height = 1), pch = 21) +
  scale_fill_manual(values = LANGCOLORMAP$rgb, breaks = LANGCOLORMAP$lang_filename) + 
  guides(fill = guide_legend("Language", ncol = 8))

l <- as_ggplot(get_legend(g))

ggsave(file = paste(OUTPUTDIR, "LanguageColors_legend.png", sep = ""), plot = l, width = 10, height = 5)

### Language family
df_dummy$langfamily <- ""
for (i in 1:nrow(df_dummy)) {
  df_dummy$langfamily[i] <- LANGCOLORMAP$family[LANGCOLORMAP$lang_filename == df_dummy$lang[i]]
}

LANGCOLORMAP_family <- unique(subset(LANGCOLORMAP, , c("family", "rgb")))

g <- ggplot(data = df_dummy, aes(x = x, y = y)) +
  geom_point(aes(fill = langfamily), position = position_jitter(width = 1, height = 1), pch = 21) +
  scale_fill_manual(values = LANGCOLORMAP_family$rgb, breaks = LANGCOLORMAP_family$family) + 
  guides(fill = guide_legend("Language family", ncol = 8))

l <- as_ggplot(get_legend(g))

ggsave(file = paste(OUTPUTDIR, "LanguageFamilyColors_legend.png", sep = ""), plot = l, width = 10, height = 5)