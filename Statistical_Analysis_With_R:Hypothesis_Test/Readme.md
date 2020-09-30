<h1 align="center">STATISTICAL ANALYSIS - nycflights13 dataset</h1>
<div align="center">
  <p>
    <strong>Performing statistical analysis in nycflights13 dataset</strong>
  </p>
  <p>
    <img src="https://www.airlines.org/wp-content/uploads/2020/03/iStock-1097481110.jpg" width="250" alt="airline">
  </p>
</div>

<div align="center">
  <a href="https://rstudio.com/" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/rstudio-v1.2.5-blue"/>

  <a href="https://cran.r-project.org/web/packages/plyr/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/plyr-v1.8.6-blueviolet"/>

  <a href="https://cran.r-project.org/web/packages/dplyr/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/dplyr-v0.8.5-blueviolet"/>

  <a href="https://cran.r-project.org/web/packages/nycflights13/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/nycflights13-v1.0-green"/>
  </a>
</div>

## Why R?
For many, the R language is not a programming language, but a statistic package that has some functionalities and features for coding, such as loops, conditionals, variables, functions, and others. It is open-source with all its features maintained by CRAN (https://cran.r-project.org). 

The R language allows us to:

* Extract Data
* Clean Data
* Load and Transform Data
* Do Statistical Analysis
* Create Predictive Models
* Use Machine Learning
* Display Data

## STATISTICAL CONCEPTS

### Central Limit Theorem
The Central Limit Theorem is a statistical concept that is the base for many other theorems, considered "the mother of all theorems" for many statisticians.

The Central Limit Theorem implicates that when sample size increases, the sample means distribution gets even closer to a normal distribution.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Centra_Limit_Theorem.png"
      alt = "Central Limit Theorem"
      style="width:400px"/>

If you have a normal distribution in your hands, you can obtain a series of insights.

It is fundamental in the inferential statistics theory that without it, the statistic wouldn't have evolved into the science it is today.

The picture below is wordless because it is an excellent way to you understand what a normal distribution is. You can see that we have a rabbit series as a normal distribution. 

Any distribution, no matter what kind it is, if it assumes a normal distribution, could be represented as a sine curve, it would result in insights of our data that could be easily understood.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Normal_Distribution.png"
      alt = "Normal Distribution"
      style="width:600;height:300px;"/>

If a sample size is equal or greater than 30, n >= 30, then the sample means can be approximated by a normal distribution. 

In this case, the mean of the sample means will be the population mean.

For a variable x whose data is a normal distribution, the sample means distribution will have a normal distribution for any sample size.

We can see that the sample size has a function in the Central Limit Theorem.

When the sample size increases, the mean of standard deviation becomes even smaller, which reduces the sampling error.

So, if you increase the sample size, you reduce the standard deviance.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Sample_Size.png"
      alt = "Sample Size"
      style="width:600;height:300px;"/>

Based on this, we have two important rules:

1. **To any population**: The mean value for all possible sample means, from given population size, is equal to our primary data mean.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/First_Rule.png"
      alt = "First Rule"
      style="width:200"/>

2. **To any population**: The sample means the standard deviation of size n is equal do the population standard deviation divide by the sample size square root.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Second_Rule.png"
      alt = "Second Rule"
      style="width:200"/>

But after all, what is so extraordinary about the Central Limit Theorem?

It says that no matter what form the original distribution has, its means will have a normal distribution.

This theorem allows us to measure the sample mean-variance, so, there is no need to collect another sample mean to compare.

For example, imagine that a group of drivers travel 12.000 km a year, with a standard deviation of 2.580 km. What is the probability that 36 drivers randomly selected travel more than 12.500 km a year?

The sample size is bigger enough (n >= 30), so we can use the Central Limit Theorem to find our answer.

The mean of the sample means can be equal to the population mean.

In this case, the mean of the sample means is equal to 12.000 km a year.

The sample means standard deviation is equal to the population standard deviation divide by the sample size square root, resulting in 430 km.

We can obtain the z-score by dividing the result of the sample mean minus mean of the sample means by the standard deviation mean. 

The sample mean is equal to 12.500 km, with a z-score of 1.16.

Based on this, we know that the probability for z-score greater than 1.16 is the same for a sample mean equal to 12.500.

With z-score equal to 1.16, the corresponding probability is 0.8770. Subtracting the corresponding probability by 1 we obtain 0.1230.

This value is the probability of a random sample of 36 drivers who drive more than 12.500 km a year be selected.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Central_Limit_Theorem_Example.png"
      alt = "Central Limit Example"
      style="width:200"/>

### Z-Score
The z-score identifies the standard deviation number that some value has.

Think of z-score as a simple value conversion to a specific unity, to conclude.

The table below shows some sandwiches and their number of calories:

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Score_Z_Example.png"
      alt = "Score_Z_Example"
      style="width:200"/>

We will calculate the z-score for the Mega Burger. Let's assume that the sample mean is equal to 1.420 calories, the mean of the sample means is equal to  776,30 calories (assuming that we are working with a data sample with more than 30 records, because of the Central Limit Theorem), and the standard deviation means is equal to 385,10.
With this, the z-score is equal to 1.67. That is the same as we say the Mega Burger calories are 1,67 standard deviation above the mean.
Let's do the same for the Big Mac, which has a sample mean equal to 430 calories, a mean of the sample means equal to 776,30 and mean standard deviation equal to 385,10. With that, the z-score is equal to -0,90, which implies that the Big Mac calories are 0,90 standard deviation below the mean.

It can is worthy to see how far the data is from the mean.

We can consider that, according to the mean values, it is wise to choose the Big Mac over Mega Burger, because its calories are below the mean calories value.

The z-score will always have one of the three attributes below:

* Positive: values above average
* Negative: values below average
* Zero: values equal average

Z-score has an important feature: it helps us to identify outliers (extreme values) in our dataset.

Data values with z-score above three or below minus three are outliers.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Score_Z_Table.png"
      alt = "Score_Z_Table"
      style="width:200"/>

### Confidence Interval
Imagine that a bowman is shooting at a target.

Suppose he hits the center of the 10 cm radius 95% of the time. That is, he only craves once every 20 attempts.

A statistician is behind the target, and he doesn't know where the center is.

The archer shoots the first arrow.

Knowing the archer skill level, the statistician draws a 10 cm radius circle around the arrow.

He is 95% confidence that the circle includes the target center.

The statistician reasoned that if he drew 10 cm radius circles around the arrows, his draws would include the target center in 95% of cases.

Summing up, the statistician has collected some samples and built a confidence interval.

This simple example shows what a confidence interval is. All you have to do is determine a minimum limit value, a maximum limit value and assume that within, we will have the population average, for example.

In most cases, we don't know what the population average is. We only hold sample insights.

The confidence interval allows us to make population inferences based on collected samples data.

How can we improve the confidence interval?

In this example, there are two ways to increase the confidence interval:

* By enlarging the circle radius: This is equal to increases the confidence interval (for example, from 95% to 99%). 
* By improving the archer's aim: This is equal to increase the number of sample records.

### Confidence Level
After studying about confidence intervals, we need to understand what is a confidence level.

The confidence level is the probability, which is represented by 1 - α, where α is the Significance Level.

The Significance Level Percentual Value is 100 * (1 - α).

The chart below helps us understand a bit more about this concept:

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Confidence_Level.png"
      alt = "Confidence_Level"
      style="width:200"/>

The red line is a normal distribution, where the two vertical lines are the upper and lower limits, which define the confidence interval, which is 95% for this example. The α value is divided by two on both ends, to represent the critical values. The result of 1 - α is the Confidence Level, where α is the significance level.

Usually, we use the following significance values:

* For IC = 90 %:  α equal to 0,10
* For IC = 95%:   α equal to 0,05
* For IC = 99%:   α equal to 0,01

Once more, we have a more detailed chart:

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Confidence_Level_2.png"
      alt = "Confidence_Level_2"
      style="width:200"/>

The confidence interval consists of a z scale interval (z-score) that is associated with a significance level.

If we collect multiple samples and build a confidence interval for each one of them, in the long run, 95% of these intervals would effectively contain the population means.

### Critical Value
The z-score corresponds to the border value of the area in the right or left tails of the normal distribution.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Critical_Value.png"
      alt = "Critical_Value"
      style="width:200"/>

By the central limit, we know the sample means tend to a normal distribution.

Considering α/2 as the area of each extreme point, there is an α possibility for the sample mean to be in one of these ends.

By the complement rule, there is a probability that the sample mean is in the un-shaded region.

## STATISTICAL ANALYSIS WITH R
The statistic is one of the pillars that support a Data Science Project.

In this project, we will learn more about probabilistic samples, central limit theorem, confidence interval, and hypothesis test. All these topics belong to inferential statistics.

We collect some data samples where based on the analysis, some inferences are made about the main population. It is what we do with Machine learning, where we will rarely work with all the population data. Usually, we would use its samples and then make some inferences.

For this project, we will use the dataset nycflights13. It provides an Airline on-time data for all flights departing New York City in 2013, and it also includes some useful "metadata" on airlines, airports, weather, and planes. In this case, we are more interested in the flight data from the nycflights13 package.

### Probabilistic Sample

First of all, we need to load the necessary packages and then visualize our dataset:

``` r
library('ggplot2')
library('plyr')
library('dplyr')
library('nycflights13')

> head(flights)
# A tibble: 6 x 19
   year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
  <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
1  2013     1     1      517            515         2      830            819
2  2013     1     1      533            529         4      850            830
3  2013     1     1      542            540         2      923            850
4  2013     1     1      544            545        -1     1004           1022
5  2013     1     1      554            600        -6      812            837
6  2013     1     1      554            558        -4      740            728
# ... with 11 more variables: arr_delay <dbl>, carrier <chr>, flight <int>,
#   tailnum <chr>, origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
#   hour <dbl>, minute <dbl>, time_hour <dttm>

> str(flights)
tibble [336,776 x 19] (S3: tbl_df/tbl/data.frame)
 $ year          : int [1:336776] 2013 2013 2013 2013 2013 2013 2013 2013 2013 2013 ...
 $ month         : int [1:336776] 1 1 1 1 1 1 1 1 1 1 ...
 $ day           : int [1:336776] 1 1 1 1 1 1 1 1 1 1 ...
 $ dep_time      : int [1:336776] 517 533 542 544 554 554 555 557 557 558 ...
 $ sched_dep_time: int [1:336776] 515 529 540 545 600 558 600 600 600 600 ...
 $ dep_delay     : num [1:336776] 2 4 2 -1 -6 -4 -5 -3 -3 -2 ...
 $ arr_time      : int [1:336776] 830 850 923 1004 812 740 913 709 838 753 ...
 $ sched_arr_time: int [1:336776] 819 830 850 1022 837 728 854 723 846 745 ...
 $ arr_delay     : num [1:336776] 11 20 33 -18 -25 12 19 -14 -8 8 ...
 $ carrier       : chr [1:336776] "UA" "UA" "AA" "B6" ...
 $ flight        : int [1:336776] 1545 1714 1141 725 461 1696 507 5708 79 301 ...
 $ tailnum       : chr [1:336776] "N14228" "N24211" "N619AA" "N804JB" ...
 $ origin        : chr [1:336776] "EWR" "LGA" "JFK" "JFK" ...
 $ dest          : chr [1:336776] "IAH" "IAH" "MIA" "BQN" ...
 $ air_time      : num [1:336776] 227 227 160 183 116 150 158 53 140 138 ...
 $ distance      : num [1:336776] 1400 1416 1089 1576 762 ...
 $ hour          : num [1:336776] 5 5 5 5 6 5 6 6 6 6 ...
 $ minute        : num [1:336776] 15 29 40 45 0 58 0 0 0 0 ...
 $ time_hour     : POSIXct[1:336776], format: "2013-01-01 05:00:00" "2013-01-01 05:00:00" ...
```
Our dataset has 336.776 records and 19 variables or columns. As a first task, we will need to create a new dataset, with only the data from United Airlines (UA) and Delta Airlines (DA) companies. This dataset must contain only two columns, the company name and arrive delay. We will consider this new dataset as our flight population.

``` r
# One way to do that is using the dplyr package, which allows us to use the infix operator %>% that works just like a pipe to chain functions together.
# We will use "na.omit()" to exclude any NA value in our dataset.
# Similar with SQL, the select function can be used to get only the columns "carrier" and "arr_delay", note that, we do not need to use the flights$column_name notation.
# Then, we use the function filter() to get only the DL and UA data and array delay greater than 0 (we just want the delay flights).
# In order to organize the data, we will group it by airline.
# We do not want all the 336.776 records, so, we will use the function "sample_n" to randomly sample our data in 17.000 records. After that, we will remove grouping.
# In the end, we will have a dataset with 34.000 records. Each airline will have 17.000 random data.
pop_data <- na.omit(flights, na.action = "exclude") %>%
  select(carrier, arr_delay) %>%
  filter(carrier %in% c("DL","UA"), arr_delay >= 0) %>%
  group_by(carrier) %>%
  sample_n(17000) %>%
  ungroup()
View(pop_data)
head(pop_data)

# A tibble: 6 x 2
  carrier arr_delay
  <chr>       <dbl>
1 DL             27
2 DL             11
3 DL              0
4 DL             47
5 DL             13
6 DL              7
> dim(pop_data)
[1] 34000     2
```
We have obtained a sample from our flight population by using a probabilistic sample method, which means the data was randomly selected.

So, our sample has 34.000 records and 2 variables: Airline and arrive delay. The arrive delay is given in minutes.

### Splitting the sample
Our next task is to divide the sample into two new datasets. One dataset has only UA airline data and the other DL airline data, each one of them with 1.000 records. In other to make things easier, let's add a third column called "sample_id" for each dataset, for example, the UA dataset has a sample_id column equal to 1, and DL dataset sample_id equal to 2.

``` r
# To add a third column in our dataset, we will use the function "mutate()" that adds new variables and preserves existing ones. 
> sample_DL <- na.omit(pop_data) %>%
+   select(carrier, arr_delay) %>%
+   filter(carrier == "DL") %>%
+   mutate(sample_id = "1") %>%
+   sample_n(1000)
> head(sample_DL)
# A tibble: 6 x 3
  carrier arr_delay sample_id
  <chr>       <dbl> <chr>    
1 DL             39 1        
2 DL             36 1        
3 DL             32 1        
4 DL              6 1        
5 DL              4 1        
6 DL              0 1        
> dim(sample_DL)
[1] 1000    3

> sample_UA <- na.omit(pop_data) %>%
+   select(carrier, arr_delay) %>%
+   filter(carrier == "UA") %>%
+   mutate(sample_id = "2") %>%
+   sample_n(1000)
> head(sample_UA)
# A tibble: 6 x 3
  carrier arr_delay sample_id
  <chr>       <dbl> <chr>    
1 UA             10 2        
2 UA              7 2        
3 UA             27 2        
4 UA             15 2        
5 UA             22 2        
6 UA             75 2        
> dim(sample_UA)
[1] 1000    3
```

### Binding UA and DL airline samples
Ok, now we have two samples for UA and DL airline with 1.000 records each. We need to bind these two samples into a unique dataset. Since both samples have the same variables (columns) we can easily bind them together by using "rbind()" function that will combine a vector, matrix, or data frame by rows.

``` r
> sample_all <- rbind(sample_DL, sample_UA)
> head(sample_all)
# A tibble: 6 x 3
  carrier arr_delay sample_id
  <chr>       <dbl> <chr>    
1 DL             39 1        
2 DL             36 1        
3 DL             32 1        
4 DL              6 1        
5 DL              4 1        
6 DL              0 1 

> dim(sample_all)
[1] 2000    3
```

Now we will calculate the confidence level (95%) for the DL sample.

For this, we will use the equation: standard deviation of delay column divide by the square root of DL sample size. It is used to calculate the standard deviation of a sample mean distribution, which can only be used when we are trying to obtain the standard deviation of the calculating means from a sample of size n.

For example, let's assume we are trying to get 10.000 samples from any population with a sample size of 2. Then, we will calculate the mean for each sample (we will have 10.000 calculate means). The previous equation for standard deviation shows us that if the sample size is bigger enough, the sample means standard deviation can be approximate by this mathematical relationship.

With some inferential conditions, such as random and independent samples, we can use this standard deviation to estimate the population standard deviation. Since this is only an estimate, it is called standard error (se). We can only estimate its value when the sample size is bigger than 30 (Central Limit Theorem) and the sample respect an interdependence condition, which implies in n <= 10% of population size.

First of all, let's calculate the standard error:

``` r
> se_DL = sd(sample_DL$arr_delay) / sqrt(nrow(sample_DL))
> se_DL
[1] 1.84913
```
To calculate the critical values for each tail, we will use the following equation:

<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Z-score_equation.png"
      alt = "Z-score_equation"
      style="width:400"/>

In this case, for interval confidence of 95%, the z-score is equal to 1,96. The standard error is equal to 1,84913. Now, we need our mean sample and to calculate the critical values for each tail. Remember, when we are dealing with the upper tail, the z-score is positive.

``` r
> limit_lower_DL = mean(sample_DL$arr_delay) - 1.96 * se_DL
> limit_upper_DL = mean(sample_DL$arr_delay) + 1.96 * se_DL

# We will store each limit in a unique vector:
ic_DL <- c(limit_lower_DL, limit_upper_DL)
mean(sample_DL$arr_delay)
ic_DL

> mean(sample_DL$arr_delay)
[1] 35.1
> ic_DL
[1] 31.47571 38.72429
```
For our sample, 35.1 minutes is the mean of flight delays for DL airline. The Confidence Interval goes from 31 minutes to 38 minutes, so, there is a 95% probability that population mean is between 31 and 38 minutes.

Let's do the same to UA airline dataset.

``` r
> se_UA = sd(sample_UA$arr_delay) / sqrt(nrow(sample_UA))
> se_UA
[1] 1.412869
> 
> limit_lower_UA = mean(sample_DL$arr_delay) - 1.96 * se_UA
> limit_upper_UA = mean(sample_DL$arr_delay) + 1.96 * se_UA

> ic_UA <- c(limit_lower_UA, limit_upper_UA)
> mean(sample_UA$arr_delay)
[1] 33.088
> ic_UA
[1] 32.33078 37.86922
```
What if we could plot both confidence intervals? 

``` r
# We will use "ddply()" function from the "plyr" package to select our sample, summarize it by "sample_id" column and calculate arr_delay mean.
> toPlot <- ddply(sample_all, ~sample_id,
+                 summarize,
+                 mean = mean(arr_delay))
> head(sample_all)
# A tibble: 6 x 3
  carrier arr_delay sample_id
  <chr>       <dbl> <chr>    
1 DL             39 1        
2 DL             36 1        
3 DL             32 1        
4 DL              6 1        
5 DL              4 1        
6 DL              0 1        
> head(toPlot)
  sample_id   mean
1         1 35.100
2         2 33.088

# Now, we will use the "mutate()" function to create two new columns in the sample, "upper" and "lower". Each one with the lower and upper critical value of confidence interval.
> toPlot = mutate(toPlot, lower = ifelse(toPlot$sample_id == 1, ic_DL[1], ic_UA[1]))
> toPlot = mutate(toPlot, upper = ifelse(toPlot$sample_id == 1, ic_DL[2], ic_UA[2]))
> head(toPlot)
  sample_id   mean    lower    upper
1         1 35.100 31.47571 38.72429
2         2 33.088 32.33078 37.86922

# We will use a point to represent mean value ("geom_point" and y = mean) and then create an error bar with the "geom_errorbar()" function, using critical values from a confidence interval.
> ggplot(toPlot, aes(x = sample_id, y = mean, colour = sample_id))+
+   geom_point()+
+   geom_errorbar(aes(ymin = lower, ymax = upper), width = .2)
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Confidence_Interval_Plot"
      alt = "Confidence_Interval_Plot"
      style="width:500"/>

Most of the data reside in the same confidence interval in the two samples, implying that both training and testing data came from the same population.

Let's create a hypothesis test to check if DL airline flights delay more than UA airline flights.
In this case, we have two hypotheses:

* H0 = There are no significant differences between DL and UA delays (delay mean differences equal to zero). Null Hypothesis.
* H1 = Delta flights delay more than those in UA (delay mean differences greater than zero). Alternative Hypothesis.

To test both Hypotheses,  we can use the T-Test.

William Sealy Gosset developed the T-Test in 1908. He used a pseudo name "Student" due to confidentiality matters, required by his employer (Guinness brewery) for who the use of statistics in the quality maintenance was considered a competitive advantage. The t-test has several variations and can be used to compare two (and only two) means with its variations related to the hypotheses to be tested.

<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/William_Sealy_Gosset.jpg"
      alt = "William Sealy Gosset"
      style="width:600;height:300px;" />

In R, we can use the function t.test() from the stats package to test both hypotheses.

``` r
> t.test(sample_DL$arr_delay, sample_UA$arr_delay, alternative = "greater")

	Welch Two Sample t-test

data:  sample_DL$arr_delay and sample_UA$arr_delay
t = 0.86459, df = 1868.9, p-value = 0.1937
alternative hypothesis: true difference in means is greater than 0
95 percent confidence interval:
 -1.817667       Inf
sample estimates:
mean of x mean of y 
   35.100    33.088 
```
The p-value measures the probability of making a mistake in rejecting the Null Hypothesis (H0), where it stems from the statistical distribution adopted. If the p-value is less than the significance level, then it is correct to reject the Null Hypothesis. The p-value is the probability that the test statistic assumes an extreme value regarding the observed value when H0 is true. We are working with a significance level of 0.05 (Confidence Level of 95%). Here are the rules to be considered in our Hypothesis Test:

* Low p value: strong empirical evidence against H0 (reject the null hypothesis)
* High p-value: little or none empirical evidence against H0

In this case, we have failed to reject the null hypothesis, because the p-value is greater than the significance value. So, there is a high probability of not exist a significant difference between delays in our confidence interval.

By considering our data, there is no statistical evidence that DL has more delays than UA airline.

Let's do the same, but now with B6 (JetBlue Airways) and EV (ExpressJet Airlines).

First of all, we will create an airline bar plot to see how its distribution.

``` r
> barr_carrier <- ggplot(flights,aes(x=as.factor(carrier), fill = as.factor(carrier))) + geom_bar()
> barr_carrier
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/All_Carriers"
      alt = "All_Carriers"
      style="width:600;height:300px;" />

If you want to use a non-graphical approach, the table function can work well.

``` r
> check_cont <- table(flights$carrier)
> check_cont

   9E    AA    AS    B6    DL    EV    F9    FL    HA    MQ    OO    UA    US 
18460 32729   714 54635 48110 54173   685  3260   342 26397    32 58665 20536 
   VX    WN    YV 
 5162 12275   601 

 > EV <- 54173/nrow(flights)
> EV
[1] 0.1608577
> 
> B6 <- 54635/nrow(flights)
> B6
[1] 0.1622295
```
EV and B6 observations represent 16% of all population data, which give us a reasonable to work with our samples.

Now, we will filter our dataset, with only EV and B6 airlines.

``` r
> pop_data <- na.omit(flights) %>%
+   select(carrier, arr_delay) %>%
+   filter(carrier %in% c("EV","B6"), arr_delay > 0) %>%
+   group_by(carrier) %>%
+   sample_n(15000) %>%
+   ungroup()

> head(pop_data)
# A tibble: 6 x 2
  carrier arr_delay
  <chr>       <dbl>
1 B6            168
2 B6            141
3 B6              3
4 B6              2
5 B6              1
6 B6             36

> str(pop_data)
tibble [30,000 x 2] (S3: tbl_df/tbl/data.frame)
 $ carrier  : chr [1:30000] "B6" "B6" "B6" "B6" ...
 $ arr_delay: num [1:30000] 168 141 3 2 1 36 13 16 100 5 ...
 - attr(*, "na.action")= 'omit' Named int [1:9430] 472 478 616 644 726 734 755 839 840 841 ...
  ..- attr(*, "names")= chr [1:9430] "472" "478" "616" "644" ...
```
Note, we cannot work with these samples because their size is greater than 10% of our population size. For example, the B6 population size is 54.635, implying that the sample size must be smaller than 5.463 to respect the Central Limit Theorem. We will filter our sampled data, splitting by carrier B6 and EV airline, and then we will randomly get 5000 records to our new sample.

``` r
> ev <- sample_n(filter(pop_data, carrier == "EV", arr_delay > 0), 5000)
> head(ev)
# A tibble: 6 x 2
  carrier arr_delay
  <chr>       <dbl>
1 EV            130
2 EV             33
3 EV              6
4 EV             36
5 EV             67
6 EV             24

> b6 <- sample_n(filter(pop_data, carrier == "B6", arr_delay > 0), 5000)
> head(b6)
# A tibble: 6 x 2
  carrier arr_delay
  <chr>       <dbl>
1 B6             63
2 B6             14
3 B6              1
4 B6              2
5 B6              4
6 B6             42
```
Now, we will calculate the standard error for each company sample and the confident limit along with its critical values.

``` r
> # Standard error and mean for EV airline:
> se = sd(ev$arr_delay) / sqrt(nrow(ev))
> mean(ev$arr_delay)
[1] 48.7102
> se
[1] 0.7958657
> 
> # Criticical values for EV airline:
> lower = mean(ev$arr_delay) - 1.96 * se
> upper = mean(ev$arr_delay) + 1.96 * se
> ic_ev = c(lower, upper)
> ic_ev
[1] 47.1503 50.2701
> 
> # Standard error and mean for B6 airline:
> se = sd(b6$arr_delay) / sqrt(nrow(b6))
> mean(b6$arr_delay)
[1] 40.2324
> se
[1] 0.6948826
> 
> # Critical values for B6 airline:
> lower = mean(b6$arr_delay) - 1.96 * se
> upper = mean(b6$arr_delay) + 1.96 * se
> ic_b6 = c(lower, upper)
> ic_b6
[1] 38.87043 41.59437
```

We can see that the population means for EV airlines should be between the values 47 and 50 minutes delay. The sample mean is equal to 48 minutes. Now, for the B6 airline, the population means should be between the values 38 and 41 minutes delay where the sample mean is equal to 40 minutes. Note that we use a z-score equal to 1.96, equivalent to a confidence level of 95%.

Ok, now we need to test our Hypothesis with the Student Test or T-Test.

``` r
> t.test(ev$arr_delay, b6$arr_delay, alternative = "greater")

	Welch Two Sample t-test

data:  ev$arr_delay and b6$arr_delay
t = 8.0242, df = 9819.4, p-value = 5.696e-16
alternative hypothesis: true difference in means is greater than 0
95 percent confidence interval:
 6.739792      Inf
sample estimates:
mean of x mean of y 
  48.7102   40.2324 
``` 

We can reject the Null Hypothesis because the p-value is smaller than the significance level (equal to 0,05).In this case, there is a high probability of a significant difference between the sample means to exist. For our data, there is statistical evidence showing EV flight delays more than B6 flights.

It is possible to prove this with a graphical approach. I mean, let's first see our data when we filtered the columns "carrier" and "arr_delay", without dividing it in "B6" and "EV":

``` r
> pop_data2 <- na.omit(flights) %>%
+   select(carrier, arr_delay) %>%
+   filter(arr_delay >0)

> dim(pop_data2)
[1] 133004      2
```
Our data has 133.004 records, so we can get 70.000 records and plot a scatter plot for each airline company with the corresponding arrives delay variable. In this case, we don't want to make any inferences over a certain population. We want to have a quick view of our variable distribution.

``` r
pop_data2 <- na.omit(flights) %>%
  select(carrier, arr_delay) %>%
  filter(arr_delay >0) %>%
  sample_n(70000)
  
allin <- ggplot(data=pop_data2,aes(x = as.factor(carrier), y = arr_delay,
colour = as.factor(carrier),size = arr_delay)) + geom_point()
allin
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/check_all_carriers"
      alt = "check_all_carriers"
      style="width:600;height:300px;" />
      
Or we could just have a scatter plot for the two airline companies sampled data B6 and EV.

``` r
> straight_point <- ggplot(data = pop_data, aes(x = as.factor(carrier), y = arr_delay,
+                             colour = as.factor(carrier), size = arr_delay)) +  geom_point()
> straight_point
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Statistical_Analysis_With_R:Hypothesis_Test/Images/Straight_Point"
      alt = "Straight Point"
      style="width:600;height:300px;" />

When we see both charts, the B6 airline has more delayed arrival flights than EV airline. Let's confirm that by analyzing the population data for both airline companies. What? Don't worry, because we will have 48.093 records that we can handle it.

``` r
> check_data <- ddply(pop_data, ~carrier,
+                 summarize,
+                 add = sum(arr_delay))
> check_data

  carrier     add
1      B6  944574
2      EV 1181808

> dim(pop_data)
[1] 48093     2
```
Fine, but why did we need to do all the Hypothesis data if we could decide by just looking for the population data? Well, imagine if you are handling billions of records, your computer or cluster can't treat all this data with a good performance. We are just doing this to show you that your Hypothesis test is correct. The correct way is to sample our data, respecting the Central Limit Theorem, after that we clean our data, and then do the Hypothesis test.

Our main goal with this little experiment is to show you how important it is to understand the data and define the business problem.

## Author

[<img src="https://avatars3.githubusercontent.com/u/47090012?s=460&u=0180e5d8646087e40786286006fc2505548b9e2a&v=4" width=200><br><sub>@meloandrew</sub>](https://github.com/meloandrew) | [<img 
