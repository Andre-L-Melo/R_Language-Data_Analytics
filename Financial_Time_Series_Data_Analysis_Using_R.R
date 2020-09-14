# Project 1 - Financial Time-Series Data Analysis using R

# Obs: Accentuations problems, please, consult the link below:
# https://support.rstudio.com/hc/en-us/articles/200532197-Character-Encoding

# Set workspace.
# Do not use space or accentuations.
setwd("C:/CursoFCD/3.0BigData_Analytics_R_e_Azure_MachineLearning/Pratica/Cap07")
getwd()
options(warn=-1)

#### Install and Load Packages ####
# install.packages("quantmod")
# install.packages("xts")
# install.packages("moments")
library(quantmod)
library(xts)
library(moments)

#### Define the Analysis Period ####
# From 01/21/2020 to 08/21/2020
startDate = as.Date("2020-01-21")
endDate = as.Date("2020-08-21")

#### Extract financial data from YAHOO ####
# Use the function "getSymbols" to consult "ABEV3.SA" data:
getSymbols("ABEV3.SA", src = "yahoo",
           from = startDate, 
           to = endDate,
           auto.assign = T)
# Check the object class:
class(ABEV3.SA)
is.xts(ABEV3.SA)
head(ABEV3.SA,3)

#### Financial Closing Data ####
# Financial Closing Data Analysis
# na.omit to remove NA values from original time-series data
ABEV3.SA.Close <- na.omit(ABEV3.SA[,"ABEV3.SA.Close"], na.action = "exclude")
is.xts(ABEV3.SA.Close)
ABEV3.SA.Close <- ABEV3.SA.Close[-25]
head(ABEV3.SA.Close,3)

#### Plot AMBEV ####
# AMBEV3.SA Candlestick Plot:
candleChart(ABEV3.SA)
# Financial Closing Data Plot:
plot(ABEV3.SA.Close, 
     main = "AMBEV3.SA Daily Closing Shares",
     col = "cadetblue1", xlab = "Data",
     ylab = "Price",
     major.ticks = "months",
     minor.ticks = FALSE)

#### Bollinger Bands ####
addBBands(n = 20, sd = 2)

#### Index ADX CandleChart ####
addADX(n=11, maType = "EMA")

#### Daily logs ####
ABEV3.SA.ret <- diff(log(ABEV3.SA.Close),lag = 1)
ABEV3.SA.ret <- na.omit(ABEV3.SA.ret, na.action = "exclude")
head(ABEV3.SA.ret,3)

#### Return Rate Plot ####
plot(ABEV3.SA.ret, 
     main="ABEV3.SA Daily Closing Shares",
     col="cadetblue1",xlab="Data",ylab="Return",
     major.ticks="month",
     minor.ticks=FALSE)

#### Statistics ####
statNames <- c("Mean","Standard Deviation",
               "Skewness", "Kurtosis")

ABEV3.SA.stats <- c(mean(ABEV3.SA.ret),sd(ABEV3.SA.ret),
                    skewness(ABEV3.SA.ret),kurtosis(ABEV3.SA.ret))
names(ABEV3.SA.stats) <- statNames
ABEV3.SA.stats

#### Save Data in rds type ####
saveRDS(ABEV3.SA,
        file = "ABEV3.SA.rds")
Abv = readRDS("ABEV3.SA.rds")
head(Abv,2)