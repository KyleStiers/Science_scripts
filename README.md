# Science_scripts
Various python/R scripts I've written over the course of my PhD for various reasons


# Running MD scripts anywhere on Lewis
To run the three scripts currently in this repo from anywhere on the cluster you can put them in your home directory (preferably somewhere easy to access near home, i.e. cd ~) and alias them like so:

1. open your .bashrc file from /home/username/
2. Add each alias like so:

        # .bashrc
        alias minimize="sbatch /home/kmskvf/gromacs_scripts/sbatch_dp_part.sh"
        alias run_md="sbatch /home/kmskvf/gromacs_scripts/sbatch_gpu_part.sh"
        alias post_process_md="sbatch /home/kmskvf/gromacs_scripts/sbatch_trjconv.sh"

I chose the names minimize, run_md, and post_process_md, but you can name them whatever you want.

3. Source the .bash_profile (which will in turn source the .bashrc)
4. Navigate to the gromacs folder unpacked in the CHARMM-GUI tarball
5. Type minimize and click enter
6. When minimize finishes, type run_md and click enter
7. When run_md finishes, type post_process_md and click enter
8. Done!
