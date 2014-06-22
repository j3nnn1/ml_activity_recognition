library(caret)
build_set = read.table('pml-training.csv',sep=',', header=TRUE); 
names(build_set)                                                                                                                                                        
summary(build_set)                                                                                                                                                      
dim(build_set)
summary(build_set$classe)
#looking vars                                                                                                                                                           
summary(build_set[,1:100])
nzv = nearZeroVar(build_set, freqCut = 95/5, uniqueCut = 10, saveMetrics = TRUE)                                                                                        
build_set = build_set[,!nzv$nzv]  
#looking vars by columns and correlations
plot(build_set[,10:16])
