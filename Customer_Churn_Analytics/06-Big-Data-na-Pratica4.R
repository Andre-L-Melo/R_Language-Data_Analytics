# Big Data na Prática 4 - Customer Churn Analytics 

# A rotatividade (churn) de clientes ocorre quando clientes ou assinantes param de fazer negócios 
# com uma empresa ou serviço. Também é conhecido como perda de clientes ou taxa de cancelamento.

# Um setor no qual saber e prever as taxas de cancelamento é particularmente útil 
# é o setor de telecomunicações, porque a maioria dos clientes tem várias opções 
# de escolha dentro de uma localização geográfica.

# Neste projeto, vamos prever a rotatividade (churn) de clientes usando um conjunto 
# de dados de telecomunicações.Usaremos a regressão logística, a árvore de decisão 
# e a floresta aleatória como modelos de Machine Learning. 

# Usaremos um dataset oferecido gratuitamente no portal IBM Sample Data Sets. 
# Cada linha representa um cliente e cada coluna contém os atributos desse cliente.

# https://www.ibm.com/communities/analytics/watson-analytics-blog/guide-to-sample-datasets/

# Definindo o diretório de trabalho
setwd("C:/CursoFCD/3.0BigData_Analytics_R_e_Azure_MachineLearning/Pratica/Cap06")
getwd()

# Carregando os Pacotes
library(plyr)
library(dplyr)
library(corrplot)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(caret) # Oferece os algoritmos de regressão logística e árvore de decisão
library(MASS)
library(randomForest) # Oferece o algoritmo de floresta aleatória
library(party) # Oferece ferramentas de Relatórios
sessionInfo()

# **** Carregando e Limpando os Dados ****

# Os dados brutos contém 7043 linhas (clientes) e 21 colunas (recursos).
# A coluna "churn" é o nosso alvo.
churn <- read.csv('06-Telco-Customer-Churn.csv', stringsAsFactors = TRUE)

# A coluna de interesse, que é a coluna "churn" é uma coluna que armazena valores categóricos, ou 
# fatores, com apenas dois níveis : "Yes" and "No". Ou seja, o cliente cancelou o plano ou não?
View(churn)
head(churn, 3)
dim(churn)
nrow(churn)
ncol(churn)
str(churn)

# Utilizar o sapply para verificar o número de valores ausentes (missing) em cada coluna.
# Descobrimos que há 11 valores ausentes nas colunas "Totalcharges".
# Então, vamos remover todas as linhas com valores ausentes.
# A função de x irá realizar a soma para cada elemento do dataframe, ou seja, para suas 21 colunas,
# de todos os elementos que são NA, Missing Values.
sapply(churn,function(x) sum (is.na(x)))
help(complete.cases) # Retorna um vetor lógico com os cases completos (no missing values).
example(complete.cases)
# Irá constar apenas as linhas completas do dataframe original, sem missing values.
churn <- churn[complete.cases(churn),]
# Veja que, não temos mais nenhum missing value em nenhuma linha do dataframe.
sapply(churn,function(x) sum (is.na(x)))

# Olhe para as variáveis, podemos ver que temos algumas limpezas e ajustes para fazer.

# Primeira mudança: Vamos mudar "No internet service" para "No" por seis colunas, que são:
# "OnlineSecurity", "OnlineBackup", "DeviceProtection", "TechSupport", "StreamingTV",
# "StreamingMovies".
str(churn)
summary(churn)
# Note que, as seis colunas começam na posição 10 do dataframe e vão até a posição 15, analisando
# na numeração da coluna do dataframe.
# A ideia é criar um loop, ou laço, que irá alterar esse dado apenas para as colunas da posição 10
# até a posição 15 do dataframe.
# Inicialmente, criamos um vetor que irá de 10 até 15, simbolizando essas colunas:
cols_recode1 <- c(10:15)
# Lógica:
# Criar um loop que irá armazenar nas colunas de 10 até 15 os valores substituídos desejados.
# O loop deve ser limitado de 1 até o número de colunas desejadas (de 10 até 15 totalizando 6).
# No loop poderíamos colocar o limite superior igual a 6 ao invés de usar ncol.
# Dentro do loop precisamos definir as colunas de churn como indo de 10 até 15, por isso usamos
# um vetor de 10:15 como índice de coluna, e selecionamos a coluna pelo integrador i.
# Guardamos na coluna correspondente a 1 os dados em forma de fator com a variável desejada, fazemos
# essa substituição com a função mapvalues.
for(i in 1:ncol(churn[,cols_recode1])){
  churn[,cols_recode1][,i] <- as.factor(mapvalues
                                        (churn[,cols_recode1][,i],
                                          from = c("No internet service"),
                                          to = c("No")))
}

View(churn)

# Segunda mudança: Vamos mudar "No phone service" para "No" para a coluna "MultipleLines"
churn$MultipleLines <- as.factor(mapvalues(churn$MultipleLines,
                                           from = c("No phone service"),
                                           to = c("No")))


head(churn,3)

# Terceira mudança: Como a permanência mínima é de 1 mês e a permanência máxima é de 
# 72 meses, podemos agrupá-los em cinco grupos de posse (tenure):
# "0-12 Mês", "12-24 Mês", "24-48 Mês", "48-60 Mês", Mês "," > 60 Mês.
min(churn$tenure); max(churn$tenure)
# Criar a função que realizará a operação de classificação por grupo
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
# Aplicar a função na coluna com os dados de tenure
churn$tenure_group <- sapply(churn$tenure, group_tenure)
churn$tenure_group <- as.factor(churn$tenure_group)
str(churn$tenure_group)
View(churn)

# Quarta mudança: Alteramos os valores na coluna "SeniorCitizen" de 0 ou 1 para "No" ou "Yes"
churn$SeniorCitizen <- as.factor(mapvalues(churn$SeniorCitizen,
                                           from = c("0","1"),
                                           to = c("No","Yes")))
str(churn$SeniorCitizen)


# Quinta mudança: Removemos as colunas que não precisamos para a análise
# Geralmente, o ID não precisa ser utilizado no processo de modelagem, pois o ID
# é um identificador único, sendo uma informação não relevante para o treinamento
# do modelo de Machine Learning.
churn$customerID <- NULL
churn$tenure <- NULL
View(churn)

#### **** Análise Exploratória dos Dados e Seleção de Recursos **** ####

### Verificar a correlação entre as variáveis numéricas ###
# Quais são as variáveis numéricas: usamos a função sapply que verificará quais
# colunas armazenam registros numéricos ou não.
numeric.var <- sapply(churn,is.numeric)
numeric.var
# Armazenaremos esse resultado em uma matriz de correlação
corr.matrix <- cor(churn[,numeric.var])
# Vemos que existem duas variáveis numéricas: MonthlyCharges e TotalCharges
corr.matrix
# Plotamos um gráfico de correlação entre as duas variáveis
corrplot(corr.matrix,main="\n\nNumerical Variable Correlation Chart", col = cm.colors(100), tl.col = "black")

corrplot(corr.matrix)
# Precisamos utilizar essas duas variáveis durante o processo de análise?
# Temos duas variáveis que praticamente querem dizer a mesma coisa,
# talvez se utilizarmos ambas no mesmo processo de Machine Learning,
# poderá causar um overfitting.
# Vemos, pelo gráfico, que a correlação entre as duas variáveis é de 0.65,
# o que é um valor relativamente alto. Se incluirmos ambas no modelo, 
# poderemos sofrer do problema de multicolinearidade.
# Por conta disso, simplesmente removemos uma das variáveis.
# Os encargos mensais e os encargos totais estão correlacionados. 
# Então, um deles será removido do modelo. Nós removemos Total Charges.
churn$TotalCharges <- NULL

##### Gráficos de Barra de Variáveis Categóricas #####
# Os gráficos serão plotados utilizando o pacote ggplot2, função ggplot
# Primeiro iremos analisar a relação de distribuição de quatro variáveis
# categóricas, sendo plotada em gráficos com coordenadas invertidas e 
# dentro da mesma área de plotagem.
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

# Mais 4 variáveis:
# PHONESERVICE:
p5 <- ggplot(churn, aes(x=PhoneService)) + ggtitle("Phone Service") + xlab("Phone Service") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5, fill = "wheat1", alpha = 0.8) + 
  ylab("Percentage") + coord_flip() + theme_minimal()
# MULTIPLELINES
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

# Mais 4 variáveis:
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

# Mais 5 variáveis:
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

View(churn)

# Todas as variáveis categóricas parecem ter uma distribuição razoavelmente ampla, 
# portanto, todas elas serão mantidas para análise posterior.


# **** Modelagem Preditiva ****

#### Regressão Logística ####
# -> A regressão logística é um algoritmo de Machine Learning para classificação. 

# Primeiramente, dividimos os dados em conjuntos de treinamento e testes
help("createDataPartition")
help("set.seed")
# A função createDataPartition cria uma série repartições para testes e a mesma
# pertence ao pacote caret. 
# O parâmetro p recebe uma porcentagem dos dados que irão para treinamento.
# Basicamente, teremos 70 porcento dos dados que irão para treinamento e 
# o restante irão para teste.
intrain <- createDataPartition(churn$Churn, p=0.7, list = FALSE)
class(intrain) # uma matriz com os dados de teste 
# Garante que a sequência randômica gerada pelo script da aula
set.seed(2017)
training <- churn[intrain,]
class(training)
testing <- churn[-intrain,]
class(testing)
View(training)
View(testing)

# Confirme se a divisão está correta
dim(training)
dim(testing)

# Treinamento do Modelo de Regressão Logística
help(glm)
# A função glm é utilizada para adequadar modelos lineares generalizados, especificados
# por uma descrição simbolica do preditor linear e da descrição do erro de distribuição.
# Aceita como parâmetro uma fórmula, ou seja, uma descrição simbólica do modelo a ser 
# adequado, no nosso caso, utilizamos a variável alvo Churn relacionando com todas as 
# outras variáveis do conjunto de treinamento, o qual irá alimentar o meu modelo
# de regressão logística. 
# Family é a descrição do erro de distribuição, nesse caso indicamos que queremos um parãmetro
# binomial com regressão logística, a qual é representada pelo logit em link.
# Data é um dataframe opcional, 
# o qual contem as variavéis do modelo
# Resumidamente, informamos os dados que irão treinar o modelo preditivo (data), 
# informamos o tipo de algoritmo a ser utilizado (family / link),
# informamos as variáveis que serão incluidas nesse treinamento.
LogModel <- glm(Churn ~., family = binomial(link="logit"), data = training)
print(summary(LogModel))



#### Análise de Variância - ANOVA ####

# Os três principais recursos mais relevantes incluem 
# Contract, tenure_group e PaperlessBilling.
# A função anova computa análises de variância para um ou mais modelos preditivos.
help(anova)
anova(LogModel, test="Chisq")

# Analisando a tabela de variância, podemos ver a queda no desvio ao adicionar cada variável 
# uma de cada vez. Adicionar InternetService, Contract e tenure_group reduz 
# significativamente o desvio residual. 
# As outras variáveis, como PaymentMethod e Dependents, parecem melhorar menos o modelo, 
# embora todos tenham valores p baixos.
# Realizar mudança nos valores de Churn no conjunto de dados para teste
testing$Churn <- as.character(testing$Churn)
testing$Churn[testing$Churn=="No"] <- "0"
testing$Churn[testing$Churn=="Yes"] <- "1"
head(testing, 3)

# Verificar o nível de acurácia do modelo
fitted.results <- predict(LogModel,newdata=testing,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != testing$Churn)
print(misClasificError)
print(paste('Logistic Regression Accuracy',1-misClasificError))

# Imprimir uma matriz de confusão da regressão logística
print("Confusion Matrix for Logistic Regression");table(testing$Churn, fitted.results > 0.5)

library(gmodels)
CrossTable(fitted.results, testing$Churn, prop.chisq = FALSE, 
           prop.t = FALSE, prop.r = FALSE, dnn = c("predicted", "actual"))

# Outra medida a ser utilizada em uma Logistic Confusion
# Odds Ratio
# Uma das medidas de desempenho interessantes na regressão logística é Odds Ratio.
# Basicamente, odds ratio é a chance de um evento acontecer.
exp(cbind(OR=coef(LogModel), confint(LogModel)))
# Concluímos que, para cada aumento na unidade no encargo mensal (Monthly Charge)
# há uma redução de 2.5% na probabilidade do cliente cancelar a assinatura.
str(testing)

#### Árvore de Decisão ####

# Visualização da Árvore de Decisão
# Para fins de ilustração, vamos usar apenas três variáveis para plotar 
# a árvores de decisão, elas são: “Contrato”, “tenure_group” e “PaperlessBilling”,
# que conforme verificado pelo anova, são as principais variáveis ou recursos para
# um modelo preditivo (embora a análise tenha sido baseada em um modelo Logistic Regression)
?ctree
# A função ctree gera árvores de inferência condiciona.
# Aceita como parâmetros uma fórmula, ou relação de variáveis, geralmente a variável target
# é posta do lado esquerdo da fórmula e os recursos do lado direito. Também recebe como 
# parâmetro o data frame contendo as variáveis do modelo.
# Nesse caso, precisamos treinar o modelo com o conjunto de dados de treinamento.
tree <- ctree(Churn ~ Contract+tenure_group+PaperlessBilling, training)
plot(tree, type='simple')

# Interpretação do modelo criado:
# 1. Das três variáveis que usamos, o Contrato é a variável mais importante 
# para prever a rotatividade de clientes ou não.
# 2. Se um cliente em um contrato de um ano ou de dois anos, 
# não importa se ele (ela) tem ou não a PapelessBilling, ele (ela) é menos propenso 
# a se cancelar a assinatura.
# 3. Por outro lado, se um cliente estiver em um contrato mensal, 
# e no grupo de posse de 0 a 12 meses, e usando o PaperlessBilling, 
# esse cliente terá mais chances de cancelar a assinatura.

# Gerar previsões com o modelo criado:
# Matriz de Confusão da Árvore de Decisão
# Estamos usando todas as variáveis para tabela de matriz de confusão de produto e fazer previsões.
pred_tree <- predict(tree, testing)
CrossTable(pred_tree, testing$Churn, prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE, dnn = c("predicted", "actual"))

# Verificar o nível de acurácia desse modelo preditivo:
p1 <- predict(tree, training)
tab1 <- table(Predicted = p1, Actual = training$Churn)
tab2 <- table(Predicted = pred_tree, Actual = testing$Churn)
print(paste('Decision Tree Accuracy',sum(diag(tab2))/sum(tab2)))

##### Random Forest #####

set.seed(2017)
?randomForest
# A função randomForest implementa um algoritmo para classificação e regressão.
# Também pode ser usado em modelos sem supervisão para validar aproximações entre 
# pontos de dados.
# Criar o modelo preditivo (alimentar o mesmo com os dados de treino)
# Utilizar todos os recursos e a variável target.
rfModel <- randomForest(Churn~.,data = training)
print(rfModel)
# Tipo do random forest: classificação
# Número de árvores: 500
plot(rfModel)

# A previsão é muito boa ao prever "Não". 
# A taxa de erros é muito maior quando se prevê "sim".

# Prevendo valores com dados de teste
pred_rf <- predict(rfModel, testing)

# Confusion Matrix
CrossTable(pred_rf, testing$Churn, prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE, dnn = c("predicted", "actual"))


# Recursos mais importantes
?varImpPlot
# Verificar a importância das variáveis
# Podemos usar a anova ou o modelo randomforest para isso
# A função varImpPlot irá olhar parao modelo criado, rfModel,
# e irá buscar quais foram as variáveis mais importantes para o cálculo da precisão
# do modelo.
varImpPlot(rfModel, sort=T, n.var = 10, main = 'Top 10 Feature Importance')
