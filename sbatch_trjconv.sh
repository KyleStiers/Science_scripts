#!/bin/bash
#-------------------------------------------------------------------------------
# SBATCH CONFIG
#-------------------------------------------------------------------------------
## resources
#SBATCH -p gpu3 # partition (which set of nodes to run on)
#SBATCH --mem=50G # Reserve this amount of memory
#SBATCH -t 2-00:00 # Time Reservation (days-hours:minutes)
#SBATCH --qos=normal
#SBATCH --gres=gpu:1 
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

echo 0 | gmx_gputhread trjconv -s step5_production.tpr -f md.trr -o md_noPBC.xtc -pbc mol -ur compact
echo 3 0 | gmx_gputhread trjconv -s step5_production.tpr -f md_noPBC.xtc -fit rot+trans -o traj_fit.xtc
echo 0 | gmx_gputhread trjconv -s step5_production.tpr -f traj_fit.xtc -o first_frame.pdb -b 0 -e 0 #TAKE FIRST FRAME AND MAKE PDB

echo 3 3 | gmx_gputhread rms -s step5_production.tpr -f traj_fit.xtc -o rmsd.xvg -tu ns
echo 3 3 | gmx_gputhread rms -s step5_production.tpr -f traj_fit.xtc -o rmsd_xtal.xvg -tu ns
echo 3 3 | gmx_gputhread rmsf -s step5_production.tpr -f traj_fit.xtc -o rmsf.xvg -oq rmsf.pdb -res

echo "### Ending at: $(date) ###"


