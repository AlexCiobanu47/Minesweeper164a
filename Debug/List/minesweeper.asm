
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega164A
;Program type           : Application
;Clock frequency        : 20.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega164A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _seed=R3
	.DEF _seed_msb=R4
	.DEF _flagIndex=R5
	.DEF _flagIndex_msb=R6
	.DEF _bombCount=R7
	.DEF _bombCount_msb=R8
	.DEF _inPlay=R10
	.DEF _firstMove=R9

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_gameOverText:
	.DB  0x4C,0x4F,0x53,0x45,0x0
_gameWonText:
	.DB  0x57,0x49,0x4E,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x1

_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;#include <mega164a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <stdbool.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include "defs.h"
;
;GLCDINIT_t init;
;unsigned int seed = 0; //pentru numere random
;int flagIndex;  // numarul de flaguri puse
;flash const int bombNumber = 5;
;flash const int flagNumber = 5;
;flash const int cellNumber = 25;
;int bombCount;
;bool inPlay = true; //pentru resetare joc
;bool firstMove = true;
;flash char flag ='f';
;flash char bomb = 'x';
;flash char gameOverText[5] = "LOSE";
;flash char gameWonText[4] = "WIN";
;struct Cell{
;    int row;
;    int col;
;    bool isBomb;
;    bool isFlag;
;    bool isCleared;
;};
;struct Cell cells[5][5]; //placa de joc
;//initializare celule si resetare atribute pentru fiecare
;void initializeCells(struct Cell cells[5][5]){
; 0000 001E void initializeCells(struct Cell cells[5][5]){

	.CSEG
_initializeCells:
; .FSTART _initializeCells
; 0000 001F     int i,j;
; 0000 0020     for(i=0; i<5;i++){
	CALL SUBOPT_0x0
;	cells -> Y+4
;	i -> R16,R17
;	j -> R18,R19
_0x4:
	__CPWRN 16,17,5
	BRGE _0x5
; 0000 0021         for(j=0;j<5;j++){
	__GETWRN 18,19,0
_0x7:
	__CPWRN 18,19,5
	BRGE _0x8
; 0000 0022             cells[i][j].row = i;
	CALL SUBOPT_0x1
	ST   Z,R16
	STD  Z+1,R17
; 0000 0023             cells[i][j].col = j;
	CALL SUBOPT_0x1
	__PUTWZR 18,19,2
; 0000 0024             cells[i][j].isBomb = false;
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0025             cells[i][j].isFlag = false;
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,5
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0026             cells[i][j].isCleared = false;
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0027         }
	__ADDWRN 18,19,1
	RJMP _0x7
_0x8:
; 0000 0028     }
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0029 }
	CALL __LOADLOCR4
	RJMP _0x210000D
; .FEND
;//desenarea unui patrat
;void drawCell(int x, int y){
; 0000 002B void drawCell(int x, int y){
_drawCell:
; .FSTART _drawCell
; 0000 002C     x = 2+16*x; // cursor -> pixel
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+2
;	y -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __LSLW4
	ADIW R30,2
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 002D     y = 2+9*y;
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL __MULW12
	ADIW R30,2
	ST   Y,R30
	STD  Y+1,R31
; 0000 002E     //linii orizontale
; 0000 002F     glcd_line(x,y,x+16,y);
	LDD  R30,Y+2
	CALL SUBOPT_0x3
	SUBI R30,-LOW(16)
	ST   -Y,R30
	LDD  R26,Y+3
	CALL _glcd_line
; 0000 0030     glcd_line(x,y+9,x+16,y+9);
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(9)
	ST   -Y,R30
	LDD  R30,Y+4
	CALL SUBOPT_0x4
; 0000 0031     //linii verticale
; 0000 0032     glcd_line(x,y,x,y+9);
	LDD  R30,Y+2
	CALL SUBOPT_0x3
	ST   -Y,R30
	LDD  R26,Y+3
	SUBI R26,-LOW(9)
	CALL _glcd_line
; 0000 0033     glcd_line(x+16,y,x+16,y+9);
	LDD  R30,Y+2
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0000 0034 }
	RJMP _0x210000E
; .FEND
;//display celula normala
;void displayCell(int x, int y){
; 0000 0036 void displayCell(int x, int y){
_displayCell:
; .FSTART _displayCell
; 0000 0037 
; 0000 0038     glcd_setlinestyle(1, GLCD_LINE_SOLID);
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+2
;	y -> Y+0
	CALL SUBOPT_0x5
; 0000 0039     drawCell(x,y);
	CALL SUBOPT_0x6
; 0000 003A 
; 0000 003B }
	RJMP _0x210000E
; .FEND
;//display cursor
;void displayCursor(int x, int y){
; 0000 003D void displayCursor(int x, int y){
_displayCursor:
; .FSTART _displayCursor
; 0000 003E     glcd_setlinestyle(1, GLCD_LINE_DOT_LARGE);
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+2
;	y -> Y+0
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(51)
	__PUTB1MN _glcd_state,9
; 0000 003F     drawCell(x,y);
	CALL SUBOPT_0x6
; 0000 0040 }
	RJMP _0x210000E
; .FEND
;//display 5x5 celule normale
;void displayBoard(int x, int y){
; 0000 0042 void displayBoard(int x, int y){
_displayBoard:
; .FSTART _displayBoard
; 0000 0043     int i,j;
; 0000 0044     for(i = 0; i<5; i++){
	CALL SUBOPT_0x0
;	x -> Y+6
;	y -> Y+4
;	i -> R16,R17
;	j -> R18,R19
_0xA:
	__CPWRN 16,17,5
	BRGE _0xB
; 0000 0045         for(j = 0; j < 5; j++){
	__GETWRN 18,19,0
_0xD:
	__CPWRN 18,19,5
	BRGE _0xE
; 0000 0046             if(i == x && j == y)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x10
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 0047                 continue;
	RJMP _0xC
; 0000 0048             displayCell(i,j);
_0xF:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _displayCell
; 0000 0049         }
_0xC:
	__ADDWRN 18,19,1
	RJMP _0xD
_0xE:
; 0000 004A     }
	__ADDWRN 16,17,1
	RJMP _0xA
_0xB:
; 0000 004B }
	CALL __LOADLOCR4
	RJMP _0x210000C
; .FEND
;//generator de bombe cu seed randomizat
;void generateBombs(struct Cell cells[5][5]){
; 0000 004D void generateBombs(struct Cell cells[5][5]){
_generateBombs:
; .FSTART _generateBombs
; 0000 004E     int i;
; 0000 004F     for(i = 0; i < bombNumber;){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	cells -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x13:
	__CPWRN 16,17,5
	BRGE _0x14
; 0000 0050         int x = seed % 25;
; 0000 0051         int xPos = x / 5;
; 0000 0052         int yPos = x % 5;
; 0000 0053         if(cells[xPos][yPos].isBomb == false){
	SBIW R28,6
;	cells -> Y+8
;	x -> Y+4
;	xPos -> Y+2
;	yPos -> Y+0
	__GETW2R 3,4
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL __MODW21U
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __DIVW21
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	ST   Y,R30
	STD  Y+1,R31
	CALL SUBOPT_0x7
	LD   R30,X
	CPI  R30,0
	BRNE _0x15
; 0000 0054             cells[xPos][yPos].isBomb = true;
	CALL SUBOPT_0x7
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 0055             i++;
	__ADDWRN 16,17,1
; 0000 0056         }
; 0000 0057         seed = seed*3 + 7;
_0x15:
	__GETW1R 3,4
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	ADIW R30,7
	__PUTW1R 3,4
; 0000 0058     }
	ADIW R28,6
	RJMP _0x13
_0x14:
; 0000 0059 }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x210000E:
	ADIW R28,4
	RET
; .FEND
;//numara bombele din celulele alaturate si returneaza numarul ca un char
;//pentru display
;char adjacentBombs(int x,int y, struct Cell cells[5][5]){
; 0000 005C char adjacentBombs(int x,int y, struct Cell cells[5][5]){
_adjacentBombs:
; .FSTART _adjacentBombs
; 0000 005D     bombCount = 0;
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+4
;	y -> Y+2
;	cells -> Y+0
	CLR  R7
	CLR  R8
; 0000 005E         if(x-1 >=0 && cells[x-1][y].isBomb)    //left
	CALL SUBOPT_0x8
	BRMI _0x17
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	BRNE _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 005F             bombCount++;
	CALL SUBOPT_0xB
; 0000 0060         if(x+1 <5 && cells[x+1][y].isBomb)    //right
_0x16:
	CALL SUBOPT_0xC
	BRGE _0x1A
	CALL SUBOPT_0xD
	CALL SUBOPT_0xA
	BRNE _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 0061             bombCount++;
	CALL SUBOPT_0xB
; 0000 0062         if(y-1 >= 0 && cells[x][y-1].isBomb)     //up
_0x19:
	CALL SUBOPT_0xE
	BRMI _0x1D
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	BRNE _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 0063             bombCount++;
	CALL SUBOPT_0xB
; 0000 0064         if(y+1 <5 && cells[x][y+1].isBomb)     //down
_0x1C:
	CALL SUBOPT_0x11
	BRGE _0x20
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
	BRNE _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 0065             bombCount++;
	CALL SUBOPT_0xB
; 0000 0066         if(x-1 >= 0 && y-1 >=0 && cells[x-1][y-1].isBomb)    //left up
_0x1F:
	CALL SUBOPT_0x8
	BRMI _0x23
	CALL SUBOPT_0xE
	BRMI _0x23
	CALL SUBOPT_0x9
	CALL SUBOPT_0x13
	BRNE _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 0067             bombCount++;
	CALL SUBOPT_0xB
; 0000 0068         if(x+1<5 && y-1 >=0 && cells[x+1][y-1].isBomb)    //right up
_0x22:
	CALL SUBOPT_0xC
	BRGE _0x26
	CALL SUBOPT_0xE
	BRMI _0x26
	CALL SUBOPT_0xD
	CALL SUBOPT_0x13
	BRNE _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 0069             bombCount++;
	CALL SUBOPT_0xB
; 0000 006A         if(x-1 >= 0 && y+1 < 5 && cells[x-1][y+1].isBomb)     //left down
_0x25:
	CALL SUBOPT_0x8
	BRMI _0x29
	CALL SUBOPT_0x11
	BRGE _0x29
	CALL SUBOPT_0x9
	CALL SUBOPT_0x14
	BRNE _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 006B             bombCount++;
	CALL SUBOPT_0xB
; 0000 006C         if(x+1 <5 && y+1 <5 && cells[x+1][y+1].isBomb)     //right down
_0x28:
	CALL SUBOPT_0xC
	BRGE _0x2C
	CALL SUBOPT_0x11
	BRGE _0x2C
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
	BRNE _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
; 0000 006D             bombCount++;
	CALL SUBOPT_0xB
; 0000 006E     if(bombCount == 0)
_0x2B:
	MOV  R0,R7
	OR   R0,R8
	BRNE _0x2E
; 0000 006F         return '0';
	LDI  R30,LOW(48)
	RJMP _0x210000D
; 0000 0070     if(bombCount == 1)
_0x2E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x2F
; 0000 0071         return '1';
	LDI  R30,LOW(49)
_0x210000D:
	ADIW R28,6
	RET
; 0000 0072     if(bombCount == 2)
_0x2F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x30
; 0000 0073         return '2';
	LDI  R30,LOW(50)
	JMP  _0x2100009
; 0000 0074     if(bombCount == 3)
_0x30:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x31
; 0000 0075         return '3';
	LDI  R30,LOW(51)
	JMP  _0x2100009
; 0000 0076     if(bombCount == 4)
_0x31:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x32
; 0000 0077         return '4';
	LDI  R30,LOW(52)
	JMP  _0x2100009
; 0000 0078     if(bombCount == 5)
_0x32:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x33
; 0000 0079         return '5';
	LDI  R30,LOW(53)
	JMP  _0x2100009
; 0000 007A     if(bombCount == 6)
_0x33:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x34
; 0000 007B         return '6';
	LDI  R30,LOW(54)
	JMP  _0x2100009
; 0000 007C     if(bombCount == 7)
_0x34:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x35
; 0000 007D         return '7';
	LDI  R30,LOW(55)
	JMP  _0x2100009
; 0000 007E     if(bombCount == 8)
_0x35:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x36
; 0000 007F         return '8';
	LDI  R30,LOW(56)
	JMP  _0x2100009
; 0000 0080 }
_0x36:
	JMP  _0x2100009
; .FEND
;//display flag, bombe si numar de bombe in celulele alaturate
;void displayCellIndicator(struct Cell cells[5][5]){
; 0000 0082 void displayCellIndicator(struct Cell cells[5][5]){
_displayCellIndicator:
; .FSTART _displayCellIndicator
; 0000 0083     int i,j;
; 0000 0084     for(i=0;i<5;i++){
	CALL SUBOPT_0x0
;	cells -> Y+4
;	i -> R16,R17
;	j -> R18,R19
_0x38:
	__CPWRN 16,17,5
	BRGE _0x39
; 0000 0085         for(j=0;j<5;j++){
	__GETWRN 18,19,0
_0x3B:
	__CPWRN 18,19,5
	BRGE _0x3C
; 0000 0086             if(cells[i][j].isFlag){
	CALL SUBOPT_0x2
	CALL SUBOPT_0x15
	BREQ _0x3D
; 0000 0087                 glcd_putcharxy(8+16*i,3+9*j, flag);
	CALL SUBOPT_0x16
	LDI  R26,LOW(102)
	CALL _glcd_putcharxy
; 0000 0088             }
; 0000 0089             if(cells[i][j].isBomb){
_0x3D:
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R30,X
	CPI  R30,0
	BREQ _0x3E
; 0000 008A                 glcd_putcharxy(8+16*i,3+9*j, bomb);
	CALL SUBOPT_0x16
	LDI  R26,LOW(120)
	CALL _glcd_putcharxy
; 0000 008B             }
; 0000 008C             if(cells[i][j].isCleared){
_0x3E:
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LD   R30,X
	CPI  R30,0
	BREQ _0x3F
; 0000 008D                 glcd_putcharxy(8+16*i,3+9*j, adjacentBombs(i,j, cells));
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL _adjacentBombs
	MOV  R26,R30
	CALL _glcd_putcharxy
; 0000 008E             }
; 0000 008F         }
_0x3F:
	__ADDWRN 18,19,1
	RJMP _0x3B
_0x3C:
; 0000 0090     }
	__ADDWRN 16,17,1
	RJMP _0x38
_0x39:
; 0000 0091 }
	CALL __LOADLOCR4
	JMP  _0x2100009
; .FEND
;//daca celulele alaturate au 0 bombe adiacente se afiseaza 0 si pe ele
;void adjacentClearCells(int x, int y, struct Cell cells[5][5]){
; 0000 0093 void adjacentClearCells(int x, int y, struct Cell cells[5][5]){
_adjacentClearCells:
; .FSTART _adjacentClearCells
; 0000 0094     if(x-1 >=0 && adjacentBombs(x-1,y,cells) == '0' && cells[x-1][y].isBomb == false){    //left
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+4
;	y -> Y+2
;	cells -> Y+0
	CALL SUBOPT_0x8
	BRMI _0x41
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	BRNE _0x41
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 0095         cells[x-1][y].isCleared = true;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
; 0000 0096     }
; 0000 0097     if(x+1 <5 && adjacentBombs(x+1,y,cells) == '0' && cells[x+1][y].isBomb == false){    //right
_0x40:
	CALL SUBOPT_0xC
	BRGE _0x44
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x19
	BRNE _0x44
	CALL SUBOPT_0xD
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
; 0000 0098         cells[x+1][y].isCleared = true;
	CALL SUBOPT_0xD
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
; 0000 0099     }
; 0000 009A     if(y-1 >= 0 && adjacentBombs(x,y-1,cells) == '0' && cells[x][y-1].isBomb == false){     //up
_0x43:
	CALL SUBOPT_0xE
	BRMI _0x47
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
	BRNE _0x47
	CALL SUBOPT_0xF
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	BREQ _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 009B         cells[x][y-1].isCleared = true;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1C
; 0000 009C     }
; 0000 009D     if(y+1 <5 && adjacentBombs(x,y+1,cells) == '0' && cells[x][y+1].isBomb == false){     //down
_0x46:
	CALL SUBOPT_0x11
	BRGE _0x4A
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	BRNE _0x4A
	CALL SUBOPT_0xF
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1B
	BREQ _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
; 0000 009E         cells[x][y+1].isCleared = true;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1C
; 0000 009F     }
; 0000 00A0     if(x-1 >= 0 && y-1 >=0 && adjacentBombs(x-1,y-1,cells) == '0' && cells[x-1][y-1].isBomb == false){    //left up
_0x49:
	CALL SUBOPT_0x8
	BRMI _0x4D
	CALL SUBOPT_0xE
	BRMI _0x4D
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
	BRNE _0x4D
	CALL SUBOPT_0x9
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	BREQ _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00A1         cells[x-1][y-1].isCleared = true;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1C
; 0000 00A2     }
; 0000 00A3     if(x+1<5 && y-1 >=0 && adjacentBombs(x+1,y-1,cells) == '0' && cells[x+1][y-1].isBomb == false){    //right up
_0x4C:
	CALL SUBOPT_0xC
	BRGE _0x50
	CALL SUBOPT_0xE
	BRMI _0x50
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
	BRNE _0x50
	CALL SUBOPT_0xD
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 00A4         cells[x+1][y-1].isCleared = true;
	CALL SUBOPT_0xD
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1C
; 0000 00A5     }
; 0000 00A6     if(x-1 >= 0 && y+1 < 5 && adjacentBombs(x-1,y+1,cells) == '0' && cells[x-1][y+1].isBomb == false){     //left down
_0x4F:
	CALL SUBOPT_0x8
	BRMI _0x53
	CALL SUBOPT_0x11
	BRGE _0x53
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	BRNE _0x53
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1B
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 00A7         cells[x-1][y+1].isCleared = true;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1C
; 0000 00A8     }
; 0000 00A9     if(x+1 <5 && y+1 <5 && adjacentBombs(x+1,y+1,cells) == '0' && cells[x+1][y+1].isBomb == false){     //right down
_0x52:
	CALL SUBOPT_0xC
	BRGE _0x56
	CALL SUBOPT_0x11
	BRGE _0x56
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	BRNE _0x56
	CALL SUBOPT_0xD
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1B
	BREQ _0x57
_0x56:
	RJMP _0x55
_0x57:
; 0000 00AA         cells[x+1][y+1].isCleared = true;
	CALL SUBOPT_0xD
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1C
; 0000 00AB     }
; 0000 00AC }
_0x55:
	JMP  _0x2100009
; .FEND
;//numara cate celule au fost acoperite(flaguri sau celule cu numere)
;//returneaza TRUE daca jocul este castigat
;//altfel returneaza FALSE
;bool checkWin(int cellsFilled){
; 0000 00B0 _Bool checkWin(int cellsFilled){
_checkWin:
; .FSTART _checkWin
; 0000 00B1     int i,j;
; 0000 00B2     int count = 0;
; 0000 00B3     for(i = 0; i < 5; i++){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	cellsFilled -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	count -> R20,R21
	__GETWRN 20,21,0
	__GETWRN 16,17,0
_0x59:
	__CPWRN 16,17,5
	BRGE _0x5A
; 0000 00B4         for(j = 0; j < 5; j++){
	__GETWRN 18,19,0
_0x5C:
	__CPWRN 18,19,5
	BRGE _0x5D
; 0000 00B5             if(cells[i][j].isCleared || cells[i][j].isFlag){
	CALL SUBOPT_0x24
	MOVW R0,R30
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LD   R30,X
	CPI  R30,0
	BRNE _0x5F
	MOVW R30,R0
	MOVW R26,R22
	CALL SUBOPT_0x15
	BREQ _0x5E
_0x5F:
; 0000 00B6                 count++;
	__ADDWRN 20,21,1
; 0000 00B7             }
; 0000 00B8         }
_0x5E:
	__ADDWRN 18,19,1
	RJMP _0x5C
_0x5D:
; 0000 00B9     }
	__ADDWRN 16,17,1
	RJMP _0x59
_0x5A:
; 0000 00BA     if(count == cellsFilled)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x61
; 0000 00BB         return true;
	LDI  R30,LOW(1)
	RJMP _0x210000B
; 0000 00BC     return false;
_0x61:
	LDI  R30,LOW(0)
_0x210000B:
	CALL __LOADLOCR6
_0x210000C:
	ADIW R28,8
	RET
; 0000 00BD }
; .FEND
;//apeleaza functiile de display
;void display(int cursorPosx, int cursorPosy, struct Cell cells[5][5]){
; 0000 00BF void display(int cursorPosx, int cursorPosy, struct Cell cells[5][5]){
_display:
; .FSTART _display
; 0000 00C0     displayBoard(cursorPosx, cursorPosy);
	ST   -Y,R27
	ST   -Y,R26
;	cursorPosx -> Y+4
;	cursorPosy -> Y+2
;	cells -> Y+0
	CALL SUBOPT_0x1E
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _displayBoard
; 0000 00C1     displayCursor(cursorPosx, cursorPosy);
	CALL SUBOPT_0x1E
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _displayCursor
; 0000 00C2     displayCellIndicator(cells);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _displayCellIndicator
; 0000 00C3 }
	JMP  _0x2100009
; .FEND
;//reseteaza pozitia bombelor(pentru regenerare bombe daca prima selectie a fost
;//fix pe o bomba)
;void resetBombs(struct Cell cells[5][5]){
; 0000 00C6 void resetBombs(struct Cell cells[5][5]){
_resetBombs:
; .FSTART _resetBombs
; 0000 00C7     int i, j;
; 0000 00C8     for(i=0;i<5;i++){
	CALL SUBOPT_0x0
;	cells -> Y+4
;	i -> R16,R17
;	j -> R18,R19
_0x63:
	__CPWRN 16,17,5
	BRGE _0x64
; 0000 00C9         for(j=0;j<5;j++){
	__GETWRN 18,19,0
_0x66:
	__CPWRN 18,19,5
	BRGE _0x67
; 0000 00CA             cells[i][j].isBomb = false;
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00CB         }
	__ADDWRN 18,19,1
	RJMP _0x66
_0x67:
; 0000 00CC     }
	__ADDWRN 16,17,1
	RJMP _0x63
_0x64:
; 0000 00CD }
	CALL __LOADLOCR4
	JMP  _0x2100009
; .FEND
;void main(void){
; 0000 00CE void main(void){
_main:
; .FSTART _main
; 0000 00CF int cursorPosx = 0;
; 0000 00D0 int cursorPosy = 0;
; 0000 00D1 //init display
; 0000 00D2 init.font=font5x7;
;	cursorPosx -> R16,R17
;	cursorPosy -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	STS  _init,R30
	STS  _init+1,R31
; 0000 00D3 init.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	__GETB1MN _init,6
	ANDI R30,LOW(0xFC)
	__PUTB1MN _init,6
; 0000 00D4 init.bias=PCD8544_DEFAULT_BIAS;
	__GETB1MN _init,6
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	__PUTB1MN _init,6
; 0000 00D5 init.vlcd=PCD8544_DEFAULT_VLCD;
	__GETB1MN _init,7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	__PUTB1MN _init,7
; 0000 00D6 /* No need for reading data from external memory */
; 0000 00D7 init.readxmem=NULL;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _init,2
; 0000 00D8 /* No need for reading data from external memory */
; 0000 00D9 init.writexmem=NULL;
	__PUTW1MN _init,4
; 0000 00DA /* Initialize the LCD controller and graphics */
; 0000 00DB glcd_init(&init);
	LDI  R26,LOW(_init)
	LDI  R27,HIGH(_init)
	CALL _glcd_init
; 0000 00DC 
; 0000 00DD //initializare porturi
; 0000 00DE BACKLIGHT = 0;
	CBI  0x8,2
; 0000 00DF SELECT = 1;
	SBI  0x0,0
; 0000 00E0 FLAG = 1;
	SBI  0x0,1
; 0000 00E1 LEFT = 1;
	SBI  0x0,2
; 0000 00E2 RIGHT = 1;
	SBI  0x0,3
; 0000 00E3 UP = 1;
	SBI  0x0,4
; 0000 00E4 DOWN = 1;
	SBI  0x0,5
; 0000 00E5 
; 0000 00E6 flagIndex = 0;
	CLR  R5
	CLR  R6
; 0000 00E7 initializeCells(cells);
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	RCALL _initializeCells
; 0000 00E8 displayBoard(0,0);
	CALL SUBOPT_0x25
	RCALL _displayBoard
; 0000 00E9 displayCursor(0,0);
	CALL SUBOPT_0x25
	RCALL _displayCursor
; 0000 00EA generateBombs(cells);
	CALL SUBOPT_0x26
; 0000 00EB displayCellIndicator(cells);
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	RCALL _displayCellIndicator
; 0000 00EC     while (1)
_0x76:
; 0000 00ED     {
; 0000 00EE     //SELECT
; 0000 00EF         if(SELECT == 0){
	SBIC 0x0,0
	RJMP _0x79
; 0000 00F0                 delay_ms(30);
	CALL SUBOPT_0x27
; 0000 00F1                 if(SELECT == 0){
	SBIC 0x0,0
	RJMP _0x7A
; 0000 00F2                     while(SELECT == 0){
_0x7B:
	SBIC 0x0,0
	RJMP _0x7D
; 0000 00F3                         wdogtrig();
	wdr
; 0000 00F4                     }
	RJMP _0x7B
_0x7D:
; 0000 00F5                     if(inPlay){
	TST  R10
	BRNE PC+2
	RJMP _0x7E
; 0000 00F6                         //daca prima selectie este pe o celula cu bomba se sterg bombele si se genereaza altele
; 0000 00F7                         if(firstMove == true && cells[cursorPosx][cursorPosy].isBomb == true){;
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x80
	CALL SUBOPT_0x24
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 00F8                             resetBombs(cells);
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	RCALL _resetBombs
; 0000 00F9                             generateBombs(cells);
	CALL SUBOPT_0x26
; 0000 00FA                             glcd_clear();
	CALL _glcd_clear
; 0000 00FB                             cells[cursorPosx][cursorPosy].isCleared = true;
	CALL SUBOPT_0x24
	MOVW R26,R22
	CALL SUBOPT_0x1C
; 0000 00FC                             display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x28
; 0000 00FD                         }
; 0000 00FE                         //daca se selecteaza bomba si nu este prima selectie
; 0000 00FF                         //LOSE
; 0000 0100                         else if(cells[cursorPosx][cursorPosy].isBomb){
	RJMP _0x82
_0x7F:
	CALL SUBOPT_0x24
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R30,X
	CPI  R30,0
	BREQ _0x83
; 0000 0101                             if(cells[cursorPosx][cursorPosy].isFlag == false){
	CALL SUBOPT_0x24
	MOVW R26,R22
	CALL SUBOPT_0x15
	BRNE _0x84
; 0000 0102                                 glcd_clear();
	CALL _glcd_clear
; 0000 0103                                 glcd_outtextxyf(0,20,gameOverText);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(_gameOverText*2)
	LDI  R27,HIGH(_gameOverText*2)
	CALL _glcd_outtextxyf
; 0000 0104                                 inPlay = false;
	CLR  R10
; 0000 0105                                 }
; 0000 0106                         }
_0x84:
; 0000 0107                         //celula selectat nu are bomba sau flag
; 0000 0108                         //verificare conditie de WIN
; 0000 0109                         else if(cells[cursorPosx][cursorPosy].isFlag == false){
	RJMP _0x85
_0x83:
	CALL SUBOPT_0x24
	MOVW R26,R22
	CALL SUBOPT_0x15
	BRNE _0x86
; 0000 010A                             cells[cursorPosx][cursorPosy].isCleared = true;
	CALL SUBOPT_0x24
	MOVW R26,R22
	CALL SUBOPT_0x1C
; 0000 010B                             adjacentClearCells(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x17
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	RCALL _adjacentClearCells
; 0000 010C                             displayCellIndicator(cells);
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	RCALL _displayCellIndicator
; 0000 010D                             if(checkWin(cellNumber) == true){
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RCALL _checkWin
	CPI  R30,LOW(0x1)
	BRNE _0x87
; 0000 010E                                 inPlay = false;
	CLR  R10
; 0000 010F                                 glcd_clear();
	CALL _glcd_clear
; 0000 0110                                 glcd_outtextxyf(0,10,gameWonText);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(_gameWonText*2)
	LDI  R27,HIGH(_gameWonText*2)
	CALL _glcd_outtextxyf
; 0000 0111                             }
; 0000 0112                         }
_0x87:
; 0000 0113                         firstMove = false;
_0x86:
_0x85:
_0x82:
	CLR  R9
; 0000 0114                     }
; 0000 0115                     //resetare joc
; 0000 0116                     else{
	RJMP _0x88
_0x7E:
; 0000 0117                         glcd_clear();
	CALL _glcd_clear
; 0000 0118                         initializeCells(cells);
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	RCALL _initializeCells
; 0000 0119                         generateBombs(cells);
	CALL SUBOPT_0x26
; 0000 011A                         cursorPosx = 0;
	__GETWRN 16,17,0
; 0000 011B                         cursorPosy = 0;
	__GETWRN 18,19,0
; 0000 011C                         flagIndex = 0;
	CLR  R5
	CLR  R6
; 0000 011D                         inPlay = true;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 011E                         display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x28
; 0000 011F                     }
_0x88:
; 0000 0120                 }
; 0000 0121 
; 0000 0122      }
_0x7A:
; 0000 0123      //FLAG
; 0000 0124         if(FLAG == 0){
_0x79:
	SBIC 0x0,1
	RJMP _0x89
; 0000 0125                 delay_ms(30);
	CALL SUBOPT_0x27
; 0000 0126                 if(FLAG == 0){
	SBIC 0x0,1
	RJMP _0x8A
; 0000 0127                     while(FLAG == 0){
_0x8B:
	SBIC 0x0,1
	RJMP _0x8D
; 0000 0128                         wdogtrig();
	wdr
; 0000 0129                     }
	RJMP _0x8B
_0x8D:
; 0000 012A                     if(inPlay == true){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x8E
; 0000 012B                         //remove flag
; 0000 012C                         if(cells[cursorPosx][cursorPosy].isFlag){
	CALL SUBOPT_0x24
	MOVW R26,R22
	CALL SUBOPT_0x15
	BREQ _0x8F
; 0000 012D                             cells[cursorPosx][cursorPosy].isFlag = false;
	CALL SUBOPT_0x24
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,5
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 012E                             flagIndex--;
	__GETW1R 5,6
	SBIW R30,1
	__PUTW1R 5,6
; 0000 012F                         }
; 0000 0130                         //set flag
; 0000 0131                         else{
	RJMP _0x90
_0x8F:
; 0000 0132                             if(flagIndex <= flagNumber){
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R5
	CPC  R31,R6
	BRLT _0x91
; 0000 0133                                 cells[cursorPosx][cursorPosy].isFlag = true;
	CALL SUBOPT_0x24
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,5
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 0134                                 flagIndex++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 0135                             }
; 0000 0136                         }
_0x91:
_0x90:
; 0000 0137                         glcd_clear();
	CALL SUBOPT_0x29
; 0000 0138                         display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x28
; 0000 0139                     }
; 0000 013A                     else{
	RJMP _0x92
_0x8E:
; 0000 013B                         glcd_clear();
	RCALL _glcd_clear
; 0000 013C                     }
_0x92:
; 0000 013D                 }
; 0000 013E         }
_0x8A:
; 0000 013F     //MOVEMENT    //2-left, 3-right, 4-up, 5-down
; 0000 0140         if(LEFT == 0){
_0x89:
	SBIC 0x0,2
	RJMP _0x93
; 0000 0141                 delay_ms(30);
	CALL SUBOPT_0x27
; 0000 0142                 if(LEFT == 0){
	SBIC 0x0,2
	RJMP _0x94
; 0000 0143                     while(LEFT == 0){
_0x95:
	SBIC 0x0,2
	RJMP _0x97
; 0000 0144                         wdogtrig();
	wdr
; 0000 0145                     }
	RJMP _0x95
_0x97:
; 0000 0146                     if(inPlay == true){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x98
; 0000 0147                         if(cursorPosx > 0){
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x99
; 0000 0148                             cursorPosx--;
	__SUBWRN 16,17,1
; 0000 0149                             glcd_clear();
	CALL SUBOPT_0x29
; 0000 014A                             display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x28
; 0000 014B                         }
; 0000 014C                     }
_0x99:
; 0000 014D                     else{
	RJMP _0x9A
_0x98:
; 0000 014E                         glcd_clear();
	RCALL _glcd_clear
; 0000 014F                     }
_0x9A:
; 0000 0150                 }
; 0000 0151         }
_0x94:
; 0000 0152         if(RIGHT == 0){
_0x93:
	SBIC 0x0,3
	RJMP _0x9B
; 0000 0153                 delay_ms(30);
	CALL SUBOPT_0x27
; 0000 0154                 if(RIGHT == 0){
	SBIC 0x0,3
	RJMP _0x9C
; 0000 0155                     while(RIGHT == 0){
_0x9D:
	SBIC 0x0,3
	RJMP _0x9F
; 0000 0156                         wdogtrig();
	wdr
; 0000 0157                     }
	RJMP _0x9D
_0x9F:
; 0000 0158                     if(inPlay == true){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xA0
; 0000 0159                         if(cursorPosx < 4){
	__CPWRN 16,17,4
	BRGE _0xA1
; 0000 015A                             cursorPosx++;
	__ADDWRN 16,17,1
; 0000 015B                             glcd_clear();
	CALL SUBOPT_0x29
; 0000 015C                             display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x28
; 0000 015D                         }
; 0000 015E                     }
_0xA1:
; 0000 015F                     else{
	RJMP _0xA2
_0xA0:
; 0000 0160                         glcd_clear();
	RCALL _glcd_clear
; 0000 0161                     }
_0xA2:
; 0000 0162                 }
; 0000 0163         }
_0x9C:
; 0000 0164         if(UP == 0){
_0x9B:
	SBIC 0x0,4
	RJMP _0xA3
; 0000 0165                 delay_ms(30);
	CALL SUBOPT_0x27
; 0000 0166                 if(UP == 0){
	SBIC 0x0,4
	RJMP _0xA4
; 0000 0167                     while(UP == 0){
_0xA5:
	SBIC 0x0,4
	RJMP _0xA7
; 0000 0168                         wdogtrig();
	wdr
; 0000 0169                     }
	RJMP _0xA5
_0xA7:
; 0000 016A                     if(inPlay == true){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xA8
; 0000 016B                         if(cursorPosy > 0){
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRGE _0xA9
; 0000 016C                             cursorPosy--;
	__SUBWRN 18,19,1
; 0000 016D                             glcd_clear();
	CALL SUBOPT_0x29
; 0000 016E                             display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x28
; 0000 016F                         }
; 0000 0170                     }
_0xA9:
; 0000 0171                     else{
	RJMP _0xAA
_0xA8:
; 0000 0172                         glcd_clear();
	RCALL _glcd_clear
; 0000 0173                     }
_0xAA:
; 0000 0174                 }
; 0000 0175         }
_0xA4:
; 0000 0176         if(DOWN == 0){
_0xA3:
	SBIC 0x0,5
	RJMP _0xAB
; 0000 0177                 delay_ms(30);
	CALL SUBOPT_0x27
; 0000 0178                 if(DOWN == 0){
	SBIC 0x0,5
	RJMP _0xAC
; 0000 0179                     while(DOWN == 0){
_0xAD:
	SBIC 0x0,5
	RJMP _0xAF
; 0000 017A                         wdogtrig();
	wdr
; 0000 017B                     }
	RJMP _0xAD
_0xAF:
; 0000 017C                     if(inPlay == true){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xB0
; 0000 017D                         if(cursorPosy < 4){
	__CPWRN 18,19,4
	BRGE _0xB1
; 0000 017E                             cursorPosy++;
	__ADDWRN 18,19,1
; 0000 017F                             glcd_clear();
	CALL SUBOPT_0x29
; 0000 0180                             display(cursorPosx, cursorPosy, cells);
	CALL SUBOPT_0x28
; 0000 0181                         }
; 0000 0182                     }
_0xB1:
; 0000 0183                     else{
	RJMP _0xB2
_0xB0:
; 0000 0184                         glcd_clear();
	RCALL _glcd_clear
; 0000 0185                     }
_0xB2:
; 0000 0186                 }
; 0000 0187         }
_0xAC:
; 0000 0188     }
_0xAB:
	RJMP _0x76
; 0000 0189 }
_0xB3:
	RJMP _0xB3
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_pcd8544_delay_G100:
; .FSTART _pcd8544_delay_G100
	RET
; .FEND
_pcd8544_wrbus_G100:
; .FSTART _pcd8544_wrbus_G100
	ST   -Y,R26
	ST   -Y,R17
	CBI  0x8,6
	LDI  R17,LOW(8)
_0x2000004:
	RCALL _pcd8544_delay_G100
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000006
	SBI  0x8,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x8,4
_0x2000007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G100
	SBI  0x8,3
	RCALL _pcd8544_delay_G100
	CBI  0x8,3
	SUBI R17,LOW(1)
	BRNE _0x2000004
	SBI  0x8,6
	LDD  R17,Y+0
	JMP  _0x2100003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x8,5
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x210000A
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	SBI  0x8,5
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x210000A
; .FEND
_pcd8544_setaddr_G100:
; .FSTART _pcd8544_setaddr_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _gfx_addr_G100,R30
	STS  _gfx_addr_G100+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2100002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G100
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	JMP  _0x2100003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G100
	LDS  R31,_gfx_addr_G100+1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R30,Z
	JMP  _0x2100003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0x2A
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x210000A
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	SBI  0x7,6
	SBI  0x8,6
	SBI  0x7,3
	CBI  0x8,3
	SBI  0x7,4
	SBI  0x7,5
	SBI  0x7,7
	CBI  0x8,7
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x8,7
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x2000008
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000A0
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	CALL SUBOPT_0x5
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2100009
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(12)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(8)
_0x200000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x210000A:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x200000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x200000E
_0x2000010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2100001
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2000012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2000011
_0x2000012:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100004
_0x2000011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2000014
	OR   R17,R16
	RJMP _0x2000015
_0x2000014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100004
; .FEND
_pcd8544_wrmasked_G100:
; .FSTART _pcd8544_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2000020
	CPI  R30,LOW(0x8)
	BRNE _0x2000021
_0x2000020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2000022
_0x2000021:
	CPI  R30,LOW(0x3)
	BRNE _0x2000024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000025
_0x2000024:
	CPI  R30,0
	BRNE _0x2000026
_0x2000025:
_0x2000022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000027
_0x2000026:
	CPI  R30,LOW(0x2)
	BRNE _0x2000028
_0x2000027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x200001E
_0x2000028:
	CPI  R30,LOW(0x1)
	BRNE _0x2000029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x200001E
_0x2000029:
	CPI  R30,LOW(0x4)
	BRNE _0x200001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x200001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x2100009:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x200002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x200002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x200002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x200002B
_0x200002C:
	RJMP _0x2100008
_0x200002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x200002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x200002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,49
	BRLO _0x200002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x200002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	RJMP _0x2100008
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x2100008
_0x2000036:
_0x2000037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000038
_0x2000039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x2B
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x200003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x200003D
	MOV  R17,R16
_0x200003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000040
	CALL SUBOPT_0x2C
	RJMP _0x200003E
_0x2000040:
	RJMP _0x200003B
_0x200003D:
_0x2000038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2000041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x2B
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2000042
	SUBI R19,-LOW(1)
_0x2000042:
	LDI  R18,LOW(0)
_0x2000043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000045
	LDD  R17,Y+14
_0x2000046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000048
	CALL SUBOPT_0x2C
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x2B
	RJMP _0x2000043
_0x2000045:
_0x2000041:
_0x2000030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x200004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x200004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2000052
	CPI  R30,LOW(0x3)
	BRNE _0x2000053
_0x2000052:
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x7)
	BRNE _0x2000055
_0x2000054:
	RJMP _0x2000056
_0x2000055:
	CPI  R30,LOW(0x8)
	BRNE _0x2000057
_0x2000056:
	RJMP _0x2000058
_0x2000057:
	CPI  R30,LOW(0x9)
	BRNE _0x2000059
_0x2000058:
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x200005A:
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2000050
_0x200005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2000050
	CALL SUBOPT_0x2D
_0x2000050:
_0x200005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2000060
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2A
	LD   R26,Z
	CALL _glcd_writemem
	RJMP _0x2000061
_0x2000060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000065
	LDI  R21,LOW(0)
	RJMP _0x2000066
_0x2000065:
	CPI  R30,LOW(0xA)
	BRNE _0x2000064
	LDI  R21,LOW(255)
	RJMP _0x2000066
_0x2000064:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	CALL SUBOPT_0x30
	MOV  R21,R30
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2000071
	COM  R21
	RJMP _0x2000072
_0x2000071:
	CPI  R30,0
	BRNE _0x2000074
_0x2000072:
_0x200006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G100
	RJMP _0x200006B
_0x2000074:
	CALL SUBOPT_0x31
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
_0x200006B:
_0x2000061:
	RJMP _0x200005D
_0x200005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000075
_0x200004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000076
_0x200004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000078
_0x2000077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000078:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200007C
	CALL SUBOPT_0x2D
_0x200007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	CALL SUBOPT_0x2A
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x32
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200007D
_0x200007F:
	RJMP _0x200007B
_0x200007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2000080
	LDI  R21,LOW(0)
	RJMP _0x2000081
_0x2000080:
	CPI  R30,LOW(0xA)
	BRNE _0x2000087
	LDI  R21,LOW(255)
_0x2000081:
	CALL SUBOPT_0x30
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000086
	CALL SUBOPT_0x31
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000084
_0x2000086:
	RJMP _0x200007B
_0x2000087:
_0x2000088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008A
	CALL SUBOPT_0x33
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000088
_0x200008A:
_0x200007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x200008B
	RJMP _0x200004B
_0x200008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x200008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000A1
_0x200008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000091
	CALL SUBOPT_0x2D
_0x2000092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	CALL SUBOPT_0x2A
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x32
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000092
_0x2000094:
	RJMP _0x2000090
_0x2000091:
	CPI  R30,LOW(0x9)
	BRNE _0x2000095
	LDI  R21,LOW(0)
	RJMP _0x2000096
_0x2000095:
	CPI  R30,LOW(0xA)
	BRNE _0x200009C
	LDI  R21,LOW(255)
_0x2000096:
	CALL SUBOPT_0x30
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2000099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200009B
	CALL SUBOPT_0x31
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000099
_0x200009B:
	RJMP _0x2000090
_0x200009C:
_0x200009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200009F
	CALL SUBOPT_0x33
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x200009D
_0x200009F:
_0x2000090:
_0x2000075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000049
_0x200004B:
_0x2100008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x34
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	JMP  _0x2100003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x34
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	JMP  _0x2100003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x35
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000B:
	CALL SUBOPT_0x36
	STD  Y+7,R0
	CALL SUBOPT_0x36
	STD  Y+6,R0
	CALL SUBOPT_0x36
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2100007
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2100007:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x37
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x35
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2100006
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x37
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x37
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x38
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2100006
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2100006:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	RJMP _0x2100002
; .FEND
_glcd_outtextxyf:
; .FSTART _glcd_outtextxyf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020028:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202002A
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020028
_0x202002A:
	LDD  R17,Y+0
	RJMP _0x2100004
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
	RJMP _0x2100002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2100003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x2100005
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	CALL SUBOPT_0x39
	BRSH _0x202004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	CALL SUBOPT_0x39
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x3A
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	CALL SUBOPT_0x39
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x3B
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x3C
_0x2020060:
	ST   -Y,R17
	CALL SUBOPT_0x3A
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x3B
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x3C
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x3A
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x2100005:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2100004:
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2100003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2080007
	CPI  R30,LOW(0xA)
	BRNE _0x2080008
_0x2080007:
	LDS  R17,_glcd_state
	RJMP _0x2080009
_0x2080008:
	CPI  R30,LOW(0x9)
	BRNE _0x208000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2080009
_0x208000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2080005
	__GETBRMN 17,_glcd_state,16
_0x2080009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x208000E
	CPI  R17,0
	BREQ _0x208000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000E:
	CPI  R17,0
	BRNE _0x2080011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x2080011:
_0x2080005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2080015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2100002
_0x2080015:
	CPI  R30,LOW(0x2)
	BRNE _0x2080016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2100002
_0x2080016:
	CPI  R30,LOW(0x3)
	BRNE _0x2080018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2100002
_0x2080018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2100002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x208001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x2)
	BRNE _0x208001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x208001B
_0x208001D:
	CPI  R30,LOW(0x3)
	BRNE _0x208001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x208001B:
_0x2100001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_init:
	.BYTE 0x8
_cells:
	.BYTE 0xAF
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	MOVW R30,R16
	__GETWRS 22,23,4
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x2:
	MOVW R30,R16
	__GETWRS 22,23,4
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SUBI R30,-LOW(16)
	ST   -Y,R30
	LDD  R26,Y+3
	SUBI R26,-LOW(9)
	JMP  _glcd_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	JMP  _drawCell

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	__GETWRS 22,23,8
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,Y
	LDD  R31,Y+1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,1
	TST  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x9:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	__GETWRS 22,23,0
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xD:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	__GETWRS 22,23,0
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	TST  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0xF:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETWRS 22,23,0
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x10:
	SBIW R30,1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x12:
	ADIW R30,1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,5
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(16)
	MULS R16,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(9)
	MULS R18,R26
	MOVW R30,R0
	SUBI R30,-LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _adjacentBombs
	CPI  R30,LOW(0x30)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A:
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1B:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	LD   R26,X
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1C:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LDI  R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _adjacentBombs
	CPI  R30,LOW(0x30)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x20:
	SBIW R30,1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x21:
	ADIW R30,1
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x24:
	__MULBNWRU 16,17,35
	SUBI R30,LOW(-_cells)
	SBCI R31,HIGH(-_cells)
	MOVW R26,R30
	MOVW R30,R18
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	JMP  _generateBombs

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(30)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_cells)
	LDI  R27,HIGH(_cells)
	JMP  _display

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	CALL _glcd_clear
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_gfx_addr_G100)
	LDI  R27,HIGH(_gfx_addr_G100)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2C:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x39:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1388
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
