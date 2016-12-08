# #####################################
# CMSIS Tiva Makefile
# #####################################
#
# Modified to work with CMSIS headers.
# Originally part of the uCtools projects
# uctools.github.com
#
#######################################
# user configuration:
#######################################
# TARGET: name of the output file
TARGET = main
# MCU: part number to build for
MCU = TM4C123GH6PM
# SOURCES: list of input source sources
SOURCES = main.c system_TM4C123.c startup_gcc.c
# INCLUDES: list of includes, by default, use Includes directory
INCLUDES = -Iinclude

# OUTDIR: directory to use for output
OUTDIR = build

# LD_SCRIPT: linker script
LD_SCRIPT = gcc_arm.ld

# define flags
CFLAGS = -g -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS += -ffunction-sections -fdata-sections -MD -std=c11 -Wall
CFLAGS += -pedantic -DPART_$(MCU) -c -DTARGET_IS_BLIZZARD_RA1 $(INCLUDES)

# Uncomment for compiler optimizations
# CFLAGS += -Os

LDFLAGS = -T $(LD_SCRIPT) --entry ResetISR --gc-sections

#######################################
# end of user configuration
#######################################
#
#######################################
# binaries
#######################################
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
RM      = rm -f
MKDIR	= mkdir -p
#######################################

# list of object files, placed in the build directory regardless of source path
OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(SOURCES:.c=.o)))
ASMOBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(SOURCES:.c=.s)))

# default: build bin
all: $(OUTDIR)/$(TARGET).bin

asm: $(ASMOBJECTS)

$(OUTDIR)/%.o: src/%.c | $(OUTDIR)
	$(CC) -o $@ $^ $(CFLAGS)

$(OUTDIR)/%.s: src/%.c | $(OUTDIR)
	$(CC) -S -o $@ $^ $(CFLAGS)

$(OUTDIR)/a.out: $(OBJECTS)
	$(LD) -o $@ $^ $(LDFLAGS)

$(OUTDIR)/main.bin: $(OUTDIR)/a.out
	$(OBJCOPY) -O binary $< $@

# create the output directory
$(OUTDIR):
	$(MKDIR) $(OUTDIR)

clean:
	-$(RM) $(OUTDIR)/*

.PHONY: all clean

