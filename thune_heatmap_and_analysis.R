library("DESeq2")
library("RColorBrewer")
library("ggplot2")
library("pheatmap")
sampleTable <- data.frame(name=c("deltaK-1", "deltaK-2", "deltaK-3", "uninf-1", "uninf-2", "uninf-3", "WT-1", "WT-2", "WT-3"))
rownames(sampleTable) <- c("deltaK-1", "deltaK-2", "deltaK-3", "uninf-1", "uninf-2", "uninf-3", "WT-1", "WT-2", "WT-3")
sampleTable[,"file"] <- c("RNASeq_4.txt", "RNASeq_5.txt", "RNASeq_6.txt", "RNASeq_7.txt", "RNASeq_8.txt", "RNASeq_9.txt", "RNASeq_1.txt", "RNASeq_2.txt", "RNASeq_3.txt")
sampleTable[,"cond"] <- as.factor(c(rep("DeltaK", 3), rep("Uninf", 3), rep("WT", 3)))
sampleTable 
thuneData <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, directory = directory, design = ~ cond)
thuneData <- DESeq(thuneData)
resultsNames(thuneData)
results_thuneData_DeltaK_Uninf <- results(thuneData, contrast=c("cond", "DeltaK", "Uninf"))
results_thuneData_DeltaK_Uninf_rnames <- rownames(results_thuneData_DeltaK_Uninf)
results_thuneData_DeltaK_WT <- results(thuneData, contrast=c("cond", "DeltaK", "WT"))
results_thuneData_DeltaK_WT_rnames <- rownames(results_thuneData_DeltaK_WT)
results_thuneData_Uninf_WT <- results(thuneData, contrast=c("cond", "Uninf", "WT"))
results_thuneData_Uninf_WT_rnames <- rownames(results_thuneData_Uninf_WT)
results_thuneData_Uninf_WT_df <- as.data.frame(results_thuneData_Uninf_WT)
results_thuneData_Uninf_WT_df$geneNames <- results_thuneData_Uninf_WT_rnames
tmpDF <- as.data.frame(results_thuneData_Uninf_WT$padj)
rnames <- as.integer(rownames(tmpDF)) # KEY: merge will not find values for row number column, thus creating a column of values with Value and NA
results_thuneData_Uninf_WT_df$sortNums <- rnames
tmpDF$rowNums <- rnames
tmpDF$geneNames <- results_thuneData_Uninf_WT_rnames
tmpDF_sorted <- tmpDF[order(tmpDF$`results_thuneData_Uninf_WT$padj`),]
tmpDF_sorted$v <- c(rep(1,23201)) # this is a hack because I am tired and frustrated
geneNamesAsNamesAndNumbers_pvalCuoff <- tmpDF_sorted[1:50,3:4]

geneNamesAsNamesAndNumbers_pvalCuoff
hmData <- merge(geneNamesAsNamesAndNumbers_pvalCuoff, results_thuneData_Uninf_WT_df, all = TRUE)
hmData$hmValues <- ifelse(hmData$v > 0 & !is.na(hmData$v), hmData$geneNames, NA)
hmData_sorted <- hmData[order(as.integer(hmData$sortNums)),]

thuneData_vst <- rlog(thuneData, blind = FALSE)
thuneData_vst_allcond <- assay(thuneData_vst)
thuneData_vst_allcond_df <- as.data.frame(thuneData_vst_allcond)
thuneData_vst_allcond_df$hmValues <- hmData_sorted$sortNums
thuneData_vst_allcond_df_sorted <- thuneData_vst_allcond_df[order(thuneData_vst_allcond_df$hmValues),]
thuneData_vst_allcond_df_sorted_selection <- as.matrix(thuneData_vst_allcond_df_sorted[1:50,1:9])

pheatmap(thuneData_vst_allcond_df_sorted_selection, cluster_rows = TRUE, show_rownames = TRUE, cluster_cols = TRUE)


write.csv(as.data.frame(results_thuneData_DeltaK_Uninf), file = 'thune_2017_deltaK_uninf.csv')
write.csv(as.data.frame(results_thuneData_DeltaK_WT), file = 'thune_2017_deltaK_WT.csv')
write.csv(as.data.frame(results_thuneData_Uninf_WT), file = 'thune_2017_uninf_v_WT.csv')
