# Constructing-NN-by-R
Practice to construct model of Mechanical Learning (ML) by R and the memo. I try to use below packages and to introduce ML to my reserach that is by Molecular Dynamics (MD) simulation. To keep accuracy of this README, I write on Japanese too just in case.  
Rを用いた機械学習モデルの構築の練習とそのメモである. 後述のRのpackageを用いて自身のMDシミュレーションを用いた研究に機械学習を導入することを目指す. 正確性を担保するため一応日本語でも記す.  

# Overview
My study investigates the characteristics that metal cations selectivity adsorb to micro porous carbon with applied voltage by MD simulation. In this trial, I construct the ML model that predicts the probability `pred_P` that metal cations adsorb to a pore with 7 parameters, `mass`, `valent`, the first/second hydration radius `r1/ r2`, the maximum value of RDF `gr_max`, voltage `vol` and pore diameter `pore_d`, by R.       
私の研究は, MD計算を用いて系に電圧を印加した際のカチオンの多孔質カーボンへの選択的吸着の特性を調査するものである. 本試行はRを用いてカチオンの質量 `mass`, 価数 `valent`, 第一/第二水和半径 `r1/r2`, RDFの最大値 `gr_max` 並びに系に印加した電圧 `vol`, 系の細孔径 `pore_d` の7つの特徴量から細孔内へカチオンが吸着される確率 pred_P を予測するモデルを作成する.  

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
About this deteal, please shows [here](https://www.rdocumentation.org/packages/nnet/versions/7.3-14/topics/nnet).  

memo  
good points  
    - easy. 簡単.  
    - output leraning process on console. コンソールに tensorflow みたく学習過程が表示されるので見やすい.  
    - speedy. neuralnet packageに比べて学習が早く感じた.  

bad points  
    - restrictive. 最大3層NNまでしか組めない.  
    - it can't plot. NNモデルのplot機能が無い.  
    - 学習の収束地点はglobal minimumではない. (学習毎に結果が異なる.)  
    - I've not understood how to use activated function yet. 活性化関数の指定法がちゃんと理解できていない. (多分恒等関数とsoftmaxが使える)　　 
    
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
About this deteal, please shows [here](https://www.rdocumentation.org/packages/neuralnet/versions/1.44.2/topics/neuralnet).  

memo  
good points  
    - it can build DL model. 3層以上の複雑なNNを構築できる.    
    - it can choose some act. func. and optimizer. act. func.やoptimizerなど様々な種類を指定できる.    
    - it can plot NN model. NNのplotをすることができる.  

bad points  
    - **neuralnet functionでは, 訓練データをdatasetとlabelに分けずに指定するので, label未知データを用いる場合どのように読み込めば良いか分からない.**  
    - もっと高性能なReLU関数を使うことができない.  
    - DLモデルを構築することができるが, 個人所有のPCではdoParallerl packageを用いても4層以上のNNは処理しきれない.  

### caret package  
This package can deal with many ML. In this trial, I use it for data processing mainly.  
About this deteal, please shows [here](http://topepo.github.io/caret/index.html).

## Convinient Function
I show some convinient function.  
### the function for input on console
```
read_func <- function () {
    Str <- readline(" <<< ")
    as.numeric(unlist(Str))
    } 
```  
Pythonでの`input('>>>	')`関数にあたるもの. Rでは意外と無かったので他の人の自作関数を使用. (ソースはそのうちに)

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
Pythonでの`+`, Fortran90での`//`にあたるもの. 文字列を結合する関数. これもRには無かったので以下略.

### the function for normalization
```
norm <- function(x){
  return((x-min(x)) / (max(x)-min(x)))
}
```
今回のdatasetは一様分布であるため, 上記の正規化を行った. 

# Conclusion  
In conclusion, I could construct NN model. In the future, I try to intoduce more packages because my study give only little datasets. The package of R has many good points and bad points. So, I want to introdce too tensorflow of python that is genelic.   
色々調べながら取り組んだ結果, 一応モデルとしては完成した. そもそもdatasetがあまり多くないという問題を抱えているためこれからも様々なpackageを利用してみたい. Rはpackageごとの長所短所の差が激しいため, 汎用性の高いPythonのtensorflowでも似たようなモデルを構築したい.  

この個人的なまとめを書いていて思ったが, caret packageがすごく使いやすそうなので今後勉強していきたい.

# problems
現状自分が抱える問題点, 疑問点を以下に記す.  
    - datasetでカバーされていない範囲の数値をパラメータとして予測に用いていいのか. (pore_d = 11までしかdatasetはカバーされていないが, pore_d = 15の時の数値を予測することが可能か.)  
    - 未知datasetの正規化はどの尺度で行えばいいのか.  
    - neuralnet packageに未知datasetを読み込ませて予測するにはどうすればいいのか.  
    - RでReLU関数を用いるにはどのような関数を定義すればいいのか.


