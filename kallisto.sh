#! /bin/bash
set -e

source /zata/zippy/hattonc/miniconda3/etc/profile.d/conda.sh
conda activate kallisto

#sample=$1
sample=test
R1="$sample"_R1_001.fastq.gz
R2="$sample"_R2_001.fastq.gz

nCores=24


baseDir=/data/rusers/hattonc/PRODMAT/Kallisto/
#fastqDir=/zata/data/zlab/projects/PRODMAT/
fastqDir=/data/rusers/hattonc/test_fastq/
referenceDir=/zata/zippy/hattonc/Genomes/hg38/Kallisto/
fastqc_rawDir=$baseDir/FastQC_Raw
fastqc_trimmedDir=$baseDir/FastQC_Trimmed
bamDir=$baseDir/BAMs
genesDir=$baseDir/Genes
isoformsDir=$baseDir/Isoforms
unpairedDir=$baseDir/Unpaired_Trimmed
alignDir=$baseDir/Aligned_Log
LogsDir=$baseDir/Logs

tempDir=/tmp/hattonc/$sample

rm -rf $tempDir; mkdir -p $tempDir; cd $tempDir
trap 'rm -rf -- "$tempDir"' EXIT 

cp $fastqDir$R1 ./
cp $fastqDir$R2 ./

fastqc $R1
fastqc $R2

trimmomatic PE -threads $nCores -trimlog $sample.trim.log -summary $sample.trim.summary \
$R1 $R2 $sample.R1.P.fastq.gz $sample.R1.U.fastq.gz $sample.R2.P.fastq.gz $sample.R2.U.fastq.gz \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

fastqc $sample.R1.P.fastq.gz 
fastqc $sample.R2.P.fastq.gz 


cp -r $referenceDir $tempDir

gunzip $sample.R1.P.fastq.gz 
gunzip $sample.R2.P.fastq.gz 

kallisto quant -i hg38_kallisto.idx -o kallisto_output -b 100 $sample.R1.P.fastq $sample.R2.P.fastq

cp $tempDir /data/rusers/hattonc/K_testing

cd /data/rusers/hattonc/PRODMAT


rm -rf $tempDir
