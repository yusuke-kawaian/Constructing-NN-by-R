#prediction by NN of nnet


library(caret)
library(doParallel)

cl_n <- detectCores()
cl <- makePSOCKcluster(cl_n)
registerDoParallel(cl)

library(nnet)
library(sigmoid)
library(NeuralNetTools)

setwd("C:/Users/kawak/Desktop/pred_P/R")

#inout data
analysis_data <- read.table("/Users/kawak/Desktop/pred_P/dataset.txt", skip = 0, header=TRUE, sep=" ");

dataset <- analysis_data[,c(3,4,5,6,7,8,9)]
p_total <- analysis_data[,c(10)]*100


normalization <- read.table("/Users/kawak/Desktop/pred_P/normalization.txt", skip = 0, header=TRUE, sep=" ");
normalization[,c(1,2)] <- NULL

norm <- function(x){
  return(abs(x-normalization[1,])/(normalization[2,]-normalization[1,]))
}
  
normed_data <- apply(dataset, 1, norm)
normed_data <- do.call("rbind", normed_data)
normed_data <- cbind(normed_data,p_total)

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


nn <- nnet(train_data, train_labels, linout = TRUE, size = 100, rang = 0.5, decay = 0, maxit = 2000)

summary(nn)
plotnet(nn)


shape <- function(x){
  if (x < 0) {
    return(0)
  } else if (x > 100) {
    return(100)
  } else {
    return(x)
  }
}

pred_test <- predict(nn,test_data)
pred_test <- as.data.frame(apply(pred_test, 1, shape))
result <- cbind(test_labels,pred_test)
write.table(result, file = "clipboard", sep="\t")


pred_dataset <- read.table("/Users/kawak/Desktop/pred_P/predict_dataset.txt", skip = 0, header=TRUE, sep=" ");
pred_data <- pred_dataset[,c(3,4,5,6,7,8,9)]
#pred_data <- as.data.frame(lapply(pred_data, norm))
#pred_data <- cbind(mass = pred_data[,c(1)], valent = pred_dataset[,c(4)], pred_data[,c(2,3,4,5,6)])
pred_value <- predict(nn,pred_data)
pred_value <- as.data.frame(apply(pred_value, 1, shape))
out_data <- cbind(pred_dataset[,c(1,4,5)],pred_value)
write.table(out_data, "/Users/kawak/Desktop/pred_P/R/predict_nnet.txt", quote = F, col.names = T, row.names = F)
write.table(out_data, file = "clipboard", sep="\t")
