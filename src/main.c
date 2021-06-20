#include <stdbool.h>
#include <stdint.h>
#include "bsp.h"
#include "miros.h"
#include "TM4C123GH6PM.h"

#include "FreeRTOS.h"
#include "task.h"

uint32_t stack_blinky1[40];;
OSThread blinky1;
void main_blinky1() {
    while (1) {
        BSP_ledGreenOn();
        BSP_delay(BSP_TICKS_PER_SEC / 4U);
        BSP_ledGreenOff();
        BSP_delay(BSP_TICKS_PER_SEC * 3U / 4U);
    }
}

uint32_t stack_blinky2[40];
OSThread blinky2;
void main_blinky2() {
    while (1) {
        BSP_ledBlueOn();
        BSP_delay(BSP_TICKS_PER_SEC / 2U);
        BSP_ledBlueOff();
        BSP_delay(BSP_TICKS_PER_SEC / 3U);
    }
}


/* background code: sequential with blocking version */
int main() {
    BSP_init();
    /* while (1) { */
    /*     BSP_ledRedOn(); */
    /*     BSP_delay(BSP_TICKS_PER_SEC * 2); */
    /*     BSP_ledRedOff(); */
    /*     BSP_delay(BSP_TICKS_PER_SEC / 1); */
    /* } */

	xTaskCreate(main_blinky1, "My", 200, NULL, 1, NULL);
	vTaskStartScheduler();
    //return 0;
}


