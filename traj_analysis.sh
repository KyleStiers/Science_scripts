#!/bin/bash
#-------------------------------------------------------------------------------
#  SBATCH CONFIG
#-------------------------------------------------------------------------------
## resources
#SBATCH -p Lewis
#SBATCH -N 1           # Reserve this number of nodes
#SBATCH -n 6            # Reserve this number of cpus
#SBATCH --mem=200G     # Reserve this amount of memory
#SBATCH -t 0-08:00    # Time Reservation (days-hours:minutes)
#SBATCH --qos=normal  # qos level

#
## labels and outputs
#SBATCH -J bio3d_R_CNA  # job name - shows up in sacct and squeue
#SBATCH -o bio3d_R_CNA_results-%j.out  # filename for the output from this job (%j = job#)
#SBATCH -e bio3d_R_CNA.e%j
#
## notifications
#SBATCH --mail-user=------@mail.missouri.edu  # email address for notifications
#SBATCH --mail-type=END,FAIL  # which type of notifications to send
#
#-------------------------------------------------------------------------------
VERSION="3.3.3"
module load R/R-${VERSION}

## Run
echo $1
echo $2
echo $3
#R --no-save -f /home/username/R_scripts/traj_analysis_noCNA_PS.R $1 $2 $3
R --no-save --args $1 $2 $3 < /home/username/R_scripts/traj_analysis_EPS.R
