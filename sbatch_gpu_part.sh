#!/bin/bash
#-------------------------------------------------------------------------------
# SBATCH CONFIG
#-------------------------------------------------------------------------------
## resources
#SBATCH -p gpu3 # partition (which set of nodes to run on)
#SBATCH --mem=50G # Reserve this amount of memory
#SBATCH -t 2-00:00 # Time Reservation (days-hours:minutes)
#SBATCH --qos=normal 
#SBATCH --gres gpu:1 
## labels and outputs
#SBATCH -J gromacs # job name - shows up in sacct and squeue
#SBATCH -o results_gromacs-%j.out # filename for the output from this job (%j = job#)
#SBATCH -A general-gpu # investor account

## notifications
#SBATCH --mail-user=------@mail.missouri.edu # email address for notifications
#SBATCH --mail-type=END,FAIL # which type of notifications to send
#
#-------------------------------------------------------------------------------

echo "### Starting at: $(date) ###"

# load modules and source
source /storage/hpc/hpc-poc/micore/gromacs-gputhread/bin/GMXRC
module load cuda/cuda-8.0
module load hwloc/hwloc-1.11.4
module list

gmx_gputhread grompp -f step4.1_equilibration.mdp -o step4.1_equilibration.tpr -c step4.0_minimization.gro -r step3_charmm2gmx.pdb -n index.ndx -p topol.top

gmx_gputhread mdrun -s step4.1_equilibration.tpr -v -deffnm step4.1_equilibration


gmx_gputhread grompp -f step5_production.mdp -o step5_production.tpr -c step4.1_equilibration.gro -n index.ndx -p topol.top

gmx_gputhread mdrun -s step5_production.tpr -deffnm md


echo "### Ending at: $(date) ###"
