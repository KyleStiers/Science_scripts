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
#SBATCH --mail-user=kmskvf@mail.missouri.edu # email address for notifications
#SBATCH --mail-type=END,FAIL # which type of notifications to send
#
#-------------------------------------------------------------------------------

echo "### Starting at: $(date) ###"

# load modules and source
source /group/micore/gromacs2018.3-mpionlydp/bin/GMXRC
module load openmpi/openmpi-2.1.3
module load hwloc/hwloc-1.11.9
module list

#OLD VERSION
#gmx_mpionlydp grompp -f step4.0_minimization.mdp -o step4.0_minimization.tpr -r step3_input.pdb -c step3_input.pdb -p topol.top

#NEW CHARMM-GUI TEMPLATE
#set init = step3_input
#set mini_prefix = step4.0_minimization
#set equi_prefix = step4.1_equilibration
#set prod_prefix = step5_production
#set prod_step   = step5
#MINIMIZE
#gmx grompp -f ${mini_prefix}.mdp -o ${mini_prefix}.tpr -c ${init}.gro -r ${init}.gro -p topol.top -n index.ndx -maxwarn -1
#gmx_d mdrun -v -deffnm ${mini_prefix}


gmx_mpionlydp grompp -f step4.0_minimization.mdp -o step4.0_minimization.tpr -c step3_input.gro -r step3_input.gro -p topol.top -n index.ndx -maxwarn -1

#gmx_mpionlydp mdrun -ntomp 6 -s step4.0_minimization.tpr -v -deffnm step4.0_minimization

gmx_mpionlydp mdrun -s step4.0_minimization.tpr -v -deffnm step4.0_minimization

echo "### Ending at: $(date) ###"
