machine learning 
=======================

For the Coursera Machine Learning course.

Human Activity Recognition, data and more about this project can be found here: http://groupware.les.inf.puc-rio.br/har
The goal of your project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set.

=======================

* First I look the dataset for an exploratory analysis, and the values in summary command, to see what data type has the predictors, summary to the class (to see if is balanced or not), later to see much NA values in some columns and other with a low variance, some dates are taken as factor, username proceded to not take account this variables, from 160 to 100.
* First Model that make was a random Forest which has best accuracy than gbm, lda, rpart so this was my firsts submit.
The second submit was the pca_view.r , that is PCA + random Forest, with more accuracy and take 27 components that explains 99% of variability.
