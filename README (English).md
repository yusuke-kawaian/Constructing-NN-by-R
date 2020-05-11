# Constructing-NN-by-R
Practice to construct model of Mechanical Learning (ML) by R and the memo. I try to use below packages and to introduce ML to my reserach that is by Molecular Dynamics (MD) simulation. To keep accuracy of this README, I write on Japanese, README (Japanese).md, too just in case.   

# Overview
My study investigates the characteristics that metal cations selectivity adsorb to micro porous carbon with applied voltage by MD simulation. In this trial, I construct the ML model that predicts the probability `pred_P` that metal cations adsorb to a pore with 7 parameters, `mass`, `valent`, the first/second hydration radius `r1/ r2`, the maximum value of RDF `gr_max`, voltage `vol` and pore diameter `pore_d`, by R.       

# Description  
## Packages  
packages about ML  
    `caret package`  
    
packages about MPI  
    `doParallel package`  

packages about NN  
    `nnet packeage`  
    `neuralnet package`

## Installation
`install.packeges('[package name]')`  
(When you use packages after installation, don't forget `library([package name])`.)
    
## How to use each packages
### doParallel package
This package can calculate with MPI on your PC.
```
cl_n <- detectCores()
cl <- makePSOCKcluster(cl_n)
registerDoParallel(cl)
```

### nnet package
This package can construct 3 layers NN.  
```nn <- nnet(train_data, train_labels, size = 100, rang = 0.5, decay = 0, maxit = 1000)```   
**Optimizer: BFGS method  
act. func.: softmax or linear conbination(?)  
err. func.: MSE or closs enthoropy(?)**  
About this detail, please shows [here](https://www.rdocumentation.org/packages/nnet/versions/7.3-14/topics/nnet).  

memo  
good points  
    - easy.
    - output leraning process on console.
    - speedy than the neuralnet package. 

bad points  
    - restrictive. it make less than 3 layers NN. 
    - it can't plot.
    - The convergence by this optimizer is not global minimum.  
    - I've not understood how to use activated function yet.　　 
    
### neuralnet package  
This package can construct large scare NN model.  
```
 nn <- neuralnet(formula = formula.nn, 
                  data = train,
                  hidden = c(5), #the number of nodes in hidden layers: c(1st layer, 2nd layer, 3rd layer,,,)
                  act.fct="logistic", #select activated func. logistic/tanh
                  learningrate = 0.01, 
                  threshold = 0.01,
                  stepmax = 1e+07,
                  err.fct = "sse", #select error func. ce(logistics)/sse()
                  startweights = NULL,
                  learningrate.factor = list(minus = 10.0, plus=10.0),
                  algorithm = "backprop",
                  linear.output=TRUE #If this model is logistic regression, this term sets "FALSE"
  )
```  
**Optimizer: Back propagation, RPROP+ or RPROP-.  
act. func.: logistic sigmoid, tanh or linear conbination    
err. func.: MSE or closs enthoropy**    
About this detail, please shows [here](https://www.rdocumentation.org/packages/neuralnet/versions/1.44.2/topics/neuralnet).  

memo  
good points  
    - it can build DL model.    
    - it can choose some act. func. and optimizer.    
    - it can plot NN model.

bad points  
    - **neuralnet function can't deal with unknown dataset because this function specifies both parameters and labels. So, I don't find how to introduce unknown dataset to themodel.**  
    - it can't use ReLU function that is high performance act. function. 
    - it can't process complex DL model with personal PC although it can construct DL model.

### caret package  
This package can deal with many ML. In this trial, I use it for data processing mainly.  
About this detail, please shows [here](http://topepo.github.io/caret/index.html).

## Convinient Function
I show some convinient function.  
### the function for input on console
```
read_func <- function () {
    Str <- readline(" <<< ")
    as.numeric(unlist(Str))
    } 
```  

### the function for binding string
```
"&" <- function(e1, e2) {
      if (is.character(c(e1, e2))) {
        paste(e1, e2, sep = "")
      } else {
        base::"&"(e1, e2)
      }
    }
```

### the function for normalization
In this trial, I did normalization below because the dataset is uniform distribution.  
```
norm <- function(x){
  return((x-min(x)) / (max(x)-min(x)))
}
```
 

# Conclusion  
In conclusion, I could construct NN model. In the future, I try to intoduce more packages because my study give only little datasets. The package of R has many good points and bad points. So, I want to introdce too tensorflow of python that is genelic.   

Especially, I want to more study about caret package because I feel it is very convinient.  


# Problems
I show my problems below.   
    - Is it possible to use as parameterspredict values by datasetでカバーされていない範囲の数値をパラメータとして予測に用いていいのか. (pore_d = 11までしかdatasetはカバーされていないが, pore_d = 15の時の数値を予測することが可能か.)   
    - How to normalize unknown dataset.  
    - How to use neuralnet package for prediction with unknown dataset.    
    - How to define reLU function on R.



