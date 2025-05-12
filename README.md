# Project: Bacterial Genome Assembly

## Background
Project by: Hannah Conway  
The starting data includes two sets of raw fastq files for two unknown bacteria. This includes a forward and a reverse read file for each set. These samples were sequenced using Illumina HiSeq 2500, paired-end, 250 bp sequencing reads. The ultimate goal of this project is to identify the species of bacteria for each sample and to create figures that analyze and visualize the contents of the two genomes. A script is written in order to make this process easier.

### Basic Read Assessment

#### Number of raw reads for each sample:
Sample 02: 1007992  
Sample 04: 361390

#### Total base pairs:
Sample 02: 503996000  
Sample 04: 180695000

#### Average coverage:
Sample 02: 71  
Sample 04: 25

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
This tool was used to identify the species of the samples. It was used in a few different ways. First, the nucleotide database on the NCBI website was used to paste the 16S sequence into to search for the species. Then BLAST was used in the command line to search for the species using the 16S sequence. Lastly, the entire genome assembly was BLASTed in the command line to assign a taxonomy to every sequence.

### BWA and Samtools
The contigs.fasta file was used as a reference assembly to map the forward and reverse reads to it to create a SAM file. Samtools was then used to convert this to a BAM file, and to also create a coverage table.

### Blobtools
This program created blobplots which gave visual graphs and information about the data. Although this also created many files, the most important one was titled 'blob_out.blobDB.json.bestsum.genus.p8.span.100.blobplot.bam0' which plotted the 'GC, coverage, taxonomy, and contigs lengths' on one graph.

### Assembly Filtering
One of the tables created while using blobtools was used to filter the genome based on length and coverage. The ultimate filter criteria used was removing contigs shorter than 500 base pairs long, and those with less than 20 coverage. The contigs that were kept were put into a filtered.fasta file.

## Results

### FastQC Before and After Read Trimming
The biggest differences in the plots given by the FastQC analysis is the adapter content graphs before and after the read trimming using trimmomatic. For both samples 02 and 04, the FastQC reports showed higher adapter content on the ends of the reads for the raw read files. After trimmomatic was used and then the FastQC reports wer run again, the adapter content for both samples were at almost zero.

### blob_plots for species
blob_out.blobDB.json.bestsum.genus.p8.span.100.blobplot.bam0  
This file takes multiple information from the reads of the sample and plots it out onto a graph. The info that can be seen on this graph includes the taxonomy for each read, the coverage, GC, and length of the contigs. Each spot represents one read, with the size of the spot representing the contig length. On the graph for sample 02, it shows that most of the contigs belong to the genus Clostridiodes. In the graph for sample 04, most of the contigs belong to the genus Escherichia. There also appears to be more contamination in sample 04. The smaller orange spot located around the 10^0 coverage area on the graph show that there are shorter contigs that belong to organisms of other genera.
![02](~/final/02/spades_assembly_default/02_blob_out.blobDB.json.bestsum.genus.p8.span.100.blobplot.bam0)
![04](~/final/04/spades_assembly_default/04_blob_out.blobDB.json.bestsum.genus.p8.span.100.blobplot.bam0)

