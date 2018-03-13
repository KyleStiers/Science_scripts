#Currently a very inefficient way of handling this, but it works for now. Will update when I've made it more elegant.
#requires a copy of catdcd 4.0 executable in /home/username/gromacs_scripts/ directory
current_path=$PWD
cp traj_fit.xtc /home/username/gromacs_scripts/
cd /home/username/gromacs_scripts/
./catdcd_LINUXAMD64 -o traj_fit.dcd -xtc traj_fit.xtc
mv traj_fit.dcd $current_path/traj_fit.dcd
rm /home/username/gromacs_scripts/traj_fit.xtc
