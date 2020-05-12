# Constructing-NN-by-R
Rを用いた機械学習モデルの構築の練習とそのメモである. 後述のRのpackageを用いて自身のMDシミュレーションを用いた研究に機械学習を導入することを目指す. 正確性を担保するため一応日本語でも記す.  

# Overview    
私の研究は, MD計算を用いて系に電圧を印加した際のカチオンの多孔質カーボンへの選択的吸着の特性を調査するものである. 本試行はRを用いてカチオンの質量 `mass`, 価数 `valent`, 第一/第二水和半径 `r1/r2`, RDFの最大値 `gr_max` 並びに系に印加した電圧 `vol`, 系の細孔径 `pore_d` の7つの特徴量から細孔内へカチオンが吸着される確率 pred_P を予測するモデルを作成する. data数は**222個**.  

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

### caret package  
This package can deal with many ML. In this trial, I use it for data processing mainly.  
About this detail, please shows [here](http://topepo.github.io/caret/index.html).


# Results and Discussion
## normalization  
```
norm <- function(x){
  return((x-min(x)) / (max(x)-min(x)))
}
```
今回のdatasetは一様分布であるため, 上記の正規化を行った.  

## multiple regression model
```
#sinple multiple regression
sol.m <- lm(s_data$Ptotal~.,data=s_data)
#multiple regression considered exchange interaction
sol.m <- lm(s_data$Ptotal~.^2,data=s_data)
```
この関数での`s_data`は前述の7つの特徴量を示す.
このモデルは`step(sol.m)`関数を用いて**変数減少法**により最適化した.  

## NN model by neuralnet package  
good points  
    - 3層以上の複雑なNNを構築できる.    
    - act. func.やoptimizerなど様々な種類を指定できる.    
    - NNのplotをすることができる.  

bad points  
    - **neuralnet functionでは, 訓練データをdatasetとlabelに分けずに指定するので, label未知データを用いる場合どのように読み込めば良いか分からない.**  
    - もっと高性能なReLU関数を使うことができない.  
    - DLモデルを構築することができるが, 個人所有のPCではdoParallerl packageを用いても4層以上のNNは処理しきれない.  

## NN model by nnet package  
good points  
    - 簡単.  
    - コンソールに tensorflow みたく学習過程が表示されるので見やすい.  
    - neuralnet packageに比べて学習が早く感じた.  

bad points  
    - 最大3層NNまでしか組めない.  
    - NNモデルのplot機能が無い.  
    - 学習の収束地点はglobal minimumではない. (学習毎に結果が異なる.)  
    - 活性化関数の指定法がちゃんと理解できていない. (多分恒等関数とsoftmaxが使える)  

# Conclusion     
色々調べながら取り組んだ結果, 一応モデルとしては完成した. そもそもdatasetがあまり多くないという問題を抱えているためこれからも様々なpackageを利用してみたい. Rはpackageごとの長所短所の差が激しいため, 汎用性の高いPythonのtensorflowでも似たようなモデルを構築したい.  

この個人的なまとめを書いていて思ったが, caret packageがすごく使いやすそうなので今後勉強していきたい.

# Problems
現状自分が抱える問題点, 疑問点を以下に記す.  
    - datasetでカバーされていない範囲の数値をパラメータとして予測に用いていいのか. (pore_d = 11までしかdatasetはカバーされていないが, pore_d = 15の時の数値を予測することが可能か.)  
    - 未知datasetの正規化はどの尺度で行えばいいのか.  
    - neuralnet packageに未知datasetを読み込ませて予測するにはどうすればいいのか.  
    - RでReLU関数を用いるにはどのような関数を定義すればいいのか.


