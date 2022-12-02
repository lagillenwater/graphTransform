## Program for converting networks from Sonawane et al. to tissue specific networks


## libraries
library('optparse')
suppressPackageStartupMessages(library(tidyverse))

option_list = list(
    make_option(c("-i", "--input_file"), type="character", default=NULL,  help="input networks file name (*.RData)", metavar="character"),
    make_option(c("-o", "--output_dir"), type="character", default=NULL, help="output directory for tissue specific files", metavar="character"),
    make_option(c("-t", "--tissues"), type="character", default=NULL, help="specific tissues for output networks. multiple tissues must be separated by a comma [e.g., blood,cell,heart]", metavar="character"),
    make_option(c("-s", "--sample_size"), type="numeric", default=NULL, help="size of sample networks to create", metavar="numeric")
  
)
 
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

## check inputs
if (is.null(opt$input_file)){
  print_help(opt_parser)
  stop("Must supply argument for input file")
}

if (is.null(opt$output_dir)){
  print_help(opt_parser)
  stop("Must supply argument for output directory")
}

### Function to convert ensembl IDs in the network into gene names
convertENSG <- function(network,gene_meta) {
    gene_meta$Symbol <- make.names(gene_meta$Symbol)
    network <- network %>% inner_join(gene_meta, by = c("Gene" = "Name"))
    names(network)[c(1,4)] <- c("source", "target")
    network <- network %>% select(source, target)
    return(network)
}

# Add the tissue specific weight to the network. 
tissueNetwork <- function(network,tissue_weights, tissue) {
    network <- cbind(network, weight = tissue_weights[, tissue])
    return(network)
}


load(opt$input_file)
## #load("./data/GTEx_PANDA_tissues.RData")


edges <- convertENSG(edges, genes)


if(!is.null(opt$sample_size)) {
   edges <- edges[1:opt$sample_size,]
   net <- net[1:opt$sample_size,]
   base_dir <- getwd()
   output_dir <- paste0(base_dir,strsplit(opt$output_dir,"[.]")[[1]][2],"sample_",format(opt$sample_size, scientific = F))
   dir.create(file.path(output_dir), recursive = T, showWarnings = FALSE)
} else {
    base_dir <-getwd()
       output_dir <- paste0(base_dir,strsplit(opt$output_dir,"[.]")[[1]][2])
       dir.create(file.path(output_dir),recursive = T,  showWarnings = FALSE)
}


if(!is.null(opt$tissues)){
    tissues <- colnames(net)[grepl(paste(strsplit(opt$tissues, ",")[[1]], collapse = "|"),colnames(net), ignore.case = TRUE)]
    for(tissue in tissues) {
        tissue_network <-tissueNetwork(edges,net,tissue)
        file_name <- paste0(output_dir, "/",tissue,".txt")
        write.table(tissue_network, file = file_name, row.names = F)
    }
} else {
    for(tissue in colnames(net)) {
        file_name <- paste0(output_dir, "/",tissue,".txt")
        write.txt(tissue_network, file = file_name, row.names = F)
    }
}


