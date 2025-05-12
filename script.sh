#!/bin/bash

# Defining command line inputs
forward_read="$1"
reverse_read="$2"

# Read Assessment
echo "Basic Read Assessment:"
for file in "$forward_read"; do
	sample=$(basename "$file")
	num_lines=$(wc -l < "$file")
	num_reads=$(( $num_lines / 4 ))
	total_bp=$(( $num_reads * 250 * 2 ))
	avg_cov=$(( total_bp / 7000000 ))
	echo
	echo "$sample:"
	echo " Number of raw reads: $num_reads"
	echo " Total base pairs: $total_bp"
	echo " Average coverage: $avg_cov"
	echo
done

# FastQC
echo "Running FastQC on raw reads."
	output_dir=./fastqc_raw-reads
	mkdir -p "$output_dir"
	fastqc "$forward_read" "$reverse_read" -o "$output_dir"
echo "FastQC completed."

# Trimmomatic
echo "Running Trimmomatic on paired-end reads."
	trim_scriptV2.sh "$forward_read" "$reverse_read"
echo "Trimmomatic completed."

# FastQC
echo "Running FastQC on trimmed reads."
output_dir_trimmed=./fastqc_trimmed-reads
mkdir -p "$output_dir_trimmed"
for file in ./trimmed-reads/*; do
	filename=$(basename "$file")
	if [[ "$filename" != unpaired* ]]; then
		fastqc "$file" -o "$output_dir_trimmed"
	fi
done
echo "FastQC completed."

# SPAdes
echo "Running SPAdes."
for file in ./trimmed-reads/*; do
	filename=$(basename "$file")
	if [[ "$filename" == *R1* && "$filename" != *unpaired* ]]; then
		for_paired="$file"
	elif [[ "$filename" == *R2* && "$filename" != *unpaired* ]]; then
		rev_paired="$file"
	elif [[ "$filename" == *R1* && "$filename" == *unpaired* ]]; then
		for_unpaired="$file"
	elif [[ "$filename" == *R2* && "$filename" == *unpaired* ]]; then
		rev_unpaired="$file"
	fi
done
spades.py -1 $for_paired -2 $rev_paired -s $for_unpaired -s $rev_unpaired -o spades_assembly_default -t 24
echo "SPAdes completed."

fasta=./spades_assembly_default/contigs.fasta

echo "Running like the rest of it and stuff."
# QUAST
quast.py "$fasta" -o quast_results

# BUSCO
busco -i "$fasta" -m genome -o busco-results -l bacteria

# PROKKA
prokka "$fasta" --outdir prokka_output --cpus 24 --mincontiglen 200
grep -o "product=.*" ./prokka_output/PROKKA_*.gff | sed 's/product=//g' | sort | uniq -c | sort -nr > protein_abundances.txt

# Species ID
extract_sequences "16S ribosomal RNA" prokka_output/PROKKA_*.ffn > 16S_sequence.fasta
makeblastdb -in "$fasta" -dbtype nucl -out contigs_db
blastn -query 16S_sequence.fasta -db contigs_db -out 16S_vs_contigs_6.tsv -outfmt 6
blast-ncbi-nt.sh "$fasta"

# Read Mapping
bwa index "$fasta"
bwa mem -t 24 "$fasta" "$for_paired" "$rev_paired" > raw_mapped.sam
samtools view -@ 24 -Sb raw_mapped.sam | samtools sort -@ 24 -o sorted_mapped.bam
samtools flagstat sorted_mapped.bam
samtools index sorted_mapped.bam
bedtools genomecov -ibam sorted_mapped.bam > coverage.out
gen_input_table.py --isbedfiles "$fasta" coverage.out > coverage_table.tsv

# Blobtools
blobtools create -i "$fasta" -b sorted_mapped.bam -t contigs.fasta.vs.nt.cul5.1e5.megablast.out -o blob_out
blobtools view -i blob_out.blobDB.json -r all -o blob_taxonomy
blobtools plot -i blob_out.blobDB.json -r genus

# Filter Genome Assembly
grep -v '##' blob_taxonomy.blob_out.blobDB.table.txt | awk -F'\t' '$2 > 500' | awk -F'\t' '$5 > 20' | awk -F\t' ' {print $1}' > list_of_contigs_to_keep_len500_cov20.txt
filter_contigs_by_list.py "$fasta" list_of_contigs_to_keep_len500_cov20.txt filtered.fasta

# Final BLAST
wget "https://ftp.ncbi.nlm.nih.gov/pub/UniVec/UniVec"
blastn -reward 1 -penalty -5 -gapopen 3 -gapextend 3 -dust yes -soft_masking true -evalue 700 -searchsp 1750000000000 -query filtered.fasta -subject UniVec -outfmt 6 -out genome_vs_univec.6
