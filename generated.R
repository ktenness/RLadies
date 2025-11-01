library(readtsv)
library(ggplot2)

data <- readtsv("/Users/kristin/repos/RLadies/Estadísticas-Climatológicas-Normales-período-1981-2010.tsv", sep = "\t")

colnames(data) <- gsub(" ", "_", colnames(data))

avg_temp_per_station <- aggregate(Temperatura_°C ~ Estación, data, mean)

ggplot(avg_temp_per_station, aes(x = Estación, y = Temperatura_°C)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Annual Temperature per Station", x = "Station", y = "Temperature (°C)") ->
avg_temp_plot
ggsave("avg_temp_plot.png", plot = avg_temp_plot)