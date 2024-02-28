for x in $(cat ./PRODMAT_samples.txt | cut -f1 ); do echo $x; sbatch -N 1 -n 24 --mem=90G -t 240 -p 4hours \
-o /zata/zippy/hattonc/logs/hisat2/PRODMAT$x.out -e /zata/zippy/hattonc/logs/hisat2/PRODMAT$x.err -J PRODMAT$x \
--wrap="bash run-pipe-PE-HISAT2-hg38.sh $x"; sleep 1; done