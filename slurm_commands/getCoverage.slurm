#!/bin/bash
#!
## author: Belen de la Morena Barrio bd417@cam.ac.uk
## updated last: 16 Jul 2019

#SBATCH -J GetCoverage
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
out_cov=${out_dir}/qc/${build}/${sample_name}.${aligner}.cov
stats_script=${scripts_dir}/getStatsCoverage.sh
out_cov_stats=${out_dir}/qc/${build}/${sample_name}.${aligner}.stats
out_cov_region=${out_dir}/qc/${build}/${sample_name}.${aligner}.ROI.cov
out_cov_region_stats=${out_dir}/qc/${build}/${sample_name}.${aligner}.ROI.stats

#! Make directories
mkdir -p ${out_dir}/qc/${build}/

#! Run commands
echo "Starting GETCOVERAGE at:"
date

echo "Running samtools depth"
samtools depth -aa $out_bam > $out_cov

echo "Running stats script"
sh $stats_script $out_cov $out_cov_stats

if [ $cov_region != "None" ]; then 
  echo "Running samtools depth for ROI"
  samtools depth -aa $out_bam -r $cov_region > $out_cov_region
  echo "Running stats script for ROI"
  sh $stats_script $out_cov_region $out_cov_region_stats
fi

echo "Finishing GETCOVERAGE at:"
date

#! Deactivate ONT environment
conda deactivate
