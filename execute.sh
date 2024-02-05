for x in $(cat PRODMAT_samples.txt | cut -f1 | head -n1 ); do echo $x; sbatch -N 1 -n 24 --mem=90G -t 240 -p 4hours \
-o /data/rusers/hattonc/logs/prodmat/PRODMAT$x.out -e /data/rusers/hattonc/logs/prodmat/PRODMAT$x.err -J PRODMAT$x \
--wrap="bash run-pipe-PE-STAR-hg38.sh $x"; sleep 1; done