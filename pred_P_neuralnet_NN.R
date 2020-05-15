#prediction by NN of neuralnet

#library(neuralnet)
library(caret)
library(doParallel)

cl_n <- detectCores()
cl <- makePSOCKcluster(4)
registerDoParallel(cl)

#install.packages('nnet') 
#omstall.paclages('sigmoid')
library(neuralnet)
library(sigmoid)

#install.packages("NeuralNetTools")
library(NeuralNetTools)

setwd("C:/Users/kawak/Desktop/pred_P/R")

#inout data
analysis_data <- read.table("/Users/kawak/Desktop/pred_P/normed_dataset.txt", skip = 0, header=TRUE, sep=" ");

dataset <- analysis_data[,c(3,4,5,6,7,8,9)]
p_total <- analysis_data[,c(10)]*100


#normed_data <- cbind(as.data.frame(lapply(dataset, norm)),p_total)
normed_data <- cbind(dataset,p_total)

#product dataset
smp.size <- floor(0.75*nrow(normed_data))
set.seed(1030)
train.ind <- sample(seq_len(nrow(normed_data)), smp.size)
train <- normed_data[train.ind,]
test <- normed_data[-train.ind,]

train_data <- train[,c(1,2,3,4,5,6,7)]
train_labels <- train[,c(8)]
test_data <- test[,c(1,2,3,4,5,6,7)]
test_labels <- test[,c(8)]


formula.nn <- as.formula("p_total ~ mass + valent + pore_d + vol + r1 + r2 + gr_max")
ReLU <- function(x){
          relu(x)
        }
nn <- neuralnet(formula = formula.nn, 
                data = train,
                hidden = c(5,5), #the number of nodes in hidden layers: c(1st layer, 2nd layer, 3rd layer,,,)
                act.fct = ReLU, #select activated func. logistic/tanh
                learningrate = 0.01, 
                threshold = 0.01,
                stepmax = 1e+06,
                err.fct = "sse", #select error func. ce(logistics)/sse()
                #startweights = NULL,
                #learningrate.factor = list(minus = 10.0, plus=10.0),
                #algorithm = "backprop",
                linear.output=TRUE #If this model is logistic regression, this term sets "FALSE"
)
#confidence.interval(nn, alpha = 0.01)
plot(nn)

pred_test <- data.frame(predict(nn, test))

shape <- function(x){
  if (x < 0) {
    return(0)
  } else if (x > 100) {
    return(100)
  } else {
    return(x)
  }
}

pred_test <- as.data.frame(apply(pred_test, 1, shape))
result <- cbind(test_labels,pred_test)
write.table(result, file = "clipboard", sep="\t")

pred_dataset <- read.table("/Users/kawak/Desktop/pred_P/predict_dataset.txt", skip = 0, header=TRUE, sep=" ");
pred_data <- pred_dataset[,c(3,4,5,6,7,8,9)]
pred_value <- predict(nn,pred_data)
pred_value <- as.data.frame(apply(pred_value, 1, shape))
out_data <- cbind(pred_dataset[,c(1,4,5)],pred_value)
write.table(out_data, "/Users/kawak/Desktop/pred_P/R/predict_nnet.txt", quote = F, col.names = T, row.names = F)
write.table(out_data, file = "clipboard", sep="\t")