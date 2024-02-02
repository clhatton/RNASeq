#! /bin/bash
set -e

source /zata/zippy/hattonc/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

sample=$1

genome=$sample.STAR.genome.sorted.bam
transcript=$sample.transcript.sorted.bam

nCores=24

baseDir=/data/rusers/hattonc/PRODMAT/
bamDir=/data/rusers/hattonc/PRODMAT/BAMs/
genomeDir=/data/rusers/hattonc/PRODMAT/Mapping_Logs_Genome
transcriptDir=/data/rusers/hattonc/PRODMAT/Mapping_Logs_Transcript

tempDir=/tmp/hattonc/$sample

rm -rf $tempDir; mkdir -p $tempDir; cd $tempDir
cp $bamDir$genome ./
cp $bamDir$transcript ./

samtools flagstat -@ $nCores $genome > $sample.genome.maplog.txt
samtools flagstat -@ $nCores $transcript > $sample.transcript.maplog.txt

cp $sample.genome.maplog.txt $genomeDir
cp $sample.transcript.maplog.txt $transcriptDir

cd $baseDir

rm -rf $tempDir
