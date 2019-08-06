#[DATA SAMPLE]
#Full path to the fastq files directoriess. If multiple, comma sepparated
data_dirs=/path/to/fastq_dir1,/path/to/fastq_dir2
#Full path to the output directory
out_dir=/path/to/out_dir
#Sample name
sample_name='sample_name'

#[ANALYSIS]
#Workflow = aligner-variant_caller. If multiple options, comma separated. Aligners:ngmlr,minimap. VC:sniffles,nanosv
workflow=ngmlr-sniffles,minimap-sniffles
#Genome build. Options: GRCh37,GRCh38
build=GRCh38
#Sniffles read evidence option
sr_sniffles=5 
#Coverage source aligner. Options are None, ngmlr OR minimap
cov_source=minimap
#Specific region of interest for calculating coverag (if not None). Eg: 1:10000-30000
cov_region='None'
#Full path to NanoSV config ini file
nanosv_config=/path/to/NanoSV_congig.ini

#[MISCELLANEOUS]
#Full path to condaSetUp.sh
conda_path=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/scripts/archive/condaSetUp.sh
#Full path to environment
env_path=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/resources/envs/ont
#Full path to the scripts directory
scripts_dir=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/scripts/new_pipeline/slurm_commands
#Full path to the b37 reference genome
build_37=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/resources/ref/human/GRCh37/Homo_sapiens.GRCh37.75.dna.fasta
#Full path to the b38 reference genome
build_38=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/resources/ref/human/GRCh38/Homo_sapiens.GRCh38.dna.fasta
#Full path to the b37 bedfile
ref_bed_37=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/resources/ref/bedfiles/human_hg19.bed
#Full path to the b38 bedfile
ref_bed_38=/rds/project/who1000/rds-who1000-wgs10k/WGS10K/data/projects/nanopore/us/resources/ref/bedfiles/human_hg38.bed

##TO DO? Change workflow to:
#aligner=minimap
#variant_caller=None
#dependency_aligner=minimap
#coverage=Yes
