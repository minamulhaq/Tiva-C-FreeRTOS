CC = arm-none-eabi-gcc	
LD = arm-none-eabi-ld	
MACH=cortex-m4
OBJCOPY = arm-none-eabi-objcopy	


RM = rm -rf
MD = mkdir -p 
BIN = bin/
OBJ = obj/

PROJ_ROOT = .
SRC = src/
LIB = lib/
INC = -Iinc  -ICMSIS/Include -IQPC/ -I$(LIB) -ItivaLib



#GCC FLAGS
CFLAGS = -g -ggdb -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 
#CFLAGS += -mfloat-abi=softfp -O0 -MD -std=c99 -c  -Wall
CFLAGS += -mfloat-abi=softfp -O0 -MD -std=gnu99 -c  -Wall -Wno-missing-braces
CFLAGS += -IFreeRTOS/Source/include -IFreeRTOS/Source/portable/GCC/ARM_CM4F -I -Itivaware/inc -Itivaware

#Linker Options

LDFLAGS += -Map=$(BIN)main.map -specs=nano.specs

SRCS := $(wildcard $(SRC)*.c)
OBJS  := $(SRCS:$(SRC)%.c=$(OBJ)%.o)

FreeRTOS_SRCS += $(wildcard $(PROJ_ROOT)/FreeRTOS/Source/*.c)


all: flash

main.bin: main.elf
	$(OBJCOPY) -O binary $(BIN)main.elf $(BIN)main.bin 



main.elf:  $(OBJS) | $(BIN) 
	$(CC)	-o $(OBJ)list.o -c $(PROJ_ROOT)/FreeRTOS/Source/list.c $(INC) $(CFLAGS)
	$(CC) 	-o $(OBJ)heap_1.o -c $(PROJ_ROOT)/FreeRTOS/Source/portable/MemMang/heap_1.c $(INC) $(CFLAGS)
	$(CC) 	-o $(OBJ)queue.o -c $(PROJ_ROOT)/FreeRTOS/Source/queue.c $(INC) $(CFLAGS)
	$(CC) 	-o $(OBJ)tasks.o -c $(PROJ_ROOT)/FreeRTOS/Source/tasks.c $(INC) $(CFLAGS)
	$(CC) 	-o $(OBJ)timers.o -c $(PROJ_ROOT)/FreeRTOS/Source/timers.c $(INC) $(CFLAGS)
	$(CC) 	-o $(OBJ)port.o -c $(PROJ_ROOT)/FreeRTOS/Source/portable/GCC/ARM_CM4F/port.c  $(INC) $(CFLAGS)
	$(LD) 	-o $(BIN)main.elf  $(OBJ)*.o -T ld/TM4C123GH6PM.ld -e Reset_Handler $(LDFLAGS)


$(OBJ)%.o: $(SRC)%.c | $(OBJ)
	$(CC) -o $@  $<  $(INC) $(CFLAGS)  

$(OBJ) $(BIN): 
	@$(MD) $@


flash: main.bin
	@lm4flash bin/main.bin


.PHONY: clean 
clean:
	@$(RM) $(OBJ) $(BIN)





   




