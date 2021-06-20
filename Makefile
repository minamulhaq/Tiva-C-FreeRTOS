CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
MACH=cortex-m4
OBJCOPY = arm-none-eabi-objcopy


RM = rm -rf
MD = mkdir -p 
BIN = bin/
OBJ = obj/

SRC = src/
LIB = lib/
TIVA_LIB_PATH = Tiva/driverlib/gcc
TIVA_LIB = driver
TIVA_INC = Tiva/driverlib


FREERTOS_SOURCE = FreeRTOS/Source
FREERTOS_INC = $(FREERTOS_SOURCE)/include
FREERTOS_PORT = $(FREERTOS_SOURCE)/portable/GCC/ARM_CM4F/
FREERTOS_MEM = $(FREERTOS_SOURCE)/portable/MemMang


INC := -Iinc  -ICMSIS/Include -I$(LIB)
INC += -I$(TIVA_INC) -I$(TIVA_LIB_PATH)
INC += -I$(FREERTOS_INC) -I$(FREERTOS_PORT)




#GCC FLAGS
CFLAGS := -g -ggdb -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
# CFLAGS += -mfloat-abi=softfp -O0 -MD -std=gnu99 -c  -Wall -Wno-missing-braces
CFLAGS +=  -O0 -MD -std=gnu99 -c  -Wall -Wno-missing-braces

#Linker Options

LDFLAGS += -Map=$(BIN)main.map -L $(TIVA_LIB_PATH) -l$(TIVA_LIB) -T ld/TM4C123GH6PM.ld -e Reset_Handler 

SRCS  := $(wildcard $(SRC)*.c)
OBJS  := $(SRCS:$(SRC)%.c=$(OBJ)%.o)


all: flash

main.bin: main.elf
	@$(OBJCOPY) -O binary $(BIN)main.elf $(BIN)main.bin

main.elf: FREERTOS_OBJS $(OBJS) | $(BIN) 
	@$(LD) -o $(BIN)main.elf  $(OBJ)*.o $(LDFLAGS)

FREERTOS_OBJS: $(FREERTOS_SRCS) | $(OBJ)
	$(CC) -o $(OBJ)list.o  $(FREERTOS_SOURCE)/list.c  $(INC) $(CFLAGS)
	$(CC) -o $(OBJ)queue.o  $(FREERTOS_SOURCE)/queue.c  $(INC) $(CFLAGS)
	$(CC) -o $(OBJ)tasks.o  $(FREERTOS_SOURCE)/tasks.c  $(INC) $(CFLAGS)
	$(CC) -o $(OBJ)timers.o  $(FREERTOS_SOURCE)/timers.c  $(INC) $(CFLAGS)
	$(CC) -o $(OBJ)port.o  $(FREERTOS_PORT)/port.c  $(INC) $(CFLAGS)
	$(CC) -o $(OBJ)heap_1.o  $(FREERTOS_MEM)/heap_1.c  $(INC) $(CFLAGS)



$(OBJ)%.o: $(SRC)%.c | $(OBJ)
	@$(CC) -o $@  $<  $(INC) $(CFLAGS)

$(OBJ) $(BIN):
	@$(MD) $@


flash: main.bin
	@lm4flash bin/main.bin


.PHONY: clean
clean:
	@$(RM) $(OBJ) $(BIN)





   




