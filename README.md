# Qdisc Sample

This is a starter qdisc and build system to quickly prototype new packet schedulers in Linux.

These instructions were tested on a fresh Ubuntu 20.04 LTS machine.
The kernel version is 5.4.0-100-generic.

On a fresh Ubuntu machine, you may need to run `sudo apt-get update` first to refresh the package list.

## Installation

### (1) Build `tc` tools by configuring and compiling iproute2

```
sh build_tc.sh
```

### (2) Build the new sample qdisc (scheduler) module

```
cd sch-5.4
make
```

The sample qdisc kernel module is only tested on 5.4.
It is a small modification to the kernel's variant of `sch_fq`,
located at
https://elixir.bootlin.com/linux/v5.4/source/net/sched/sch_fq.c

You can see the modification by searching
for the words "SAMPLE MODIFICATION"
in the sch_fq_new.c file.

```
	/* SAMPLE MODIFICATION
	 * Here is an example of modifying the qdisc's
	 * default behavior. We set a hard limit of 10000000
	 * bytes/sec, or 80 Mbit/s on all flows going through
	 * the qdisc.
	 * The default fq code uses a configurable parameter
	 * flow_max_rate. We got rid of it below. */
	// rate = q->flow_max_rate; */
	rate = 10000000; /* 10,000,000 bytes per second */
```

### (3) Load the kernel module

```
cd .. # return to top-level repo folder
sudo insmod sch-5.4/sch_fq_new.ko
```

## Testing the sample qdisc

You can see the difference the rate ceiling makes by running
an iperf transfer with and without the sample `fq_new` qdisc.

### Before loading the qdisc

```
$ tc qdisc show dev lo
qdisc noqueue 0: root refcnt 2
```

On shell 1:

```
iperf -s -p 50500
```

On shell 2:
```
$ iperf -c localhost -p 50500
------------------------------------------------------------
Client connecting to localhost, TCP port 50500
TCP window size: 2.50 MByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 57942 connected with 127.0.0.1 port 50500
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  35.0 GBytes  30.1 Gbits/sec
```

### Loading the qdisc

```
$ sudo env TC_LIB_DIR="iproute2/tc"
$ sudo tc qdisc add dev lo root fq_new
$ tc qdisc show dev lo
qdisc fq_new 8005: root refcnt 2 [Unknown qdisc, optlen=88] 
```

Re-run the iperf client:
```
$ iperf -c localhost -p 50500         
------------------------------------------------------------
Client connecting to localhost, TCP port 50500
TCP window size: 2.50 MByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 57944 connected with 127.0.0.1 port 50500
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.1 sec  98.8 MBytes  81.8 Mbits/sec
```

The bandwidth between two sockets is now rate-limited at 80 Mbit/s.

If needed, later, the qdisc can be removed by running
```
sudo tc qdisc del dev lo root
```

The scheduler kernel module can now be removed using
```
sudo rmmod sch_fq_new
```

#### Older notes

modified the simple fq qdisc 

modified the make file in the iproute2/tc/ folder and tc (which is part of make file of iproute2 folder )to add object files 

sudo env TC_LIB_DIR="$path to Iproute(where iproute 2 tc module is built)/iproute2/tc"

tc qdisc add dev $module(ethernet interface) root fq_new
