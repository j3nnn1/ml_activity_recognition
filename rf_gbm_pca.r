library(caret)                                                                                                                                                          
                                                                                                                                                                        
build_set = read.table('pml-training.csv',sep=',', header=TRUE);                                                                                                        
#nzv
nzv = nearZeroVar(build_set, freqCut = 95/5, uniqueCut = 10, saveMetrics = TRUE)                                                                                        
build_set = build_set[,!nzv$nzv]                                                                                                                                        
build_set$user_name = NULL;                                                                                                                                             
build_set$cvtd_timestamp = NULL; 
#no na
build_set = build_set[, !(colSums(is.na(build_set)> 0))] 

#make sets
idx_build = createDataPartition(y=build_set$classe, p=0.7, list=FALSE);                                                                                                 
training = build_set[idx_build,];                                                                                                                                       
testing = build_set[-idx_build,];   

#pca
x = training[,-ncol(training)];
preProc <- preProcess(x, method='pca', scale=TRUE, na.remove=TRUE, verbose=TRUE); 
trainPC <- predict(preProc, x); 

#setting crossvalidation ten folders                                                                                                                                    
fitControl <- trainControl(method = "repeatedcv",                                                                                                                       
                        number = 10,                                                                                                                                    
                        repeats = 10,                                                                                                                                   
                        returnResamp = "all",                                                                                                                           
                        allowParallel=TRUE)

#train
modelFitGBMPC <- train(training$classe ~ ., method='gbm', data=trainPC,  trControl=fitControl);
modelFitRFPC <- train(training$classe ~ ., method='rf', data=trainPC,  trControl=fitControl);

#load
load('workspace/gbm_no_na_nzv_pca.RData')
load('workspace/rf_no_na_nzv_pca56vars.RData')

#check testing
x_test = testing[,-ncol(testing)]
testPC <- predict(preProc, x_test); 

#confusionM
#pred1 0.80
predGBMPC = predict(modelFitGBMPC, testPC)
confusionMatrix(predGBMPC, testing$classe)
#pred2 0.98
predRFPC = predict(modelFitRFPCA, testPC)
confusionMatrix(predRFPC, testing$classe)

#train gbm-rf
newX = data.frame(preGBM=predGBMPC, preRF=predRFPC, classe=testing$classe)
modelFitFusion <- train(testing$classe ~ ., method='rf', data=newX,  trControl=fitControl);

#confusionM fusion
predFusion = predict(modelFitFusion, newX)
confusionMatrix(predFusion, testing$classe)

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

#get Fusion
predGBMPC_test = predict(modelFitGBMPC, testing_setPCA)
predRFPC_test = predict(modelFitRFPCA, testing_setPCA)
newX_test = data.frame(preGBM=predGBMPC_test, preRF=predRFPC_test)
predFusion_test = predict(modelFitFusion, newX_test)

#ToSave
testing_set = cbind(testing_set, predFusion_test)
write.csv(testing_set,'gbm_rf_pca.csv')

#doingFiles
for (i in 1:nrow(testing_set)) {                                                                                                                                        
 filename = paste0("gbm_rf_pca_pca_problem_id", testing_set$problem_id[i], ".txt")                                                                                                
 write.table(testing_set$predGBMPC[i], file=filename, quote=FALSE, row.names=FALSE, col.names=FALSE)                                                                    
}   

save.image('gbm_rf_no_na_nzv_pca.RData')
