#!/bin/bash
#-------------------------------------------------------------------------------
# SBATCH CONFIG
#-------------------------------------------------------------------------------
## resources
#SBATCH -p Lewis # partition (which set of nodes to run on) # <-- updated
#SBATCH -N 1
#SBATCH --mem=50G # Reserve this amount of memory
#SBATCH -t 2-00:00 # Time Reservation (days-hours:minutes)
#SBATCH --qos=normal # qos level

## labels and outputs
#SBATCH -J gromacs # job name - shows up in sacct and squeue
#SBATCH -o results_gromacs-%j.out # filename for the output from this job (%j = job#)
#SBATCH -A general # investor account # <-- updated

## notifications
#SBATCH --mail-user=------@mail.missouri.edu # email address for notifications
#SBATCH --mail-type=END,FAIL # which type of notifications to send
#
#-------------------------------------------------------------------------------

echo "### Starting at: $(date) ###"

# load modules and source
source /storage/hpc/hpc-poc/micore/gromacs-mpionlydp/bin/GMXRC
module load cuda/cuda-8.0
module load hwloc/hwloc-1.11.4
module list

gmx_mpionlydp grompp -f step4.0_minimization.mdp -o step4.0_minimization.tpr -c step3_charmm2gmx.pdb -p topol.top
gmx_mpionlydp mdrun -ntomp 6 -s step4.0_minimization.tpr -v -deffnm step4.0_minimization


echo "### Ending at: $(date) ###"
