# Machine Learning - Regressão 
# Prevendo Despesas Hospitalares

# Obs: Caso tenha problemas com a acentuação, consulte este link:
# https://support.rstudio.com/hc/en-us/articles/200532197-Character-Encoding

# Configurando o diretório de trabalho
# Coloque entre aspas o diretório de trabalho que você está usando no seu computador
setwd("C:/CursoFCD/3.0BigData_Analytics_R_e_Azure_MachineLearning/Pratica/Cap11/Regressao")
getwd()

#### 1º: Problema de Negócio ####

# Problema de Negócio: Previsão de Despesas Hospitalares.
# Imagine uma clínica médica, uma companhia que vende plano de saúde ou mesmo
# uma empresa que forneça plano de saúde para os colaboradores e que gostaria 
# de fazer uma previsão de despesas hospitalares.
# Ou seja, qual o custo envolvido em despesas com médico, com clínica, exames etc.
# Então esse é o nosso problema.
# Nesse caso o cenário seria de uma empresa que de alguma forma trabalha com 
# plano de saúde. Ou ela fornece o plano de saúde para os colaboradores ou ela 
# vende plano de saúde para outras pessoas.

# Para esta análise, vamos usar um conjunto de dados simulando despesas médicas hipotéticas
# para um conjunto de pacientes espalhados por 4 regiões do Brasil.
# Esse dataset possui 1.338 observações e 7 variáveis (linhas e colunas).
# Para que possamos criar um modelo preditivo, precisamos de dados históricos.
# Isso vale para qualquer problema de negócio.
# Sem dados históricos, não temos modelo preditivo (aprendizagem supervisionada e 
# não supervisionada).
# Esse é um típico modelo de aprendizagem supervisionada, pois iremos apresentar os dados 
# de entrada e os dados de saída para o meu algoritmo de aprendizado de máquina.
# O algoritmo irá aprender a relação matemática entre as variáveis e quando apresentarmos 
# novos dados de entrada ele será capaz de prever as saídas.

# Já temos, portanto, a definição do nosso problema de negócio.
# A próxima etapa será a coleta dos dados e a Análise Exploratória das variáveis,
# com base nos exemplos passados anteriormente.


#### 2º: Coletando os dados ####

# No nosso caso, nós já temos o dataset despesas.csv.
# Em uma empresa, em um projeto, você precisa encontrar as fontes de dados aonde você pode 
# buscar os dados necessários para realizar o projeto.
# Os dados podem estar em um Banco de Dados, podem estar em mais de um Banco de Dados,
# podem estar em arquivos .csv, em planilha Excel, em um datalake.
# É importante que você encontre as fontes de dados.
# Normalmente esse trabalho acaba sendo feito por um Engenheiro de Dados.
# Ele é o responsável por encontrar os dados e oferecer isso para o Cientista de Dados.

# Vamos utilizar a função read.csv.
# Lembre-se que essa função irá retornar seu arquivo csv em um formato data.frame, ok?
# Caso deseje outro formato para melhor se adequar aos pacotes plyr, pode-se utilizar a função read_csv.

despesas <- read.csv("despesas.csv", stringsAsFactors = TRUE)
head(despesas,10)
str(despesas)

# Olhando nosso conjunto de dados temos:
# - 1 coluna com a Idade do Paciente;
# - 1 coluna com o Sexo do Paciente;
# - 1 coluna com o bmI do Paciente (Body Mass Index);
# - 1 coluna com o Número de Filhos do Paciente;
# - 1 coluna indicando se o Paciente é ou não é Fumante;
# - 1 coluna com a Região do Paciente;
# - 1 coluna com os Gastos Médicos Totais do Paciente;

# Esse poderia ser o dataset de uma empresa de Plano de saúde, de uma empresa que oferece
# plano de saúde para os seus colaboradores, o contexto aqui não é relevante.
# O que importa é que nós temos um conjunto de dados exatamente com valores históricos.
# Por exemplo, no primeiro registro, temos uma pessoa com 19 anos, mulher, com índice de massa
# corpórea igual 27.9, sem filhos, fumante, habitante da região Sudeste, e que gastou R$16.884,92.
# Os demais registros seguem o mesmo padrão de variáveis.

# Essa informação pode ser que esteja em um único Banco, pode ser que esteja em mais de um Banco de Dados.
# Nessa fase é importante conhecer exatamente o cenário de negócio para a coleta dos dados.

#### 3º: Explorando e Preparando os dados ####

# ENTENDENDO OS TIPOS DE DADOS:
# Primeiro, vamos olhar os tipos de variáveis.
# Como o formato do arquivo é um data.frame, podemos utilizar a função str().
str(despesas)
# Quando nós fizemos a carga dos dados, o próprio interpretador se encarregou de
# colocar um tipo para cada variável.
# Logo, temos:
# - Idade: Inteiro
# - Sexo: Factor (2 níveis: "homem", "mulher")
# - bmI: Numérico
# - Filhos: Inteiro
# - Fumante: Factor (variável categórica, "sim", "nao")
# - Região: Factor
# - Gastos: Numérico


# ANÁLISE DA VARIÁVEL TARGET "GASTOS":
# Vamos dar uma olhada na noss variável target.
# A variável target se encontra na coluna "gastos".
# Voltando para o dataset, as variáveis Idade, Sexo, bmI, Filhos, FUmante e Região são
# variáveis preditoras, são variáveis independetes (x).
# E a variável gastos é uma variável target, uma variável dependente (y).
# Ou seja, o valor do gasto médico depende dos valores das nossas variáveis independentes.
# Por isso que é importante fazer um resumo de como está essa variável.

summary(despesas$gastos)

# Veja que nós temos:
# - Valor mínimo de R$1.122,00;
# - 25% dos gastos abaixo de R$4.740,00 (1º Quartil);
# - Mediana de R$9.382,00;
# - Média de R$13.270,00;
# - 75% dos gastos abaixo de R$16.640,00 (3º Quartil);
# - Valor máximo de R$63.770,00.

# Pela Diferença entre a Mediana e a Média aparentemente não temos uma distribuição Normal
# nesse conjunto de dados.
# Com o summary da variável target já conseguimos coletar alguns insights.

# Vamos confirmar tudo isso, criando um Histograma.

hist(despesas$gastos, main = "Histograma dos Gastos", xlab = "Gastos", col = "violet")
boxplot(despesas$gastos)

# Veja que nós temos uma grande ocorrência de gastos médicos com valores mais ou menos até
# R$10.000,00, depois com R$20.000,00 há uma queda bastante considerável e temos pouquíssimos casos
# de gastos médicos acima de R$40.000,00 - R$50.000,00.


# TABELA DE CONTIGÊNCIA DA VARIÁVEL QUALITATIVA REGIÃO:
# Vamos agora criar uma tabela de contingência das regiões.
# A Tabela de COntigência irá nos dar a frequência das observações dessa variável qualitativa nominal.

table(despesas$regiao)

# Nós temos:
# - 325 registros do Nordeste;
# - 324 registros do Norte;
# - 325 registros do Sudeste;
# - 364 registros do Sul.
# Proporção de cada classe dentro do total de registros.

round(prop.table(table(despesas$regiao))*100) 

# CORRELAÇÃO ENTRE AS VARIÁVEIS NUMÉRICAS:
# Vamos agora verificar a correlação das variáveis.
# Explorando o relacionamento entre as variáveis a partir de uma Matriz de Correlação.
# Iremos fazer isso somente com as variáveis do tipo numérico ou inteiro, mas que sejam quantitativas.

library(corrplot)
mat <- cor(despesas[,c("idade","bmi","filhos","gastos")])
corrplot(mat, method = "color", order = "alphabet", col = rainbow(100))

# Sabemos que, o coeficiente de correlação é na verdade um número que vai de -1 até +1.
# O número 0 indica que não há correlação.
# O número 1 indica que existe uma forte correlação positiva (diretamente proporcional).
# O número -1 indica que existe uma forte correlação negativa (inversamente proporcional).
# Nenhuma das correlações na matriz é considerada forte, mas existem algumas associações interessantes.
# Por exemplo, a idade e o bmi (IMC) parecem ter uma correlação positiva fraca, o que significa que
# com o aumento da idade, a massa corporal tende a aumentar. Há também uma correlação positiva
# moderada entre a idade e os gastos, além do número de filhos e os gastos. Estas associações implicam que,
# à medida que idade, massa corporal e número de filhos aumenta, o custo esperado do seguro de saúde aumenta.

# Explorando o relacionamento entre as mesmas variáveis numéricas, porém usando um ScatterPlot.
# Utilizamos a função pairs, do pacote graphics, a qual gera uma matrix de Scatterplots.
# Podemos verificar a correlação de forma visual fazendo esse procedimento.

help(pairs)
pairs(despesas[,c("idade","bmi","filhos","gastos")], col = heat.colors(100))

# Perceba que não existe um claro relacionamento entre as variáveis.

# Podemos melhorar a visualização dos ScatterPlots gerados pela função pairs().
# Para isso iremos instalar o pacote "psych", e usaremos a função pairs,panels().

library(psych)
pairs.panels(despesas[,c("idade","bmi","filhos","gastos")], hist.col = "violet")

# Este gráfico fornece mais informações sobre o relacionamento entre as variáveis.
# Este gráfico nos mostra os índices de correlação entre as variáveis, mostra a distribuição de 
# frequência (em histograma) de cada variável individual, mostra o ScatterPlot entre as variáveis com 
# a reta de regressão linear, e as médias dos valores em cada gráfico gerado respectivamente.
# Portanto, além de fazer as análises com valores numéricos é recomendado o uso de gráfico para auxiliar na 
# Exploração do seu conjunto de dados.

#### 4º: Construção e Treinamento do Modelo Preditivo ####

# Nós vamos agora construir e treinar o nosso modelo de Machine Learning para esse problema de Regressão.
# Antes, porém, uma observação importante:
# - A análise Exploratória que fizemos na 3º Etapa não irá tomar a decisão pelo Cientista de Dados.
# - A análise Exploratória é apenas para compreendermos como os dados estão organizados, distribuídos, as correlações entre as variáveis,
# e assim por diante. Uma vez que você tenha essa compreensão é você quem vai tomar as decisões.
# A Análise Exploratória é apenas para você compreender os dados.
# Dito isso, vamos agora construir o nosso modelo que é a parte mais simples do processo.

# Escolhemos o tipo do algoritmo, que será um modelo linear representado pela função lm() no RStudio.
# Esse exemplo é de uma regressão linear múltipla com diversas variáveis preditoras.
# Formato: y = ax1 + bx2 + cx3 + dx4 + ex5 + fx6 + g.

modelo <- lm(gastos ~ idade, bmi, filhos, data = despesas)

# Nesse caso, informamos a variável target, a sintaxe da função, as variáveis de entrada e a fonte dos dados.

# Similar ao item anterior:

modelo <- lm(gastos ~., data = despesas)

# Da mesma forma, ao invés de utilizarmos a simbologia '+', usamos o '.' que significa todas as demais variáveis preditoras.

# Visualizando os Coeficientes:

modelo

# Note que, o algoritmo de regressão linear calculou os múltiplos coeficientes da equação e escolheu internamente
# o melhor modelo treinado para atender o conjunto de dados de entrada e de saídas informados para treinamento do modelo.
# Dentro da função 'lm()' existe um código escrito em Linguagem R com todo o procedimento para construir o modelo de regressão.
# Totalmente relacionado ao conceito de Frameworks.
# Ou seja, o algoritmo já foi escrito por alguém em Linguagem R.

#### 5º: Fazendo Previsões com o Modelo ####

# Depois de Realizar o treinamento do Modelo, precisamos fazer as previsões com o modelo construído, 
# com o modelo já treinado.
# Uma coisa importante antes de começar é que, no início, nós carregamos o dataset completo.
# Não fizemos a divisão ou Split, entre dados de treino e dados de teste.
# No entanto, é interessante fazer a divisão do dataset em duas amostras aleatórias, na proporção 70/30.
# Nesse caso, eu não posso usar os dados de treino para testar o modelo.
# Porque senão estaremos apresentando para o modelo dados que ele já viu.
# Por isso, carregaremos um novo conjunto de dados da mesma fonte de dados mas de diferentes registros.

# Para fazer as previsões vamos olhar a função predict.
# Essa função faz parte do pacote stats.
# Ela é uma função genérica para previsões dos resultados de vários modelos de funções.
# Essa função utiliza métodos particulares que irão depender da classe do seu primeiro argumento.

previsao1 <- predict(modelo)
class(previsao1)
head(previsao1)

# Na coluna gastos do dataset despesas nós temos os dados reais.
# Na coluna V1 das previsões de previsao1 são os dados previstos pelo modelo, os gastos previstos.
# Note que, ambos têm o mesmo número de registros.
# A diferença entre os valores dos dois objetos nos fornece o erro do modelo.
# O nosso trabalho é minimizar esse erro tanto quanto possível.

# Vamos carregar o nosso dataset de teste.

despesasteste <- read.csv("despesas-teste.csv")
View(despesasteste)
head(despesasteste)

# O que temos nesse dataset?
# - 20 registros;
# - Está faltando a coluna com o valor dos gastos de despesa médica;
# Agora que eu tenho o modelo treinado, eu não preciso apresentar os dados de saída, isso é o que eu quero
# que o modelo me entregue.
# Então eu apresento novos dados de entrada, e o modelo terá que fazer as previsões.
# Exemplo para o primeiro registro:
# Querido modelo, tem uma mulher de 52 anos, com um bmi de 26.6,
# ela não tem filhos, não é fumante e mora na região nordeste do Brasil.
# Por favor, me forneça a estimativa de gastos médicos dessa pessoa.

previsao2 <- predict(modelo, despesasteste)
View(previsao2)
head(previsao2)

#### 6º: Valiando a Performance do Modelo ####

# Vamos utilizar a função summary() no nosso modelo de regressão linear múltipla para
# esse conjunto de dados para responder a esse problema de negócio:

summary(modelo)

# Nós vamos agora interpretar o resultado do modelo de Machine Learning.

# Quando criamos um modelo de regressão uma das primeiras coisas que precisamos observar é o Multiple R - Square.
# Nesse caso, nosso Multiple R - squared é igual a 0.7509.
# Esse é o coeficiente de determinação, que vai de 0 até 1.
# Quanto maior for o valor desse coeficiente de determinação melhor será o seu modelo.


# ****************************************************
# *** Estas informações abaixo é que farão de você ***
# *** um verdadeiro conhecedor de Machine Learning *** 
# ****************************************************

# EQUAÇÃO DE REGRESSÃO LINEAR SIMPLES:
# y = a + bx.
# y, nesse caso, seria exatamente a coluna gastos, isso é o que estamos prevendo.
# a, o coeficiente de intercepto.
# b, o coeficiente de inclinação da reta de regressão.
# x, nesse caso, seria as variáveis de entrada, as variáveis preditoras.

# RESÍDUOS:
# É a diferença entre os valores observados de uma variável e seus valores previstos.
# Seus resíduos devem se parecer com uma distribuição normal, o que indica
# que a média entre os valores previstos e os valores observaos é próximo de 0 (o que é muito bom )
# Nesse caso, a diferença entre os valores da coluna gastos do dataset despesas e a previsao1 (resultado do modelo treinado)
# é igual aos resíduos do modelo.

# COEFICIENTE - INTERCEPT - A (ALFA)
# Valor de a na equação de regressão.
# Ponto em que a reta de regressão corta o eixo y.

# COEFICIENTES - NOMES DAS VARIÁVEIS - B(BETA0)
# Valor de b na equação de regressão.

# Obs.: A questão é que lm() ou summary() têm diferentes convenções de 
# rotulagem para cada variável explicativa.
# Em vez de escrever slope_1, slope_2,...
# Eles simplesmente usam o nome da variável em qualquer saída para
# indicar quais coeficientes pertencem a qual variável.

# STANDARD ERROR:
# Medida de variabilidade na estimativa do coeficiente a (alfa), o ideal é que este valor
# seja menor que o valor do coeficiente, mas nem sempre isso irá ocorrer.

# ASTERISCOS:
# Os asteriscos representam os níveis de significância de acordo com o p-value.
# Quanto mais estrelas, maior a significância.
# Atenção --> muitos asteriscos indicam que é improvável que não exista 
# relacionamento entre as variáveis.

# T - VALUE:
# Define se os coeficientes da variável é significativo ou não para o modelo.
# Ele é usado para calcular o p-value e os níveis de significância.

# P-VALUE:
# O p-value representa a probabilidade que a variável não seja relevante.
# Deve ser o menor valor possivel. Se este valor for realmente pequeno,
# o R irá mostrar o valor como notação científica.

# SIGNIFICÂNCIA:
# São aquelas legendas próximas as suas variáveis.
# Espaço em branco - ruim. (não tem grande influência na construção do modelo)
# Pontos - razoável.
# Asteriscos - bom.
# Muitos Asteriscos - muito bom.

# O problema de significância ruim é que, o objetivo do seu modelo preditivo é a generalização.
# Quando você apresentar novos conjuntos de dados, seu modelo pode ter um nível de precisão inferior, menor.
# Coloque no modelo as variáveis que são relevantes para ele.
# Descubra isso ao longo da análise exploratório, a partir dos coeficientes de correlação.

# RESIDUAL STANDARD ERROR:
# Este valor representa o desvio padrão dos resíduos.

# DEGREES OF FREEDOM:
# É a diferença entre o número de observações na amostra de treinamento e o 
# número de variáveis no seu modelo.

# R-SQUARED (COEFICIENTE DE DETERMINAÇÃO - R²):
# Ajuda a avaliar o nível de precisão do nosso modelo.
# Quanto maior, mehor, sendo 1 o valor ideal.

# F-STATISTICS:
# É o teste F do modelo.
# Esse teste obtém os parâmetros do nosso modelo e compara com um 
# modelo que tenha menos parâmetros.
# Em teoria, um modelo com mais parâmetros tem um desempenho melhor.
# Se o seu modelo com mais parâmetros NÃO tiver performance melhor que um 
# modelo com menos parâmetros, o valor do p-value será bem alto.

# Se o modelo com mais parâmetros tiver tiver performance melhor que um 
# modelo com menos parãmetros, o valor do p-value será mais baixo.

# Lembre-se que correlação não implica causalidade.
# As variáveis que tem nível maiso de significância, não necessariamente
# fazem existir maior gasto no plano de saúde.

# Estamos apenas fazendo um estudo, que nos permite fazer previsões.

#### 7º: Otimizando o seu Modelo ####

# Concluímos até então a primeira versão do nosso primeiro modelo.
# Construção a Etapa 4.
# Vamos otimizar o nosso modelo.
# Não vamos nos contentar com um R-Squared de 0.7509.
# Existem várias possibilidades para otimizar o nosso modelo.
# Vamos usar um exemplo.

# Adicionando uma variável com o dobro do valor das idades.

despesas$idade2 <- despesas$idade ^ 2

# Veja que a variável idade tem uma significância bastante forte para o modelo.
# Então, vamos adicionar uma outra variável que é o dobro da idade.
# Como forma de ver o relacionamento entre a idade e a criação do nosso modelo.
# Algumas pesquisas comprovam que à medida que você dobra o valor de uma variável, é gerado um
# impacto bastante positivo na criação do modelo se a variável tiver uma forte significância.
# Isso é um experimento, um teste conveniente.

# Adicionando um indicador para BMI >= 30:

despesas$bmi30 <- ifelse(despesas$bmi >= 30, 1, 0)
View(despesas)
head(despesas)


# Criando o modelo final:
modelo_v2 <- lm(gastos ~ idade + idade2 + filhos + bmi + sexo +
                  bmi30 * fumante + regiao, data = despesas)

summary(modelo_v2)

# Verifique o R-Square aumentou para 0.8653.

# Dados de teste:
despesasteste <- read.csv("despesas-teste.csv")
head(despesasteste)
previsao <- predict(modelo, despesasteste)
class(previsao)
head(previsao)

# Esse é o trabalho de Filter Selection, escolher as melhores variáveis para o modelo.
# Isso deve ser feito algumas vezes para o seu modelo preditivo.

#### 8º: Documentando o Resultado Final ####

