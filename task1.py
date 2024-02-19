# import libraries
import pandas as pd
import gzip
import csv
import sys

# Read files
data = pd.read_csv('Homo_sapiens.gene_info.gz', sep='\t')
pathway_file = open('h.all.v2023.1.Hs.symbols.gmt', 'r')

# Considering only tax_id 9606
data.drop(index=data[data['#tax_id'] != 9606].index, inplace=True)

# Creating maps
mapping = {}
synonyms_mapping = {}
for i in data.index:
    gene_id = data.loc[i, 'GeneID']
    symbol = data.loc[i, 'Symbol_from_nomenclature_authority']
    synonyms = data.loc[i, 'Synonyms']
    if symbol != '-':
        mapping[symbol] = gene_id
    if synonyms != '-':
        for v in synonyms.split('|'):
            if v in synonyms_mapping:
                synonyms_mapping[v].append(gene_id)
            else:
                synonyms_mapping[v] = [gene_id]

# Replacing Symbols with gene ID
output_file = open('replaced_with_gene_id.gmt', 'w')
for line in pathway_file.readlines():
    replaced_line = line
    for symbol in line.strip('\n').split('\t')[2:]:
        if symbol in mapping:
            gene_id = mapping[symbol]
        elif symbol in synonyms_mapping:
            gene_id = synonyms_mapping[symbol][0]
        else:
            print(symbol)
            continue
        replaced_line = replaced_line.replace(symbol, str(gene_id))
    output_file.write(replaced_line)
output_file.close()
pathway_file.close()

# If a symbol not found in column 11, it searches in synonyms mapping and takes
# the first gene_id where the synonym found.
# If a symbol is not found either in column 11 or among the synonyms, it prints the symbol in the terminal
# and fails to replace the symbol.
