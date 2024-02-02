for x in $(cat PRODMAT_samples.txt | cut -f1 ); do echo $x; sbatch -N 1 -n 24 --mem=90G -t 240 -p 4hours \
-o /data/rusers/hattonc/logs/flagstat/PRODMAT$x.out -e /data/rusers/hattonc/logs/flagstat/PRODMAT$x.err -J PRODMAT$x \
--wrap="bash flagstat.sh $x"; sleep 1; done