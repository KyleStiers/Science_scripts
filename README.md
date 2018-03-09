# Science_scripts
Various python, R, and shell scripts I've written over the course of my PhD - hopefully helpful to others! If you have questions or comments you can reach me at *kyle stiers at gmail dot com* (no spaces).

# HTS Data processing
The HTS_process.py script is quite case-specific, but there are certainly pieces that could be useful to others. It expects the output from a PerkinElmer Envision spectrophotometer (flourimeter) where the first row contains plate number and a timestamp. Then, after a newline character, CSVs of RFUs for an entire plate. After another new line, it simply prints some static text. Of note, the next time the instrument reads the same plate, i.e. plate #1, it still only prints "Plate_1" to the file - so the script has to remember if it's seen that before or not to parse out timestamps and calculate time elapsed and subsequently RFU/time (rate). If you'd like an email send me a message.

# Running MD scripts anywhere on Lewis
To run the three scripts currently in this repo from anywhere on the cluster you can put them in your home directory (preferably somewhere easy to access near home, i.e. cd ~) and alias them like so:

1. open your .bashrc file from /home/username/
1. Add each alias like so:

        # .bashrc
        alias minimize="sbatch /home/username/gromacs_scripts/sbatch_dp_part.sh"
        alias run_md="sbatch /home/username/gromacs_scripts/sbatch_gpu_part.sh"
        alias post_process_md="sbatch /home/username/gromacs_scripts/sbatch_trjconv.sh"
        alias continue_md="sbatch /home/username/gromacs_scripts/sbatch_continue_md.sh"

I chose the names minimize, run_md, and post_process_md, but you can name them whatever you want.

1. Source the .bash_profile (which will in turn source the .bashrc)
1. Navigate to the gromacs folder unpacked in the CHARMM-GUI tarball
1. Type minimize and click enter
1. When minimize finishes, type run_md and click enter
        *-Note If you want longer than a 1ns simulation, vim step5_production.mdp and alter nsteps (add a 0 for 10ns and so on)-*
1. When run_md finishes, type post_process_md and click enter
1. Done!
