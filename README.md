# gen711_final

# Project: Bacterial Genome Assembly

## Background

The starting data includes two sets of raw fastq files for two unknown bacteria. This includes a forward and a reverse read file for each set. The ultimate goal of the project is to identify the species of bacteria and create figures analyze and visualize the genome.

## Basic Read Assessment

### Number of raw reads for each file:

02_S65_L001_R1_001.fastq.gz: 38429
02_S65_L001_R2_001.fastq.gz: 37827
04_S62_L001_R1_001.fastq.gz: 14476
04_S62_L001_R2_001.gastq.gz: 14497

### Total number of raw reads in all four files:

2747202

### Total base pairs of data:

1373601000

### Average coverage:
196

## Methods

## Examination of Read Quality
Ran FASTQC program on all samples, redirecting output into fastqc_raw-reads directory.
Result is one HTML and one zip file for each sample. Downloaded HTML file results to local using sftp.

## Adapter and Quality Trimming
Ran trimmomatic program twice. Once on forward/reverse reads for sample 1 (02), and forward/reverse reads for sample 2 (04).
Output went into trimmed_reads directory. Four files for each time the program ran for a total of eight files.

## Genome Assembly
