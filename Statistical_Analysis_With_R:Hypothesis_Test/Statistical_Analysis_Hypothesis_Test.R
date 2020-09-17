# Statistical Analysis With R


# Set Workspace
setwd("C:/CursoFCD/3.0BigData_Analytics_R_e_Azure_MachineLearning/Pratica/Cap09")
getwd()

# Packages
install.packages("dplyr")
install.packages('nycflights13')
library('ggplot2')
library("plyr")
library('dplyr')
library('nycflights13')
View(flights)
head(flights)
str(flights)
?flights

# Defining the Business Problem:
# Create a Hypothesis test to check if Delta Airlines flights are later than United Airlines flights.

#### Create the "pop_data" dataset with UA and DL flights data ####
# This dataset must have two columns, one for the company name and the other for the delayed arrival flights. 
# This data must be extracted from "flights" dataset.
# This dataset will our population.
# We can use dplyr() package.
# Let's exclude any NA values in the dataset rows.
# Then, we will select only the variables "carrier" and "arr_delay".
# We will filter the carrier column with only DL and UA airlines.
# We are only interested in the delayed flights, so we will return only the values where arr_delay > 0.
# Let's group our data by airline and randomly sample it in 17.000 records for UA and 17.000 records for DL.
# In the end, we will remove grouping.
pop_data <- na.omit(flights, na.action = "exclude") %>%
  select(carrier, arr_delay) %>%
  filter(carrier %in% c("DL","UA"), arr_delay >= 0) %>%
  group_by(carrier) %>%
  sample_n(17000) %>%
  ungroup()
View(pop_data)
head(pop_data)
dim(pop_data)

#### Create two samples with size equal to 1.000 from pop_data dataset with only DL and UA data. ####
# Let's include a third column called "sample_id" with 1 for DL data and 2 for UA data.
sample_DL <- na.omit(pop_data) %>%
  select(carrier, arr_delay) %>%
  filter(carrier == "DL") %>%
  mutate(sample_id = "1") %>%
  sample_n(1000)
head(sample_DL)
dim(sample_DL)

sample_UA <- na.omit(pop_data) %>%
  select(carrier, arr_delay) %>%
  filter(carrier == "UA") %>%
  mutate(sample_id = "2") %>%
  sample_n(1000)
head(sample_UA)
dim(sample_UA)

#### Now, we will unite the two previous dataset. ####
# Let's use the "rbind()" function to bind the two datasets by rows.
sample_all <- rbind(sample_DL, sample_UA)
View(sample_all)
head(sample_all)
dim(sample_all)

#### Calculate the confidence interval (95%) to DL sample. ####
# Standard error for DL airline sample.
se_DL = sd(sample_DL$arr_delay) / sqrt(nrow(sample_DL))
se_DL

# Upper and Lower Limits to DL.
# 1.96 is the z-score value to a confidence level of 95%.
limit_lower_DL = mean(sample_DL$arr_delay) - 1.96 * se_DL
limit_upper_DL = mean(sample_DL$arr_delay) + 1.96 * se_DL
print(limit_lower_DL)
print(limit_upper_DL)

# DL Confidence Interval.
ic_DL <- c(limit_lower_DL, limit_upper_DL)
mean(sample_DL$arr_delay)
ic_DL

#### Calculate the confidence interval (95%) to UA sample. ####
se_UA = sd(sample_UA$arr_delay) / sqrt(nrow(sample_UA))
se_UA
limit_lower_UA = mean(sample_DL$arr_delay) - 1.96 * se_UA
limit_upper_UA = mean(sample_DL$arr_delay) + 1.96 * se_UA

# Upper and Lower Limits to UA.
ic_UA <- c(limit_lower_UA, limit_upper_UA)
mean(sample_UA$arr_delay)
ic_UA

#### Create a plot to display both confidence intervals. ####
# Obtain the central value, mean, for our chart.
toPlot <- ddply(sample_all, ~sample_id,
                summarize,
                mean = mean(arr_delay))
head(sample_all)
head(toPlot)
toPlot = mutate(toPlot, lower = ifelse(toPlot$sample_id == 1, ic_DL[1], ic_UA[1]))
toPlot = mutate(toPlot, upper = ifelse(toPlot$sample_id == 1, ic_DL[2], ic_UA[2]))
head(toPlot)

ggplot(toPlot, aes(x = sample_id, y = mean, colour = sample_id))+
  geom_point()+
  geom_errorbar(aes(ymin = lower, ymax = upper), width = .2)

#### Create a Hypothesis test to check if Delta Airlines flights are later than United Airlines flight.
# H0 and H1 must be mutually exclusive.
# H0 = There is no significance change between DL and UA delays.(diff between delayed mean  = 0)
# H1 = Delta flights are later than UA. (mean diff > 0).

# T Test:
t.test(sample_DL$arr_delay, sample_UA$arr_delay, alternative = "greater")

# We have failed to reject the Null Hypothesis.
a <- table(flights$carrier)
View(a)

#### Create a Hypothesis test to check if EV flights are later than B6 flights. ####
# H0 = There is no significance change between EV and B6 delays.(diff between delayed mean  = 0)
# H1 = EV flights are later than B6 (mean diff > 0).

# Let's check our airline distribution data:
# Bar chart.
barr_carrier <- ggplot(flights,aes(x=as.factor(carrier), fill = as.factor(carrier))) + geom_bar()
barr_carrier

# Let's use the "table()" function.
check_cont <- table(flights$carrier)
check_cont

EV <- 54173/nrow(flights)
EV
B6 <- 54635/nrow(flights)
B6

# Let's filter our dataset to select only the EV and B6 airline.
pop_data <- na.omit(flights) %>%
  select(carrier, arr_delay) %>%
  filter(carrier %in% c("EV","B6"), arr_delay > 0) %>%
  group_by(carrier) %>%
  sample_n(15000) %>%
  ungroup()
head(pop_data)
str(pop_data)

# Create samples:
# Collect 1/3 from population data (pop_data).
ev <- sample_n(filter(pop_data, carrier == "EV", arr_delay > 0), 5000)
head(ev)
b6 <- sample_n(filter(pop_data, carrier == "B6", arr_delay > 0), 5000)
head(b6)
pop_data4 <- rbind(ev, b6)
View(pop_data4)

# Standard error and mean for EV airline:
se = sd(ev$arr_delay) / sqrt(nrow(ev))
mean(ev$arr_delay)
se

# Criticical values for EV airline:
lower = mean(ev$arr_delay) - 1.96 * se
upper = mean(ev$arr_delay) + 1.96 * se
ic_ev = c(lower, upper)
ic_ev

# Standard error and mean for B6 airline:
se = sd(b6$arr_delay) / sqrt(nrow(b6))
mean(b6$arr_delay)
se

# Critical values for B6 airline:
lower = mean(b6$arr_delay) - 1.96 * se
upper = mean(b6$arr_delay) + 1.96 * se
ic_b6 = c(lower, upper)
ic_b6

# T Test:
t.test(ev$arr_delay, b6$arr_delay, alternative = "greater")

# We will reject the Null Hypothesis.Rejeitamos a hipótese nula, pois p-valor é menor que o nível de significância.

# Visual Analysis using a Scatter_Plot.
pop_data2 <- na.omit(flights) %>%
  select(carrier, arr_delay) %>%
  filter(arr_delay >0) %>%
  sample_n(70000)

allin <- ggplot(data=pop_data2,aes(x = as.factor(carrier), y = arr_delay,
                                   colour = as.factor(carrier),size = arr_delay)) + geom_point()
allin

check_data <- ddply(pop_data, ~carrier,
                    summarize,
                    add = sum(arr_delay))
check_data

# Plot only a Scatter Plot with EV and B6 data:
straight_point <- ggplot(data = pop_data, aes(x = as.factor(carrier), y = arr_delay,
                                              colour = as.factor(carrier), size = arr_delay)) +  geom_point()
straight_point
