TARGET = sch_fq_new

EXTRA_CFLAGS += $(FLAGS)

obj-m := $(TARGET).o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean
