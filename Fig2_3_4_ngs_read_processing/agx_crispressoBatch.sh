#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --job-name="agx_cutmerge"
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --array=1-1

conda activate crispresso2_env

## First specify the reference and base path
base_path="specify file path"
## enter base path so make sure 10x sample list is stored here!
cd ${base_path}

SAMPLELIST=./exps.csv
SEED=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SAMPLELIST)
exp_id=$(echo "$SEED" | cut -d$',' -f1)
amp_sht=$(echo "$SEED" | cut -d$',' -f2)

echo $exp_id
echo $amp_sht

CRISPRessoBatch --batch_settings $amp_sht -p 4 --ignore_substitutions

