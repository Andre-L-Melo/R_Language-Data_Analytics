<h1 align="center">FINANCIAL DATA ANALYSIS USING R</h1>

<div align="center">
  <p>
    <strong>Let's use R to study Stock Market?</strong>
  </p>
  <p>
    <a href="https://www.r-project.org/about.html" target="_blank" rel="noopener">
      <img src="https://www.r-project.org/Rlogo.png" width="50" alt="R Studio" />
    </a>
  </p>
</div>

<div align="center">
  <a href="https://rstudio.com/" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/rstudio-v1.2.5-blue">

  <a href="https://www.quantmod.com/download/" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/quantmod-v0.4.17-blueviolet">

  <a href="https://r-forge.r-project.org/R/?group_id=118" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/xts-v0.12-blueviolet">

  <a href="https://cran.r-project.org/web/packages/moments/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/moments-v0.14-blueviolet">
  </a>
</div>

## Why R?
For many, the R language is not considered a programming language, but a statistic package which has some functionalities and features for coding, such as loops, conditionals, variables, functions and others.
It is open source and all its packages are maintaned by CRAN (https://cran.r-project.org).

The R language allows us to:

* Extract Data
* Clean Data
* Load and Transform Data
* Do Statistical Analysis
* Create Predictive Models
* Use Machine Learning
* Display Data

## Time-Series Data with R
A time series is a numerical sequence of data points over a specified time period. All this data is recorded at regular intervals. 
It is very useful to see how a variable changes over time, for example, meteorological data and financial variables.
In order to study the behavior of a specific company on the financial market, it is necessary to understand how its shares price changed during a period given.

For this project, we will analyze a time series of a company share focusing in the Daily Closing Stock Prices from 01/21/2020 to 08/21/2020 and then listing the data in chronological order. 
R has a handy package called *quantmod* that is used to create time-series for financial market. 
It is necessary to install the packages *xts* and *moments* before installing *quantmod*, both used to deal with time-series analysis. For more info about the package, access the link: www.quantmod.com.

``` r
install.packages("quantmod")
install.packages("xts")
install.packages("moments")
library(quantmod)
library(xts)
library(moments)
```

After that, we will define a variable with start date and another with the end date. These two variables will define the period we will analyze.

``` r
startDate = as.Date("2020-01-21")
endDate = as.Date("2020-08-21")
```

In order to load and manage data, the function *getSymbols* from *quantmods* will be used. It will search for AMBEV financial data over the period given in the *Yahoo Finances API*, note that is important to know the company code to search for its quotations.

``` r
getSymbols("ABEV3.SA", src = "yahoo",
           from = startDate, 
           to = endDate,
           auto.assign = T)
class(ABEV3.SA)
[1] "xts" "zoo"
```
*getSymbols* has returned an object of type *xts zoo*. *zoo* is a time-series data type considered in R. What really categorize a time-series is a data sequence over time, which makes possible to do sales predictions, for example. Note that, we could use any company share for this example, but we preferred to use a company from Brazil Stock Market, in this case, the company AMBEV.

<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Financial_Data_Analysis_With_R/Images/logo-b3.png" alt = "B3" style="width:200px;height:200px;"/>

If you want to know more about Brazil Stock Market, B3, check the link below:

http://www.b3.com.br/pt_br/

Printing the object content, we have:

``` r
head(ABEV3.SA,3)
## ABEV3.SA.Open ABEV3.SA.High ABEV3.SA.Low ABEV3.SA.Close
## 2020-01-21 18.68 18.92 18.66 18.74
## 2020-01-22 18.85 19.08 18.77 19.05
## 2020-01-23 18.90 19.03 18.59 18.65
## ABEV3.SA.Volume ABEV3.SA.Adjusted
## 2020-01-21 11249000 18.74
## 2020-01-22 13925400 19.05
## 2020-01-23 20155900 18.65
```
The dataset index consist of data type objects, which represents a time-series problem.
Now, we are only interested in the *ABEV.SA.Close data* or the *Financial Closing Share Prices*. For this, we can use a slicing notation to filter only the column *ABEV.SA.Close* and store it in another variable. It is necessary to use the function *na.omit* to remove any NA values in the zoo type object.

``` r
ABEV3.SA.Close <- na.omit(ABEV3.SA[,"ABEV3.SA.Close"], na.action = "exclude")
is.xts(ABEV3.SA.Close)
## [1] TRUE
ABEV3.SA.Close <- ABEV3.SA.Close[-25]
head(ABEV3.SA.Close,3)
## ABEV3.SA.Close
## 2020-01-21 18.74
## 2020-01-22 19.05
## 2020-01-23 18.65
```

Remember, although we had filter only one column, the index comes together. Another way to do that is use the function *cl* from the package *quantmod*, which can extract and transform colums of time-series objects.

Now, before we go any further, let's plot a candlestick of the original data *ABEV3*. We will use the function *candleChart* from *quantmod*.
 ``` r
candleChart(ABEV3.SA)
 ```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Financial_Data_Analysis_With_R/Images/plot_zoom_png"
      alt = "Candle Chart ABEV3"
      style="width:600px;height:300px;"/>

In this chart we have info about opening prices, closing prices and traded shares volume.

In order to just analyze the closing prices, let's plot a line chart:

``` r
plot(ABEV3.SA.Close,
main = "ABEV3.SA Daily Closing Shares",
col = "cadetblue1", xlab = "Data",
ylab = "Price",
major.ticks = "months",
minor.ticks = FALSE)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Financial_Data_Analysis_With_R/Images/plot_zoom_png2"
      alt = "Daily Closing Shares AMBEV3.SA"
      style="width:600px;height:300px;"/>

With this, we have the Closing Shares price evolution over time.

In our Candlestick chart, let's add the **Bollinger Bands** with *Simple Moving Average -> 20 days period* equal to 20 and *Standard Deviation* equal to 2. These bands are always below and above the price at a distance relative to the standard deviation, that indicates how much the price has changed over time.  

``` r
addBBands(n = 20, sd = 2)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Financial_Data_Analysis_With_R/Images/Bollinger_Band"
      alt = "Daily Closing Shares AMBEV3.SA"
      style="width:600px;height:300px;"/>

We can add an **ADX - Average Directional Index** to this chart, with a *Simple Moving Exponential Average* equal to 11. 
It is used to determine the strength of a trend. The trend can be either up or donwn, which can be shown by two indicators, the **Negative Directional Indicator(-DI)** and the **Positive Directional Indicator (+DI)**. Therefore, ADX uses three separate lines to help assess whether a trade should be taken long or short.
We will use the function *addADX* from *quantmod* to add the Directional Movement Index. 

``` r
addADX(n=11, maType = "EMA")
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Financial_Data_Analysis_With_R/Images/ADX"
      alt = "Daily Closing Shares AMBEV3.SA"
      style="width:700px;height:300px;"/>

The price is moving up when +DI is above -DI, and the price is moving down when -DI is above +DI. 
If the ADX value is over 25 we have a strong trend, otherwise it is a weak trend.
Crossovers of the -DI and +DI lines can be used as sign to trade, for example, if the ADX is above 25 and something like this happens, it indicates a strong signal to buy.
In our chart, the green line indicates the +DI, the red line indicates the -DI and the blue line is the ADX.
Note that, during the period studied, -DI is predominantly above +DI, so the price is moving down.

Now, let's calculate the daily logs, but only for the Daily Closing Shares Price, in other words, we will represent the data in a logarithmic scale.

``` r
ABEV3.SA.ret <- diff(log(ABEV3.SA.Close),lag = 1)
ABEV3.SA.ret <- na.omit(ABEV3.SA.ret, na.action = "exclude")

plot(ABEV3.SA.ret, 
     main="ABEV3.SA Daily Closing Shares",
     col="cadetblue1",xlab="Data",ylab="Return",
     major.ticks="month",
     minor.ticks=FALSE)
```
  <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Financial_Data_Analysis_With_R/Images/log_scale"
      alt = "Daily Closing Shares AMBEV3.SA"
      style="width:700px;height:300px;"/>

Ok, now we already know how to collect share market data, plot a candlestick, use Bollinger Bands and ADX Index to help in our analysis. Let's learn how to obtain statistical insights from the Company Closing Share Price.
We will analyze 4 statistical measures:

* **Mean**
* **Standard Deviation**
* **Skewness**: It allows us to say if some distribution is symmetric or no. If assumes value greater than 0, it has positive asymmetry, or a return distribution, where frequent small losses and a few extreme gains are common. If assumes value smaller than 0, it has negative asymmetry, or frequent small gains and a few extreme losses that are more common.
* **Kurtosis**: Describes the size of a tail on a distribution. It helps determine how much risk is involved in a specific investment. It usually says if the probability of obtaining an high outcome or value from the event is higher than in a normal distribution of outcomes. When this coefficient is positive, it has a leptokurtic distribution, indicating a heavy degree of risk (the tail on this distribution is heavier than of a normal distribution). If the value is negative, it has a platykurtic distribution, with a tail thinner than a normal distribution, indicating results that won't be very extreme, which are prefered by investor who don't want to take a lot of risk.

``` r
statNames <- c("Mean","Standard Deviation",
"Skewness", "Kurtosis")
ABEV3.SA.stats <- c(mean(ABEV3.SA.ret),sd(ABEV3.SA.ret),
skewness(ABEV3.SA.ret),kurtosis(ABEV3.SA.ret))
names(ABEV3.SA.stats) <- statNames
ABEV3.SA.stats
## Mean Standard Deviation Skewness Kurtosis
## -0.002604059 0.034263013 -1.074486561 8.428591283
```
At last, we can save our data in a RDS file for future use:

``` r
saveRDS(ABEV3.SA,
file = "ABEV3.SA.rds")
Abv = readRDS("ABEV3.SA.rds")
head(Abv,2)
## ABEV3.SA.Open ABEV3.SA.High ABEV3.SA.Low ABEV3.SA.Close
## 2020-01-21 18.68 18.92 18.66 18.74
## 2020-01-22 18.85 19.08 18.77 19.05
## ABEV3.SA.Volume ABEV3.SA.Adjusted
## 2020-01-21 11249000 18.74
## 2020-01-22 13925400 19.05
```

## Author

[<img src="https://avatars3.githubusercontent.com/u/47090012?s=460&u=0180e5d8646087e40786286006fc2505548b9e2a&v=4" width=200><br><sub>@meloandrew</sub>](https://github.com/meloandrew) | [<img 
