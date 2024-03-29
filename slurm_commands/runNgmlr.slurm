#!/bin/bash
#!
## author: Belen de la Morena Barrio bd417@cam.ac.uk
## updated last: 8 Jul 2019

#SBATCH -J NGMLR
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
threads=32

if [ $build = "GRCh37" ]; then
 build_post="b37"
 ref=$build_37
else
 build_post="b38"
 ref=$build_38
fi

fastq=${out_dir}/fastq/${sample_name}.fastq.fof
merged=${out_dir}/fastq/${sample_name}.merged.fastq
out_sam=${out_dir}/alignments/${build}/ngmlr/${sample_name}.${build_post}.sam
out_bam=${out_dir}/alignments/${build}/ngmlr/${sample_name}.${build_post}.bam

#! Make directories 
mkdir -p ${out_dir}/alignments/${build}/ngmlr/

#! Run commands
echo "Starting NGMLR workflow at:"
date

echo "mapping reads with ngmlr"
ngmlr -t $threads -r $ref -q $merged -o $out_sam -x ont

echo "converting sam to bam"
samtools view -h $out_sam | samtools sort - -O BAM -o $out_bam

samtools index $out_bam

if [[ -f "$out_bam" ]]; then
  rm $out_sam
fi

echo "Finishing NGMLR workflow at:"
date

#! Deactivate ONT encironment
conda deactivate
