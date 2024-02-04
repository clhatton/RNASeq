#! /bin/bash
set -e

source /zata/zippy/hattonc/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

#sample=$1
sample=test
R1="$sample"_R1_001.fastq.gz
R2="$sample"_R2_001.fastq.gz

nCores=24

#baseDir=/pi/zhiping.weng-umw/data/hattonc/PRODMAT_Corvera/RNASeq/PRODMAT/STAR/
baseDir=/data/rusers/hattonc/PRODMAT/test/ 
#fastqDir=/zata/data/zlab/projects/PRODMAT/
fastqDir=/data/rusers/hattonc/test_fastq/
referenceDir=/zata/zippy/hattonc/Genomes/hg38/RSEM/STAR/
fastqc_rawDir=$baseDir/FastQC_Raw
fastqc_trimmedDir=$baseDir/FastQC_Trimmed
bamDir=$baseDir/BAMs
genesDir=$baseDir/Genes
isoformsDir=$baseDir/Isoforms
unpairedDir=$baseDir/Unpaired_Trimmed
LogsDir=$baseDir/Logs

tempDir=/tmp/hattonc/$sample


rm -rf $tempDir; mkdir -p $tempDir; cd $tempDir
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

genome=$sample.STAR.genome.sorted.bam
transcript=$sample.transcript.sorted.bam

samtools flagstat -@ $nCores $genome > $sample.genome.maplog.txt
samtools flagstat -@ $nCores $transcript > $sample.transcript.maplog.txt

cp $sample.genome.maplog.txt $LogsDir
cp $sample.transcript.maplog.txt $LogsDir

cp $sample.genes.results $genesDir
cp $sample.isoforms.results $isoformsDir
cp $sample.STAR.genome.sorted.bam $bamDir
cp $sample.transcript.sorted.bam $bamDir
cp $sample.STAR.genome.sorted.bam.bai $bamDir
cp $sample.transcript.sorted.bam.bai $bamDir
cp "$sample"_R1_001_fastqc.html $fastqc_rawDir
cp "$sample"_R2_001_fastqc.html $fastqc_rawDir
cp $sample.R1.P_fastqc.html $fastqc_trimmedDir
cp $sample.R2.P_fastqc.html $fastqc_trimmedDir
cp $sample.trim.summary $LogsDir
cp "$sample"_R1_001_fastqc.zip $LogsDir
cp "$sample"_R2_001_fastqc.zip $LogsDir

if [ -e $sample.R1.U.fastq.gz ];
then 
cp $sample.R1.U.fastq.gz $unpairedDir
fi 
if [ -e $sample.R2.U.fastq.gz ];
then
cp $sample.R2.U.fastq.gz $unpairedDir
fi



cd /data/rusers/hattonc/PRODMAT/test/temp
cp -rv $tempDir ./

rm -rf $tempDir

