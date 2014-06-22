machine learning 
=======================

For the Coursera Machine Learning course.

Human Activity Recognition, data and more about this project can be found here: http://groupware.les.inf.puc-rio.br/har
The goal of your project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set.

=======================

* First I look the dataset for an exploratory analysis, and the values in summary command, to see what data type has the predictors, summary to the class (to see if is balanced or not), later to see much NA values in some columns and other with a low variance, some dates are taken as factor, username proceded to not take account this variables, from 160 to 100.
* The First Model that make was a random Forest which has best accuracy than gbm, lda, rpart so this was my firsts submit.
The second submit was the pca_view.r , that is PCA + random Forest, with more accuracy and take 27 components that explains 99% of variability.
* Another Model that had a little increase in the accuracy was combining previous models like randomForest and GBM, RF with a accuracy 0.98 and GBM with 0.8, can see
rf_gbm_pca.r 

with CrossValidation seems some rows with the group C was classified like B (4%), and rows of the group D a 4% was clasified like C
the group E only was a 1% missclassified. so the group C had some values that is in the bounding of  these (B,D)
 
          Reference
Prediction    A    B    C    D    E
         A 28.4  0.1  0.0  0.0  0.0
         B  0.0 19.1  0.2  0.0  0.0
         C  0.0  0.2 17.1  0.4  0.0
         D  0.0  0.0  0.2 16.0  0.1
         E  0.0  0.0  0.0  0.0 18.3

* later another model set CV with 10 folds and increase a bit the accuraccy. this can see in  pca_view_rf_cv.r

