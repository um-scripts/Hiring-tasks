library(ggplot2)


#Read Files
data <- read.csv(gzfile("Homo_sapiens.gene_info.gz"), fill = TRUE, sep = '\t', header = TRUE, comment.char = '')

# Count number of genes for each chromosome
values <- c()
for (v in data$chromosome) {
  if (grepl('\\|', v)){
    next
  }
  if(v == ""){
    next
  }
  if (v %in% names(values)){
    values[v] = values[v] + 1
  }
  else{
    values[v] <- 1
  }
}

chromosomes <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                 "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT", "Un")

# Convert to factor with correct ordering
chromosomes <- factor(chromosomes, levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                                              "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT", "Un"))

gene_counts <- c()
for (ch in chromosomes){
  gene_counts <- append(gene_counts, values[ch])
}

#Plot and Save
df <- data.frame(chromosome=chromosomes, gene_count=gene_counts)
plt<-ggplot(data=df, aes(x=factor(chromosome), y=gene_counts)) + geom_bar(stat="identity") + xlab("Chromosomes") + ylab("Gene count") + theme_classic() + ggtitle("Number of genes in each chromosome") + theme(plot.title=element_text( hjust=0.5, vjust=0.5, face='bold'))
ggsave("BarPlot.pdf", plot = plt)
