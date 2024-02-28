## This run Single End sequencing. 
#! /bin/bash
set -e

source ~/miniconda3/etc/profile.d/conda.sh
#conda env create -n rnaseq --file rnaseq.yml
conda activate rnaseq

sample=P001-ABD-C1_R1_001
#sample=test1

baseDir=/home/courtney.hatton-umw/PRODMAT/ 
fastqDir=/pi/silvia.corvera-umw/project/prodmat/fastq/
#fastqDir=/home/courtney.hatton-umw/test_fastq/
referenceDir=/home/courtney.hatton-umw/data/genome/hg38/RSEM/STAR/
fastqc_rawDir=$baseDir/FastQC_Raw
fastqc_trimmedDir=$baseDir/FastQC_Trimmed
bamDir=$baseDir/BAMs
genesDir=$baseDir/Genes
isoformsDir=$baseDir/Isoforms

tempDir=/home/courtney.hatton-umw/tempFiles/$sample


rm -rf $tempDir; mkdir -p $tempDir; cd $tempDir
trap 'rm -rf -- "$tempDir"' EXIT 

cp $fastqDir$sample.fastq.gz ./

fastqc $sample.fastq.gz

java -jar /home/courtney.hatton-umw/trimmomatic-0.39/trimmomatic-0.39.jar SE -phred33 -threads 8 \
$sample.fastq.gz $sample.trimmed.fastq.gz \
ILLUMINACLIP:/home/courtney.hatton-umw/trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

fastqc $sample.trimmed.fastq.gz

cp -r $referenceDir $tempDir

gunzip $sample.trimmed.fastq.gz

rsem-calculate-expression \
--star \
--output-genome-bam \
--sort-bam-by-coordinate \
-p 8 \
$sample.trimmed.fastq \
$tempDir/STAR/RSEM \
$sample

cp $sample.genes.results $genesDir
cp $sample.isoforms.results $isoformsDir
cp $sample.genome.sorted.bam $bamDir
cp $sample.transcript.sorted.bam $bamDir
cp "$sample"_fastqc.html $fastqc_rawDir
cp $sample.trimmed_fastqc.html $fastqc_trimmedDir

cd $baseDir

rm -rf $tempDir
