# Created by the Intel FPGA Monitor Program
# DO NOT MODIFY

############################################
# Global Defines
DEFINE_COMMA	:= ,

############################################
# Compilation Targets

# Programs
AS		:= nios2-elf-as
CC		:= nios2-elf-gcc
LD		:= nios2-elf-ld
OC		:= nios2-elf-objcopy
RM		:= rm -f

# Flags
USERCCFLAGS	:= -g -O1 -ffunction-sections -fverbose-asm -fno-inline -mno-cache-volatile
ARCHASFLAGS	:= --gstabs -I "C:/intelFPGA/18.1/nios2eds/components/altera_nios2/sdk/inc/"
ARCHCCFLAGS	:= -mhw-mul -mhw-div -I "C:/intelFPGA/18.1/nios2eds/components/altera_nios2/HAL/inc/" -DSYSTEM_BUS_WIDTH=32 -DALT_SINGLE_THREADED -D_JTAG_UART_BASE=268439552u
ARCHLDFLAGS	:= --defsym nasys_stack_top=0x20000 --defsym nasys_program_mem=0x200 --defsym nasys_data_mem=0x200 --section-start .exceptions=0x20 --section-start .reset=0x0 --section-start .reset=0x0 --section-start .exceptions=0x20
ARCHLDSCRIPT	:= --script="C:/intelFPGA/18.1/University_Program/Monitor_Program/build/nios_cpp_build.ld"
ASFLAGS		:= $(ARCHASFLAGS)
CCFLAGS		:= -Wall -c $(USERCCFLAGS) $(ARCHCCFLAGS)
LDFLAGS		:= $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDFLAGS)) $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDSCRIPT))
OCFLAGS		:= -O srec

# Files
HDRS		:=
SRCS		:= In_lab3.c amp/lib/src/niosII_jtag_uart.c
OBJS		:= $(patsubst %, %.o, $(SRCS))

# Targets
COMPILE: In_lab3.srec

In_lab3.srec: In_lab3.elf
	$(RM) $@
	$(OC) $(OCFLAGS) $< $@

In_lab3.elf: $(OBJS)
	$(RM) $@
	$(CC) $(LDFLAGS) $(OBJS) -o $@

%.c.o: %.c $(HDRS)
	$(RM) $@
	$(CC) $(CCFLAGS) $< -o $@

%.s.o: %.s $(HDRS)
	$(RM) $@
	$(AS) $(ASFLAGS) $< -o $@

CLEAN: 
	$(RM) In_lab3.srec In_lab3.elf $(OBJS)

