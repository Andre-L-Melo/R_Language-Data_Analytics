<h1 align="center">Machine Learning - Regression Problem - Predicting Medical Expenses</h1>
<div align="center">
  <p>
    <strong>Predicting Medical Expenses with R</strong>
  </p>
  <p>
    <img src="https://dynaimage.cdn.cnn.com/cnn/c_fill,g_auto,w_1200,h_675,ar_16:9/https%3A%2F%2Fcdn.cnn.com%2Fcnnnext%2Fdam%2Fassets%2F180419120320-healthcare-costs.jpg" width="400" alt="airline">
  </p>
</div>

<div align="center">
  <a href="https://rstudio.com/" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/rstudio-v1.2.5-blue"/>

  <a href="https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/corrplot-v0.84-blueviolet"/>

  <a href="https://cran.r-project.org/web/packages/psych/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/psych-v1.9.12.31-blueviolet"/>
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

## BUSINESS PROBLEM

Imagine that your cliente is a medical clinic, or a health insurance company or even a private company that provides health insurance for its employees. Your client would like to predict medical expenses, in other words, what are the costs involved in medical fees, exams, remedies etc. 
Well, this is our business problem, we want to predict medical expenses for our client.

Let's assume that, for this example, our client is a Health Insurance Company. 

We will work with hypothetical data that simulate medical expenses regarding brazilian patients from 4 regions (Northest, South, Southest and North). This dataset has 1338 records and 7 variables.

This is a tipical problem for supervised learning models, because we'll train our algorithm with inputs (predictos) and outputs (expected variable), where it will learn a mathematical relation between variables and then predict the target variable for a new input. 

The next step is to collect data and do the exploratory analysis.

## COLLECTING DATA

In this case we already have the dataset "despesas.csv", all we need to do is to read this file and transform it in a dataframe object. 

When you're working in a company, you need to find your data source, which can be a Relational Data Base, a Excel sheet, a Data Lake, among others. Usually, this is a data engineering task, but it is also important to a Data Scientist.

To read our file we'll use "read.csv" function which returns a dataframe object. 

``` r
> despesas <- read.csv("despesas.csv", stringsAsFactors = TRUE)
> head(despesas,10)
   idade   sexo  bmi filhos fumante   regiao   gastos
1     19 mulher 27.9      0     sim  sudeste 16884.92
2     18  homem 33.8      1     nao      sul  1725.55
3     28  homem 33.0      3     nao      sul  4449.46
4     33  homem 22.7      0     nao nordeste 21984.47
5     32  homem 28.9      0     nao nordeste  3866.86
6     31 mulher 25.7      0     nao      sul  3756.62
7     46 mulher 33.4      1     nao      sul  8240.59
8     37 mulher 27.7      3     nao nordeste  7281.51
9     37  homem 29.8      2     nao    norte  6406.41
10    60 mulher 25.8      0     nao nordeste 28923.14

> str(despesas)

'data.frame':	1338 obs. of  7 variables:
 $ idade  : int  19 18 28 33 32 31 46 37 37 60 ...
 $ sexo   : Factor w/ 2 levels "homem","mulher": 2 1 1 1 1 2 2 2 1 2 ...
 $ bmi    : num  27.9 33.8 33 22.7 28.9 25.7 33.4 27.7 29.8 25.8 ...
 $ filhos : int  0 1 3 0 0 0 1 3 2 0 ...
 $ fumante: Factor w/ 2 levels "nao","sim": 2 1 1 1 1 1 1 1 1 1 ...
 $ regiao : Factor w/ 4 levels "nordeste","norte",..: 3 4 4 1 1 4 4 1 2 1 ...
 $ gastos : num  16885 1726 4449 21984 3867 ...
```
From our dataset we have the following variables:

* idade (age)
* sexo (gender)
* bmi (Body Mass Index)
* filhos (number of children)
* fumante (smoker)
* região (area)
* gastos (expenses)

In our first record we have a person who is 19 years old, woman, BMI of 27.9, childless, smoker, from southest area, R$ 16.884,92 of medical expenses. Others follow the same pattern.

## EXPLORING AND PREPARING DATA

We already know our variables type, now, we need to explory more our target variable, which is the column "gastos" or expenses. 

In our dataset, the variables "idade", "sexo", "bmi", "filhos", "fumante" and "região" are the predictors (x) and "gastos" is the target (y).

First of all, let's summarize the variable "gastos":

``` r
> summary(despesas$gastos)

   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   1122    4740    9382   13270   16640   63770 
```
The minimun value is R$ 1.122,00. 

25% of our data is below R$ 4.740,00 (1st Quartile).

Median is equal to R$ 9.382,00.

Mean is equal to R$ 13.270,00.

75% of our data is below R$ 16.640,00 (3rd Quartile).

The maximum value is R$ 63.770,00.

By the difference between mean and median we don't have a normal distribution for our target variable. We will use a Histogram to confirm this:

``` r
> hist(despesas$gastos, main = "Histograma dos Gastos", xlab = "Gastos", col = "violet")
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Predicting_Medical_Expenses/Images/Histograma_dos_gastos" width="600" alt="airline">

The histogram shows us that most part of our data is below R$ 10.000,00. We have just a few occurences between R$ 40.000,00 and R$ 60.000,00.

Now, we will use a contingency table that will give us a summary of "regiao", which is a nominal qualitative variable.

``` r
> table(despesas$regiao)

nordeste    norte  sudeste      sul 
     325      324      325      364

> # Proportion of each class within our records: 
> round(prop.table(table(despesas$regiao))*100) 

nordeste    norte  sudeste      sul 
      24       24       24       27 
```
This data has a good distribution, you can see that only south area has more patients than others, but the difference is meaningless.

Our next step is to check the correlation between numerical variables. In this case, we want to see how the numerical variables (quantitative variables) are related to one another. We can use the "cor" function to create the correlation matrix and then plot it with "corrplot" function:

``` r
> library(corrplot)
> mat <- cor(despesas[,c("idade","bmi","filhos","gastos")])
> corrplot(mat, method = "color", order = "alphabet", col = rainbow(100))
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Predicting_Medical_Expenses/Images/Analise_Correlacao_Numerica" width="600" alt="airline">

The correlation coeficient is a number tha assumes values between -1 and 1. If is equal to 1, the pair of variables have a strong positive correlation. If is -1, we have a strong negative correlation, and if is equal to 0 there is no correlation between both variables. Remember, correlation does not imply causation. 

None of the variables show a strong correlation with the variable "gastos", but we can do some interesting associations.

For example, the variables "idade" and "bmi" have a weak positive correlation, so if a person gets older, her or his bmi increases as well. There is another positive correlation between "idade"/"gastos", and "filhos"/"gastos", therefore, as age, bmi and number of children increases so do the health insurance expenses.

We can explore the relation between the same numerical variables previously seen, but in this case we will use a scatter plot. The "pairs" function from *graphics* package can help us with this task.

``` r
> pairs(despesas[,c("idade","bmi","filhos","gastos")], col = heat.colors(100))
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Predicting_Medical_Expenses/Images/Scatter_Plot_1" width="600" alt="airline">

Notice there is no significant correlation between the variables.

We can improve our scatter plot by using "pairs()" function from *psych* package.

``` r
> library(psych)
> pairs.panels(despesas[,c("idade","bmi","filhos","gastos")], hist.col = "violet")
```
<img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Predicting_Medical_Expenses/Images/Scatter_Plot_2" width="600" alt="airline">

This plot provides more insights about the relation between variables. For example, we have the correlation coefficient valor for each variable, the frequency distribution (histogram), a scatter plot for each variable with a regression line and the mean point respectively.

## CREATING AND TRAINING THE PREDICTIVE MODEL 

In this section we will create and then train our machine learning model for this regression problem.

The Exploratory Analysis that we have done before will not make the decision for us, its only purpose was to help us understand the data, for example, how the data is distributed, the correlation between variables, if the data is normalized, outliers, missing values, if you will treat the data or not this is the Data Scientist decision. 

In this example we didn't remove any missing values because we did know there wasn't any. Ok, but what if we didn't know? Well, in this case we could do the following task:

``` r
> sapply(despesas,function(x) sum (is.na(x)))
  idade    sexo     bmi  filhos fumante  regiao  gastos 
      0       0       0       0       0       0       0 
```
No missing value.

Now, let's create our predictive model.

Our model is based on a multiple linear regression algorithm given by the "lm" function.

A multiple linear regression equation is similar to that:

y = ax1 + bx2 + cx3 + dx4 + ex5 + fx6 + g

``` r
> modelo <- lm(gastos ~ ., data = despesas)
> modelo

Call:
lm(formula = gastos ~ ., data = despesas)

Coefficients:
  (Intercept)          idade     sexomulher            bmi         filhos  
     -12425.7          256.8          131.4          339.3          475.7  
   fumantesim    regiaonorte  regiaosudeste      regiaosul  
      23847.5          352.8         -606.5         -682.8  
```

The linear regression algorithm calculated the multiple coefficients for the equation and then choose the best trained model to our inputs and output.

In this case we have multiple coefficientes for the multiple linear regression equation, each one of then for each predictor variable, with y equal to the target variable.

## MAKING PREDICTIONS WITH THE MODEL

The next step is to predict the medical expenses for our test dataset.

One important thing is that we haven't splitted our dataset into training and testing data, using the 70/30 proportion. So, we can't use the training data to test the machine learning model. Why not? Because the model has already seen this data before, so the result will not be valid.

In this case, we will load another dataset from the same datasource, but with different records.

Ok, but just out of curiosity, we'll use the "predict" function from *stats* package to predict the output for our training dataset (this is not a good option, we are just curious to see what the model will predict). 

``` r
> previsao1 <- predict(modelo)

> class(previsao1)
[1] "numeric"

> head(previsao1)
        1         2         3         4         5 
25292.740  3458.281  6706.619  3751.868  5598.626 
        6 
 3704.606 
```
Let's load the new dataset that will test our model:

``` r
> despesasteste <- read.csv("despesas-teste.csv")

> View(despesasteste)

> head(despesasteste)
  idade   sexo  bmi filhos fumante   regiao
1    52 mulher 26.6      0     nao nordeste
2    27  homem 27.1      0     nao      sul
3    26 mulher 29.9      1     nao      sul
4    24 mulher 22.2      0     nao      sul
5    34 mulher 33.7      1     nao  sudeste
6    53 mulher 33.3      0     nao    norte
```
We have 20 records in this dataset and the column "gastos" is missing, because once we have trained our model, we don't need to present the output anymore, this will be the model result. For example, we will say to the model: "My dear model, there is a lady, 52 years old, bmi of 26.6, childless, no smoker, from Northest zone. Please, could you give me her medical expenses?"

``` r
> previsao2 <- predict(modelo, despesasteste)

> head(previsao2)
         1          2          3          4 
10086.3947  3020.9027  4321.1161   719.2169 
         5          6 
 7741.4208 12969.2660 
```
## EVALUATING THE MODEL

We'll use the "summary()" function to show us more valuable information abou the multiple regression model:

``` r
> summary(modelo)

Call:
lm(formula = gastos ~ ., data = despesas)

Residuals:
     Min       1Q   Median       3Q      Max 
-11302.7  -2850.9   -979.6   1383.9  29981.7 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)
(Intercept)   -12425.7     1000.7 -12.418  < 2e-16
idade            256.8       11.9  21.586  < 2e-16
sexomulher       131.3      332.9   0.395 0.693255
bmi              339.3       28.6  11.864  < 2e-16
filhos           475.7      137.8   3.452 0.000574
fumantesim     23847.5      413.1  57.723  < 2e-16
regiaonorte      352.8      476.3   0.741 0.458976
regiaosudeste   -606.5      477.2  -1.271 0.203940
regiaosul       -682.8      478.9  -1.426 0.154211
                 
(Intercept)   ***
idade         ***
sexomulher       
bmi           ***
filhos        ***
fumantesim    ***
regiaonorte      
regiaosudeste    
regiaosul        
---
Signif. codes:  
0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 6062 on 1329 degrees of freedom
Multiple R-squared:  0.7509,	Adjusted R-squared:  0.7494 
F-statistic: 500.9 on 8 and 1329 DF,  p-value: < 2.2e-16
```
What are all these values?

When we create a regression model, one of the many values we need to observe is the Multiple R-Square, which is equal to 0.7509 for this little experiment. The R-Square is the Determination Coefficient, that assumes values between 0 and 1. The higher its value the better is the model accuracy.

Before we continue, let's see some basic concepts first:

## Simple Linear Regression Equation:

y = a + bx.

In this case, 'y' is the "gastos" column, the variable we want to predict. 

'a' is the intercept coefficient.

'b' is the slope coefficiente of the regression line.

'x' is the predictor variable.

## The Residual:

The residual is the difference between the observed values of the dependent variable and the predicted values.

If the residual assumes a normal distribution, the mean between the predicted values and the observed values are almost 0 (which is good). In this case, the difference between "gastos" values from "despesas" and the predicted values from "previsao1" is our residual. 

## Intercept Coefficient (a - alpha):

It is the alpha value in the regression equation, indicating the point where the regression line intercept y axis.

## Slope Coefficients (b - Beta):

It is the beta value in the regression equation. The point here is that "lm" and "summary" use different conventions to label each explanatory variable. Instead of use "slope_1", "slope_2", they use the variable name for any output to indicate which coefficient belongs to a respective variable.

## Standard Error:

Variability measure for the intercept coefficient. Ideally, this value should be smaller than the coefficient value.

## Asterisks:

They represent the significance levels according to the p-value. If we have more asterisks in a variable, the bigger will be its significance. 

But, be aware, because many asterisks could also imply that is unlikely to not exist a relationship between variables.

## T - Value:

Defines the significance for each coefficient. It is used to calculate the p - value and the significance levels.

## P - Value:

It represents the probability for a variable not be relevant for the model. It should be as small as possible, but if it assumes a real small value, than R will represent it in cientific notation.

## Significances:

They are the legends near the variables.

If we have a blank space, than it is bad my friend (the variable does not have a high significance level for the model).

If we have dots, the significance level is reasonable ok.

If we have asterisks, the significance level is good.

If we have multiple asterisks, the significance level is great.

The thing with bad significance levels is that, the main goal of a predictive model is to be generic. When you test your model with new data, it can assume a worst accuracy level. So, we need to train our model with only the variable that really matter. This can be discovered over the exploratoy analysis.

## Residual Standard Error:

This value is the standard deviation for the residual.

## DEGREES OF FREEDOM:

It is the difference between the number of observations for our sample and the number of variables that we used it to create our model.

## R-Squared (Determination Coefficient - R²):

It helps us to evaluate the accuracy level for our machine learning model. 

## F - Statistics:

It is the F-Test. This test gets the parameters of the model and then, compares them  with a model that has less parameters. Ideally, a model that has more parameters, shows a better performance. 

If the model that has more parameters shows a worse performance than a model with less parameters, then the p-value will be very high. Otherwise, the p-value will be very small.

Remember, correlation does not imply in causation. A variable that has a high significance level, does not imply on a higher medical expense.

## IMPROVING OUR MODEL

Until now, we have trained and validated our first predictive model. Next step is to improve the accuracy level.

There are many possibilities to optimize our model.

One way to do it is to add a variable which is equal to the square of "idade" variable.

``` r
despesas$idade2 <- despesas$idade ^ 2
```
We have seen that "idade" has a strong significance level, so, we'll add another variable which is the square of "idade", in order to see the relation between this new variable and "idade" variable.

Some papers prove that as you doble or assume a power level for a variable, it shows a positive impact for the model training. 

We will also add an index for BMI >= 30:

``` r
despesas$bmi30 <- ifelse(despesas$bmi >= 30, 1, 0)

> head(despesas)

  idade   sexo  bmi filhos fumante   regiao   gastos
1    19 mulher 27.9      0     sim  sudeste 16884.92
2    18  homem 33.8      1     nao      sul  1725.55
3    28  homem 33.0      3     nao      sul  4449.46
4    33  homem 22.7      0     nao nordeste 21984.47
5    32  homem 28.9      0     nao nordeste  3866.86
6    31 mulher 25.7      0     nao      sul  3756.62
  idade2 bmi30
1    361     0
2    324     1
3    784     1
4   1089     0
5   1024     0
6    961     0

```
So, now we can create the final version of our predictive model, using all of our variables:

``` r
> modelo_v2 <- lm(gastos ~ idade + idade2 + filhos + bmi + sexo +
+                   bmi30 * fumante + regiao, data = despesas)
> 
> summary(modelo_v2)

Call:
lm(formula = gastos ~ idade + idade2 + filhos + bmi + sexo + 
    bmi30 * fumante + regiao, data = despesas)

Residuals:
     Min       1Q   Median       3Q      Max 
-17297.1  -1656.0  -1262.7   -727.8  24161.6 

Coefficients:
                   Estimate Std. Error t value
(Intercept)       -636.9298  1361.0589  -0.468
idade              -32.6181    59.8250  -0.545
idade2               3.7307     0.7463   4.999
filhos             678.6017   105.8855   6.409
bmi                119.7715    34.2796   3.494
sexomulher         496.7690   244.3713   2.033
bmi30             -997.9355   422.9607  -2.359
fumantesim       13404.5952   439.9591  30.468
regiaonorte        279.1661   349.2826   0.799
regiaosudeste     -942.9958   350.1754  -2.693
regiaosul         -548.8684   352.1950  -1.558
bmi30:fumantesim 19810.1534   604.6769  32.762
                 Pr(>|t|)    
(Intercept)      0.639886    
idade            0.585690    
idade2           6.54e-07 ***
filhos           2.03e-10 ***
bmi              0.000492 ***
sexomulher       0.042267 *  
bmi30            0.018449 *  
fumantesim        < 2e-16 ***
regiaonorte      0.424285    
regiaosudeste    0.007172 ** 
regiaosul        0.119372    
bmi30:fumantesim  < 2e-16 ***
---
Signif. codes:  
0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4445 on 1326 degrees of freedom
Multiple R-squared:  0.8664,	Adjusted R-squared:  0.8653 
F-statistic: 781.7 on 11 and 1326 DF,  p-value: < 2.2e-16
```
The R-Square is now equal to 0.8653

Now, let's test our new model:

``` r
> despesasteste <- read.csv("despesas-teste.csv")

> head(despesasteste)

  idade   sexo  bmi filhos fumante   regiao
1    52 mulher 26.6      0     nao nordeste
2    27  homem 27.1      0     nao      sul
3    26 mulher 29.9      1     nao      sul
4    24 mulher 22.2      0     nao      sul
5    34 mulher 33.7      1     nao  sudeste
6    53 mulher 33.3      0     nao    norte

> previsao <- predict(modelo, despesasteste)

> class(previsao)
[1] "numeric"

> head(previsao)
         1          2          3          4 
10086.3947  3020.9027  4321.1161   719.2169 
         5          6 
 7741.4208 12969.2660 
```

We usually obtain these kind of insights about our variables using filter selection techniques, such as ANOVA, among others. It is a good practice to do that during a Data Science Project, of course, it will always depend on the business problem

[<img src="https://avatars3.githubusercontent.com/u/47090012?s=460&u=0180e5d8646087e40786286006fc2505548b9e2a&v=4" width=200><br><sub>@meloandrew</sub>](https://github.com/meloandrew) | [<img 
