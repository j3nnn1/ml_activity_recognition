library(caret)                                                                                                                                                          
library(ggplot2)                                                                                                                                                        
                                                                                                                                                                        
build_set = read.table('pml-training.csv',sep=',', header=TRUE);                                                                                                        
nzv = nearZeroVar(build_set, freqCut = 95/5, uniqueCut = 10, saveMetrics = TRUE)                                                                                        
build_set = build_set[,!nzv$nzv]                                                                                                                                        
build_set$user_name = NULL;                                                                                                                                             
build_set$cvtd_timestamp = NULL; 

build_set = build_set[, !(colSums(is.na(build_set)> 0))] 

#make sets
idx_build = createDataPartition(y=build_set$classe, p=0.7, list=FALSE);                                                                                                 
training = build_set[idx_build,];                                                                                                                                       
testing = build_set[-idx_build,];   

#pca
x = training[,-ncol(training)];
preProc <- preProcess(x, method='pca', scale=TRUE, na.remove=TRUE, verbose=TRUE); 
trainPC <- predict(preProc, x); 

#crossValidation
fitControl <- trainControl(method = "repeatedcv",                                                                                                                       
                        number = 10,                                                                                                                                    
                        repeats = 10,                                                                                                                                   
                        returnResamp = "all",                                                                                                                           
                        allowParallel=TRUE);
#train
modelFitRFPCA <- train(training$classe ~ ., method='rf', data=trainPC,  trControl=fitControl);

#check testing
x_test = testing[,-ncol(testing)]
testPC <- predict(preProc, x_test); 

#confusionM
predRFPC = predict(modelFitRFPCA, testPC)
confusionMatrix(predRFPC, testing$classe)

#testToSaved
testing_set = read.table('pml-testing.csv',sep=',', header=TRUE); 
build_set = read.table('pml-training.csv',sep=',', header=TRUE);                                                                                                        
nzv = nearZeroVar(build_set, freqCut = 95/5, uniqueCut = 10, saveMetrics = TRUE)                                                                                        
testing_set = testing_set[,!nzv$nzv]                                                                                                                                    
build_set = build_set[,!nzv$nzv]                                                                                                                                        
testing_set = testing_set[, !(colSums(is.na(build_set)> 0))]                                                                                                            
testing_set$user_name = NULL;                                                                                                                                           
testing_set$cvtd_timestamp = NULL; 
testing_set_no_pid = testing_set[,-ncol(testing_set)]
#PCA
testing_setPCA <- predict(preProc, testing_set_no_pid); 
predRFPC = predict(modelFitRFPCA, testing_setPCA)
testing_set = cbind(testing_set, predRFPC)
write.csv(testing_set,'rf_no_na_nzv_57vars_pca.csv')

#doingFiles
for (i in 1:nrow(testing_set)) {                                                                                                                                        
 filename = paste0("rf_no_na_nzv_pca_problem_id", testing_set$problem_id[i], ".txt")                                                                                                
 write.table(testing_set$predRFPC[i], file=filename, quote=FALSE, row.names=FALSE, col.names=FALSE)                                                                    
}   

save.image('rf_no_na_nzv_pca56vars.RData')
