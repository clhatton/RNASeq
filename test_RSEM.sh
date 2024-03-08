#! /bin/bash
set -e

source /zata/zippy/hattonc/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

#sample=$1
sample=test
R1="$sample"_R1_001.fastq.gz
R2="$sample"_R2_001.fastq.gz

nCores=24


baseDir=/data/rusers/hattonc/PRODMAT/STAR/
#fastqDir=/zata/data/zlab/projects/PRODMAT/
fastqDir=/data/rusers/hattonc/test_fastq/
referenceDir=/zata/zippy/hattonc/Genomes/hg38/RSEM/STAR/


tempDir=/tmp/hattonc/$sample


rm -rf $tempDir; mkdir -p $tempDir; cd $tempDir
trap 'rm -rf -- "$tempDir"' EXIT 

cp $fastqDir$R1 ./
cp $fastqDir$R2 ./


cp -r $referenceDir $tempDir

gunzip $sample.R1.P.fastq.gz 
gunzip $sample.R2.P.fastq.gz 

rsem-calculate-expression \
--paired-end \
--star \
--star-output-genome-bam \
-p $nCores \
$sample.R1.P.fastq \
$sample.R2.P.fastq \
$tempDir/STAR/RSEM \
$sample

samtools sort -@ $nCores $sample.STAR.genome.bam -o $sample.STAR.genome.sorted.bam
samtools sort -@ $nCores $sample.transcript.bam -o $sample.transcript.sorted.bam

samtools index -@ $nCores $sample.STAR.genome.sorted.bam
samtools index -@ $nCores $sample.transcript.sorted.bam


cd /data/rusers/hattonc/TEST_FOLDER
cp -r $tempDir ./

rm -rf $tempDir