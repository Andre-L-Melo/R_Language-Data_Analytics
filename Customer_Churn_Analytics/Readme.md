<h1 align="center">CUSTOMER CHURN ANALYSIS</h1>
<div align="center">
  <p>
    <strong>Predict Customer Churn using R</strong>
  </p>
  <p>
    <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/bye_bye.png?raw=true" width="250" alt="customer">
  </p>
</div>

<div align="center">
  <a href="https://rstudio.com/" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/rstudio-v1.2.5-blue"/>

  <a href="https://www.rdocumentation.org/packages/caret/versions/6.0-86" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/caret-v6.0--86-blueviolet"/>

  <a href="https://www.rdocumentation.org/packages/randomForest/versions/4.6-14" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/randomforest-v4.6--14-blueviolet"/>

  <a href="https://www.rdocumentation.org/packages/lattice/versions/0.20-41" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/lattice-0.20--41-brightgreen"/>
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

## Customer Churn Analysis Using R
Our main goal is to work with Customer Churn Analysis. Churn is the same as turnover. When a client buys a product or hire a service, he/she probably will not keep it for all the eternity, so, in some moment the client will no longer be a client, that is what churn means.
Thereby, we will predict the Customer Churn based in historical data collected.
Who will be the next customer to turnover a product or service? After answering this question, we can define the best future strategy to be adopted.

The customer churn happens when a client or subscriber stop doing business with a company or service. It is also known as client loss or revocation rate. Knowing and predicting these revocation rates is particularly useful for the telecommunication industry, because most customers have several options to choose from within a geographic location. 

In this project we will predict de customer churn using a telecommunication dataset. We will use some of the many Machine Learning algorithms, such as logistic regression, decision tree and random forest. 

The dataset is offered by IBM Sample Data Sets.

Each dataset line represents a client and each column has all its features. 

### Understanding the Dataset

First of all, we will need to load and clean our dataset.

Our source will be a csv file, so, the function "read.csv" from R can be useful in this process.

Once the data is loaded, we will need to clean it before the Machine Learning process begin.

The first step is to install and load all the packages we are going to use in this project:

``` r
# Load the packages
library(plyr)
library(dplyr)
library(corrplot)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(caret) # Offers logistic regression and decision tree algorithms. You need to previously install the lattice package.
library(MASS)
library(randomForest) # Offers random forest algorithm
library(party) # Offers report tools
```

The package should be installed once, that is why we didn't include the command in the script.

Now, let's load our dataset
```r
# The raw data has 7043 lines (customers) and 21 columns (features).
# The "churn" columns is our target variable.
churn <- read.csv('06-Telco-Customer-Churn.csv', stringsAsFactors = TRUE)

# The column of interest has only categorical values, or factors, with only two levels: "yes" and "no". In other words, the client has canceled the service or no? 
head(churn,3)

  customerID   gender SeniorCitizen Partner Dependents tenure PhoneService
1 7590-VHVEG   Female     0          Yes      No        1           No
2 5575-GNVDE   Male       0          No       No        34          Yes
3 3668-QPYBK   Male       0          No       No        2          Yes
  MultipleLines InternetService OnlineSecurity OnlineBackup DeviceProtection
1 No phone service             DSL             No          Yes               No
2               No             DSL            Yes           No              Yes
3               No             DSL            Yes          Yes               No
  TechSupport StreamingTV StreamingMovies       Contract PaperlessBilling
1          No          No              No Month-to-month              Yes
2          No          No              No       One year               No
3          No          No              No Month-to-month              Yes
     PaymentMethod MonthlyCharges TotalCharges Churn
1 Electronic check          29.85        29.85    No
2     Mailed check          56.95      1889.50    No
3     Mailed check          53.85       108.15   Yes

# Let's check or dataset structure:
str(churn)

'data.frame':	7043 obs. of  21 variables:
 $ customerID      : Factor w/ 7043 levels "0002-ORFBO","0003-MKNFE",..: 5376 3963 2565 5536 6512 6552 1003 4771 5605 4535 ...
 $ gender          : Factor w/ 2 levels "Female","Male": 1 2 2 2 1 1 2 1 1 2 ...
 $ SeniorCitizen   : int  0 0 0 0 0 0 0 0 0 0 ...
 $ Partner         : Factor w/ 2 levels "No","Yes": 2 1 1 1 1 1 1 1 2 1 ...
 $ Dependents      : Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 2 1 1 2 ...
 $ tenure          : int  1 34 2 45 2 8 22 10 28 62 ...
 $ PhoneService    : Factor w/ 2 levels "No","Yes": 1 2 2 1 2 2 2 1 2 2 ...
 $ MultipleLines   : Factor w/ 3 levels "No","No phone service",..: 2 1 1 2 1 3 3 2 3 1 ...
 $ InternetService : Factor w/ 3 levels "DSL","Fiber optic",..: 1 1 1 1 2 2 2 1 2 1 ...
 $ OnlineSecurity  : Factor w/ 3 levels "No","No internet service",..: 1 3 3 3 1 1 1 3 1 3 ...
 $ OnlineBackup    : Factor w/ 3 levels "No","No internet service",..: 3 1 3 1 1 1 3 1 1 3 ...
 $ DeviceProtection: Factor w/ 3 levels "No","No internet service",..: 1 3 1 3 1 3 1 1 3 1 ...
 $ TechSupport     : Factor w/ 3 levels "No","No internet service",..: 1 1 1 3 1 1 1 1 3 1 ...
 $ StreamingTV     : Factor w/ 3 levels "No","No internet service",..: 1 1 1 1 1 3 3 1 3 1 ...
 $ StreamingMovies : Factor w/ 3 levels "No","No internet service",..: 1 1 1 1 1 3 1 1 3 1 ...
 $ Contract        : Factor w/ 3 levels "Month-to-month",..: 1 2 1 2 1 1 1 1 1 2 ...
 $ PaperlessBilling: Factor w/ 2 levels "No","Yes": 2 1 2 1 2 2 2 1 2 1 ...
 $ PaymentMethod   : Factor w/ 4 levels "Bank transfer (automatic)",..: 3 4 4 1 3 3 2 4 3 1 ...
 $ MonthlyCharges  : num  29.9 57 53.9 42.3 70.7 ...
 $ TotalCharges    : num  29.9 1889.5 108.2 1840.8 151.7 ...
 $ Churn           : Factor w/ 2 levels "No","Yes": 1 1 2 1 2 2 1 1 2 1 ...
```
The "Churn" column tells us if the customer canceled the service or no.

To know more about this data or the info it gives us, the Data Scientist or Data Analyst should consult the business area to learn more about it.

So, we have 20 predictor variables and 1 target variable.

### Loading and Cleaning Data

We have already undertood our dataset, now, we can clean and transform it.

This work does not follow a script. A dataset will never be like other, because a problem will never be the same. So, we do not have a "cake recipe" to be follow.

Of course, we still have a macro structure to be considered:

* Load the data
* Clean the data
* Exploratory Data Analysis
* Feature Selection
* Predictive Modeling
* Model Evaluation

These steps will always exist, but inside of each one of them there are multiple techniques, process, procedures and tools that can be used according to the problem and the dataset.

**1º Change:** Our first task is to remove any NA value or Missing Values in our dataset.

```r
# First, we will use the sapply() function, one of the many from the apply family. The apply family provides functions that replace the use of loops, but in a more efficient way, for example, the sapply function is great when we are trying to work with vectors and lists. In this case we are going to apply a function to each element of list, this function will sum all NA values for each column. This will be useful to know where the Missing Values are.
sapply(churn,function(x) sum (is.na(x)))

      customerID           gender    SeniorCitizen          Partner 
               0                0                0                0 
      Dependents           tenure     PhoneService    MultipleLines 
               0                0                0                0 
 InternetService   OnlineSecurity     OnlineBackup DeviceProtection 
               0                0                0                0 
     TechSupport      StreamingTV  StreamingMovies         Contract 
               0                0                0                0 
PaperlessBilling    PaymentMethod   MonthlyCharges     TotalCharges 
               0                0                0               11 
           Churn 
               0 
# Now we know that the column "Totalcharges" has 11 NA values. 
# We will use the function "complete.cases". This function returns a logical vector indicating only the completed cases. In this case, we want all the columns and only the rows where "complete.cases" returns TRUE.
churn <- churn[complete.cases(churn),]

# We don't have NA values anymore.
sapply(churn,function(x) sum (is.na(x)))
      customerID           gender    SeniorCitizen          Partner 
               0                0                0                0 
      Dependents           tenure     PhoneService    MultipleLines 
               0                0                0                0 
 InternetService   OnlineSecurity     OnlineBackup DeviceProtection 
               0                0                0                0 
     TechSupport      StreamingTV  StreamingMovies         Contract 
               0                0                0                0 
PaperlessBilling    PaymentMethod   MonthlyCharges     TotalCharges 
               0                0                0                0 
           Churn 
               0 
```
If we look to our variables, we will see that some changes are still needed.

**2º Change:** We will replace the sentence "No internet service" with "No" in six differents columns.

* OnlineSecurity
* OnlineBackup
* DeviceProtection
* TechSupport
* StreamingTV
* StreamingMovies

All the six columns are align in sequence, going from index 10 to index 15. 

We can create a loop that will replace the values in each columns so as we desire. First, let's create a vector which will store a range of values going from 10 to 15.
```r
cols_recode1 <- c(10:15)
```
Now, we will create a loop "for" to check all the elements in these 6 columns. We will replace all values equal to "No internet services" with "No", using the function "mapvalues()" and converting the value type to a factor.

``` r
for(i in 1:ncol(churn[,cols_recode1])){
  churn[,cols_recode1][,i] <- as.factor(mapvalues
                                        (churn[,cols_recode1][,i],
                                          from = c("No internet service"),
                                          to = c("No")))
}

head(churn, 3)

  customerID gender SeniorCitizen Partner Dependents tenure PhoneService
1 7590-VHVEG Female             0     Yes         No      1           No
2 5575-GNVDE   Male             0      No         No     34          Yes
3 3668-QPYBK   Male             0      No         No      2          Yes
     MultipleLines InternetService OnlineSecurity OnlineBackup DeviceProtection
1 No phone service             DSL             No          Yes               No
2               No             DSL            Yes           No              Yes
3               No             DSL            Yes          Yes               No
  TechSupport StreamingTV StreamingMovies       Contract PaperlessBilling
1          No          No              No Month-to-month              Yes
2          No          No              No       One year               No
3          No          No              No Month-to-month              Yes
     PaymentMethod MonthlyCharges TotalCharges Churn
1 Electronic check          29.85        29.85    No
2     Mailed check          56.95      1889.50    No
3     Mailed check          53.85       108.15   Yes
```

**3º Change:** We will need to change "No phone service" to "No" in the column "MultipleLines".

``` r
churn$MultipleLines <- as.factor(mapvalues(churn$MultipleLines,
                                           from = c("No phone service"),
                                           to = c("No")))

head(churn, 3)

  customerID gender SeniorCitizen Partner Dependents tenure PhoneService
1 7590-VHVEG Female             0     Yes         No      1           No
2 5575-GNVDE   Male             0      No         No     34          Yes
3 3668-QPYBK   Male             0      No         No      2          Yes
  MultipleLines InternetService OnlineSecurity OnlineBackup DeviceProtection
1            No             DSL             No          Yes               No
2            No             DSL            Yes           No              Yes
3            No             DSL            Yes          Yes               No
  TechSupport StreamingTV StreamingMovies       Contract PaperlessBilling
1          No          No              No Month-to-month              Yes
2          No          No              No       One year               No
3          No          No              No Month-to-month              Yes
     PaymentMethod MonthlyCharges TotalCharges Churn
1 Electronic check          29.85        29.85    No
2     Mailed check          56.95      1889.50    No
3     Mailed check          53.85       108.15   Yes
```
**4º Change:** The "tenure" column is related to the lenght period the customer had the service. The minimum lenght period is 1 month and the maximum is 72 months. Well, we can split it into 5 different groups, like.
* 0 - 12 
* 12 - 24
* 24 - 48
* 48 - 60
* greater than 60

Let's check in our dataset what is the minimum and the maximum value in the column "tenure":

``` r
min(churn$tenure); max(churn$tenure)
[1] 1
[1] 72
```

Great, the minimum value is 1 month and the maximum value is 72 month.

Now, we can start our work to classify our data.

First, we will create a function named "group_tenure" that will received a value and then classify it according to a coditional statement. After that, this function will be applied to the column "tenure", where the result is going to be convert to a factor type and stored it in a new column named "tenure_group".

``` r
group_tenure <- function(tenure) {
  if(tenure>= 0 & tenure <= 12){
    return('0-12 Month')
  } else if(tenure > 12 & tenure <= 24){
    return('12-24 Month')
  } else if (tenure > 24 & tenure <= 48){
    return('24-48 Month')
  } else if (tenure > 48 & tenure <= 60){
    return('48-60 Month') 
  } else if (tenure > 60){
    return('> 60 Month')
  }
}

churn$tenure_group <- sapply(churn$tenure, group_tenure)
churn$tenure_group <- as.factor(churn$tenure_group)
str(churn$tenure_group)

 Factor w/ 5 levels "> 60 Month","0-12 Month",..: 2 4 2 4 2 2 3 2 4 1 ...
```
**5º Change:** Another replacement task. In the column "SeniorCitizen" we will replace the value 0 and 1 to "No" and "Yes". Let's use the function "mapvalues()" for this.

``` r
churn$SeniorCitizen <- as.factor(mapvalues(churn$SeniorCitizen,
                                           from = c("0","1"),
                                           to = c("No","Yes")))
str(churn$SeniorCitizen)
Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 1 1 1 1 ...
```
**6º Change:**  We will remove the columns that are unnecessary for modeling process. Usually, the ID column doesn't need to be used because it is a unique identifier, being an irrelevant information. We will also remove the "tenure" column, because we already have the "tenure_group" column.
``` r
churn$customerID <- NULL
churn$tenure <- NULL
head(churn, 2)
  gender SeniorCitizen Partner Dependents PhoneService MultipleLines
1 Female            No     Yes         No           No            No
2   Male            No      No         No          Yes            No
  InternetService OnlineSecurity OnlineBackup DeviceProtection TechSupport
1             DSL             No          Yes               No          No
2             DSL            Yes           No              Yes          No
  StreamingTV StreamingMovies       Contract PaperlessBilling    PaymentMethod
1          No              No Month-to-month              Yes Electronic check
2          No              No       One year               No     Mailed check
  MonthlyCharges TotalCharges Churn tenure_group
1          29.85        29.85    No   0-12 Month
2          56.95      1889.50    No  24-48 Month
```

### Exploratory Analysis and Feature Selection

The Exploratory Analysis can be done before cleaning the data, in order to detect problems in our dataset, but it is not mandatory.

During this phase, we search for relations between the variables.

Let's begin with numerical variables.

To check which variables in our dataset are numerical, we use the function "is.numeric" applied to our dataset.

``` r
numeric.var <- sapply(churn, is.numeric)
numeric.var

          gender    SeniorCitizen          Partner       Dependents 
           FALSE            FALSE            FALSE            FALSE 
    PhoneService    MultipleLines  InternetService   OnlineSecurity 
           FALSE            FALSE            FALSE            FALSE 
    OnlineBackup DeviceProtection      TechSupport      StreamingTV 
           FALSE            FALSE            FALSE            FALSE 
 StreamingMovies         Contract PaperlessBilling    PaymentMethod 
           FALSE            FALSE            FALSE            FALSE 
  MonthlyCharges     TotalCharges            Churn     tenure_group 
            TRUE             TRUE            FALSE            FALSE 
```

We can see that the columns "MonthlyCharges" and "TotalCharges" are numerical variables.

Our next goal is to look for some correlation between these two variables. Correlation is the scale version of covariance, assuming values between -1 and 1, it is used to measure relation between numerical variables. By its values, we can make the following assumptions:

* Equal to 1: Perfect correlation between the variables, so they are directly proportional and linearly dependent.
* Equal to -1: Perfect correlation between the variables, but they are inversely proportional and linearly dependent.
* Equal to 0: There is no correlation at all between the variables.

Remember, correlation is different from causality, one variable does not necessarly change another variable.

In R, we can use a correlation matrix, generated by the function cor().

``` r
corr.matrix <- cor(churn[,numeric.var])
corr.matrix

               MonthlyCharges TotalCharges
MonthlyCharges      1.0000000    0.6510648
TotalCharges        0.6510648    1.0000000
```
Note that we have a Correlation Matrix with a coefficient equal to 0.6510648. This indicates a strong positive correlation between both variables. 

We can also plot the Correlation Matrix by using the function "corrplot()":

``` r
corrplot(corr.matrix,main="\n\nNumerical Variable Correlation Chart", col = cm.colors(100), tl.col = "black")
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Correlation_Matrix"
      alt = "Correlation Matrix"
      style="width:600px;height:300px;"/>

If we include both variables to train our predictive model, we can have a problem of Over Fitting, because these two variables have a strong correlation, in other words, they can represent the same info. Because of that, we will have to remove one of the variables, in this case, let's remove the variable "TotalCharges":

``` r
churn$TotalCharges <- NULL
```
Ok, now we can check how our categorical variables are distributed.

Why can't we use a graphical approach? Actually, we can!

We will use the package *ggplot2*. Four categorical variables are going to be represented in a bar chart. These are: Gender, SeniorCitizen, Partner and Dependents. In this case, to create the bar chart, we will use a percentual value for coordinate "y" given by dividing a specific category total by the total amount of observed values.

``` r
# GENDER:
p1 <- ggplot(churn, aes(x=gender)) + ggtitle("Gender") + xlab("Sex") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "red", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# SENIOR CITIZEN:
p2 <- ggplot(churn, aes(x=SeniorCitizen)) + ggtitle("Senior Citizen") + xlab("Senior Citizen") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "blue", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# PARTNER:
p3 <- ggplot(churn, aes(x=Partner)) + ggtitle("Partner") + xlab("Partner") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "aquamarine", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# DEPENDENTS:
p4 <- ggplot(churn, aes(x=Dependents)) + ggtitle("Dependents") + xlab("Dependents") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "plum", alpha = 0.8) +
  ylab("Percentage") + coord_flip() + theme_minimal()

grid.arrange(p1, p2, p3, p4, ncol=2)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Bar_Chart_1"
      alt = "Bar Chart 1"
      style="width:600px;height:300px;"/>

The variable SeniorCitizen does not have a reasonably wide distribution, but for now we will maintain it in our dataset.

Let's do the same with the variables PhoneService, MultipleLines, InternetService and OnlineSecurity.

``` r
# PHONESERVICE:
p5 <- ggplot(churn, aes(x=PhoneService)) + ggtitle("Phone Service") + xlab("Phone Service") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "wheat1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# MULTIPLELINES:
p6 <- ggplot(churn, aes(x=MultipleLines)) + ggtitle("Multiple Lines") + xlab("Multiple Lines") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "lightgreen", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# INTERNETSERVICE:
p7 <- ggplot(churn, aes(x=InternetService)) + ggtitle("Internet Service") + xlab("Internet Service") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "slategray1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# ONLINESECURITY:
p8 <- ggplot(churn, aes(x=OnlineSecurity)) + ggtitle("Online Security") + xlab("Online Security") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "mistyrose1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

grid.arrange(p5, p6, p7, p8, ncol=2)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Bar_Chart_2"
      alt = "Bar Chart 2"
      style="width:600px;height:300px;"/>

The variable PhoneService does not show a good distribution, but let's keep it that way and continue our analysis.

We will check more 4 variables: OnlineBackup, DeviceProtection, TechSupport and StreamingTV.

``` r
# ONLINEBACKUP:
p9 <- ggplot(churn, aes(x=OnlineBackup)) + ggtitle("Online Backup") + xlab("Online Backup") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5,fill = "orangered1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# DEVICEPROTECTION:
p10 <- ggplot(churn, aes(x=DeviceProtection)) + ggtitle("Device Protection") + xlab("Device Protection") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5,fill = "orchid1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# TECHSUPPORT:
p11 <- ggplot(churn, aes(x=TechSupport)) + ggtitle("Tech Support") + xlab("Tech Support") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5,fill = "palegreen", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# STREAMINGTV:
p12 <- ggplot(churn, aes(x=StreamingTV)) + ggtitle("Streaming TV") + xlab("Streaming TV") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5,fill = "azure2") + 
  ylab("Percentage") + coord_flip() + theme_minimal()

grid.arrange(p9, p10, p11, p12, ncol=2)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Bar_Chart_3"
      alt = "Bar Chart 3"
      style="width:600px;height:300px;"/>

Let's check the next 5 variables: StreamingMovies, Contract, PaperlessBilling, PaymentMethod and tenure_group.

``` r
# STREAMINGMOVIES:
p13 <- ggplot(churn, aes(x=StreamingMovies)) + ggtitle("Streaming Movies") + xlab("Streaming Movies") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "chocolate1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# CONTRACT:
p14 <- ggplot(churn, aes(x=Contract)) + ggtitle("Contract") + xlab("Contract") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "brown1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# PAPERLESSBILLING:
p15 <- ggplot(churn, aes(x=PaperlessBilling)) + ggtitle("Paperless Billing") + xlab("Paperless Billing") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "coral1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# PAYMENTMETHOD:
p16 <- ggplot(churn, aes(x=PaymentMethod)) + ggtitle("Payment Method") + xlab("Payment Method") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "darkgoldenrod1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

# TENURE_GROUP:
p17 <- ggplot(churn, aes(x=tenure_group)) + ggtitle("Tenure Group") + xlab("Tenure Group") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "bisque2", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()

grid.arrange(p13, p14, p15, p16, p17, ncol=2)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Bar_Chart_4"
      alt = "Bar Chart 4"
      style="width:600px;height:300px;"/>

Although we have seen some variables with bad distribution, like for example, SeniorCitizen and PhoneService, we will keep them in our dataset. The rest of the variables presented a reasonably wide distribution.

### Predictive Model With Logistic Regression

We have already done a cleaning process in our dataset and a small exploratory analysis, therefore, we are ready to create our machine learning model.

We can, when working with predictive models, use one of over 60 machine learning algorithms. Ok, but which algorithm will we use? It will depend on the business problem. If the problem is about classification, then we will use algorithms for classification, such as random forest and decision tree. If the problem is about regression, then we can use neural networks, linear regression, among others.

You can use more than one algoritm in your project. We could train multiples algorithms, analyze each one performance and then, choose the algorithm that had better accuracy. 

First, we will use the logistic regression model, perfect for classification problems.

Let's split our data into two different groups: train_data and test_data. The train_data will be used to train our model and the test_data will validate its accuracy. To do that, the proportion will be 70% of original data for train_data and 30% for test_data, of course we will do a random split, this is important in order to avoid biased models.

In R, we have the function *createDataPartition* from **caret package**, which is one of the best package to work with machine learning. The function "set.seed()" is also important so you can obtain the same results as mine. 

``` r
set.seed(2017)
intrain <- createDataPartition(churn$Churn, p=0.7, list = FALSE)
class(intrain) 
[1] "matrix" "array" 

training <- churn[intrain,]
testing <- churn[-intrain,]

# Evaluate the division:
dim(training)
dim(testing)
[1] 4924   19
[1] 2108   19
``` 
Ok, now we have two different datasets.

The logistic regression algorithm can be found in the function *glm* which is used to adept widespread linear models. It expects as a parameter a target variable expression (in this case, the Churn variable relating with the others predictor variables), the distribution error (considering a binomial parameter with logistic regression) and the training dataset.

``` r
LogModel <- glm(Churn ~., family = binomial(link="logit"), data = training)
print(summary(LogModel))
Call:
glm(formula = Churn ~ ., family = binomial(link = "logit"), data = training)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.9383  -0.6755  -0.2983   0.6878   3.0776  

Coefficients:
                                      Estimate Std. Error z value Pr(>|z|)    
(Intercept)                          -0.809621   0.982867  -0.824  0.41009    
genderMale                           -0.027853   0.077355  -0.360  0.71879    
SeniorCitizenYes                      0.185995   0.099795   1.864  0.06235 .  
PartnerYes                           -0.008472   0.092476  -0.092  0.92701    
DependentsYes                        -0.136396   0.106380  -1.282  0.19979    
PhoneServiceYes                       0.669190   0.776088   0.862  0.38854    
MultipleLinesYes                      0.451411   0.209906   2.151  0.03151 *  
InternetServiceFiber optic            2.358699   0.954358   2.472  0.01345 *  
InternetServiceNo                    -2.185139   0.964047  -2.267  0.02341 *  
OnlineSecurityYes                    -0.136715   0.211886  -0.645  0.51878    
OnlineBackupYes                       0.064912   0.209047   0.311  0.75617    
DeviceProtectionYes                   0.309254   0.211474   1.462  0.14364    
TechSupportYes                        0.030998   0.217421   0.143  0.88663    
StreamingTVYes                        0.815694   0.390059   2.091  0.03651 *  
StreamingMoviesYes                    0.742469   0.390137   1.903  0.05703 .  
ContractOne year                     -0.720719   0.126103  -5.715 1.10e-08 ***
ContractTwo year                     -1.575616   0.216041  -7.293 3.03e-13 ***
PaperlessBillingYes                   0.376015   0.088978   4.226 2.38e-05 ***
PaymentMethodCredit card (automatic)  0.084524   0.136987   0.617  0.53722    
PaymentMethodElectronic check         0.480168   0.113172   4.243 2.21e-05 ***
PaymentMethodMailed check             0.144513   0.136064   1.062  0.28819    
MonthlyCharges                       -0.056179   0.037919  -1.482  0.13846    
tenure_group0-12 Month                1.799061   0.205465   8.756  < 2e-16 ***
tenure_group12-24 Month               0.953339   0.201605   4.729 2.26e-06 ***
tenure_group24-48 Month               0.601146   0.185380   3.243  0.00118 ** 
tenure_group48-60 Month               0.447994   0.196632   2.278  0.02271 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 5702.8  on 4923  degrees of freedom
Residual deviance: 4116.3  on 4898  degrees of freedom
AIC: 4168.3

Number of Fisher Scoring iterations: 6
```
Note that, the deviance residuals represent the square root of the contribution that each data point has to the overall Residual Deviance. Thus, deviance residuals are analogous to the residuals in ordinary least squares. When we square these residuals, we get the Sums of Squares used to asses how well a model fits the data. 

For Logistic Regression the equation for deviance residuals is based on the distances between the data and the best fitting line. We usually use them to identify outliers.

Imagine a Logistic Regression as a function. The point where this function intercept y is called "Intercept", in this case is equal to -0.809621. Then when have the Standard Error, equal to 0.9828, the z - value (estimated intercept divided by the standard error) equal to -0.824 and the p-value (the area under a standard normal curve that is further than -0.824 standard deviations away from 0. ).

The second coefficient is the slope, it means that for every change in the customer gender, the log(odds of churn) decreases by 0.027853.

So, we considered that, these variables that present a z-value greater than 2 (or -2), normaly will have a small p-value, and so, are significant to our target variable.

### Variance Analysis with ANOVA

An algorithm is nothing more than a step sequence to be executed towards a problem. When you executed a Machine Learning algorithm, what you obtain is a mathematical equation, that needs to be completed with its coefficients. To obtain this complete mathematical equation, we need to feed the algorithm with data, in other words, train the algorithm. During the training, the algorithm will find the best coefficients to completed its equation.

So, in the previous step we have trained an algorithm with all features from the original data (after the cleaning process, of course). 

But, the question is, how do we know which are the best variables?

Well, to answer that question we can do some Variance Analysis, where it is possible to check which are the most important variables for our Machine Learning Model.

R has a function called *ANOVA* which is used to compute variance analysis for one or more predictive models.

``` r
anova(LogModel, test="Chisq")

Analysis of Deviance Table

Model: binomial, link: logit

Response: Churn

Terms added sequentially (first to last)


                 Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
NULL                              4923     5702.8              
gender            1     0.49      4922     5702.3   0.48221    
SeniorCitizen     1    92.64      4921     5609.6 < 2.2e-16 ***
Partner           1   115.56      4920     5494.1 < 2.2e-16 ***
Dependents        1    30.17      4919     5463.9 3.949e-08 ***
PhoneService      1     1.04      4918     5462.8   0.30699    
MultipleLines     1     4.05      4917     5458.8   0.04418 *  
InternetService   2   486.64      4915     4972.1 < 2.2e-16 ***
OnlineSecurity    1   176.91      4914     4795.2 < 2.2e-16 ***
OnlineBackup      1    85.36      4913     4709.9 < 2.2e-16 ***
DeviceProtection  1    34.77      4912     4675.1 3.703e-09 ***
TechSupport       1    66.84      4911     4608.3 2.939e-16 ***
StreamingTV       1     1.31      4910     4606.9   0.25177    
StreamingMovies   1     0.00      4909     4606.9   0.96551    
Contract          2   279.88      4907     4327.1 < 2.2e-16 ***
PaperlessBilling  1    17.83      4906     4309.2 2.415e-05 ***
PaymentMethod     3    46.09      4903     4263.1 5.431e-10 ***
MonthlyCharges    1     2.41      4902     4260.7   0.12026    
tenure_group      4   144.44      4898     4116.3 < 2.2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Analyzing the variance, we can see that the Deviance Residual decreases as we add more variables, one at a time. For example, when we add InternetService, Contract and tenure_group, the Deviance Residual decreases drastically, they also have a small p-value.
The other variables, such as PaymentMethod and Dependents, improve the model in a lower rate, although their p-value is small.

Ok, now let's check our model accuracy. First of all, let's see its precision level:

``` r
# The variable "Churn" will be converted to "char" and then, we will replace the text with numbers.
testing$Churn <- as.character(testing$Churn)
testing$Churn[testing$Churn=="No"] <- "0"
testing$Churn[testing$Churn=="Yes"] <- "1"
head(testing, 3)

  gender SeniorCitizen Partner Dependents PhoneService MultipleLines
1 Female            No     Yes         No           No            No
2   Male            No      No         No          Yes            No
5 Female            No      No         No          Yes            No
  InternetService OnlineSecurity OnlineBackup DeviceProtection TechSupport
1             DSL             No          Yes               No          No
2             DSL            Yes           No              Yes          No
5     Fiber optic             No           No               No          No
  StreamingTV StreamingMovies       Contract PaperlessBilling
1          No              No Month-to-month              Yes
2          No              No       One year               No
5          No              No Month-to-month              Yes
     PaymentMethod MonthlyCharges Churn tenure_group
1 Electronic check          29.85     0   0-12 Month
2     Mailed check          56.95     0  24-48 Month
5 Electronic check          70.70     1   0-12 Month

# Using the function "predict()" we pass the data for testing and the predictive model. 
fitted.results <- predict(LogModel,newdata=testing,type='response')

# We know that the model will hardly predict a value equal to 1 and 0, so, we create a conditional statement where values greater than 0.5 will be round to 1, otherwise, they will be equal to 0.
fitted.results <- ifelse(fitted.results > 0.5,1,0)

# We will find a mean of all the values predicted that are different from the test dataset.
misClasificError <- mean(fitted.results != testing$Churn)

# Now, we can see our model accuracy:
print(paste('Logistic Regression Accuracy',1-misClasificError))

[1] "Logistic Regression Accuracy 0.80977229601518"
```
By using this model we have obtained an accuracy level of 80%, which means that, for every 100 records, our model gets 80 right. Of course, the accuracy level depends on the project, it is a metric that must be defined on the business case, before starting the project.

Let's print the Confusion Matrix, that basicaly shows how our model did the predictions. It creates a relation between successes and mistakes. Have you ever heard of False Positive and False Negative? Well, I believe the image below will help you understand:

 <img src="https://miro.medium.com/max/675/0*3VJ0eMdSaifXrCeP.png"
      alt = "Confusion Matrix"
      style="width:300;height:250px;"/>

So, what we will get is the relation of scores and mistakes did by our model.

``` r
library(gmodels)

CrossTable(fitted.results, testing$Churn, prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE, dnn = c("predicted", "actual"))

   Cell Contents
|-------------------------|
|                       N |
|           N / Col Total |
|-------------------------|

 
Total Observations in Table:  2108 

 
             | actual 
   predicted |         0 |         1 | Row Total | 
-------------|-----------|-----------|-----------|
           0 |      1416 |       269 |      1685 | 
             |     0.915 |     0.480 |           | 
-------------|-----------|-----------|-----------|
           1 |       132 |       291 |       423 | 
             |     0.085 |     0.520 |           | 
-------------|-----------|-----------|-----------|
Column Total |      1548 |       560 |      2108 | 
             |     0.734 |     0.266 |           | 
-------------|-----------|-----------|-----------|
```
Okay, we were not too bad, even though we still had more thing to do in Exploratory Analysis phase. 
Maybe we will give it another try later.

Hey, we still have one more thing to do with this model, check the Odds Ratio. The Odds Ratio it is the likelihood of an event happening. 

``` r
exp(cbind(OR=coef(LogModel), confint(LogModel)))

                                             OR      2.5 %     97.5 %
(Intercept)                           0.4450265 0.06475483  3.0548888
genderMale                            0.9725310 0.83568637  1.1317700
SeniorCitizenYes                      1.2044168 0.99020231  1.4644001
PartnerYes                            0.9915639 0.82724303  1.1887862
DependentsYes                         0.8724973 0.70779273  1.0741676
PhoneServiceYes                       1.9526554 0.42693371  8.9526262
MultipleLinesYes                      1.5705268 1.04122031  2.3713357
InternetServiceFiber optic           10.5771862 1.63411055 68.9350634
InternetServiceNo                     0.1124621 0.01695684  0.7430277
OnlineSecurityYes                     0.8722184 0.57555751  1.3210161
OnlineBackupYes                       1.0670655 0.70838058  1.6078666
DeviceProtectionYes                   1.3624083 0.90036906  2.0632000
TechSupportYes                        1.0314831 0.67339409  1.5794967
StreamingTVYes                        2.2607431 1.05354012  4.8627249
StreamingMoviesYes                    2.1011169 0.97891350  4.5196508
ContractOne year                      0.4864024 0.37884962  0.6212757
ContractTwo year                      0.2068801 0.13354547  0.3120785
PaperlessBillingYes                   1.4564685 1.22382101  1.7347466
PaymentMethodCredit card (automatic)  1.0881985 0.83179606  1.4234775
PaymentMethodElectronic check         1.6163463 1.29611918  2.0202126
PaymentMethodMailed check             1.1554768 0.88553808  1.5098507
MonthlyCharges                        0.9453702 0.87755518  1.0182293
tenure_group0-12 Month                6.0439670 4.05873014  9.0875398
tenure_group12-24 Month               2.5943566 1.75405640  3.8686909
tenure_group24-48 Month               1.8242075 1.27364367  2.6363913
tenure_group48-60 Month               1.5651696 1.06647470  2.3074728
```
Note that, some of these variables presented OR greater than 1, which means that the comparison outcome is more likely than the reference outcome as the predictor increases. For example, if the MonthlyCharges increases its values, lower is the customer churn probability, in other words, if the client pays more for the service greater are her/his odds to keep the service. 

### Predictive Model with Decision Tree

This is an interesting algorithm, because we use it everyday in our lives. When you wake up, you decide to either take a bus or a subway to work, in this moment you are using a decision tree to make this choice. If by any chance you go to work by car, you will arrive in 50 minutes, if you take the subway you will arrive in 30 minutes. Each decision you make leaves to another.

We need to define the decision tree, that is why we will use the "ctree()" function. It creates conditional inference decision trees. In order to train our model, we will use only three predictors:

* Contract
* tenure_group
* PaperlessBilling

These variables are the most important among the others for our model, this was proved using ANOVA Analysis, although the analysis has been based in a logistic regression model.

``` r
tree <- ctree(Churn ~ Contract+tenure_group+PaperlessBilling, training)
plot(tree, type='simple')
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Decision_Tree"
      alt = "Decision Tree"
      style="width:600;height:300px;"/>

Interpreting the model:

* The contract is the most important variable to predict client turnover.
* If a client has a one or two years contract, it doesn't matter if she/he has or hasn't a PaperlessBilling, he/she is less likely to cancel subscription.
* On the other hand, if a client has a month-to-month contract, and has a 0-12 month tenure contract, then the PaperlessBilling will influence in a turnover decision.

Nice, let's check our model accuracy:

``` r
pred_tree <- predict(tree, testing)

CrossTable(pred_tree, testing$Churn, prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE, dnn = c("predicted", "actual"))

   Cell Contents
|-------------------------|
|                       N |
|           N / Col Total |
|-------------------------|

 
Total Observations in Table:  2108 

 
             | actual 
   predicted |         0 |         1 | Row Total | 
-------------|-----------|-----------|-----------|
          No |      1389 |       333 |      1722 | 
             |     0.897 |     0.595 |           | 
-------------|-----------|-----------|-----------|
         Yes |       159 |       227 |       386 | 
             |     0.103 |     0.405 |           | 
-------------|-----------|-----------|-----------|
Column Total |      1548 |       560 |      2108 | 
             |     0.734 |     0.266 |           | 
-------------|-----------|-----------|-----------|

# Predict target values based on training data
p1 <- predict(tree, training)
tab1 <- table(Predicted = p1, Actual = training$Churn)
tab2 <- table(Predicted = pred_tree, Actual = testing$Churn)
print(paste('Decision Tree Accuracy',sum(diag(tab2))/sum(tab2)))

[1] "Decision Tree Accuracy 0.766603415559772"

```

The accuracy level for this model is lower than for the logistic regression model.

### Predictive Model with Random Forest

The Random Forest algorithm is a set of Decison Trees. Basically, we have various decison trees within the same algorithm, working side-by-side, in the end, a mean is taken from all the decison tree results in order to obtain the best prediction. We can say that the trees protect each other from their individual erros, so we have a bunch of uncorrelated models working together in the same portfolio. 


``` r
set.seed(2017)

# The randomForest function() creates an algorithm for classification and regression problems.

# It can also be used to created unsupervised models that evaluate approximations between data points.

# To create the predictive model we need the training data. So let's use all the previous resources and the target variable.

rfModel <- randomForest(Churn~.,data = training)
print(rfModel)

Call:
 randomForest(formula = Churn ~ ., data = training) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 4

        OOB estimate of  error rate: 21.22%
Confusion matrix:
      No Yes class.error
No  3241 374   0.1034578
Yes  671 638   0.5126050


# Random Forest Type: classification
# Number of trees: 500
# Accuracy: 78.78%
plot(rfModel)
``` 
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Random_Forest"
      alt = "Random_Forest"
      style="width:600;height:300px;"/>

Note that, the error rate is high when the model is starting to learn, but after a few "classes" the error stabilizes until it reaches a plateau shape, at this point we can't do anything to improve the error rate.

Let's predict the testing values with our model.

``` r
# Predicting values with the training data:
pred_rf <- predict(rfModel, testing)

# Confusion Matrix
CrossTable(pred_rf, testing$Churn, prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE, dnn = c("predicted", "actual"))

   Cell Contents
|-------------------------|
|                       N |
|           N / Col Total |
|-------------------------|

 
Total Observations in Table:  2108 

 
             | actual 
   predicted |         0 |         1 | Row Total | 
-------------|-----------|-----------|-----------|
          No |      1387 |       284 |      1671 | 
             |     0.896 |     0.507 |           | 
-------------|-----------|-----------|-----------|
         Yes |       161 |       276 |       437 | 
             |     0.104 |     0.493 |           | 
-------------|-----------|-----------|-----------|
Column Total |      1548 |       560 |      2108 | 
             |     0.734 |     0.266 |           | 
-------------|-----------|-----------|-----------|
```

There is one more important resource: **varImpPlot**

With this function we can check how important a variable is. Note that, we have used all the model variables, in other words, everything that is not our target variable. Again, will all these variables impact in our model decision?

We can use ANOVA or randomforest model to answer this question.

This specific function *varImpPlot* will look to our model and search for the most important variables in prediction calculations.

``` r
varImpPlot(rfModel, sort=T, n.var = 10, main = 'Top 10 Feature Importance')
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Customer_Churn_Analytics/Images/Variable_Importance"
      alt = "Random Importance"
      style="width:600;height:300px;"/>

When we look to the chart, it is noticeable that MonthlyCharges, ternure_group and Contract are the most important variables for this model. 

## Conclusion

After all this, what model would you choose as a final version? 

I believe the logistic regression had shown a better accuracy than the other two algorithms. 

But, we need to have in mind that this is only the iceberg tip, we are only scrathing the surface, there are inumerous thing we can do to improve our model accuracy, such as, check data normalization, adjust data scale or remove some unimportant variables, even check for outliers in our numerical variables is something worth doing.

When we create a Machine Learning Project, we are actually working with a workflow of tasks, it can be continuous or a cycle, you create a model, train it, evaluate it, come back to do more exploratory analysis and transformations, then repeat it all again. It all dependes on the problem you are trying to solve. 

So, the first question you should do is:

<div align="center">
  <p>
    <strong>What is my business problem?</strong>
  </p>
  <p>
    <img src="https://miro.medium.com/max/1250/1*vlkAwKkZeXXwFMXJbJVbBg.jpeg" width="400" alt="customer">
  </p>
</div>

## Author

[<img src="https://avatars3.githubusercontent.com/u/47090012?s=460&u=0180e5d8646087e40786286006fc2505548b9e2a&v=4" width=200><br><sub>@meloandrew</sub>](https://github.com/meloandrew) | [<img 
