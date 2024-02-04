
qualimap rnaseq \
-bam ./test.STAR.genome.bam \
-gtf /zata/zippy/hattonc/Genomes/hg38/hg38.ncbiRefSeq.gtf \
-pe \
-outdir ./qualimap \
-oc test.counts \
-outfile test.report \
-outformat PDF:HTML \
--java-mem-size=8G 