<h1 align="center"> Breast Tumor UCI </h1>
<div align="center">
  <p>
    <strong>Predict Breast Tumor using R </strong>
  </p>
  <p>
    <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/cancer_predict.jpeg" width = "250" alt = "Breast_tumor" width="250" alt="breast_tumor">
  </p>
</div>

<div align = "center> 
  <a href = "https://rstudio.com/" 
  target = "_blank" rel = "noopener">
    <img src = "https://img.shields.io/badge/rstudio-v1.3.1-blue"/>  
  <a href="https://cran.r-project.org/web/packages/randomForest/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/rpart-v4.1-blueviolet"/>
  <a href="https://cran.r-project.org/web/packages/caTools/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/caTools-v1.18.1-blueviolet"/>
  <a href="https://cran.r-project.org/web/packages/e1071/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/e1071-v1.7-blueviolet"/>
  <a href="https://cran.r-project.org/web/packages/gmodels/index.html" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/gmodels-v2.18.1-blueviolet"/>
  <a href="https://www.rdocumentation.org/packages/caret/versions/6.0-86" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/caret-v6.0--86-blueviolet"/>                                                                      
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
* Create Dynamic Apps with R Shiny

## Predict Breast Tumor Using R
Breast cancer is the second threatening cause of cancer death in middle-aged women throughout the world, but preventively detecting the tumor, can reduce the chances of death according to PRINTOM, et al.

In this project, we will classify breast tumors according to biopsies data. We will use the kNN, SVM, and Random Forest to classify a breast tumor as Malign or Benign. 
The dataset is offered by UCI, where each record represents a biopsy result where each column has all its features. 

This dataset provides features that were computed from a digitized image of a breast mass biopsy, describing characteristics of the cell nuclei present in the image. 

### Understanding the Dataset

Our source will be a CSV file, so, the function "read.csv" from R can be useful in this process.

The first step is to install and load all the packages we are going to use in this project:

``` r
library(caret)
library(class)
library(gmodels)
library(e1071)
library(rpart)
library(ggplot2)
library(GGally)
library(corrplot)
library(gridExtra)
library(RColorBrewer)
library(caTools)
```

We expect that you have installed the package, so we did not include the command in this script.

Now, let's load our dataset:

``` r
# This dataset has 569 tumor biopsies observations, each one with 32 features. 
# One feature is the biopsies ID, another one is the tumor diagnostic,
# and the rest 30 features are laboratory numerical measures. 
# The tumor diagnostic is codified as 'M' for Malign and 'B' for Benign.

# Load the csv file using the function read.csv:
dados <- read.csv("dataset.csv", stringsAsFactors = TRUE)

# Check variables type:
str(dados)

'data.frame':	569 obs. of  32 variables:
 $ diagnosis        : Factor w/ 2 levels "B","M": 1 1 1 1 1 1 1 2 1 1 ...
 $ radius_mean      : num  12.3 10.6 11 11.3 15.2 ...
 $ texture_mean     : num  12.4 18.9 16.8 13.4 13.2 ...
 $ perimeter_mean   : num  78.8 69.3 70.9 73 97.7 ...
 $ area_mean        : num  464 346 373 385 712 ...
 $ smoothness_mean  : num  0.1028 0.0969 0.1077 0.1164 0.0796 ...
 $ compactness_mean : num  0.0698 0.1147 0.078 0.1136 0.0693 ...
 $ concavity_mean   : num  0.0399 0.0639 0.0305 0.0464 0.0339 ...
 $ points_mean      : num  0.037 0.0264 0.0248 0.048 0.0266 ...
 $ symmetry_mean    : num  0.196 0.192 0.171 0.177 0.172 ...
 $ dimension_mean   : num  0.0595 0.0649 0.0634 0.0607 0.0554 ...
 $ radius_se        : num  0.236 0.451 0.197 0.338 0.178 ...
 $ texture_se       : num  0.666 1.197 1.387 1.343 0.412 ...
 $ perimeter_se     : num  1.67 3.43 1.34 1.85 1.34 ...
 $ area_se          : num  17.4 27.1 13.5 26.3 17.7 ...
 $ smoothness_se    : num  0.00805 0.00747 0.00516 0.01127 0.00501 ...
 $ compactness_se   : num  0.0118 0.03581 0.00936 0.03498 0.01485 ...
 $ concavity_se     : num  0.0168 0.0335 0.0106 0.0219 0.0155 ...
 $ points_se        : num  0.01241 0.01365 0.00748 0.01965 0.00915 ...
 $ symmetry_se      : num  0.0192 0.035 0.0172 0.0158 0.0165 ...
 $ dimension_se     : num  0.00225 0.00332 0.0022 0.00344 0.00177 ...
 $ radius_worst     : num  13.5 11.9 12.4 11.9 16.2 ...
 $ texture_worst    : num  15.6 22.9 26.4 15.8 15.7 ...
 $ perimeter_worst  : num  87 78.3 79.9 76.5 104.5 ...
 $ area_worst       : num  549 425 471 434 819 ...
 $ smoothness_worst : num  0.139 0.121 0.137 0.137 0.113 ...
 $ compactness_worst: num  0.127 0.252 0.148 0.182 0.174 ...
 $ concavity_worst  : num  0.1242 0.1916 0.1067 0.0867 0.1362 ...
 $ points_worst     : num  0.0939 0.0793 0.0743 0.0861 0.0818 ...
 $ symmetry_worst   : num  0.283 0.294 0.3 0.21 0.249 ...
 $ dimension_worst  : num  0.0677 0.0759 0.0788 0.0678 0.0677 ...
 $ index            : Factor w/ 2 levels "0","1": 2 1 2 2 2 2 2 2 2 2 ...

# Summarize variables by them measures:
summary(dados)

 diagnosis  radius_mean      texture_mean   perimeter_mean     area_mean     
 B:357     Min.   : 6.981   Min.   : 9.71   Min.   : 43.79   Min.   : 143.5  
 M:212     1st Qu.:11.700   1st Qu.:16.17   1st Qu.: 75.17   1st Qu.: 420.3  
           Median :13.370   Median :18.84   Median : 86.24   Median : 551.1  
           Mean   :14.127   Mean   :19.29   Mean   : 91.97   Mean   : 654.9  
           3rd Qu.:15.780   3rd Qu.:21.80   3rd Qu.:104.10   3rd Qu.: 782.7  
           Max.   :28.110   Max.   :39.28   Max.   :188.50   Max.   :2501.0  
 smoothness_mean   compactness_mean  concavity_mean     points_mean     
 Min.   :0.05263   Min.   :0.01938   Min.   :0.00000   Min.   :0.00000  
 1st Qu.:0.08637   1st Qu.:0.06492   1st Qu.:0.02956   1st Qu.:0.02031  
 Median :0.09587   Median :0.09263   Median :0.06154   Median :0.03350  
 Mean   :0.09636   Mean   :0.10434   Mean   :0.08880   Mean   :0.04892  
 3rd Qu.:0.10530   3rd Qu.:0.13040   3rd Qu.:0.13070   3rd Qu.:0.07400  
 Max.   :0.16340   Max.   :0.34540   Max.   :0.42680   Max.   :0.20120  
 symmetry_mean    dimension_mean      radius_se        texture_se    
 Min.   :0.1060   Min.   :0.04996   Min.   :0.1115   Min.   :0.3602  
 1st Qu.:0.1619   1st Qu.:0.05770   1st Qu.:0.2324   1st Qu.:0.8339  
 Median :0.1792   Median :0.06154   Median :0.3242   Median :1.1080  
 Mean   :0.1812   Mean   :0.06280   Mean   :0.4052   Mean   :1.2169  
 3rd Qu.:0.1957   3rd Qu.:0.06612   3rd Qu.:0.4789   3rd Qu.:1.4740  
 Max.   :0.3040   Max.   :0.09744   Max.   :2.8730   Max.   :4.8850  
  perimeter_se       area_se        smoothness_se      compactness_se    
 Min.   : 0.757   Min.   :  6.802   Min.   :0.001713   Min.   :0.002252  
 1st Qu.: 1.606   1st Qu.: 17.850   1st Qu.:0.005169   1st Qu.:0.013080  
 Median : 2.287   Median : 24.530   Median :0.006380   Median :0.020450  
 Mean   : 2.866   Mean   : 40.337   Mean   :0.007041   Mean   :0.025478  
 3rd Qu.: 3.357   3rd Qu.: 45.190   3rd Qu.:0.008146   3rd Qu.:0.032450  
 Max.   :21.980   Max.   :542.200   Max.   :0.031130   Max.   :0.135400  
  concavity_se       points_se         symmetry_se        dimension_se      
 Min.   :0.00000   Min.   :0.000000   Min.   :0.007882   Min.   :0.0008948  
 1st Qu.:0.01509   1st Qu.:0.007638   1st Qu.:0.015160   1st Qu.:0.0022480  
 Median :0.02589   Median :0.010930   Median :0.018730   Median :0.0031870  
 Mean   :0.03189   Mean   :0.011796   Mean   :0.020542   Mean   :0.0037949  
 3rd Qu.:0.04205   3rd Qu.:0.014710   3rd Qu.:0.023480   3rd Qu.:0.0045580  
 Max.   :0.39600   Max.   :0.052790   Max.   :0.078950   Max.   :0.0298400  
  radius_worst   texture_worst   perimeter_worst    area_worst    
 Min.   : 7.93   Min.   :12.02   Min.   : 50.41   Min.   : 185.2  
 1st Qu.:13.01   1st Qu.:21.08   1st Qu.: 84.11   1st Qu.: 515.3  
 Median :14.97   Median :25.41   Median : 97.66   Median : 686.5  
 Mean   :16.27   Mean   :25.68   Mean   :107.26   Mean   : 880.6  
 3rd Qu.:18.79   3rd Qu.:29.72   3rd Qu.:125.40   3rd Qu.:1084.0  
 Max.   :36.04   Max.   :49.54   Max.   :251.20   Max.   :4254.0  
 smoothness_worst  compactness_worst concavity_worst   points_worst    
 Min.   :0.07117   Min.   :0.02729   Min.   :0.0000   Min.   :0.00000  
 1st Qu.:0.11660   1st Qu.:0.14720   1st Qu.:0.1145   1st Qu.:0.06493  
 Median :0.13130   Median :0.21190   Median :0.2267   Median :0.09993  
 Mean   :0.13237   Mean   :0.25427   Mean   :0.2722   Mean   :0.11461  
 3rd Qu.:0.14600   3rd Qu.:0.33910   3rd Qu.:0.3829   3rd Qu.:0.16140  
 Max.   :0.22260   Max.   :1.05800   Max.   :1.2520   Max.   :0.29100  
 symmetry_worst   dimension_worst   index  
 Min.   :0.1565   Min.   :0.05504   0:111  
 1st Qu.:0.2504   1st Qu.:0.07146   1:458  
 Median :0.2822   Median :0.08004          
 Mean   :0.2901   Mean   :0.08395          
 3rd Qu.:0.3179   3rd Qu.:0.09208          
 Max.   :0.6638   Max.   :0.20750 

# View dataset (first 5 records):
head(dados)

  diagnosis radius_mean texture_mean perimeter_mean area_mean smoothness_mean
1         B       12.32        12.39          78.85     464.1         0.10280
2         B       10.60        18.95          69.28     346.4         0.09688
3         B       11.04        16.83          70.92     373.2         0.10770
4         B       11.28        13.39          73.00     384.8         0.11640
5         B       15.19        13.21          97.65     711.8         0.07963
6         B       11.57        19.04          74.20     409.7         0.08546
  compactness_mean concavity_mean points_mean symmetry_mean dimension_mean
1          0.06981        0.03987     0.03700        0.1959        0.05955
2          0.11470        0.06387     0.02642        0.1922        0.06491
3          0.07804        0.03046     0.02480        0.1714        0.06340
4          0.11360        0.04635     0.04796        0.1771        0.06072
5          0.06934        0.03393     0.02657        0.1721        0.05544
6          0.07722        0.05485     0.01428        0.2031        0.06267
  radius_se texture_se perimeter_se area_se smoothness_se compactness_se
1    0.2360     0.6656        1.670   17.43      0.008045       0.011800
2    0.4505     1.1970        3.430   27.10      0.007470       0.035810
3    0.1967     1.3870        1.342   13.54      0.005158       0.009355
4    0.3384     1.3430        1.851   26.33      0.011270       0.034980
5    0.1783     0.4125        1.338   17.72      0.005012       0.014850
6    0.2864     1.4400        2.206   20.30      0.007278       0.020470
  concavity_se points_se symmetry_se dimension_se radius_worst texture_worst
1      0.01683  0.012410     0.01924     0.002248        13.50         15.64
2      0.03354  0.013650     0.03504     0.003318        11.88         22.94
3      0.01056  0.007483     0.01718     0.002198        12.41         26.44
4      0.02187  0.019650     0.01580     0.003442        11.92         15.77
5      0.01551  0.009155     0.01647     0.001767        16.20         15.73
6      0.04447  0.008799     0.01868     0.003339        13.07         26.98
  perimeter_worst area_worst smoothness_worst compactness_worst concavity_worst
1           86.97      549.1           0.1385            0.1266         0.12420
2           78.28      424.8           0.1213            0.2515         0.19160
3           79.93      471.4           0.1369            0.1482         0.10670
4           76.53      434.0           0.1367            0.1822         0.08669
5          104.50      819.1           0.1126            0.1737         0.13620
6           86.43      520.5           0.1249            0.1937         0.25600
  points_worst symmetry_worst dimension_worst index
1      0.09391         0.2827         0.06771     1
2      0.07926         0.2940         0.07587     0
3      0.07431         0.2998         0.07881     1
4      0.08611         0.2102         0.06784     1
5      0.08178         0.2487         0.06766     1
6      0.06664         0.3035         0.08284     1

# Check if variable id has unique registers:
is.recursive(dados$id)
[1] FALSE

# Check how well the diagnosis variable is distributed:
table(dados$diagnosis)

  B   M 
357 212 
```

### Pre Processing Data

Pre-processing data is one of the most important steps taken in a data science project, so it cannot be neglected.

In this part, we will apply some changes in our data, such as, removing some variables, adjusting the data scale, check for missing values and change the target variable labels.

``` r
# Exclude ID Column:
# No matter which machine learning method will be used,ID variables should always be removed. Otherwise, this can lead to wrong results because the ID variable can be independently used to predict each example.
# Therefore, a model that has an ID as a predictor can suffer from overfitting.
dados$id = NULL
ncol(dados)

[1] 32

# Adjusting target variable label:
# We will rename our target variable label, diagnosis.
# For M we will have Malign and for B we will have Benign.
dados$diagnosis = sapply(dados$diagnosis, 
                         function(x){ifelse(x=='M','Maligno','Benigno')})

# Many classifiers expect a target variable that is a categorical type:
dados$diagnosis <- factor(dados$diagnosis, 
                          levels = c("Benigno", "Maligno"), 
                          labels = c("Benigno", "Maligno"))

table(dados$diagnosis)

  B   M 
357 212 

# Check the proportion for the target variable distribution.
# This is important to not create a biased model:
round(prop.table(table(dados$diagnosis)) * 100,1)

   B    M 
62.7 37.3 

# Create a barplot to check target variable distribution:
diagnosis_bar_plot <- ggplot(dados, aes(x=diagnosis, fill = diagnosis)) + 
      geom_bar(alpha = 0.8)
```

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/Diagnosis_Bar_Plot.png"
      alt = "Diagnosis_Bar_Plot"
      style="width:600px;height:300px;"/>

``` r
# Check if there is any missing value in our dataset:
sapply(dados,function(x) sum(is.na(x)))

> sapply(dados,function(x) sum(is.na(x)))
        diagnosis       radius_mean      texture_mean 
                0                 0                 0 
   perimeter_mean         area_mean   smoothness_mean 
                0                 0                 0 
 compactness_mean    concavity_mean       points_mean 
                0                 0                 0 
    symmetry_mean    dimension_mean         radius_se 
                0                 0                 0 
       texture_se      perimeter_se           area_se 
                0                 0                 0 
    smoothness_se    compactness_se      concavity_se 
                0                 0                 0 
        points_se       symmetry_se      dimension_se 
                0                 0                 0 
     radius_worst     texture_worst   perimeter_worst 
                0                 0                 0 
       area_worst  smoothness_worst compactness_worst 
                0                 0                 0 
  concavity_worst      points_worst    symmetry_worst 
                0                 0                 0 
  dimension_worst             index 
                0                 0 

# Central Tendency Measures:
# In our dataset we have a scale difference between some features, which need to be normalized. Otherwise, this can be a problem for algorithms that use distance measures, such as the kNN with the Euclidean Distance (There is more, but the Euclidean Distance is commonly used):
summary(dados[c("radius_mean","area_mean","smoothness_mean")])

  radius_mean       area_mean      smoothness_mean  
 Min.   : 6.981   Min.   : 143.5   Min.   :0.05263  
 1st Qu.:11.700   1st Qu.: 420.3   1st Qu.:0.08637  
 Median :13.370   Median : 551.1   Median :0.09587  
 Mean   :14.127   Mean   : 654.9   Mean   :0.09636  
 3rd Qu.:15.780   3rd Qu.: 782.7   3rd Qu.:0.10530  
 Max.   :28.110   Max.   :2501.0   Max.   :0.16340 

# Creating a normalizing function:
normalizer <- function(x) {
  return((x-min(x)) / (max(x) - min(x)))}

# Testing the normalizing function.
# Both results must be identicals:
normalizer(c(1,2,3,4,5))
[1] 0.00 0.25 0.50 0.75 1.00

normalizer(c(10,20,30,40,50))
[1] 0.00 0.25 0.50 0.75 1.00

# Applying the normalizing function in our data:
# First, let's select only the numerical variables, and then apply the normalizing function:
dados_norm <- as.data.frame(lapply(dados[2:31], normalizer))

norm_pairs_plot <- ggpairs(dados_norm, columns = 1:3,
              columnLabels = c("Radius", "Texture", "Perimeter"))
norm_pairs_plot
```

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/Norm_Pairs_Plot.png"
      alt = "Diagnosis_Bar_Plot"
      style="width:600px;height:300px;"/>

### kNN Algorithm 
Once we have loaded, understood, cleaned, and pre-processed our data, we can choose one or more mathematical algorithms to create and train machine learning models.

The first one is the kNN Algorithm. 

KNN is one of the simplest algorithms for Machine Learning, being a “lazy” algorithm, that is, no computation is performed in the dataset until a new data point is tested.

The accuracy of the classification using the KNN algorithm strongly depends on the data model. 

Most of the time, the attributes need to be normalized to prevent distance measurements from being dominated by a single attribute. 

The KNN algorithm is a variation of the NN algorithm, this algorithm proposes a modification to the original algorithm that occurs during the testing and classification phase, where the algorithm makes use of the nearest K neighbors instead of using only the nearest neighbor as proposed in the original NN algorithm. 

The deficiency of the two is still the same, as they continue to store all training standards in memory, requiring great computational effort. The KNN's differential is the use of the K parameter, which indicates the number of neighbors that will be used by the algorithm during the training phase. It makes the algorithm able to make a more refined classification, but the optimal K value varies from one problem to another, which means that we have to test different K values for each problem we are working on.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/knn_def.png"
      alt = "knn_def"
      style="width:600px;height:300px;"/>

``` r
# Bind norm data with target variable:
dados_norm_final <- dados_norm
dados_norm_final$diagnosis <- dados$diagnosis

# Split into training and testing samples:
set.seed(200)
indxTrain <- createDataPartition(y=dados_norm_final$diagnosis,
                                 p = 0.80,list = FALSE)
training_norm <- dados_norm_final[indxTrain,]
testing_norm <- dados_norm_final[-indxTrain,]

# Create a training control pipeline:
ctrl <- trainControl(method="repeatedcv",repeats = 3)

# Train with target variable equal to diagnosis, kNN Method:
knnFit <- train(diagnosis ~ ., data = training_norm, 
                method = "knn", 
                trControl = ctrl,
                tuneLength = 20)

# Use plots to see an optimal number of clusters:
# Plotting yields Number of Neighbors Vs accuracy 
# (based on repeated cross-validation)
plot(knnFit)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/Elbow_kNN_Norm.png"
      alt = "Elbow_kNN_Norm"
      style="width:600px;height:300px;"/>

``` r
# Train and Test samples for target variable:
dados_treino_labels_norm <- training_norm$diagnosis
dados_teste_labels_norm <- testing_norm$diagnosis
length(dados_treino_labels_norm)
[1] 456

length(dados_teste_labels_norm)
[1] 113

# Training the kNN Model:
modelo_knn_v1 <- knn(train=training_norm[1:30],
                     test=testing_norm[1:30],
                     cl=dados_treino_labels_norm,
                     k=knnFit$bestTune)

# The kNN function returns the predictions for each execution:
summary(modelo_knn_v1)

Benigno Maligno 
     72      41 
```

### Evaluating kNN Model
Let's check the model accuracy using the test dataset:

``` r
# Create a Cross Table Prediction x Testing:
CrossTable(x = dados_teste_labels_norm, y = modelo_knn_v1, prop.chisq = FALSE)
 
   Cell Contents
|-------------------------|
|                       N |
|           N / Row Total |
|           N / Col Total |
|         N / Table Total |
|-------------------------|

 
Total Observations in Table:  113 

 
                        | modelo_knn_v1 
dados_teste_labels_norm |   Benigno |   Maligno | Row Total | 
------------------------|-----------|-----------|-----------|
                Benigno |        69 |         2 |        71 | 
                        |     0.972 |     0.028 |     0.628 | 
                        |     0.958 |     0.049 |           | 
                        |     0.611 |     0.018 |           | 
------------------------|-----------|-----------|-----------|
                Maligno |         3 |        39 |        42 | 
                        |     0.071 |     0.929 |     0.372 | 
                        |     0.042 |     0.951 |           | 
                        |     0.027 |     0.345 |           | 
------------------------|-----------|-----------|-----------|
           Column Total |        72 |        41 |       113 | 
                        |     0.637 |     0.363 |           | 
------------------------|-----------|-----------|-----------|


# Understand the results:

# Reading the Confusion Matrix (It is Benign or Malign):
# True Positive: 
# - The person had a Benign Tumor and the model predicted that the Tumor was Benign;
# False Positive: 
# - The person had a Benign Tumor and the model predicted that the Tumor was Malign;
# False Negative: 
# - The person had a Malign Tumor and the model predicted that the Tumor was Benign;
# True Negative: 
# - The person had a Malign Tumor and the model predicted that the Tumor was Malign;

# False Positive = Error Type I
# False Negative = Error Type II

# Model Accuracy: 96%
round(sum(dados_teste_labels_norm == modelo_knn_v1)/length(dados_teste_labels_norm) * 100)

[1] 96
```

### Scaling the Dataset
What we did before was normalize our dataset and then, train the kNN model to classify the target variable. We have seen an accuracy of 96%, which is indeed a good number, but, let's do a didactic experiment, to standardized our dataset, centralize our numerical variables using the z-score. After that, we will create a new version for the kNN model, and then, compare it with the previous one:

``` r
# The scale function centralizes the z-score for each numerical variable, in this case, we standardize the z-score.
dados_scale <- as.data.frame(scale(dados[-1]))

# Check the result of transformation:
summary(dados_scale$area_mean)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
-1.4532 -0.6666 -0.2949  0.0000  0.3632  5.2459 

# Bind scale data with target variable:
dados_scale_final <- dados_scale
dados_scale_final$diagnosis <- dados$diagnosis

# Split into training and testing samples:
set.seed(200)
indxTrain <- createDataPartition(y=dados_scale_final$diagnosis,
                                 p = 0.80,list = FALSE)
training_scale <- dados_scale_final[indxTrain,]
testing_scale <- dados_scale_final[-indxTrain,]
dados_treino_labels_scale <- training_scale$diagnosis
dados_teste_labels_scale <- testing_scale$diagnosis

# Training the second version of the kNN Model:
# Train with target variable equal to diagnosis, kNN Method:
knnFit <- train(diagnosis ~ ., data = training_scale, 
                method = "knn", 
                trControl = ctrl, 
                tuneLength = 20)

# Use plots to see an optimal number of clusters:
# Plotting yields Number of Neighbors vs Accuracy 
# (based on repeated cross-validation)
plot(knnFit)
```
 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/Elbow_kNN_Scale.png"
      alt = "Elbow_kNN_Scale"
      style="width:600px;height:300px;"/>

``` r
modelo_knn_v2 <- knn(train = training_scale[1:30],
                     test = testing_scale[1:30],
                     cl = dados_treino_labels_scale,
                     k = knnFit$bestTune)

# CrossTable:
CrossTable(x = dados_teste_labels_scale, y = modelo_knn_v2, prop.chisq = FALSE)

 
   Cell Contents
|-------------------------|
|                       N |
|           N / Row Total |
|           N / Col Total |
|         N / Table Total |
|-------------------------|

 
Total Observations in Table:  113 

 
                         | modelo_knn_v2 
dados_teste_labels_scale |   Benigno |   Maligno | Row Total | 
-------------------------|-----------|-----------|-----------|
                 Benigno |        70 |         1 |        71 | 
                         |     0.986 |     0.014 |     0.628 | 
                         |     0.959 |     0.025 |           | 
                         |     0.619 |     0.009 |           | 
-------------------------|-----------|-----------|-----------|
                 Maligno |         3 |        39 |        42 | 
                         |     0.071 |     0.929 |     0.372 | 
                         |     0.041 |     0.975 |           | 
                         |     0.027 |     0.345 |           | 
-------------------------|-----------|-----------|-----------|
            Column Total |        73 |        40 |       113 | 
                         |     0.646 |     0.354 |           | 
-------------------------|-----------|-----------|-----------|

# Model Accuracy: 96%.
round(sum(dados_teste_labels_scale == modelo_knn_v2)/length(dados_teste_labels_scale) * 100)
[1] 96

# Confusion Matrix:
cm_knn <- confusionMatrix(modelo_knn_v2, dados_teste_labels_scale)
cm_knn_d <- data.frame(cm_knn$table)
cm_knn_d$diag <- cm_knn_d$Prediction == cm_knn_d$Reference # Get the Diagonal
cm_knn_d$ndiag <- cm_knn_d$Prediction != cm_knn_d$Reference # Off Diagonal     
cm_knn_d[cm_knn_d == 0] <- NA # Replace 0 with NA for white tiles
cm_knn_d$Reference <-  reverse.levels(cm_knn_d$Reference) # diagonal starts at top left
cm_knn_d$ref_freq <- cm_knn_d$Freq * ifelse(is.na(cm_knn_d$diag),-1,1)
cm_knn_st <- data.frame(round(cm_knn$overall, 4))
names(cm_knn_st)[1] <- 'Statistics'
cm_knn_plot <- ggplot(data = cm_knn_d, aes(x = Prediction, y = Reference, fill = Freq)) +
  scale_x_discrete(position = 'top') + 
  geom_tile(data = cm_knn_d, aes(fill = ref_freq)) +
  scale_fill_gradient2(guide = FALSE, low = 'cyan', high = 'aquamarine', midpoint = 0,
                       na.value = 'white')+
  geom_text(aes(label = Freq), color = 'black', size = 4) + 
  ggtitle("kNN") + 
  theme_bw() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = 'none',
        panel.border = element_blank(),
        plot.background = element_blank(),
ga_knn <- grid.arrange(cm_knn_plot, tableGrob(cm_knn_st), nrow = 1, ncol = 2)
        axis.line = element_blank())
```

### Support Vector Machine
SVM or Support Vector Machine can be used for both regression and classification problems. It creates a hyperplan to linearly split your data by adding one or more dimensions to your euclidian plan.

This algorithm is based on the kernel function, capable of being used in data that is linearly separable or non-linearly separable, also, to build models for both classification and regression problems, working with supervised learning cases. They were developed for more complex problems, based on the theory of statistical learning.
To complement the concept of SVMs, let's look at some of their main
features:
* In the case of outliers, the SVM model seeks the best possible way of
classification and, if necessary, disregard the outlier.
* It is a classifier designed to provide linear separation.
* Works very well in complicated domains, where there is a clear
separation margin.
* Does not work well on very large data sets, as time
training is very expensive.
* Does not work well on data sets with large amounts of
noise.
* If the classes are very overlapping, you should only use
independent evidence.

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/svm_def.png"
      alt = "svm_def"
      style="width:600px;height:300px;"/>

In machine learning, a "kernel" is often used to refer to the kernel trick, a method of using a linear classifier to solve a nonlinear problem. This implies transforming linearly inseparable data, linearly separable data. 

The kernel function is applied to each instance of data to map the original nonlinear observations in a space of
greater dimension in which they become separable.

Instead of defining a series of resources (as KNN does), you define a kernel's only function for calculating class similarity. You provide that kernel, along with the data and labels to the learning, and the result is a classifier
The Linear, Polynomial, and RBF (or Gaussian) Kernels are simply different options to establish the hyperplane decision limit between classes.

Generally, Linear and Polynomial Kernels are less time consuming and provide less accuracy than RBF Kernels.
The Linear Kernel is what you would expect, a linear model. RBF uses curves around the data points and add them together so that the decision limit can be defined by a type of topology condition, such as curves where
the sum is above a value of 0.5.

``` r
set.seed(40)

# Preparing our dataset:
dados <- read.csv("dataset.csv", stringsAsFactors = FALSE)
dados$id = NULL
dados$diagnosis <- as.factor(dados$diagnosis)
dados[, 'index'] <- as.factor(ifelse(runif(nrow(dados))<0.8, 1, 0))

# Split dataset into training and testing subsets:
trainset <- dados[dados$index == 1, ]
testset <- dados[dados$index == 0, ]
trainColNum <- grep('index', names(trainset))

# Removing index column from each dataset:
trainset <- trainset[, -trainColNum]
testset <- testset[, -trainColNum]

# Get column index of predicted variable in dataset:
typeColNum <- grep('diag', names(dados))

# Using radial kernel for SVM Model 
modelo_svm_v1 <- svm(diagnosis ~.,
                     data = trainset,
                     type = 'C-classification',
                     kernel = 'radial')

# Model predictions - Trainset:
pred_train <- predict(modelo_svm_v1, trainset)
mean(pred_train == trainset$diagnosis)

[1] 0.9847162

# Model predictions - Testset:
pred_test <- predict(modelo_svm_v1, testset)
mean(pred_test == testset$diagnosis)

[1] 0.990991

# Confusion Matrix:
cm_svm <- confusionMatrix(pred_test, testset$diagnosis)
cm_svm_d <- data.frame(cm_svm$table)

# Get the Diagonal
cm_svm_d$diag <- cm_svm_d$Prediction == cm_svm_d$Reference 

# Off Diagonal
cm_svm_d$ndiag <- cm_svm_d$Prediction != cm_svm_d$Reference 

# Replace 0 with NA for white tiles
cm_svm_d[cm_svm_d == 0] <- NA

# diagonal starts at top left
cm_svm_d$Reference <-  reverse.levels(cm_svm_d$Reference) 

cm_svm_d$ref_freq <- cm_svm_d$Freq * ifelse(is.na(cm_svm_d$diag),-1,1)

cm_svm_st <- data.frame(round(cm_svm$overall, 4))
names(cm_svm_st)[1] <- 'Statistics'

cm_svm_plot <- ggplot(data = cm_svm_d, aes(x = Prediction, y = Reference, fill = Freq)) +
  scale_x_discrete(position = 'top') + 
  geom_tile(data = cm_svm_d, aes(fill = ref_freq)) +
  scale_fill_gradient2(guide = FALSE, low = 'cyan', high = 'orange', midpoint = 0,
                       na.value = 'white')+
  geom_text(aes(label = Freq), color = 'black', size = 4) + 
  ggtitle("SVM") + 
  theme_bw() + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        legend.position = 'none',
        panel.border = element_blank(),
        plot.background = element_blank(),
        axis.line = element_blank())
ga_svm <- grid.arrange(cm_svm_plot, tableGrob(cm_svm_st), nrow = 1, ncol = 2)
```

### Random Forest

The main specialization of decision trees is the Random Forest, which is nothing more than a collection of decision trees.

Random Forest is an ensemble method that combines several decision trees and adds a stochastic component to create more diversity between decision trees.
Bagging, or Boostrap Aggregation, applies bootstrap techniques (resampling) to the training dataset to build several decision trees and then obtains the best estimate by voting between the trees or by the weight of the estimates.

It is nothing more than a set of decision trees.
So, we have several models of decision trees that work together to create the predictions in RandomForest, this being, it is usually one of the most accurate models in Machine Learning.

``` r
# Create model with rpart():
modelo_rf_v1 = rpart(diagnosis ~., 
                     data = trainset, 
                     control = rpart.control(cp = .0005))

# Test group Predictions:
tree_pred = predict(modelo_rf_v1, 
                    testset, 
                    type = 'class')

# Model Accuracy:
mean(tree_pred == testset$diagnosis)

[1] 0.963964

# Confusion Matrix:
cm_rf <- confusionMatrix(tree_pred, testset$diagnosis)
cm_rf_d <- data.frame(cm_rf$table)
cm_rf_d$diag <- cm_rf_d$Prediction == cm_rf_d$Reference 
cm_rf_d$ndiag <- cm_rf_d$Prediction != cm_rf_d$Reference      
cm_rf_d[cm_rf_d == 0] <- NA 
cm_rf_d$Reference <-  reverse.levels(cm_rf_d$Reference) 
cm_rf_d$ref_freq <- cm_rf_d$Freq * ifelse(is.na(cm_rf_d$diag),-1,1)

cm_rf_st <- data.frame(round(cm_rf$overall, 4))
names(cm_rf_st)[1] <- 'Statistics'

cm_rf_plot <- ggplot(data = cm_rf_d, 
                     aes(x = Prediction, y = Reference, fill = Freq)) +
  scale_x_discrete(position = 'top') + 
  geom_tile(data = cm_rf_d, aes(fill = ref_freq)) +
  scale_fill_gradient2(guide = FALSE, 
                       low = 'cyan', 
                       high = 'violet', 
                       midpoint = 0,
                       na.value = 'white')+
  geom_text(aes(label = Freq), color = 'black', size = 4) + 
  ggtitle("Random Forest") + 
  theme_bw() + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = 'none',
        panel.border = element_blank(),
        plot.background = element_blank(),
        axis.line = element_blank())
ga_rf <- grid.arrange(cm_rf_plot, 
                      tableGrob(cm_rf_st), 
                      nrow = 1, 
                      ncol = 2)
```

### Evaluating the Models

 <img src="https://github.com/meloandrew/R_Language-Data_Analytics/blob/master/Classification_of_Breast_Tumor_UCI/Images/Confusion_Matrix_Models.png"
      alt = "Confusion_Matrix_Models"
      style="width:600px;height:300px;"/>

## Conclusion

After all this, what model would you choose as a final version?

I believe the support vector machine had shown better accuracy than the other two algorithms.

But, this is not the only way to answer the primary question, we could have used an XGBoost algorithm instead of random forest model or we could have checked for outliers in our dataset and treat them to improve the kNN performance, among many other things. We can't be sure that for this specific problem, an XGBoost algorithm could be better than the random forest model, or by treating outliers the kNN algorithm could obtain better accuracy, in that case, all we can do is a test, experiment, create a hypothesis (good ones related to our business problem and real situations).

When we create a Machine Learning Project, we are working with a workflow of tasks, it can be continuous or a cycle, you create a model, train it, evaluate it, come back to do more exploratory analysis and transformations, then repeat it all. It all depends on the problem you are trying to solve.

## Author

[<img src="https://avatars3.githubusercontent.com/u/47090012?s=460&u=0180e5d8646087e40786286006fc2505548b9e2a&v=4" width=200><br><sub>@meloandrew</sub>](https://github.com/meloandrew) | [<img 
