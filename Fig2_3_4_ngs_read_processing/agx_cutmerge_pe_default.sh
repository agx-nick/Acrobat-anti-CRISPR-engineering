#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --job-name="agx_cutmerge"
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --array=1-32

conda activate cutadaptenv

## First specify the reference and base path
base_path="specify filepath"
trim_path="specify filepath"
cd ${base_path}
mkdir ${trim_path}

SAMPLELIST="specify sample list"
SEED=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SAMPLELIST)
sample_id=$(echo "$SEED" | cut -d$',' -f1)
read1_fq=$(echo "$SEED" | cut -d$',' -f2)
read2_fq=$(echo "$SEED" | cut -d$',' -f3)

echo $sample_id
echo $read1_fq
echo $read2_fq
cd ${trim_path}

cutadapt \
	-g ACCACTGCCATGTATCAAAGTACG \ #seq adaptors
	-a CGAGGAGGTTCACTGGGTAGTAAG \
	-G CTTACTACCCAGTGAACCTCCTCG \
	-A CGTACTTTGATACATGGCAGTGGT \
	-o "${sample_id}.R1.trimmed.fastq.gz" \
	-p "${sample_id}.R2.trimmed.fastq.gz" \
	${read1_fq} \
	${read2_fq}

flash \
	--allow-outies \
	--compress \
	-o ${sample_id} \
	${sample_id}.R1.trimmed.fastq.gz \
	${sample_id}.R2.trimmed.fastq.gz

