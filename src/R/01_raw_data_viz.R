# Data visualization 

# Load in the libraries
library(dplyr)
library(tidymodels)
library(ggplot2)

# Read in the dataset
raw_data<-readRDS("../../data/TSresponse_clean.RDS")

# Data has one row per ping, with the target strength at each 0.5kHz frequency between 45 and 170kHz (except 90 & 90.5). 

# convert to long format to plot
data_long<-gather(raw_data,frequency,TS,F45:F170)
data_long$frequency<-as.numeric(gsub('F','',data_long$frequency))

# Get the mean target value for each frequency across all animals
data_long <- data_long %>%
  group_by(frequency) %>%
  mutate(avg_freq = mean(TS))

#Create new column with normalized target frequencies 
data_long$diff = -(data_long$TS - data_long$avg_freq) / (data_long$TS + data_long$avg_freq)

######################
## Show each frequency spectrum (for each individual across whole dataset)
######################
ggplot(data_long)+
  geom_line(aes(x=frequency,y=TS),alpha=0.1,linewidth=0.5)+
  theme_bw()+
  ylab("Target Strength")+
  facet_wrap(~species)

# For one individual only
data_long%>%
  filter(fishNum=="LT009")%>%
  ggplot()+
  geom_line(aes(x=frequency,y=TS),alpha=0.2,linewidth=0.5)+
  theme_bw()+
  ylab("Target Strength")

data_long%>%
  filter(fishNum=="SMB010")%>%
  ggplot()+
  geom_line(aes(x=frequency,y=TS),alpha=0.2,linewidth=0.5)+
  theme_bw()+
  ylab("Target Strength")

# summarised information
data_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(TS),upper95=quantile(TS,0.975),lower95=quantile(TS,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw()+
  ylab("Target Strength")

data_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(diff),upper95=quantile(diff,0.975),lower95=quantile(diff,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw()+
  ggtitle("Normalized target strengths (avg across individuals)")
ylab("Target Strength")

# Group by fishNum and then summarize the mean for columns 52 to 302 
# (the target strength data for each frequency)
avg_data <- raw_data %>%
  group_by(fishNum, species) %>%
  summarize(across(50:299, mean, na.rm = TRUE))

# pivot to long format
avg_long<-gather(avg_data, frequency, value, F45:F170)
avg_long$frequency<-as.numeric(gsub('F','',avg_long$frequency))

# Add a column for "high" (>=116) and "low" (<116) frequencies
avg_long = avg_long %>%
  mutate(freq_lvl = ifelse(frequency < 116, "low", "high"))

# Get the mean target value for each frequency across all animals
avg_long <- avg_long %>%
  group_by(frequency) %>%
  mutate(avg_sp = mean(value))

#Create new column with normalized target frequencies 
avg_long$diff = -(avg_long$value - avg_long$avg_sp) / (avg_long$value + avg_long$avg_sp)

# Plot the average target frequencies for the "low" and "high"frequencies
avg_low_high_freq = ggplot(avg_long, aes(x = freq_lvl, y = value, fill = species)) +
  geom_boxplot(aes(fill = species))
avg_low_high_freq

# Plot the target value data for all individuals (average for each individual across all individuals)
avg_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(value),upper95=quantile(value,0.975),lower95=quantile(value,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw()+
  ylab("Target Strength")

# Plot the normalized data
avg_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(diff),upper95=quantile(diff,0.975),lower95=quantile(diff,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw()+
  ggtitle("Normalized target strengths (avg across species)") +
  ylab("Difference in Target Strength from mean")

