#!/bin/bash
#-------------------------------------------------------------------------------
#  SBATCH CONFIG
#-------------------------------------------------------------------------------
## resources
#SBATCH -p gpu3        # partition (which set of nodes to run on)
#SBATCH -N1           # Reserve this number of nodes
#SBATCH -n1           # How many tasks are we doing?
#SBATCH --mem=50G     # Reserve this amount of memory
#SBATCH -t 2-00:00    # Time Reservation (days-hours:minutes)
#SBATCH --qos=normal  # qos level
#SBATCH --gres gpu:1  # Reserve one GPU

#
## labels and outputs
#SBATCH -J gromacs  # job name - shows up in sacct and squeue
#SBATCH -o results_gromacs-%j.out  # filename for the output from this job (%j = job#)
#SBATCH -A general-gpu  # investor account
#
## notifications
#SBATCH --mail-user=------@mail.missouri.edu  # email address for notifications
#SBATCH --mail-type=END,FAIL  # which type of notifications to send
#
#-------------------------------------------------------------------------------

echo "### Starting at: $(date) ###"

# load modules and source
source /storage/hpc/hpc-poc/micore/gromacs-gputhread/bin/GMXRC
module load cuda/cuda-8.0
module load hwloc/hwloc-1.11.4
module list

gmx_gputhread mdrun -s step5_production.tpr -cpi md.cpt -append -deffnm md #make sure the -deffnm is the SAME as whatever it was in the original mdrun call

echo "### Ending at: $(date) ###"
