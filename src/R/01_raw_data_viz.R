# Data visualization 

# Load in the libraries
library(dplyr)
library(tidymodels)
library(ggplot2)

# Read in the dataset
raw_data<-readRDS("data/TSresponse_clean.RDS")

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
all_freq_response_curves = ggplot(data_long)+
  geom_line(aes(x=frequency,y=TS),alpha=0.1,linewidth=0.5)+
  theme_bw()+
  ylab("Target Strength")+
  ggtitle("Frequency response curves for each ping") +
  xlab("Frequency (kHz)") +
  facet_wrap(~species)

ggsave("figs/01_raw_data_viz/all_freq_response_curves.png", all_freq_response_curves, width = 6, height = 4, dpi = 300)

# For one individual only
single_LT_freq_response_curve = data_long%>%
  filter(fishNum=="LT009")%>%
  ggplot()+
  geom_line(aes(x=frequency,y=TS),alpha=0.2,linewidth=0.5)+
  theme_bw()+
  ggtitle("Frequency response curve for all pings from 1 lake trout (LT009)") +
  xlab("Frequency (kHz)") +
  ylab("Target Strength")

ggsave("figs/01_raw_data_viz/single_LT_freq_response_curve.png", single_LT_freq_response_curve, width = 6, height = 4, dpi = 300)

single_SMB_freq_response_curve = data_long%>%
  filter(fishNum=="SMB010")%>%
  ggplot()+
  geom_line(aes(x=frequency,y=TS),alpha=0.2,linewidth=0.5)+
  theme_bw()+
  ggtitle("Frequency response curve for all pings from 1 Bass (SMB010)") +
  xlab("Frequency (kHz)") +
  ylab("Target Strength")

ggsave("figs/01_raw_data_viz/single_SMB_freq_response_curve.png", single_SMB_freq_response_curve, width = 6, height = 4, dpi = 300)


# summarised information
freq_response_all_reps_mean_CI = data_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(TS),upper95=quantile(TS,0.975),lower95=quantile(TS,0.025))%>%
  ggplot()+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  theme_bw()+
  ggtitle("Mean frequency response curves +95% CI for all samples") +
  xlab("Frequency (kHz)") +
  ylab("Target Strength")

ggsave("figs/01_raw_data_viz/freq_response_all_reps_mean_CI.png", freq_response_all_reps_mean_CI, width = 6, height = 4, dpi = 300)

normalized_freq_response_all_reps_mean_CI = data_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(diff),upper95=quantile(diff,0.975),lower95=quantile(diff,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw()+
  ggtitle("Normalized frequency response curves +95% CI for all samples") +
  xlab("Frequency (kHz)") +
  ylab("Target Strength")

ggsave("figs/01_raw_data_viz/normalized_freq_response_all_reps_mean_CI.png", normalized_freq_response_all_reps_mean_CI, width = 6, height = 4, dpi = 300)

# Group by fishNum and then summarize the mean for columns 52 to 302 
# (the target strength data for each frequency)
avg_data <- raw_data %>%
  group_by(fishNum, species) %>%
  summarize(across(50:299, mean, na.rm = TRUE))

# pivot to long format
avg_long<-gather(avg_data, frequency, value, F45:F170)
avg_long$frequency<-as.numeric(gsub('F','',avg_long$frequency))

# Get the mean target value for each frequency across all animals
avg_long <- avg_long %>%
  group_by(frequency) %>%
  mutate(avg_sp = mean(value))

#Create new column with normalized target frequencies 
avg_long$diff = -(avg_long$value - avg_long$avg_sp) / (avg_long$value + avg_long$avg_sp)

# Plot the target value data for all individuals (average for each individual across all individuals)
freq_response_avg_per_individual = avg_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(value),upper95=quantile(value,0.975),lower95=quantile(value,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw() +
  ggtitle("Frequency response +95% CI avg per individual") +
  xlab("Frequency (kHz)") +
  ylab("Target Strength")

ggsave("figs/01_raw_data_viz/freq_response_avg_per_individual.png", freq_response_avg_per_individual, width = 6, height = 4, dpi = 300)


# Plot the normalized data
norm_freq_response_avg_per_individual = avg_long%>%
  group_by(species,frequency)%>%
  summarise(meanTS=mean(diff),upper95=quantile(diff,0.975),lower95=quantile(diff,0.025))%>%
  ggplot()+
  geom_line(aes(x=frequency,y=meanTS,col=species))+
  geom_ribbon(aes(x=frequency,ymin=lower95,ymax=upper95,group=species,fill=species),alpha=0.5)+
  theme_bw()+
  ggtitle("Normalized frequency response +95% CI avg per individual") +
  xlab("Frequency (kHz)") +
  ylab("Target Strength")

ggsave("figs/01_raw_data_viz/normalized_freq_response_avg_per_individual.png", norm_freq_response_avg_per_individual, width = 6, height = 4, dpi = 300)

