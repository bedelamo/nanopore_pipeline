#!/bin/bash
#!
## author: Belen de la Morena Barrio bd417@cam.ac.uk
## updated last: 16 Jul 2019

#SBATCH -J Sniffles
#SBATCH -A WGS10K-SL2-CPU
#SBATCH --nodes=3
#SBATCH --ntasks=48
#SBATCH --time=36:00:00
#SBATCH --mail-type=FAIL
#SBATCH --exclusive

#! Do not change:
#SBATCH -p skylake

#! Number of nodes and tasks per node allocated by SLURM (do not change):
numnodes=$SLURM_JOB_NUM_NODES
numtasks=$SLURM_NTASKS
mpi_tasks_per_node=$(echo "$SLURM_TASKS_PER_NODE" | sed -e  's/^\([0-9][0-9]*\).*$/\1/')

#! Modify the environment seen by the application. For this example we need the default modules.
. /etc/profile.d/modules.sh                # This line enables the module command
module purge                               # Removes all modules still loaded
module load rhel7/default-peta4            # REQUIRED - loads the basic environment

#! Source config file
source $1

#! Set ONT enviroment
source $conda_path
ont_env=$env_path
conda activate $ont_env

#! Define variables
aligner=$2
threads=46

if [ $build = "GRCh37" ]; then
 build_post="b37"
 ref=$build_37
else
 build_post="b38"
 ref=$build_38
fi

out_bam=${out_dir}/alignments/${build}/${aligner}/${sample_name}.${build_post}.bam
out_vcf_tmp=${out_dir}/variant_calling/${build}/sniffles/${sample_name}.${build_post}.sniffles.${aligner}.tmp.vcf
out_vcf=${out_dir}/variant_calling/${build}/sniffles/${sample_name}.${build_post}.sniffles.${aligner}.vcf.gz

#! Make directories
mkdir -p ${out_dir}/variant_calling/${build}/sniffles

#! Run commands
echo "Starting SNIFFLES at:"
date

sniffles -s $sr_sniffles -m $out_bam -v $out_vcf_tmp

bcftools sort $out_vcf_tmp -O z -o $out_vcf

bcftools index $out_vcf

if [[ -f "$out_vcf" ]]; then
  rm $out_vcf_tmp
fi

echo "Finishing SNIFFLES  at:"
date

#! Deactivate ONT environment
conda deactivate

