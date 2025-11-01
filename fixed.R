library(readr)
library(ggplot2)

data <- read_tsv("/Users/kristin/repos/RLadies/Estadísticas-Climatológicas-Normales-período-1981-2010.tsv")
colnames(data) <- gsub(" ", "_", colnames(data))

# Keep only temperature rows
temp_data <- data %>%
  filter(`Valor_Medio_de` == "Temperatura (°C)")

# Convert from wide (months) to long format
temp_long <- temp_data %>%
  pivot_longer(cols = Ene:Dic, names_to = "Mes", values_to = "Temperatura") %>%
  mutate(Temperatura = as.numeric(Temperatura))

# Compute mean annual temperature per station
avg_temp_per_station <- temp_long %>%
  group_by(Estación) %>%
  summarise(Temp_promedio_anual = mean(Temperatura, na.rm = TRUE))

print(avg_temp_per_station)

# Plot
avg_temp_plot <- ggplot(avg_temp_per_station,
                        aes(x = reorder(Estación, Temp_promedio_anual),
                            y = Temp_promedio_anual)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Temperatura promedio anual por estación (1981–2010)",
    x = "Estación",
    y = "Temperatura (°C)"
  )

print(avg_temp_plot)

# Save plot
ggsave("avg_temp_plot.png", avg_temp_plot, width = 8, height = 6)