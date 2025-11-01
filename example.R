library(readr)
library(dplyr)
library(tidyr)

file_path <- "~/repos/RLadies/Estadísticas-Climatológicas-Normales-período-1981-2010.tsv"

# Read TSV without guessing column names
raw_data <- read_tsv(file_path, col_names = FALSE)

# First row contains headers
headers <- as.character(unlist(raw_data[1, ]))
climate_data <- raw_data[-1, ]
colnames(climate_data) <- headers

# Pivot months to long format
long_data <- climate_data %>%
  pivot_longer(
    cols = Ene:Dic,
    names_to = "Mes",
    values_to = "Valor"
  ) %>%
  mutate(Valor = as.numeric(Valor))  # convert month values to numeric

# Filter for max temperature only
tmax_data <- long_data %>%
  filter(`Valor Medio de` == "Temperatura máxima (°C)") %>%
  group_by(Estación) %>%
  summarize(TMAX_mean = mean(Valor, na.rm = TRUE))

print(tmax_data,n=100)

# Barilcohe is cold!
# Antarctica (Base *) is colder!