# Science_scripts
Various python, R, and shell scripts I've written over the course of my PhD - hopefully helpful to others! If you have questions or comments you can reach me at *kyle stiers at gmail dot com* (no spaces). If anything in here is used in a publication I would appreciate minimally letting me know or more ideally an acknowledgement.

------------------------------------------------------------------------------------------------------------------
## HTS Data processing
The HTS_process.py script is quite case-specific, but there are certainly pieces that could be useful to others. It expects the output from a PerkinElmer Envision spectrophotometer (flourimeter) where the first row contains plate number and a timestamp. Then, after a newline character, CSVs of RFUs for an entire plate. After another new line, it simply prints some static text. Of note, the next time the instrument reads the same plate, i.e. plate #1, it still only prints "Plate_1" to the file - so the script has to remember if it's seen that before or not to parse out timestamps and calculate time elapsed and subsequently RFU/time (rate). If you'd like an email send me a message.

------------------------------------------------------------------------------------------------------------------

## Easily running GROMACS-MD on Lewis
The information below is meant to improve the speed at which new users on the Lewis cluster (or others) can get up and running with Gromacs simulations. All of the work presented here is done with Gromacs 2016.3, but should be compatible with anything above version 5 (I think - no promises).

### Setting up the automation scripts
Download this repository and scp (or however you like to transfer) the archive to a folder on your home folder of the cluster. Unpack the archive in an easy to access place. The following examples assume you've extracted everything to `/home/username/gromacs_scripts/`. Then follow the steps below to make running these scripts easy from anywhere you have access on the cluster.

1. Open your .bashrc file from /home/username/, i.e. `vim ~/.bashrc`
1. Add each alias like so:

        # .bashrc
        alias minimize="sbatch /home/username/gromacs_scripts/sbatch_dp_part.sh"
        alias run_md="sbatch /home/username/gromacs_scripts/sbatch_gpu_part.sh"
        alias post_process_md="sbatch /home/kmskvf/gromacs_scripts/sbatch_trjconv.sh"
        alias continue_md="sbatch /home/kmskvf/gromacs_scripts/sbatch_continue_md.sh"
        alias convert_xtc_to_dcd="/home/kmskvf/gromacs_scripts/convert_xtc_to_dcd.sh"
        alias analyze_traj="sbatch /home/kmskvf/R_scripts/traj_analysis.sh"

I chose the names minimize and run_md, but you can name them whatever you want (the other ones are talked about in the Processing MD section).

1. Run `source ~/.bashrc`

### Running MD
1. Go to http://charmm-gui.org/?doc=input/mdsetup and prepare your files, be sure to select the GROMACS input file generation check box.
1. Create a *very clear* directory name for the simulation
1. Copy (via scp, sftp, etc.) the tarball created by Charmm-gui to this folder
1. Run `tar -xvf charmm-gui.tgz -C your_dir_name/`
1. Run `cd your_dir_name/charmm-gui/gromacs/`
1. Run `minimize`
1. When minimize finishes, run `run_md`
        *-Note If you want longer than a 1ns simulation, `vim step5_production.mdp` and alter nsteps (add a 0 for 10ns and so on). Also         if the simulation doesn't finish within the time-frame allocated you can go back to the same directory and use `continue_md` to         continue it.
1. Done!

### Processing MD
If you don't have a pipeline for post-processing you can follow these steps to process the files and perform some basic analyses with built in gromacs utilities and the wonderful Bio3D R package.
1. Run `post_process_md` 
1. Run `convert_xtc_to_dcd` and wait for it to finish, then click enter and wait for the prompt to come back.
1. Run `analyze_traj` and wait, this could take awhile.
1. Transfer over all your beautiful EPS images and start learning about your system!
