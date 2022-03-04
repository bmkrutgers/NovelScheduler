# NovelScheduler
Code Base for Novel Scheduler Project


git clone https://github.com/shemminger/iproute2.git


modified the simple fq qdisc 

modified the make file in the iproute2/tc/ folder and tc (which is part of make file of iproute2 folder )to add object files 

There are two parts to run custom fq:

1) Build the tc module using build_tc.sh
2) makefile :  
a) sudo apt install make(build kernel modules)
b)load ernel module: sudo insmod ./sch_fq_new.ko 


Loading the qdisc:

sudo env TC_LIB_DIR="$path to Iproute(where iproute 2 tc module is built)/iproute2/tc" tc qdisc add dev $module(ethernet interface) root fq_new
