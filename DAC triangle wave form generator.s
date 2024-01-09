;******************** (C) COPYRIGHT 2011 STMicroelectronics ********************
;* File Name          : DAC triangle wave form generator.s
;* Author             : Stefan Zakutansky
;* Version            : V1.0
;* Date               : 24-October-2023
;* Description        : STM32F100RB DAC triangle wave form generator in low level assembly lenguage cod
;* 						low level assembly lenguage code
;*******************************************************************************

; Amount of memory (in bytes) allocated for Stack
; Tailor this value to your application needs
; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit

                PRESERVE8
                THUMB
					
	
RCC_Base	EQU	0x40021000
RCC_APB2ENR	EQU	0x18			;APB2 peripheral clock enable register (RCC_APB2ENR
IOPAEN		EQU	0x1<<2			;I/O port A clock enable
AFIOEN		EQU	0x1<<0			;Alternate function I/O clock enable
RCC_APB1ENR EQU 0x1C			;APB1 peripheral clock enable register (RCC_APB1ENR)
DACEN		EQU	0x1<<29			;DACEN: DAC interface clock enable
GPIOA_Base	EQU 0x40010800		;Port GPIO_A_Base adress
GPIOA_CRL 	EQU 0x00			;Port configuration register low (GPIOx_CRL)
CNF4_1		EQU 0x1<<19			;Port x configuration bits 
CNF4_0		EQU 0x1<<18			;Port x configuration bits 
MODE4_1		EQU 0x1<<17			;Port x mode bits 
MODE4_0		EQU 0x1<<16			;Port x mode bits 
DAC_Base	EQU 0x40007400		;Digital to Analog converter base address
DAC_CR 		EQU 0x00			;DAC control register (DAC_CR
WAVE_1		EQU 0x1<<7			;DAC channel1 noise/triangle wave generation enable  - Only used if bit TEN1 = 1 DAC channel1 trigger enabled
WAVE_0		EQU 0x1<<6			;DAC channel1 noise/triangle wave generation enable  - Only used if bit TEN1 = 1 DAC channel1 trigger enabled
TSEL1_2		EQU	0x1<<5			;DAC channel1 trigger selection These bits select the external event used to trigger DAC channel1
TSEL1_1		EQU	0x1<<4			;DAC channel1 trigger selection These bits select the external event used to trigger DAC channel1
TSEL1_0		EQU	0x1<<3			;DAC channel1 trigger selection These bits select the external event used to trigger DAC channel1
TEN1		EQU 0x1<<2			;DAC channel1 trigger enabl
BOFF1		EQU	0x1<<1			;DAC channel1 output buffer disable
EN1			EQU	0x1<<0			;DAC channel1 enable
DAC_SWTRIGR	EQU 0x04			;DAC software trigger register (DAC_SWTRIGR
SWTRIG1		EQU 0x1<<0			;DAC channel1 software trigger
DAC_DHR12R1	EQU 0x08			;DAC channel1 12-bit right-aligned data holding register DAC_DHR12R1
MAMP1_0		EQU 0x1<<8			;DAC channel1 bits sellect mask in wave generation mode
MAMP1_1		EQU 0x1<<9			;or
MAMP1_2		EQU 0x1<<10         ;in this case Amplitude in triangle mode
MAMP1_3		EQU 0x1<<11
DAC_DOR1	EQU	0x2C


; Vector Table Mapped to Address 0 at Reset
                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp                    ; Top of Stack
                DCD     Reset_Handler                   ; Reset Handler
                DCD     NMI_Handler                     ; NMI Handler
                DCD     HardFault_Handler               ; Hard Fault Handler
                DCD     MemManage_Handler               ; MPU Fault Handler
                DCD     BusFault_Handler                ; Bus Fault Handler
                DCD     UsageFault_Handler              ; Usage Fault Handler
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     SVC_Handler                     ; SVCall Handler
                DCD     DebugMon_Handler                ; Debug Monitor Handler
                DCD     0                               ; Reserved
                DCD     PendSV_Handler                  ; PendSV Handler
                DCD     SysTick_Handler                 ; SysTick Handler

                ; External Interrupts
                DCD     WWDG_IRQHandler                 ; Window Watchdog
                DCD     PVD_IRQHandler                  ; PVD through EXTI Line detect
                DCD     TAMPER_IRQHandler               ; Tamper
                DCD     RTC_IRQHandler                  ; RTC
                DCD     FLASH_IRQHandler                ; Flash
                DCD     RCC_IRQHandler                  ; RCC
                DCD     EXTI0_IRQHandler                ; EXTI Line 0
                DCD     EXTI1_IRQHandler                ; EXTI Line 1
                DCD     EXTI2_IRQHandler                ; EXTI Line 2
                DCD     EXTI3_IRQHandler                ; EXTI Line 3
                DCD     EXTI4_IRQHandler                ; EXTI Line 4
                DCD     DMA1_Channel1_IRQHandler        ; DMA1 Channel 1
                DCD     DMA1_Channel2_IRQHandler        ; DMA1 Channel 2
                DCD     DMA1_Channel3_IRQHandler        ; DMA1 Channel 3
                DCD     DMA1_Channel4_IRQHandler        ; DMA1 Channel 4
                DCD     DMA1_Channel5_IRQHandler        ; DMA1 Channel 5
                DCD     DMA1_Channel6_IRQHandler        ; DMA1 Channel 6
                DCD     DMA1_Channel7_IRQHandler        ; DMA1 Channel 7
                DCD     ADC1_IRQHandler                 ; ADC1
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     EXTI9_5_IRQHandler              ; EXTI Line 9..5
                DCD     TIM1_BRK_TIM15_IRQHandler       ; TIM1 Break and TIM15
                DCD     TIM1_UP_TIM16_IRQHandler        ; TIM1 Update and TIM16
                DCD     TIM1_TRG_COM_TIM17_IRQHandler   ; TIM1 Trigger and Commutation and TIM17
                DCD     TIM1_CC_IRQHandler              ; TIM1 Capture Compare
                DCD     TIM2_IRQHandler                 ; TIM2
                DCD     TIM3_IRQHandler                 ; TIM3
                DCD     TIM4_IRQHandler                 ; TIM4
                DCD     I2C1_EV_IRQHandler              ; I2C1 Event
                DCD     I2C1_ER_IRQHandler              ; I2C1 Error
                DCD     I2C2_EV_IRQHandler              ; I2C2 Event
                DCD     I2C2_ER_IRQHandler              ; I2C2 Error
                DCD     SPI1_IRQHandler                 ; SPI1
                DCD     SPI2_IRQHandler                 ; SPI2
                DCD     USART1_IRQHandler               ; USART1
                DCD     USART2_IRQHandler               ; USART2
                DCD     USART3_IRQHandler               ; USART3
                DCD     EXTI15_10_IRQHandler            ; EXTI Line 15..10
                DCD     RTCAlarm_IRQHandler             ; RTC Alarm through EXTI Line
                DCD     CEC_IRQHandler                  ; HDMI-CEC
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved 
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved 
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     0                               ; Reserved
                DCD     TIM6_DAC_IRQHandler             ; TIM6 and DAC underrun
                DCD     TIM7_IRQHandler                 ; TIM7
__Vectors_End

__Vectors_Size  EQU  __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY

; Reset handler
Reset_Handler    PROC
                 EXPORT  Reset_Handler             [WEAK]

;RCC
		LDR r0, =RCC_Base
;APB2 peripheral clock
		LDR r1, [r0, #RCC_APB2ENR]		; APB2 peripheral clock enable register 
		ORR r1, r1, #IOPAEN				; I/O port A clock enabled
		ORR r1, r1, #AFIOEN				; Alternate Function I/O clock enabled
		STR r1, [r0, #RCC_APB2ENR]
;APB1 peripheral clock
		LDR r1, [r0, #RCC_APB1ENR]		; APB1 peripheral clock enable register
		ORR r1, r1, #DACEN				; DAC interface clock enable
		STR r1, [r0, #RCC_APB1ENR]
;GPIO
		LDR r0, =GPIOA_Base
		LDR r1, [r0, #GPIOA_CRL]
		BIC r1, r1, #CNF4_1
		BIC r1, r1, #CNF4_0
		BIC r1, r1, #MODE4_1            ;Analog output mode
		BIC r1, r1, #MODE4_0
		STR r1, [r0, #GPIOA_CRL]
;DAC configuration
		LDR r0, =DAC_Base
		LDR r1, [r0, #DAC_CR]
;DAC MAMP1 mask/amplitude selector
		ORR r1,r1,#MAMP1_0				; these bits sellect mask in wave generation mode
		ORR r1,r1,#MAMP1_1              ; or
		BIC r1,r1,#MAMP1_2              ; in this case Amplitude in triangle mode
		ORR r1,r1,#MAMP1_3              ; 1011 - triangle wave amplitude equal to 4095
		STR r1, [r0, #DAC_CR]
;Triangle wave generation configuration
		LDR r1, [r0, #DAC_CR]
		ORR r1, r1, #WAVE_1				; 1x - triangle wave generation enabled	
		ORR r1, r1, #WAVE_0
		ORR r1, r1, #TSEL1_2			; DAC channel 1 Trigger sellection config bits
		ORR r1, r1, #TSEL1_1			; 111 - Software trigger selected
		ORR r1, r1, #TSEL1_0
		ORR r1, r1, #TEN1				; Triangle wave is enabled when TEN1 is set "1"
		BIC r1, r1, #BOFF1				; Output buuffer enable bit, cleared "0" means its enabled
		ORR r1, r1, #EN1				; DAC1 channel enable bit
		STR r1, [r0, #DAC_CR]
		;3V3 pin to GND 2.99V
		;MOV r1, #0xFFF	;2.94V
		;MOV r1, #0xBFE	;2.25V
		;MOV r1, #0x7FF	;1.501V
		;MOV r1, #0x3FF	;0.750V		
		;STR r1, [r0, #DAC_DHR12R1]
		LDR r1, [r0, #DAC_SWTRIGR]
		ORR r1, r1, #SWTRIG1			; First high impuls in this register turns on DAC triggered by software
		STR r1, [r0, #DAC_SWTRIGR]
		
LOOP
		LDR r1, [r0, #DAC_SWTRIGR]
		ORR r1, r1, #SWTRIG1			; Keep Generating Software trigger
		STR r1, [r0, #DAC_SWTRIGR]

		B LOOP	 
	 
	 ;IMPORT  __main
     ;IMPORT  SystemInit
                 ;LDR     R0, =SystemInit
                 ;BLX     R0
                 ;LDR     R0, =__main
                 ;BX      R0
                 ENDP

; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler                      [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler                [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler                [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler                 [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler               [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler                      [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler                 [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler                   [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler                  [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WWDG_IRQHandler                  [WEAK]
                EXPORT  PVD_IRQHandler                   [WEAK]
                EXPORT  TAMPER_IRQHandler                [WEAK]
                EXPORT  RTC_IRQHandler                   [WEAK]
                EXPORT  FLASH_IRQHandler                 [WEAK]
                EXPORT  RCC_IRQHandler                   [WEAK]
                EXPORT  EXTI0_IRQHandler                 [WEAK]
                EXPORT  EXTI1_IRQHandler                 [WEAK]
                EXPORT  EXTI2_IRQHandler                 [WEAK]
                EXPORT  EXTI3_IRQHandler                 [WEAK]
                EXPORT  EXTI4_IRQHandler                 [WEAK]
                EXPORT  DMA1_Channel1_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel2_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel3_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel4_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel5_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel6_IRQHandler         [WEAK]
                EXPORT  DMA1_Channel7_IRQHandler         [WEAK]
                EXPORT  ADC1_IRQHandler                  [WEAK]
                EXPORT  EXTI9_5_IRQHandler               [WEAK]
                EXPORT  TIM1_BRK_TIM15_IRQHandler        [WEAK]
                EXPORT  TIM1_UP_TIM16_IRQHandler         [WEAK]
                EXPORT  TIM1_TRG_COM_TIM17_IRQHandler    [WEAK]
                EXPORT  TIM1_CC_IRQHandler               [WEAK]
                EXPORT  TIM2_IRQHandler                  [WEAK]
                EXPORT  TIM3_IRQHandler                  [WEAK]
                EXPORT  TIM4_IRQHandler                  [WEAK]
                EXPORT  I2C1_EV_IRQHandler               [WEAK]
                EXPORT  I2C1_ER_IRQHandler               [WEAK]
                EXPORT  I2C2_EV_IRQHandler               [WEAK]
                EXPORT  I2C2_ER_IRQHandler               [WEAK]
                EXPORT  SPI1_IRQHandler                  [WEAK]
                EXPORT  SPI2_IRQHandler                  [WEAK]
                EXPORT  USART1_IRQHandler                [WEAK]
                EXPORT  USART2_IRQHandler                [WEAK]
                EXPORT  USART3_IRQHandler                [WEAK]
                EXPORT  EXTI15_10_IRQHandler             [WEAK]
                EXPORT  RTCAlarm_IRQHandler              [WEAK]
                EXPORT  CEC_IRQHandler                   [WEAK]
                EXPORT  TIM6_DAC_IRQHandler              [WEAK]
                EXPORT  TIM7_IRQHandler                  [WEAK]

WWDG_IRQHandler
PVD_IRQHandler
TAMPER_IRQHandler
RTC_IRQHandler
FLASH_IRQHandler
RCC_IRQHandler
EXTI0_IRQHandler
EXTI1_IRQHandler
EXTI2_IRQHandler
EXTI3_IRQHandler
EXTI4_IRQHandler
DMA1_Channel1_IRQHandler
DMA1_Channel2_IRQHandler
DMA1_Channel3_IRQHandler
DMA1_Channel4_IRQHandler
DMA1_Channel5_IRQHandler
DMA1_Channel6_IRQHandler
DMA1_Channel7_IRQHandler
ADC1_IRQHandler
EXTI9_5_IRQHandler
TIM1_BRK_TIM15_IRQHandler
TIM1_UP_TIM16_IRQHandler
TIM1_TRG_COM_TIM17_IRQHandler
TIM1_CC_IRQHandler
TIM2_IRQHandler
TIM3_IRQHandler
TIM4_IRQHandler
I2C1_EV_IRQHandler
I2C1_ER_IRQHandler
I2C2_EV_IRQHandler
I2C2_ER_IRQHandler
SPI1_IRQHandler
SPI2_IRQHandler
USART1_IRQHandler
USART2_IRQHandler
USART3_IRQHandler
EXTI15_10_IRQHandler
RTCAlarm_IRQHandler
CEC_IRQHandler
TIM6_DAC_IRQHandler
TIM7_IRQHandler
                B       .

                ENDP

                ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************
                 IF      :DEF:__MICROLIB           
                
                 EXPORT  __initial_sp
                 EXPORT  __heap_base
                 EXPORT  __heap_limit
                
                 ELSE
                
                 IMPORT  __use_two_region_memory
                 EXPORT  __user_initial_stackheap
                 
__user_initial_stackheap

                 LDR     R0, =  Heap_Mem
                 LDR     R1, =(Stack_Mem + Stack_Size)
                 LDR     R2, = (Heap_Mem +  Heap_Size)
                 LDR     R3, = Stack_Mem
                 BX      LR

                 ALIGN

                 ENDIF

                 END

;******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE*****
