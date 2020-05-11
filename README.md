# Constructing-NN-by-R
Practice to construct model of Mechanical Learning (ML) by R and the memo.(English and Japanese)  
Rを用いた機械学習モデルの構築の練習とそのメモです. 正確性を担保するため一応日本語でも書いておきます。  

# Description
I try to use below packages and to introduce ML to my reserach that is by Molecular Dynamics (MD) simulation.  
後述のRのpackageを用いて自身のMDシミュレーションを用いた研究に機械学習を導入することを目指します.  

# Overview
My study investigates the characteristics that metal cations selectivity adsorb to micro porous carbon with applied voltage by MD simulation. In this trial, I construct the ML model that predicts the probability `pred_P` that metal cations adsorb to a pore with 7 parameters, `mass`, `valent`, the first/second hydration radius `r1/ r2`, the maximum value of RDF `gr_max`, voltage `vol` and pore diameter `pore_d`, by R.       
私の研究は, MD計算を用いて系に電圧を印加した際のカチオンの多孔質カーボンへの選択的吸着の特性を調査するものです. 本試行はRを用いてカチオンの質量 `mass`, 価数 `valent`, 第一/第二水和半径 `r1/r2`, RDFの最大値 `gr_max` 並びに系に印加した電圧 `vol`, 系の細孔径 `pore_d` の7つの特徴量から細孔内へカチオンが吸着される確率 pred_P を予測するモデルを作成します.  

# Packages  
packages about optimaizer of multiple regression  
    `caret package`  
    
packages about MPI  
    `doParallel package`  

packages about NN  
    `nnet packeage`  
    `neuralnet package`

# Installation
`install.packeges('[package name]')`  
(When you use packages after installation, don't forget `library([package name])`.)
    
# How to use each packages
## doParallel package
This package can calculate with MPI on your PC.  


# Function
I show some convinient function.  
## the function for input on console
```
read_func <- function () {
    Str <- readline(" <<< ")
    as.numeric(unlist(Str))
    } 
```  
Pythonでの`input('>>>	')`関数にあたるもの. Rでは意外と無かったので他の人の自作関数を使わせてもらっています. (ソースはそのうちに)

## the function for binding string
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



