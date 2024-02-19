#Task 2

#Get Data
wget https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa

# Initialize variables
total_length=0
count=0

#Iterate through all lines and track count and total length
while read -r line; do
    if $(echo "$line" | grep -q "^>"); 
    then
	count=$((count+1))
    else
    	length=$(echo $line | tr -d '\n' | wc -m)
    	total_length=$((total_length+length))
    fi    	
done < NC_000913.faa

#ANSI escape codes for italics
ITALIC_START="\033[3m"
ITALIC_END="\033[0m"

#Calculate Average and print output
result=$(echo "$total_length / $count" | bc)
printf "Average length of protein for ${ITALIC_START}E. coli${ITALIC_END} MG1655: $result\n"
