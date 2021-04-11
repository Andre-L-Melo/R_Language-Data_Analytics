# Predicting Breast Tumor Occurrence

#### Business Problem: Predicting Breast Tumor Occurrence ####
# For this problem, we will use The UCI Repository dataset:
# http://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29

#### Loading Packages ####
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
library(gmodels)

#### Step 1: Collecting and Exploring Data ####

# This dataset has 569 tumor biopsies observations, each one with 32 features. 
# One feature is the biopsies ID, another one is the tumor diagnostic,
# and the rest 30 features are laboratory numerical measures. 
# The tumor diagnostic is codified as 'M' for Malign and 'B' for Benign.

# Load the csv file using the function read.csv:
dados <- read.csv("dataset.csv", stringsAsFactors = TRUE)

# Check variables type:
str(dados)

# Summarize variables by them measures:
summary(dados)

# View dataset (first 5 records):
head(dados)

# Check if variable id has unique registers:
is.recursive(dados$id)

# Check how well the diagnosis variable is distributed:
table(dados$diagnosis)


#### Step 2: Data Preprocessing ####

# Exclude ID Column:
# No matter which machine learning method will be used,ID variables should 
# always be removed. Otherwise, this can lead to wrong results because the 
# the ID variable can be independently used to predict each example.
# Therefore, a model that has an ID as a predictor can suffer from overfitting.
dados$id = NULL
ncol(dados)

# Adjusting target variable label:
# We will rename our target variable label, diagnosis.
# For M we will have Malign and for B we will have Benign.
dados$diagnosis = sapply(dados$diagnosis, 
                         function(x){ifelse(x=='M','Maligno','Benigno')})
head(dados$diagnosis)

# Many classifiers expect a target variable that is a categorical type:
dados$diagnosis <- factor(dados$diagnosis, 
                          levels = c("Benigno", "Maligno"), 
                          labels = c("Benigno", "Maligno"))
str(dados$diagnosis)
table(dados$diagnosis)

# Check the proportion for the target variable distribution.
# This is important in to not create a biased model:
round(prop.table(table(dados$diagnosis)) * 100,1)

# Create a barplot to check target variable distribution:
diagnosis_bar_plot <- ggplot(dados, aes(x=diagnosis, fill = diagnosis)) + 
      geom_bar(alpha = 0.8)
diagnosis_bar_plot

# Check if there is any missing value in our dataset:
sapply(dados,function(x) sum(is.na(x)))

# Central Tendency Measures:
# In our dataset we have a scale difference between some features, 
# which need to be normalized. Otherwise, this can be a problem 
# for algorithms that use distance measures, such as the kNN 
# with the Euclidean Distance 
# (There is more, but the Euclidean Distance is commonly used):
summary(dados[c("radius_mean","area_mean","smoothness_mean")])

# Creating a normalizing function:
normalizer <- function(x) {
  return((x-min(x)) / (max(x) - min(x)))}

# Testing the normalizing function.
# Both results must be identicals:
normalizer(c(1,2,3,4,5))
normalizer(c(10,20,30,40,50))

# Applying the normalizing function in our data:
# First, let's select only the numerical variables, and then
# apply the normalizing function:
dados_norm <- as.data.frame(lapply(dados[2:31], normalizer))
head(dados_norm)
summary(dados_norm)

norm_pairs_plot <- ggpairs(dados_norm, columns = 1:3,
              columnLabels = c("Radius", "Texture", "Perimeter"))
norm_pairs_plot


#### Step 3: Training the model with the kNN algorithm ####

# Bind norm data with target variable:
dados_norm_final <- dados_norm
dados_norm_final$diagnosis <- dados$diagnosis

# Split into training and testing samples:
set.seed(200)
indxTrain <- createDataPartition(y = dados_norm_final$diagnosis,
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
knnFit

# Use plots to see an optimal number of clusters:
# Plotting yields Number of Neighbors Vs accuracy 
# (based on repeated cross-validation)
plot(knnFit)

# Train and Test samples for target variable:
dados_treino_labels_norm <- training_norm$diagnosis
dados_teste_labels_norm <- testing_norm$diagnosis
length(dados_treino_labels_norm)
length(dados_teste_labels_norm)

# Training the kNN Model:
modelo_knn_v1 <- knn(train=training_norm[1:30],
                     test=testing_norm[1:30],
                     cl=dados_treino_labels_norm,
                     k=knnFit$bestTune)

# The kNN function returns the predictions for each execution:
summary(modelo_knn_v1)


#### Step 4: Evaluating the model ####

# Create a Cross Table Prediction x Testing:
CrossTable(x = dados_teste_labels_norm, y = modelo_knn_v1, prop.chisq = FALSE)

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


#### Step 5: Scaling the dataset ####

# The scale function centralizes the z-score for each 
# numerical variable, in this case, we standardize the z-score.
dados_scale <- as.data.frame(scale(dados[-1]))

# Check the result of transformation:
summary(dados_scale$area_mean)

# Bind scale data with target variable:
dados_scale_final <- dados_scale
dados_scale_final$diagnosis <- dados$diagnosis

# Split into training and testing samples:
set.seed(200)
indxTrain <- createDataPartition(y = dados_scale_final$diagnosis,
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
knnFit

# Use plots to see an optimal number of clusters:
# Plotting yields Number of Neighbors Vs accuracy 
# (based on repeated cross-validation)
plot(knnFit)

modelo_knn_v2 <- knn(train = training_scale[1:30],
                     test = testing_scale[1:30],
                     cl = dados_treino_labels_scale,
                     k = knnFit$bestTune)

# CrossTable:
CrossTable(x = dados_teste_labels_scale, y = modelo_knn_v2, prop.chisq = FALSE)

# Model Accuracy: 96%.
round(sum(dados_teste_labels_scale == modelo_knn_v2)/length(dados_teste_labels_scale) * 100)

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
        axis.line = element_blank())
ga_knn <- grid.arrange(cm_knn_plot, tableGrob(cm_knn_st), nrow = 1, ncol = 2)


#### Step 6: Support Vector Machine ####

# SVM or Support Vector Machine can be used for both regression and classification 
# problems. It creates a hyperplan to linearly split your data by adding one or more
# dimensions to your euclidian plan.
set.seed(40)

# Preparing our dataset:
dados <- read.csv("dataset.csv", stringsAsFactors = FALSE)
dados$id = NULL
dados$diagnosis <- as.factor(dados$diagnosis)
dados[, 'index'] <- as.factor(ifelse(runif(nrow(dados))<0.8, 1, 0))
head(dados$index)

# Split into training and testing groups:
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

# Model predictions - Testset:
pred_test <- predict(modelo_svm_v1, testset)
mean(pred_test == testset$diagnosis)

# Confusion Matrix:
cm_svm <- confusionMatrix(pred_test, testset$diagnosis)
cm_svm_d <- data.frame(cm_svm$table)
cm_svm_d$diag <- cm_svm_d$Prediction == cm_svm_d$Reference # Get the Diagonal
cm_svm_d$ndiag <- cm_svm_d$Prediction != cm_svm_d$Reference # Off Diagonal     
cm_svm_d[cm_svm_d == 0] <- NA # Replace 0 with NA for white tiles
cm_svm_d$Reference <-  reverse.levels(cm_svm_d$Reference) # diagonal starts at top left
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


#### Step 7: Random Forest ####

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


#### Step 8: Evaluating models ####

grid.arrange(ga_knn, ga_svm, ga_rf, nrow = 3, ncol = 1)
