---
title: "Health Analytics"
output: 
  pdf_document:
    keep_md: true
---


```r
knitr::opts_chunk$set(echo = TRUE, cache = TRUE)
```

## Health Analytics Project

Projeto - Podemos Prever o Tempo de Sobrevivência dos Pacientes 1 Ano Após Receberem um Transplante?

## Code

1- Loading Packages


```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```
## Loading required package: ggplot2
```

```
## Registered S3 method overwritten by 'quantmod':
##   method            from
##   as.zoo.data.frame zoo
```

```
## 
## Attaching package: 'neuralnet'
```

```
## The following object is masked from 'package:dplyr':
## 
##     compute
```

2 - Loading Dataset



```r
dados <- read.csv("dados/dataset.csv", header = TRUE, na.strings = c(""), 
                  stringsAsFactors =  TRUE)
dim(dados)
```

```
## [1] 79100    46
```

3 - Exploratory Analysis


```r
# Tipos dos dados
str(dados)
```

```
## 'data.frame':	79100 obs. of  46 variables:
##  $ ï..DAYSWAIT_CHRON   : int  7 5 10 9 2 6 4 9 1 11 ...
##  $ PSTATUS             : int  0 0 0 0 0 0 0 1 1 0 ...
##  $ FINAL_MELD_SCORE    : int  39 19 22 35 35 19 35 14 36 23 ...
##  $ PTIME               : int  51 6 6 27 54 10 51 0 3 6 ...
##  $ TX_DATE             : Factor w/ 6139 levels "1/1/2003","1/1/2004",..: 1822 1805 1890 1873 1754 1822 1788 1890 1754 1941 ...
##  $ PX_STAT             : Factor w/ 2 levels "A","D": 1 1 1 1 1 1 1 2 2 1 ...
##  $ PX_STAT_DATE        : Factor w/ 5774 levels ".","1/1/2003",..: 2046 1818 377 264 2030 377 2013 1803 1723 442 ...
##  $ AGE                 : int  30 63 48 54 71 62 62 56 28 66 ...
##  $ ABO                 : Factor w/ 8 levels "A","A1","A1B",..: 8 1 7 8 8 8 8 1 7 1 ...
##  $ GENDER              : int  1 0 0 1 1 1 1 0 1 0 ...
##  $ WGT_KG_TCR          : num  56.2 81.9 78.9 63.5 75.8 ...
##  $ HGT_CM_TCR          : num  163 178 181 155 163 ...
##  $ BMI_TCR             : num  21.3 25.9 24.1 26.4 28.7 ...
##  $ DIAB                : int  1 1 1 1 1 3 1 1 1 1 ...
##  $ INIT_AGE            : int  30 63 48 54 71 62 62 56 28 66 ...
##  $ ETHCAT              : int  1 1 1 1 1 1 1 4 2 1 ...
##  $ REGION              : int  2 3 10 4 3 3 5 3 3 11 ...
##  $ PERM_STATE          : Factor w/ 56 levels "AK","AL","AR",..: 22 12 38 47 20 20 6 42 2 44 ...
##  $ TX_Year             : int  2018 2018 2018 2018 2018 2018 2018 2018 2018 2018 ...
##  $ TX_PROCEDUR_TY      : int  701 701 701 701 701 701 701 701 701 701 ...
##  $ MED_COND_TRR        : int  1 3 3 2 3 1 1 3 1 3 ...
##  $ PREV_TX             : Factor w/ 2 levels "N","Y": 1 1 1 1 1 2 1 1 1 1 ...
##  $ AGE_DON             : int  24 34 42 48 37 38 23 47 18 35 ...
##  $ GENDER_DON          : int  1 0 1 1 1 0 0 0 0 0 ...
##  $ HGT_CM_DON_CALC     : num  173 183 173 157 173 165 175 163 173 178 ...
##  $ WGT_KG_DON_CALC     : num  75 90 107 93 81.6 55.7 93 49.9 68 67.7 ...
##  $ BMI_DON_CALC        : num  25.1 26.9 35.8 37.7 27.3 ...
##  $ COD_CAD_DON         : int  3 3 1 2 3 3 1 2 3 1 ...
##  $ ETHCAT_DON          : int  2 1 1 1 1 1 4 4 4 1 ...
##  $ HOME_STATE_DON      : Factor w/ 57 levels "AK","AL","AR",..: 42 12 38 48 3 11 5 43 43 45 ...
##  $ DIABETES_DON        : Factor w/ 3 levels "N","U","Y": 1 1 3 1 1 1 1 1 1 1 ...
##  $ HIST_HYPERTENS_DON  : Factor w/ 3 levels "N","U","Y": 1 1 3 3 1 1 1 1 1 1 ...
##  $ HIST_IV_DRUG_OLD_DON: Factor w/ 3 levels "N","U","Y": NA NA NA NA NA NA NA NA NA NA ...
##  $ ABO_DON             : Factor w/ 8 levels "A","A1","A1B",..: 8 1 7 8 8 8 8 4 7 2 ...
##  $ HIST_CANCER_DON     : Factor w/ 3 levels "N","U","Y": 1 1 1 1 1 1 1 1 1 1 ...
##  $ ALCOHOL_HEAVY_DON   : Factor w/ 3 levels "N","U","Y": 1 1 1 1 1 3 1 1 1 1 ...
##  $ ABO_MAT             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ COLD_ISCH           : num  4.3 3.48 4.95 3.62 7.5 5.33 9.14 5.25 4.6 5.6 ...
##  $ MALIG               : Factor w/ 3 levels "N","U","Y": 2 2 2 2 2 2 2 2 2 3 ...
##  $ HGT_CM_CALC         : num  163 178 183 155 163 ...
##  $ WGT_KG_CALC         : num  45 85 76.2 61.1 70.8 ...
##  $ BMI_CALC            : num  17 26.9 22.8 25.5 26.8 47.9 19.5 32.1 33.7 24.9 ...
##  $ TX_MELD             : Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 1 1 1 1 ...
##  $ LISTYR              : int  2018 2018 2018 2018 2018 2018 2018 2018 2018 2018 ...
##  $ LiverSize           : num  1722 1935 1987 1669 1605 ...
##  $ LiverSizeDon        : num  2277 2387 2555 2255 2215 ...
```

Explorando os dados das variáveis numéricas:


```r
hist(dados$AGE)
```

![](HealthAnalytics_files/figure-latex/numerical variable-1.pdf)<!-- --> 

```r
hist(dados$AGE_DON)
```

![](HealthAnalytics_files/figure-latex/numerical variable-2.pdf)<!-- --> 

```r
hist(dados$PTIME)
```

![](HealthAnalytics_files/figure-latex/numerical variable-3.pdf)<!-- --> 

```r
hist(dados$ï..DAYSWAIT_CHRON)
```

![](HealthAnalytics_files/figure-latex/numerical variable-4.pdf)<!-- --> 

```r
hist(dados$FINAL_MELD_SCORE)
```

![](HealthAnalytics_files/figure-latex/numerical variable-5.pdf)<!-- --> 

Explorando os dados das variáveis categóricas


```r
dados$DIAB <- as.factor(dados$DIAB)
table(dados$DIAB)
```

```
## 
##     1     2     3     4     5   998 
## 57017  1520 16476   309  2939   828
```

```r
dados$PSTATUS <- as.factor(dados$PSTATUS)
table(dados$PSTATUS)
```

```
## 
##     0     1 
## 55634 23466
```

```r
dados$GENDER <- as.factor(dados$GENDER)
dados$GENDER_DON <- as.factor(dados$GENDER_DON)
table(dados$GENDER)
```

```
## 
##     0     1 
## 53312 25788
```

```r
table(dados$GENDER_DON)
```

```
## 
##     0     1 
## 47310 31790
```

```r
dados$REGION <- as.factor(dados$REGION)
table(dados$REGION)
```

```
## 
##     1     2     3     4     5     6     7     8     9    10    11 
##  2802  9435 14070  7436  9962  2505  6503  5458  4745  7656  8528
```

```r
dados$TX_Year <- as.factor(dados$TX_Year)
table(dados$TX_Year)
```

```
## 
## 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 
##    1 1456 2948 3717 4062 4475 4501 4459 4641 4583 4745 4751 4898 5128 5430 6239 
## 2017 2018 
## 6519 6547
```

```r
dados$MALIG <- as.factor(dados$MALIG)
table(dados$MALIG)
```

```
## 
##     N     U     Y 
## 42828 21290 14982
```

```r
dados$HIST_CANCER_DON <- as.factor(dados$HIST_CANCER_DON)
table(dados$HIST_CANCER_DON)
```

```
## 
##     N     U     Y 
## 76040   398  2660
```

```r
# Considerando apenas os pacientes que sobreviveram ao primeiro ano de cirurgia
dados1 <- dados %>%
  filter(PTIME > 365) %>%
  mutate(PTIME = (PTIME - 365))

dim(dados1)
```

```
## [1] 61600    46
```

```r
# Dos pacientes que sobreviveram ao primeiro ano da cirurgia,
# filtramos os que permaneceram vivos por até três anos depois da cirurgia.
dados2 <- dados1 %>%
  filter(PTIME <= (365*3))

dim(dados2)
```

```
## [1] 23348    46
```

Vamos separar variáveis numéricas e categóricas:


```r
dados_num <- dados2[, !unlist(lapply(dados2, is.factor))]
dim(dados_num)
```

```
## [1] 23348    25
```

```r
dados_fator <- dados2[,unlist(lapply(dados2, is.factor))]
dim(dados_fator)
```

```
## [1] 23348    21
```

Correlação entre as variáveis numéricas
Para variáveis categóricas usamos associação:


```r
df_corr <- round(cor(dados_num, use = "complete.obs"), 2)
ggcorrplot(df_corr, insig = "blank", 
           colors = c("blue", "white", "green"))
```

![](HealthAnalytics_files/figure-latex/correlation matrix-1.pdf)<!-- --> 

4 - Pre processing


```r
# Padronização das variáveis numéricas e combinação em um novo dataframe 
# com as variáveis categóricas

# Padronização
dados_num_norm <- scale(dados_num)
dados_final <- cbind(dados_num_norm, dados_fator)
dim(dados_final)
```

```
## [1] 23348    46
```

5 - Train and test samples


```r
# Divisão dos dados em treino e teste
set.seed(1)
index <- sample(1:nrow(dados_final), dim(dados_final)[1]*.7)
dados_treino <- dados_final[index,]
dados_teste <- dados_final[-index,]

# Remove os registros dos anos de 2001 e 2002 (pois foram os primeiros anos da coleta de dados)
dados_treino <- dados_treino %>%
  filter(TX_Year != 2001) %>%
  filter(TX_Year != 2002)

dados_teste <- dados_teste %>%
  filter(TX_Year != 2001) %>%
  filter(TX_Year != 2002)
```

6 - Regression Model: Baseline


```r
# Modelagem Preditiva com Modelo de Regressão

# Vamos trabalhar apenas com algumas variáveis mais significativas para o problema.
# Isso também reduz o tempo total de treinamento.
# ?lm
modelo_v1 <- lm(PTIME ~ FINAL_MELD_SCORE + 
                  REGION + 
                  LiverSize + 
                  LiverSizeDon + 
                  ALCOHOL_HEAVY_DON + 
                  MALIG + 
                  TX_Year,
                data = dados_treino)

summary(modelo_v1)
```

```
## 
## Call:
## lm(formula = PTIME ~ FINAL_MELD_SCORE + REGION + LiverSize + 
##     LiverSizeDon + ALCOHOL_HEAVY_DON + MALIG + TX_Year, data = dados_treino)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -2.82000 -0.25968 -0.00686  0.31820  1.98020 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)    
## (Intercept)        -0.057395   0.272740  -0.210 0.833328    
## FINAL_MELD_SCORE   -0.005884   0.005555  -1.059 0.289479    
## REGION2             0.021997   0.031158   0.706 0.480214    
## REGION3            -0.006592   0.030028  -0.220 0.826252    
## REGION4             0.032639   0.032013   1.020 0.307955    
## REGION5             0.054480   0.030982   1.758 0.078693 .  
## REGION6             0.092334   0.041076   2.248 0.024598 *  
## REGION7             0.038559   0.033228   1.160 0.245883    
## REGION8             0.096889   0.034389   2.817 0.004847 ** 
## REGION9             0.041179   0.035508   1.160 0.246180    
## REGION10            0.043031   0.032285   1.333 0.182602    
## REGION11            0.042307   0.031578   1.340 0.180337    
## LiverSize           0.016993   0.005428   3.131 0.001748 ** 
## LiverSizeDon        0.010583   0.005384   1.966 0.049365 *  
## ALCOHOL_HEAVY_DONU -0.142699   0.039135  -3.646 0.000267 ***
## ALCOHOL_HEAVY_DONY  0.005513   0.014420   0.382 0.702258    
## MALIGU             -0.126692   0.021201  -5.976 2.34e-09 ***
## MALIGY             -0.087577   0.018653  -4.695 2.69e-06 ***
## TX_Year2004         0.053256   0.274566   0.194 0.846207    
## TX_Year2005         0.038102   0.273314   0.139 0.889130    
## TX_Year2006        -0.016489   0.273384  -0.060 0.951906    
## TX_Year2007        -0.009258   0.273289  -0.034 0.972976    
## TX_Year2008         0.015776   0.273194   0.058 0.953952    
## TX_Year2009         0.082104   0.273240   0.300 0.763812    
## TX_Year2010         0.047056   0.273247   0.172 0.863275    
## TX_Year2011         0.030757   0.273405   0.112 0.910432    
## TX_Year2012         0.088236   0.273382   0.323 0.746883    
## TX_Year2013         0.304265   0.273064   1.114 0.265184    
## TX_Year2014         1.336612   0.271706   4.919 8.77e-07 ***
## TX_Year2015         0.703425   0.272098   2.585 0.009741 ** 
## TX_Year2016        -0.214548   0.272186  -0.788 0.430569    
## TX_Year2017        -1.067647   0.272330  -3.920 8.88e-05 ***
## TX_Year2018        -1.304908   0.275309  -4.740 2.16e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.6638 on 15805 degrees of freedom
##   (385 observations deleted due to missingness)
## Multiple R-squared:  0.561,	Adjusted R-squared:  0.5601 
## F-statistic: 631.2 on 32 and 15805 DF,  p-value: < 2.2e-16
```

```r
# Avaliação do modelo

# Com dados de treino
modelo_v1_pred_1 = predict(modelo_v1, newdata = dados_treino)
accuracy(modelo_v1_pred_1, dados_treino$PTIME)
```

```
##                    ME      RMSE       MAE      MPE    MAPE
## Test set 1.328345e-14 0.6631428 0.4694482 31.36785 109.317
```

```r
# Com dados de teste
modelo_v1_pred_2 = predict(modelo_v1, newdata = dados_teste)
accuracy(modelo_v1_pred_2, dados_teste$PTIME)
```

```
##                   ME      RMSE       MAE      MPE     MAPE
## Test set -0.01551896 0.6774505 0.4767675 25.16939 99.65712
```

Distribuição do erro de validação:


```r
par(mfrow = c(1,1))
residuos <- dados_teste$PTIME - modelo_v1_pred_2
hist(residuos, xlab = "Resíduos", main = "Sobreviventes de 1 a 3 Anos")
```

![](HealthAnalytics_files/figure-latex/validation error-1.pdf)<!-- --> 

```r
index1 <- sample(1:length(residuos), length(residuos) * 0.7)
testss <- residuos[index1]
shapiro.test(testss)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  testss
## W = 0.96375, p-value < 2.2e-16
```

7 - Data normalization


```r
# Agora vamos padronizar os dados de treino e teste de forma separada.
# Executamos o procedimento anterior, mas de forma separada em cada subset.
set.seed(1)
index <- sample(1:nrow(dados2), dim(dados2)[1]*.7)
dados_treino <- dados2[index,]
dados_teste <- dados2[-index,]

# Vamos separar variáveis numéricas e categóricas (treino)
dados_treino_num <- dados_treino[,!unlist(lapply(dados_treino, is.factor))]
dim(dados_treino_num)
```

```
## [1] 16343    25
```

```r
dados_treino_fator <- dados_treino[,unlist(lapply(dados_treino, is.factor))]
dim(dados_treino_fator)
```

```
## [1] 16343    21
```

```r
# Vamos separar variáveis numéricas e categóricas (teste)
dados_teste_num <- dados_teste[,!unlist(lapply(dados_teste, is.factor))]
dim(dados_teste_num)
```

```
## [1] 7005   25
```

```r
dados_teste_fator <- dados_teste[,unlist(lapply(dados_teste, is.factor))]
dim(dados_teste_fator)
```

```
## [1] 7005   21
```

```r
# Padronização
dados_treino_num_norm <- scale(dados_treino_num)
dados_treino_final <- cbind(dados_treino_num_norm, dados_treino_fator)
dim(dados_treino_final)
```

```
## [1] 16343    46
```

```r
# Padronização
dados_teste_num_norm <- scale(dados_teste_num)
dados_teste_final <- cbind(dados_teste_num_norm, dados_teste_fator)
dim(dados_teste_final)
```

```
## [1] 7005   46
```

```r
# Filtra os anos de 2001 e 2002
dados_treino_final <- dados_treino_final %>%
  filter(TX_Year != 2001) %>%
  filter(TX_Year != 2002)

dados_teste_final <- dados_teste_final %>%
  filter(TX_Year != 2001) %>%
  filter(TX_Year != 2002)
```

8 - Regression Model: Second Version


```r
# Cria novamente o modelo agora com o outro dataset de treino
modelo_v1 <- lm(PTIME ~ FINAL_MELD_SCORE + 
                  REGION + 
                  LiverSize + 
                  LiverSizeDon + 
                  ALCOHOL_HEAVY_DON + 
                  MALIG + 
                  TX_Year,
                data = dados_treino_final)

summary(modelo_v1)
```

```
## 
## Call:
## lm(formula = PTIME ~ FINAL_MELD_SCORE + REGION + LiverSize + 
##     LiverSizeDon + ALCOHOL_HEAVY_DON + MALIG + TX_Year, data = dados_treino_final)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -2.81872 -0.25956 -0.00686  0.31805  1.97930 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)    
## (Intercept)        -0.060301   0.272615  -0.221 0.824945    
## FINAL_MELD_SCORE   -0.005869   0.005541  -1.059 0.289479    
## REGION2             0.021987   0.031144   0.706 0.480214    
## REGION3            -0.006589   0.030014  -0.220 0.826252    
## REGION4             0.032625   0.031999   1.020 0.307955    
## REGION5             0.054455   0.030968   1.758 0.078693 .  
## REGION6             0.092292   0.041057   2.248 0.024598 *  
## REGION7             0.038541   0.033212   1.160 0.245883    
## REGION8             0.096845   0.034374   2.817 0.004847 ** 
## REGION9             0.041161   0.035492   1.160 0.246180    
## REGION10            0.043012   0.032271   1.333 0.182602    
## REGION11            0.042288   0.031564   1.340 0.180337    
## LiverSize           0.016932   0.005409   3.131 0.001748 ** 
## LiverSizeDon        0.010607   0.005396   1.966 0.049365 *  
## ALCOHOL_HEAVY_DONU -0.142635   0.039117  -3.646 0.000267 ***
## ALCOHOL_HEAVY_DONY  0.005510   0.014414   0.382 0.702258    
## MALIGU             -0.126634   0.021191  -5.976 2.34e-09 ***
## MALIGY             -0.087537   0.018644  -4.695 2.69e-06 ***
## TX_Year2004         0.053231   0.274441   0.194 0.846207    
## TX_Year2005         0.038085   0.273189   0.139 0.889130    
## TX_Year2006        -0.016481   0.273260  -0.060 0.951906    
## TX_Year2007        -0.009254   0.273165  -0.034 0.972976    
## TX_Year2008         0.015769   0.273070   0.058 0.953952    
## TX_Year2009         0.082067   0.273115   0.300 0.763812    
## TX_Year2010         0.047035   0.273123   0.172 0.863275    
## TX_Year2011         0.030743   0.273280   0.112 0.910432    
## TX_Year2012         0.088196   0.273257   0.323 0.746883    
## TX_Year2013         0.304126   0.272940   1.114 0.265184    
## TX_Year2014         1.336004   0.271582   4.919 8.77e-07 ***
## TX_Year2015         0.703105   0.271974   2.585 0.009741 ** 
## TX_Year2016        -0.214450   0.272062  -0.788 0.430569    
## TX_Year2017        -1.067161   0.272206  -3.920 8.88e-05 ***
## TX_Year2018        -1.304314   0.275184  -4.740 2.16e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.6635 on 15805 degrees of freedom
##   (385 observations deleted due to missingness)
## Multiple R-squared:  0.561,	Adjusted R-squared:  0.5601 
## F-statistic: 631.2 on 32 and 15805 DF,  p-value: < 2.2e-16
```

```r
# Avaliação do modelo

# Com dados de treino
modelo_v1_pred_1 = predict(modelo_v1, newdata = dados_treino_final)
accuracy(modelo_v1_pred_1, dados_treino_final$PTIME)
```

```
##                    ME     RMSE       MAE      MPE     MAPE
## Test set 1.329679e-14 0.662841 0.4692345 28.86713 118.5728
```

```r
# Com dados de teste
modelo_v1_pred_2 = predict(modelo_v1, newdata = dados_teste_final)
accuracy(modelo_v1_pred_2, dados_teste_final$PTIME)
```

```
##                    ME      RMSE       MAE      MPE    MAPE
## Test set -0.005736363 0.6779696 0.4773144 28.45828 104.231
```

Distribuição do erro de validação:


```r
par(mfrow = c(1,1))
residuos <- dados_teste_final$PTIME - modelo_v1_pred_2
hist(residuos, xlab = "Resíduos", main = "Sobreviventes de 1 a 3 Anos")
```

![](HealthAnalytics_files/figure-latex/error validation-1.pdf)<!-- --> 

Vamos desfazer a escala dos dados:


```r
variaveis_amostra <- c("PTIME",
                       "FINAL_MELD_SCORE",
                       "REGION",
                       "LiverSize",
                       "LiverSizeDon",
                       "ALCOHOL_HEAVY_DON",
                       "MALIG",
                       "TX_Year")

# Removemos valores NA das variáveis que usaremos para aplicar o unscale
dados_unscale <- na.omit(dados2[,variaveis_amostra])

# Retorna os dados unscale
dados_final_unscale <- dados_unscale[-index,] %>%
  filter(TX_Year!= 2001) %>%
  filter(TX_Year!= 2002)
```

Histograma dos dados sem escala (formato original):


```r
previsoes = predict(modelo_v1, newdata = dados_final_unscale)
hist(previsoes)
```

![](HealthAnalytics_files/figure-latex/histogram unscale data-1.pdf)<!-- --> 

```r
accuracy(previsoes, dados_final_unscale$PTIME)
```

```
##                ME     RMSE      MAE      MPE     MAPE
## Test set 438.6935 547.1971 448.7258 -14.7297 161.6181
```

9 - Neural Network Model


```r
# Preparação dos dados
dados_final2 <- na.omit(dados_final[,variaveis_amostra])
dim(dados_final2)
```

```
## [1] 22619     8
```

```r
str(dados_final2)
```

```
## 'data.frame':	22619 obs. of  8 variables:
##  $ PTIME            : num  -1.363 0.745 -1.326 -1.105 -0.812 ...
##  $ FINAL_MELD_SCORE : num  0.859 -0.406 -0.933 -1.038 -0.406 ...
##  $ REGION           : Factor w/ 11 levels "1","2","3","4",..: 8 3 11 5 2 9 3 5 7 4 ...
##  $ LiverSize        : num  -0.2862 -0.0409 1.705 0.8967 -0.2815 ...
##  $ LiverSizeDon     : num  1.571 0.963 0.226 -0.61 -1.693 ...
##  $ ALCOHOL_HEAVY_DON: Factor w/ 3 levels "N","U","Y": 1 1 1 3 2 1 1 3 1 1 ...
##  $ MALIG            : Factor w/ 3 levels "N","U","Y": 3 1 1 1 1 3 1 1 1 1 ...
##  $ TX_Year          : Factor w/ 18 levels "2001","2002",..: 11 4 6 7 5 6 5 6 7 5 ...
##  - attr(*, "na.action")= 'omit' Named int [1:729] 1 2 3 4 5 6 7 8 9 11 ...
##   ..- attr(*, "names")= chr [1:729] "1" "2" "3" "4" ...
```

```r
# Retorna somente as variáveis que não são do tipo fator
variaveis_numericas <- !unlist(lapply(dados_final2, is.factor))
# View(variaveis_numericas)

# Retorna o nome das variáveis numéricas
variaveis_numericas_nomes <- names(dados_final2[,!unlist(lapply(dados_final2, is.factor))])
# View(variaveis_numericas_nomes)

# Gera o dataframe final com variáveis dummy
# ?class.ind
df_final = cbind(dados_final2[,variaveis_numericas],
                 class.ind(dados_final2$REGION),
                 class.ind(dados_final2$ALCOHOL_HEAVY_DON),
                 class.ind(dados_final2$MALIG),
                 class.ind(dados_final2$TX_Year))

dim(df_final)
```

```
## [1] 22619    39
```

```r
# View(df_final)

# Nomes das variáveis
names(df_final) = c(variaveis_numericas_nomes,
                    paste("REGION", c(1:11),sep = ""),
                    paste("ALCOHOL_HEAVY_DON", c(1:3),sep = ""),
                    paste("MALIG", c(1:3), sep = ""),
                    paste("LISTYR", c(01:18), sep = ""))

dim(df_final)
```

```
## [1] 22619    39
```

```r
# Divisão em dados de treino e teste
index2 <- sample(1:nrow(df_final), dim(df_final)[1]*.70)
dados_treino2 <- df_final[index2,]
dados_teste2 <- df_final[-index2,]
print(dados_teste2[1,])
```

```
##        PTIME FINAL_MELD_SCORE LiverSize LiverSizeDon REGION1 REGION2 REGION3
## 56 -1.435102       -0.5112898 -1.887502     0.116546       0       0       0
##    REGION4 REGION5 REGION6 REGION7 REGION8 REGION9 REGION10 REGION11
## 56       0       0       0       1       0       0        0        0
##    ALCOHOL_HEAVY_DON1 ALCOHOL_HEAVY_DON2 ALCOHOL_HEAVY_DON3 MALIG1 MALIG2
## 56                  1                  0                  0      1      0
##    MALIG3 LISTYR1 LISTYR2 LISTYR3 LISTYR4 LISTYR5 LISTYR6 LISTYR7 LISTYR8
## 56      0       0       0       0       0       0       0       1       0
##    LISTYR9 LISTYR10 LISTYR11 LISTYR12 LISTYR13 LISTYR14 LISTYR15 LISTYR16
## 56       0        0        0        0        0        0        0        0
##    LISTYR17 LISTYR18
## 56        0        0
```

```r
# Modelo
# www.deeplearningbook.com.br
# ?neuralnet
modelo_v2 <- neuralnet::neuralnet(PTIME ~ ., 
                                  data = dados_treino2, 
                                  linear.output = TRUE,
                                  hidden = 2,
                                  stepmax = 1e7)
```

Neural Network Plot:


```r
plot(modelo_v2,
     col.entry.synapse = "red", 
     col.entry = "brown",
     col.hidden = "green", 
     col.hidden.synapse = "black",
     col.out = "yellow", 
     col.out.synapse = "purple",
     col.intercept = "green", 
     fontsize = 10,
     show.weights = TRUE ,
     rep = "best")
```

![](HealthAnalytics_files/figure-latex/neural network plot-1.pdf)<!-- --> 

Avaliação do modelo

Com dados de treino:


```r
modelo_v2_pred_1 <- compute(modelo_v2, dados_treino2)
accuracy(unlist(modelo_v2_pred_1), dados_treino2$PTIME)
```

```
##                  ME    RMSE    MAE      MPE     MAPE
## Test set -0.9977917 1.41197 1.1868 118.2142 337.1391
```

Com dados de teste:


```r
modelo_v2_pred_2 <- compute(modelo_v2, dados_teste2)
accuracy(unlist(modelo_v2_pred_2), dados_teste2$PTIME)
```

```
##                  ME     RMSE      MAE      MPE     MAPE
## Test set -0.9986846 1.416642 1.191281 126.3079 309.9417
```

## Insights

O modelo de regressão linear apresentou uma taxa de erro menor e, portanto, deve ser usado como versão final.

Sim, conseguimos prever o tempo de sobrevivência dos pacientes 1 ano após receberem um transplante.

