# Project: Bacterial Genome Assembly

## Background
The starting data includes two sets of raw fastq files for two unknown bacteria. This includes a forward and a reverse read file for each set. The ultimate goal of the project is to identify the species of bacteria and create figures analyze and visualize the genome.

### Basic Read Assessment

#### Number of raw reads for each file:
02_S65_L001_R1_001.fastq.gz: 38429
02_S65_L001_R2_001.fastq.gz: 37827
04_S62_L001_R1_001.fastq.gz: 14476
04_S62_L001_R2_001.gastq.gz: 14497

#### Total number of raw reads in all four files:
2747202

#### Total base pairs of data:
1373601000

#### Average coverage:
196

## Methods

### FastQC
The FastQC program is used on fastq files to analyze the read qualities and the composition of base pairs in the reads. Using the program, the forward and reverse read files were inputted into the program, and the output was directed to a new directory. This program gave a zip file and an html file that contains many graphs that give a lot of analytical data about the reads.
This program is used twice in this pipeline. The first time is with the raw reads, and the second time is with the trimmed reads once the adapter sequences are removed. The html files were downloaded using sftp. Comparing this data gives information about how the quality of the data and composition of the base pairs of the reads changed after putting them throught the trimming program.

### Trimmomatic
The trimmomatic program was run twice. Once on the forward/reverse reads for sample 02, and once on the forward/reverse reads for sample 04. This program trims the raw reads by removing adapter sequences and low quality base pairs. The output went into a directory called trimmed_reads. Four files were created using the program: paired forward and reverse fastq files, and two unpaired fastq files.

### SPAdes
The SPAdes program took all of the trimmed read fastq files and converted them into fasta files. This program created many output files, but only a few of the necessary ones were kept. The most important being the contigs.fasta file. This is the genome assembly.

### QUAST and BUSCO
Multiple different programs were used to assess the genome. This includes QUAST and BUSCO. Using the contigs.fasta file from SPAdes, QUAST outputs multiple files that contain different statistical information about the conitgs. BUSCO was then used with the contigs.fasta file which outputs even more files with information about genes and orthologs.

### PROKKA
This program is important for assessing the genes in the genome. Using the program outputs many files which puts different genes and what they code for into different files. The most important for this project is the nucleotide fasta file which was used to find the 16S sequences of the samples. The 16S sequence for sample 02 contained two partial 16S sequences, and sample 04 contained one full 16S sequence.

### BLAST
This tool was used to identify the species of the samples.

'/c/Users/hacon/Pictures/Screenshots/Screenshot 2025-05-11 100116.png'
