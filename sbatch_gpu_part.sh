#!/bin/bash
#-------------------------------------------------------------------------------
# SBATCH CONFIG
#-------------------------------------------------------------------------------
## resources
#SBATCH -p gpu3 # partition (which set of nodes to run on) # <-- updated
#SBATCH --mem=75G # Reserve this amount of memory
#SBATCH -t 2-00:00 # Time Reservation (days-hours:minutes)
#SBATCH --qos=normal # qos level
#SBATCH --gres gpu:1 # <-- updated (missing before)
## labels and outputs
#SBATCH -J gromacs # job name - shows up in sacct and squeue
#SBATCH -o results_gromacs-%j.out # filename for the output from this job (%j = job#)
#SBATCH -A general-gpu # investor account # <-- updated

## notifications
#SBATCH --mail-user=------@mail.missouri.edu # email address for notifications
#SBATCH --mail-type=END,FAIL # which type of notifications to send
#
#-------------------------------------------------------------------------------

echo "### Starting at: $(date) ###"

# load modules and source
source /group/micore/gromacs2018.3-gputhread/bin/GMXRC
module load hwloc/hwloc-1.11.9
module load cuda/cuda-9.2.148
module list

###NEW TEMPLATE
#set init = step3_input
#set mini_prefix = step4.0_minimization
#set equi_prefix = step4.1_equilibration
#set prod_prefix = step5_production
#set prod_step   = step5
#gmx grompp -f ${equi_prefix}.mdp -o ${equi_prefix}.tpr -c ${mini_prefix}.gro -r ${init}.gro -p topol.top -n index.ndx
#gmx mdrun -v -deffnm ${equi_prefix}

gmx_gputhread grompp -f step4.1_equilibration.mdp -o step4.1_equilibration.tpr -c step4.0_minimization.gro -r step4.0_minimization.gro -n index.ndx -p topol.top

gmx_gputhread mdrun -s step4.1_equilibration.tpr -v -deffnm step4.1_equilibration


gmx_gputhread grompp -f step5_production.mdp -o step5_production.tpr -c step4.1_equilibration.gro -n index.ndx -p topol.top

gmx_gputhread mdrun -s step5_production.tpr -deffnm md


echo "### Ending at: $(date) ###"
