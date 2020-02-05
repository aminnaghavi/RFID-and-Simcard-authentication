
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _lcd_cc=R5
	.DEF _temp=R4
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0x41,0x54,0x2B,0x53,0x41,0x50,0x42,0x52
	.DB  0x3D,0x33,0x2C,0x31,0x2C,0x22,0x43,0x6F
	.DB  0x6E,0x74,0x79,0x70,0x65,0x22,0x2C,0x22
	.DB  0x47,0x50,0x52,0x53,0x22,0xD,0xA,0x0
	.DB  0x25,0x73,0x25,0x73,0x0,0x41,0x54,0x2B
	.DB  0x53,0x41,0x50,0x42,0x52,0x3D,0x33,0x2C
	.DB  0x31,0x2C,0x22,0x41,0x50,0x4E,0x22,0x2C
	.DB  0x22,0x69,0x6E,0x74,0x65,0x72,0x6E,0x65
	.DB  0x74,0x22,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x53,0x41,0x50,0x42,0x52,0x3D,0x31,0x2C
	.DB  0x31,0xD,0xA,0x0,0x41,0x54,0x2B,0x53
	.DB  0x41,0x50,0x42,0x52,0x3D,0x32,0x2C,0x31
	.DB  0xD,0xA,0x0,0x41,0x54,0x2B,0x48,0x54
	.DB  0x54,0x50,0x49,0x4E,0x49,0x54,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x50,0x41,0x52,0x41,0x3D,0x22,0x43,0x49
	.DB  0x44,0x22,0x2C,0x31,0xD,0xA,0x0,0x41
	.DB  0x54,0x2B,0x48,0x54,0x54,0x50,0x50,0x41
	.DB  0x52,0x41,0x3D,0x22,0x55,0x52,0x4C,0x22
	.DB  0x2C,0x22,0x68,0x74,0x74,0x70,0x3A,0x2F
	.DB  0x2F,0x32,0x30,0x34,0x38,0x67,0x61,0x6D
	.DB  0x65,0x2E,0x74,0x6B,0x2F,0x63,0x61,0x72
	.DB  0x64,0x5F,0x64,0x61,0x74,0x61,0x2E,0x70
	.DB  0x68,0x70,0x3F,0x69,0x64,0x3D,0x25,0x73
	.DB  0x22,0xD,0xA,0x0,0x41,0x54,0x2B,0x48
	.DB  0x54,0x54,0x50,0x41,0x43,0x54,0x49,0x4F
	.DB  0x4E,0x3D,0x30,0xD,0xA,0x0,0x41,0x54
	.DB  0x2B,0x48,0x54,0x54,0x50,0x52,0x45,0x41
	.DB  0x44,0xD,0xA,0x0,0x4D,0x49,0x46,0x41
	.DB  0x52,0x45,0x20,0x52,0x43,0x35,0x32,0x32
	.DB  0x76,0x32,0x0,0x44,0x65,0x74,0x65,0x63
	.DB  0x74,0x65,0x64,0x0,0x4D,0x49,0x46,0x41
	.DB  0x52,0x45,0x20,0x52,0x43,0x35,0x32,0x32
	.DB  0x76,0x31,0x0,0x4E,0x6F,0x20,0x72,0x65
	.DB  0x61,0x64,0x65,0x72,0x20,0x66,0x6F,0x75
	.DB  0x6E,0x64,0x0,0x25,0x58,0x25,0x58,0x25
	.DB  0x58,0x25,0x58,0x25,0x58,0x25,0x58,0x25
	.DB  0x58,0x25,0x58,0x25,0x64,0x0,0x47,0x52
	.DB  0x41,0x4E,0x54,0x45,0x44,0x0,0x44,0x45
	.DB  0x4E,0x41,0x49,0x44,0x0,0x25,0x58,0x20
	.DB  0x25,0x58,0x20,0x25,0x58,0x20,0x25,0x58
	.DB  0x20,0x25,0x58,0x20,0x25,0x58,0x20,0x25
	.DB  0x58,0x20,0x25,0x58,0x20,0x25,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _0x48
	.DW  _0x0*2+302

	.DW  0x07
	.DW  _0x48+8
	.DW  _0x0*2+310

	.DW  0x07
	.DW  _0x48+15
	.DW  _0x0*2+310

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Standard Input/Output functions
;#include <stdio.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <spi.h>
;#include <string.h>
;
;unsigned char lcd_cc=0;
;unsigned char lcd_data[50];
;char at_req[200];
;char at_res[200];
;char temp;
;// SPI interrupt service routine
;unsigned char SPI_PUT(unsigned char data)
; 0000 0015 {

	.CSEG
_SPI_PUT:
; .FSTART _SPI_PUT
; 0000 0016     //while(!(SPSR & (1<<SPIF)));
; 0000 0017     SPDR=data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 0018     while(!(SPSR & (1<<SPIF)));
_0x3:
	SBIS 0xE,7
	RJMP _0x3
; 0000 0019     return SPDR;
	IN   R30,0xF
	JMP  _0x20A0006
; 0000 001A }
; .FEND
;
;
;//MFRC522
;//status
;#define CARD_FOUND        1
;#define CARD_NOT_FOUND    2
;#define ERROR            3
;
;#define MAX_LEN            16
;
;//Card types
;#define Mifare_UltraLight     0x4400
;#define Mifare_One_S50        0x0400
;#define Mifare_One_S70        0x0200
;#define Mifare_Pro_X        0x0800
;#define Mifare_DESFire        0x4403
;
;// Mifare_One card command word
;# define PICC_REQIDL          0x26               // find the antenna area does not enter hibernation
;# define PICC_REQALL          0x52               // find all the cards antenna area
;# define PICC_ANTICOLL        0x93               // anti-collision
;# define PICC_SElECTTAG       0x93               // election card
;# define PICC_AUTHENT1A       0x60               // authentication key A
;# define PICC_AUTHENT1B       0x61               // authentication key B
;# define PICC_READ            0x30               // Read Block
;# define PICC_WRITE           0xA0               // write block
;# define PICC_DECREMENT       0xC0               // debit
;# define PICC_INCREMENT       0xC1               // recharge
;# define PICC_RESTORE         0xC2               // transfer block data to the buffer
;# define PICC_TRANSFER        0xB0               // save the data in the buffer
;# define PICC_HALT            0x50               // Sleep
;//end of status
;//registers
;
;#ifndef _MFRC522_REG_H
;#define _MFRC522_REG_H
;
;//Page 0 ==> Command and Status
;
;#define Page0_Reserved_1 	0x00
;#define CommandReg			0x01
;#define ComIEnReg			0x02
;#define DivIEnReg			0x03
;#define ComIrqReg			0x04
;#define DivIrqReg			0x05
;#define ErrorReg			0x06
;#define Status1Reg			0x07
;#define Status2Reg			0x08
;#define FIFODataReg			0x09
;#define FIFOLevelReg		0x0A
;#define WaterLevelReg		0x0B
;#define ControlReg			0x0C
;#define BitFramingReg		0x0D
;#define CollReg				0x0E
;#define Page0_Reserved_2	0x0F
;
;//Page 1 ==> Command
;#define Page1_Reserved_1	0x10
;#define ModeReg				0x11
;#define TxModeReg			0x12
;#define RxModeReg			0x13
;#define TxControlReg		0x14
;#define TxASKReg			0x15
;#define TxSelReg			0x16
;#define RxSelReg			0x17
;#define RxThresholdReg		0x18
;#define	DemodReg			0x19
;#define Page1_Reserved_2	0x1A
;#define Page1_Reserved_3	0x1B
;#define MfTxReg				0x1C
;#define MfRxReg				0x1D
;#define Page1_Reserved_4	0x1E
;#define SerialSpeedReg		0x1F
;
;//Page 2 ==> CFG
;#define Page2_Reserved_1	0x20
;#define CRCResultReg_1		0x21
;#define CRCResultReg_2		0x22
;#define Page2_Reserved_2	0x23
;#define ModWidthReg			0x24
;#define Page2_Reserved_3	0x25
;#define RFCfgReg			0x26
;#define GsNReg				0x27
;#define CWGsPReg			0x28
;#define ModGsPReg			0x29
;#define TModeReg			0x2A
;#define TPrescalerReg		0x2B
;#define TReloadReg_1		0x2C
;#define TReloadReg_2		0x2D
;#define TCounterValReg_1	0x2E
;#define TCounterValReg_2 	0x2F
;
;//Page 3 ==> TestRegister
;#define Page3_Reserved_1 	0x30
;#define TestSel1Reg			0x31
;#define TestSel2Reg			0x32
;#define TestPinEnReg		0x33
;#define TestPinValueReg		0x34
;#define TestBusReg			0x35
;#define AutoTestReg			0x36
;#define VersionReg			0x37
;#define AnalogTestReg		0x38
;#define TestDAC1Reg			0x39
;#define TestDAC2Reg			0x3A
;#define TestADCReg			0x3B
;#define Page3_Reserved_2 	0x3C
;#define Page3_Reserved_3	0x3D
;#define Page3_Reserved_4	0x3E
;#define Page3_Reserved_5	0x3F
;
;#endif
;
;//end of registers
;
;//commands
;
;#ifndef MFRC522_CMD_H
;#define MFRC522_CMD_H
;
;//command set
;#define Idle_CMD 				0x00
;#define Mem_CMD					0x01
;#define GenerateRandomId_CMD	0x02
;#define CalcCRC_CMD				0x03
;#define Transmit_CMD			0x04
;#define NoCmdChange_CMD			0x07
;#define Receive_CMD				0x08
;#define Transceive_CMD			0x0C
;#define Reserved_CMD			0x0D
;#define MFAuthent_CMD			0x0E
;#define SoftReset_CMD			0x0F
;
;#endif
;
;
;//end of commands
;
;void mf_write(unsigned char addr,unsigned char data)
; 0000 00A5 {
_mf_write:
; .FSTART _mf_write
; 0000 00A6 
; 0000 00A7     PORTB.0=0;
	ST   -Y,R26
;	addr -> Y+1
;	data -> Y+0
	CBI  0x18,0
; 0000 00A8     SPI_PUT((addr<<1)&0x7E);
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	MOV  R26,R30
	RCALL _SPI_PUT
; 0000 00A9     SPI_PUT(data);
	LD   R26,Y
	RCALL _SPI_PUT
; 0000 00AA     PORTB.0=1;
	SBI  0x18,0
; 0000 00AB 
; 0000 00AC 
; 0000 00AD }
	JMP  _0x20A0007
; .FEND
;unsigned char mf_read(unsigned char addr)
; 0000 00AF {
_mf_read:
; .FSTART _mf_read
; 0000 00B0     unsigned char data;
; 0000 00B1     PORTB.0=0;
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	data -> R17
	CBI  0x18,0
; 0000 00B2     SPI_PUT(((addr<<1)&0x7E) | 0x80);
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _SPI_PUT
; 0000 00B3     data=SPI_PUT(0x00);
	LDI  R26,LOW(0)
	RCALL _SPI_PUT
	MOV  R17,R30
; 0000 00B4     PORTB.0=1;
	SBI  0x18,0
; 0000 00B5     return data;
	LDD  R17,Y+0
	JMP  _0x20A0007
; 0000 00B6 }
; .FEND
;void mf_reset()
; 0000 00B8 {
_mf_reset:
; .FSTART _mf_reset
; 0000 00B9     mf_write(CommandReg,SoftReset_CMD);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _mf_write
; 0000 00BA }
	RET
; .FEND
;
;void mf_init()
; 0000 00BD {
_mf_init:
; .FSTART _mf_init
; 0000 00BE     unsigned char cont_reg;
; 0000 00BF     mf_reset();
	ST   -Y,R17
;	cont_reg -> R17
	RCALL _mf_reset
; 0000 00C0     mf_write(TModeReg, 0x8D);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(141)
	RCALL _mf_write
; 0000 00C1     mf_write(TPrescalerReg, 0x3E);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _mf_write
; 0000 00C2     mf_write(TReloadReg_1, 30);
	LDI  R30,LOW(44)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _mf_write
; 0000 00C3     mf_write(TReloadReg_2, 0);
	LDI  R30,LOW(45)
	CALL SUBOPT_0x0
; 0000 00C4 	mf_write(TxASKReg, 0x40);
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _mf_write
; 0000 00C5 	mf_write(ModeReg, 0x3D);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _mf_write
; 0000 00C6     cont_reg=mf_read(TxControlReg); //read TxControlReg
	LDI  R26,LOW(20)
	RCALL _mf_read
	MOV  R17,R30
; 0000 00C7 
; 0000 00C8     if(!(cont_reg&0x03))
	ANDI R30,LOW(0x3)
	BRNE _0xE
; 0000 00C9         mf_write(TxControlReg,cont_reg|0x03);
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOV  R30,R17
	ORI  R30,LOW(0x3)
	MOV  R26,R30
	RCALL _mf_write
; 0000 00CA }
_0xE:
	LD   R17,Y+
	RET
; .FEND
;//end of MFRC522
;
;unsigned char mf_to_card(unsigned char cmd, unsigned char *send_data, unsigned char send_data_len, unsigned char *back_d ...
; 0000 00CE {
_mf_to_card:
; .FSTART _mf_to_card
; 0000 00CF     unsigned char status = ERROR;
; 0000 00D0     unsigned char irqEn = 0x00;
; 0000 00D1     unsigned char waitIRq = 0x00;
; 0000 00D2     unsigned char lastBits;
; 0000 00D3     unsigned char n;
; 0000 00D4     unsigned char tmp;
; 0000 00D5     long int i;
; 0000 00D6 
; 0000 00D7     switch (cmd)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
;	cmd -> Y+17
;	*send_data -> Y+15
;	send_data_len -> Y+14
;	*back_data -> Y+12
;	*back_data_len -> Y+10
;	status -> R17
;	irqEn -> R16
;	waitIRq -> R19
;	lastBits -> R18
;	n -> R21
;	tmp -> R20
;	i -> Y+6
	LDI  R17,3
	LDI  R16,0
	LDI  R19,0
	LDD  R30,Y+17
	LDI  R31,0
; 0000 00D8     {
; 0000 00D9         case MFAuthent_CMD:		//Certification cards close
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x12
; 0000 00DA 		{
; 0000 00DB 			irqEn = 0x12;
	LDI  R16,LOW(18)
; 0000 00DC 			waitIRq = 0x10;
	LDI  R19,LOW(16)
; 0000 00DD 			break;
	RJMP _0x11
; 0000 00DE 		}
; 0000 00DF 		case Transceive_CMD:	//Transmit FIFO data
_0x12:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x14
; 0000 00E0 		{
; 0000 00E1 			irqEn = 0x77;
	LDI  R16,LOW(119)
; 0000 00E2 			waitIRq = 0x30;
	LDI  R19,LOW(48)
; 0000 00E3 			break;
; 0000 00E4 		}
; 0000 00E5 		default:
_0x14:
; 0000 00E6 			break;
; 0000 00E7     }
_0x11:
; 0000 00E8 
; 0000 00E9     //mf_write(ComIEnReg, irqEn|0x80);	//Interrupt request
; 0000 00EA     n=mf_read(ComIrqReg);
	LDI  R26,LOW(4)
	RCALL _mf_read
	MOV  R21,R30
; 0000 00EB     mf_write(ComIrqReg,n&(~0x80));//clear all interrupt bits
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOV  R30,R21
	ANDI R30,0x7F
	MOV  R26,R30
	RCALL _mf_write
; 0000 00EC     n=mf_read(FIFOLevelReg);
	LDI  R26,LOW(10)
	RCALL _mf_read
	MOV  R21,R30
; 0000 00ED     mf_write(FIFOLevelReg,n|0x80);//flush FIFO data
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1
; 0000 00EE 
; 0000 00EF 	mf_write(CommandReg, Idle_CMD);	//NO action; Cancel the current cmd???
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
; 0000 00F0 
; 0000 00F1     for (i=0; i<send_data_len; i++)
	LDI  R30,LOW(0)
	__CLRD1S 6
_0x16:
	LDD  R30,Y+14
	CALL SUBOPT_0x2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRGE _0x17
; 0000 00F2     {
; 0000 00F3 		mf_write(FIFODataReg, send_data[i]);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _mf_write
; 0000 00F4 	}
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	RJMP _0x16
_0x17:
; 0000 00F5 
; 0000 00F6     mf_write(CommandReg, cmd);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+18
	RCALL _mf_write
; 0000 00F7     if (cmd == Transceive_CMD)
	LDD  R26,Y+17
	CPI  R26,LOW(0xC)
	BRNE _0x18
; 0000 00F8     {
; 0000 00F9 		n=mf_read(BitFramingReg);
	LDI  R26,LOW(13)
	RCALL _mf_read
	MOV  R21,R30
; 0000 00FA 		mf_write(BitFramingReg,n|0x80);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 00FB 	}
; 0000 00FC     	i = 100000;	//i according to the clock frequency adjustment, the operator M1 card maximum waiting time 25ms???
_0x18:
	__GETD1N 0x186A0
	__PUTD1S 6
; 0000 00FD     do
_0x1A:
; 0000 00FE     {
; 0000 00FF 		//CommIrqReg[7..0]
; 0000 0100 		//Set1 TxIRq RxIRq IdleIRq HiAlerIRq LoAlertIRq ErrIRq TimerIRq
; 0000 0101         n = mf_read(ComIrqReg);
	LDI  R26,LOW(4)
	RCALL _mf_read
	MOV  R21,R30
; 0000 0102         i--;
	CALL SUBOPT_0x3
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 6
; 0000 0103     }
; 0000 0104     while ((i!=0) && !(n&0x01) && !(n&waitIRq));
	CALL SUBOPT_0x2
	CALL __CPD02
	BREQ _0x1C
	SBRC R21,0
	RJMP _0x1C
	MOV  R30,R19
	AND  R30,R21
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
	RJMP _0x1A
_0x1B:
; 0000 0105 
; 0000 0106 	tmp=mf_read(BitFramingReg);
	LDI  R26,LOW(13)
	RCALL _mf_read
	MOV  R20,R30
; 0000 0107 	mf_write(BitFramingReg,tmp&(~0x80));
	LDI  R30,LOW(13)
	ST   -Y,R30
	MOV  R30,R20
	ANDI R30,0x7F
	MOV  R26,R30
	RCALL _mf_write
; 0000 0108 
; 0000 0109     if (i != 0)
	CALL SUBOPT_0x3
	CALL __CPD10
	BRNE PC+2
	RJMP _0x1E
; 0000 010A     {
; 0000 010B         if(!(mf_read(ErrorReg) & 0x1B))	//BufferOvfl Collerr CRCErr ProtecolErr
	LDI  R26,LOW(6)
	RCALL _mf_read
	ANDI R30,LOW(0x1B)
	BREQ PC+2
	RJMP _0x1F
; 0000 010C         {
; 0000 010D             status = CARD_FOUND;
	LDI  R17,LOW(1)
; 0000 010E             if (n & irqEn & 0x01)
	MOV  R30,R16
	AND  R30,R21
	ANDI R30,LOW(0x1)
	BREQ _0x20
; 0000 010F             {
; 0000 0110 				status = CARD_NOT_FOUND;			//??
	LDI  R17,LOW(2)
; 0000 0111 			}
; 0000 0112 
; 0000 0113             if (cmd == Transceive_CMD)
_0x20:
	LDD  R26,Y+17
	CPI  R26,LOW(0xC)
	BREQ PC+2
	RJMP _0x21
; 0000 0114             {
; 0000 0115                	n = mf_read(FIFOLevelReg);
	LDI  R26,LOW(10)
	RCALL _mf_read
	MOV  R21,R30
; 0000 0116               	lastBits = mf_read(ControlReg) & 0x07;
	LDI  R26,LOW(12)
	RCALL _mf_read
	ANDI R30,LOW(0x7)
	MOV  R18,R30
; 0000 0117                 if (lastBits)
	CPI  R18,0
	BREQ _0x22
; 0000 0118                 {
; 0000 0119 					*back_data_len = (n-1)*8 + lastBits;
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x4C
; 0000 011A 				}
; 0000 011B                 else
_0x22:
; 0000 011C                 {
; 0000 011D 					*back_data_len = n*8;
	LDI  R30,LOW(8)
	MUL  R30,R21
	MOVW R30,R0
_0x4C:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __CWD1
	CALL __PUTDP1
; 0000 011E 				}
; 0000 011F 
; 0000 0120                 if (n == 0)
	CPI  R21,0
	BRNE _0x24
; 0000 0121                 {
; 0000 0122 					n = 1;
	LDI  R21,LOW(1)
; 0000 0123 				}
; 0000 0124                 if (n > MAX_LEN)
_0x24:
	CPI  R21,17
	BRLO _0x25
; 0000 0125                 {
; 0000 0126 					n = MAX_LEN;
	LDI  R21,LOW(16)
; 0000 0127 				}
; 0000 0128 
; 0000 0129 				//Reading the received data in FIFO
; 0000 012A                 for (i=0; i<n; i++)
_0x25:
	LDI  R30,LOW(0)
	__CLRD1S 6
_0x27:
	MOV  R30,R21
	CALL SUBOPT_0x2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRGE _0x28
; 0000 012B                 {
; 0000 012C 					back_data[i] = mf_read(FIFODataReg);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(9)
	RCALL _mf_read
	POP  R26
	POP  R27
	ST   X,R30
; 0000 012D 				}
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	RJMP _0x27
_0x28:
; 0000 012E             }
; 0000 012F         }
_0x21:
; 0000 0130         else
	RJMP _0x29
_0x1F:
; 0000 0131         {
; 0000 0132 			status = ERROR;
	LDI  R17,LOW(3)
; 0000 0133 		}
_0x29:
; 0000 0134 
; 0000 0135     }
; 0000 0136 
; 0000 0137     //SetBitMask(ControlReg,0x80);           //timer stops
; 0000 0138     //mf_write(cmdReg, PCD_IDLE);
; 0000 0139 
; 0000 013A     return status;
_0x1E:
	MOV  R30,R17
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; 0000 013B 
; 0000 013C }
; .FEND
;unsigned char mf_request(unsigned char req,unsigned char *tag_type)
; 0000 013E {
_mf_request:
; .FSTART _mf_request
; 0000 013F     unsigned char status;
; 0000 0140     long int backBits;
; 0000 0141     mf_write(BitFramingReg, 0x07);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	req -> Y+7
;	*tag_type -> Y+5
;	status -> R17
;	backBits -> Y+1
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _mf_write
; 0000 0142     tag_type[0]=req;
	LDD  R30,Y+7
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ST   X,R30
; 0000 0143     status = mf_to_card(Transceive_CMD, tag_type, 1, tag_type, &backBits);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _mf_to_card
	MOV  R17,R30
; 0000 0144     if ((status != CARD_FOUND) || (backBits != 0x10))
	CPI  R17,1
	BRNE _0x2B
	__GETD2S 1
	__CPD2N 0x10
	BREQ _0x2A
_0x2B:
; 0000 0145 	{
; 0000 0146 		status = ERROR;
	LDI  R17,LOW(3)
; 0000 0147 	}
; 0000 0148 	return status;
_0x2A:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,8
	RET
; 0000 0149 }
; .FEND
;
;unsigned char mf_get_card_serial(unsigned char * serial_out)
; 0000 014C {
_mf_get_card_serial:
; .FSTART _mf_get_card_serial
; 0000 014D 	unsigned char status;
; 0000 014E     unsigned char i;
; 0000 014F 	unsigned char serNumCheck=0;
; 0000 0150     long int unLen;
; 0000 0151 
; 0000 0152 	mf_write(BitFramingReg, 0x00);		//TxLastBists = BitFramingReg[2..0]
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
;	*serial_out -> Y+8
;	status -> R17
;	i -> R16
;	serNumCheck -> R19
;	unLen -> Y+4
	LDI  R19,0
	LDI  R30,LOW(13)
	CALL SUBOPT_0x0
; 0000 0153 
; 0000 0154     serial_out[0] = PICC_ANTICOLL;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(147)
	ST   X,R30
; 0000 0155     serial_out[1] = 0x20;
	ADIW R26,1
	LDI  R30,LOW(32)
	ST   X,R30
; 0000 0156     status = mf_to_card(Transceive_CMD, serial_out, 2, serial_out, &unLen);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL _mf_to_card
	MOV  R17,R30
; 0000 0157     if (status == CARD_FOUND)
	CPI  R17,1
	BRNE _0x2D
; 0000 0158 	{
; 0000 0159 		//Check card serial number
; 0000 015A 		for (i=0; i<4; i++)
	LDI  R16,LOW(0)
_0x2F:
	CPI  R16,4
	BRSH _0x30
; 0000 015B 		{
; 0000 015C 		 	serNumCheck ^= serial_out[i];
	CALL SUBOPT_0x5
	EOR  R19,R30
; 0000 015D 		}
	SUBI R16,-1
	RJMP _0x2F
_0x30:
; 0000 015E 		if (serNumCheck != serial_out[i])
	CALL SUBOPT_0x5
	CP   R30,R19
	BREQ _0x31
; 0000 015F 		{
; 0000 0160 			status = ERROR;
	LDI  R17,LOW(3)
; 0000 0161 		}
; 0000 0162     }
_0x31:
; 0000 0163 
; 0000 0164 
; 0000 0165     return status;
_0x2D:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; 0000 0166 }
; .FEND
;
;char *trim(char *s)
; 0000 0169 {
_trim:
; .FSTART _trim
; 0000 016A     unsigned char i=0;
; 0000 016B     unsigned char j=0;
; 0000 016C     char str[50];
; 0000 016D     for(i=0;s[i];i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,50
	ST   -Y,R17
	ST   -Y,R16
;	*s -> Y+52
;	i -> R17
;	j -> R16
;	str -> Y+2
	LDI  R17,0
	LDI  R16,0
	LDI  R17,LOW(0)
_0x33:
	CALL SUBOPT_0x6
	LD   R30,X
	CPI  R30,0
	BREQ _0x34
; 0000 016E         if(s[i]!='\r' || s[i]!='\n')
	CALL SUBOPT_0x6
	LD   R26,X
	CPI  R26,LOW(0xD)
	BRNE _0x36
	CALL SUBOPT_0x6
	LD   R26,X
	CPI  R26,LOW(0xA)
	BREQ _0x35
_0x36:
; 0000 016F             str[j++]=s[i];
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x6
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0170     s[j]=0;
_0x35:
	SUBI R17,-1
	RJMP _0x33
_0x34:
	LDD  R26,Y+52
	LDD  R27,Y+52+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	ST   X,R30
; 0000 0171     return str;
	MOVW R30,R28
	ADIW R30,2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,54
	RET
; 0000 0172 }
; .FEND
;
;
;
;void sim900_HTTP_init()
; 0000 0177 {
_sim900_HTTP_init:
; .FSTART _sim900_HTTP_init
; 0000 0178     printf("AT+SAPBR=3,1,\"Contype\",\"GPRS\"\r\n");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x7
; 0000 0179     scanf("%s%s",at_req,at_res);
; 0000 017A     lcd_clear();
; 0000 017B     lcd_puts(at_req);
; 0000 017C     lcd_puts(trim(at_res));
; 0000 017D 
; 0000 017E 
; 0000 017F 
; 0000 0180 
; 0000 0181     printf("AT+SAPBR=3,1,\"APN\",\"internet\"\r\n");
	__POINTW1FN _0x0,37
	CALL SUBOPT_0x7
; 0000 0182     scanf("%s%s",at_req,at_res);
; 0000 0183     lcd_clear();
; 0000 0184     lcd_puts(at_req);
; 0000 0185     lcd_puts(trim(at_res));
; 0000 0186 
; 0000 0187 
; 0000 0188 
; 0000 0189 
; 0000 018A     printf("AT+SAPBR=1,1\r\n");
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x7
; 0000 018B     scanf("%s%s",at_req,at_res);
; 0000 018C     lcd_clear();
; 0000 018D     lcd_puts(at_req);
; 0000 018E     lcd_puts(trim(at_res));
; 0000 018F 
; 0000 0190 
; 0000 0191 
; 0000 0192 
; 0000 0193     printf("AT+SAPBR=2,1\r\n");
	__POINTW1FN _0x0,84
	CALL SUBOPT_0x8
; 0000 0194     scanf("%s%s",at_req,at_res);
; 0000 0195     scanf("%s",at_res);
; 0000 0196     lcd_clear();
; 0000 0197     lcd_puts(at_req);
; 0000 0198     lcd_puts(trim(at_res));
; 0000 0199 
; 0000 019A 
; 0000 019B 
; 0000 019C 
; 0000 019D      printf("AT+HTTPINIT\r\n");
	__POINTW1FN _0x0,99
	CALL SUBOPT_0x7
; 0000 019E     scanf("%s%s",at_req,at_res);
; 0000 019F     lcd_clear();
; 0000 01A0     lcd_puts(at_req);
; 0000 01A1     lcd_puts(trim(at_res));
; 0000 01A2 
; 0000 01A3 
; 0000 01A4 
; 0000 01A5 
; 0000 01A6      printf("AT+HTTPPARA=\"CID\",1\r\n");
	__POINTW1FN _0x0,113
	CALL SUBOPT_0x7
; 0000 01A7     scanf("%s%s",at_req,at_res);
; 0000 01A8     lcd_clear();
; 0000 01A9     lcd_puts(at_req);
; 0000 01AA     lcd_puts(trim(at_res));
; 0000 01AB 
; 0000 01AC 
; 0000 01AD 
; 0000 01AE }
	RET
; .FEND
;void send_HTTP_request(unsigned char *data)
; 0000 01B0 {
_send_HTTP_request:
; .FSTART _send_HTTP_request
; 0000 01B1     printf("AT+HTTPPARA=\"URL\",\"http://2048game.tk/card_data.php?id=%s\"\r\n",data);
	ST   -Y,R27
	ST   -Y,R26
;	*data -> Y+0
	__POINTW1FN _0x0,135
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x9
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 01B2     scanf("%s%s",at_req,at_res);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	LDI  R24,8
	CALL _scanf
	ADIW R28,10
; 0000 01B3     lcd_clear();
	CALL _lcd_clear
; 0000 01B4     lcd_puts(at_req);
	LDI  R26,LOW(_at_req)
	LDI  R27,HIGH(_at_req)
	CALL _lcd_puts
; 0000 01B5     lcd_puts(trim(at_res));
	LDI  R26,LOW(_at_res)
	LDI  R27,HIGH(_at_res)
	RCALL _trim
	MOVW R26,R30
	CALL _lcd_puts
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 
; 0000 01B9     printf("AT+HTTPACTION=0\r\n");
	__POINTW1FN _0x0,196
	CALL SUBOPT_0x8
; 0000 01BA     scanf("%s%s",at_req,at_res);
; 0000 01BB     scanf("%s",at_res);
; 0000 01BC     lcd_clear();
; 0000 01BD     lcd_puts(at_req);
; 0000 01BE     lcd_puts(trim(at_res));
; 0000 01BF 
; 0000 01C0 
; 0000 01C1 
; 0000 01C2 
; 0000 01C3     printf("AT+HTTPREAD\r\n");
	__POINTW1FN _0x0,214
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01C4 }
	JMP  _0x20A0007
; .FEND
;void sim900_sms_init()
; 0000 01C6 {
; 0000 01C7 //   printf("ATE1\r\n");
; 0000 01C8 //    scanf("%s%s",at_req,at_res);
; 0000 01C9 //    lcd_clear();
; 0000 01CA //    lcd_puts(at_req);
; 0000 01CB //    lcd_puts(trim(at_res));
; 0000 01CC //
; 0000 01CD //
; 0000 01CE //
; 0000 01CF //    printf("AT+CMGF=1\r\n");
; 0000 01D0 //    scanf("%s%s",at_req,at_res);
; 0000 01D1 //    lcd_clear();
; 0000 01D2 //    lcd_puts(at_req);
; 0000 01D3 //    lcd_puts(trim(at_res));
; 0000 01D4 //
; 0000 01D5 //
; 0000 01D6 //
; 0000 01D7 //    printf("AT+CSCS=\"GSM\"\r\n");
; 0000 01D8 //    scanf("%s%s",at_req,at_res);
; 0000 01D9 //    lcd_clear();
; 0000 01DA //    lcd_puts(at_req);
; 0000 01DB //    lcd_puts(trim(at_res));
; 0000 01DC }
;void sim900_client_init()
; 0000 01DE {
; 0000 01DF    /*
; 0000 01E0     //just for GPRS turn it off for sms or calling
; 0000 01E1     printf("ATE1\r\n");
; 0000 01E2     scanf("%s%s",at_req,at_res);
; 0000 01E3     lcd_clear();
; 0000 01E4     lcd_puts(at_req);
; 0000 01E5     lcd_puts(trim(at_res));
; 0000 01E6 
; 0000 01E7 
; 0000 01E8 
; 0000 01E9     printf("AT+CMGF=1\r\n");
; 0000 01EA     scanf("%s%s",at_req,at_res);
; 0000 01EB     lcd_clear();
; 0000 01EC     lcd_puts(at_req);
; 0000 01ED     lcd_puts(trim(at_res));
; 0000 01EE 
; 0000 01EF 
; 0000 01F0 
; 0000 01F1     printf("AT+CSCS=\"GSM\"\r\n");
; 0000 01F2     scanf("%s%s",at_req,at_res);
; 0000 01F3     lcd_clear();
; 0000 01F4     lcd_puts(at_req);
; 0000 01F5     lcd_puts(trim(at_res));
; 0000 01F6 
; 0000 01F7 
; 0000 01F8     // for server client mode
; 0000 01F9 
; 0000 01FA 
; 0000 01FB     printf("AT+CGATT=1\r\n");
; 0000 01FC     scanf("%s%s",at_req,at_res);
; 0000 01FD     lcd_clear();
; 0000 01FE     lcd_puts(at_req);
; 0000 01FF     lcd_puts(trim(at_res));
; 0000 0200 
; 0000 0201 
; 0000 0202 
; 0000 0203     printf("AT+CIPMUX=0\r\n");
; 0000 0204     scanf("%s%s",at_req,at_res);
; 0000 0205     lcd_clear();
; 0000 0206     lcd_puts(at_req);
; 0000 0207     lcd_puts(trim(at_res));
; 0000 0208 
; 0000 0209 
; 0000 020A 
; 0000 020B 
; 0000 020C     printf("AT+CIPMODE=0\r\n");
; 0000 020D     scanf("%s%s",at_req,at_res);
; 0000 020E     lcd_clear();
; 0000 020F     lcd_puts(at_req);
; 0000 0210     lcd_puts(trim(at_res));
; 0000 0211 
; 0000 0212 
; 0000 0213 
; 0000 0214 
; 0000 0215     printf("AT+CIPCSGP=1,\"internet\"\r\n");
; 0000 0216     scanf("%s%s",at_req,at_res);
; 0000 0217     lcd_clear();
; 0000 0218     lcd_puts(at_req);
; 0000 0219     lcd_puts(trim(at_res));
; 0000 021A 
; 0000 021B 
; 0000 021C 
; 0000 021D 
; 0000 021E     printf("AT+CLPORT=\"TCP\",\"2020\"\r\n");
; 0000 021F     scanf("%s%s",at_req,at_res);
; 0000 0220     lcd_clear();
; 0000 0221     lcd_puts(at_req);
; 0000 0222     lcd_puts(trim(at_res));
; 0000 0223 
; 0000 0224 
; 0000 0225 
; 0000 0226 
; 0000 0227     printf("AT+CSTT=\"internet\",\"\",\"\"\r\n");
; 0000 0228     scanf("%s%s",at_req,at_res);
; 0000 0229     lcd_clear();
; 0000 022A     lcd_puts(at_req);
; 0000 022B     lcd_puts(trim(at_res));
; 0000 022C 
; 0000 022D 
; 0000 022E 
; 0000 022F 
; 0000 0230     printf("AT+CIPSRIP=1\r\n");
; 0000 0231     scanf("%s%s",at_req,at_res);
; 0000 0232     lcd_clear();
; 0000 0233     lcd_puts(at_req);
; 0000 0234     lcd_puts(trim(at_res));
; 0000 0235 
; 0000 0236 
; 0000 0237 
; 0000 0238 
; 0000 0239     printf("AT+CIICR\r\n");
; 0000 023A     scanf("%s%s",at_req,at_res);
; 0000 023B     lcd_clear();
; 0000 023C     lcd_puts(at_req);
; 0000 023D     lcd_puts(trim(at_res));
; 0000 023E 
; 0000 023F 
; 0000 0240 
; 0000 0241 
; 0000 0242     printf("AT+CIFSR\r\n");
; 0000 0243     scanf("%s%s",at_req,at_res);
; 0000 0244     lcd_clear();
; 0000 0245     lcd_puts(at_req);
; 0000 0246     lcd_puts(trim(at_res));
; 0000 0247 
; 0000 0248 
; 0000 0249 
; 0000 024A 
; 0000 024B     printf("AT+CIPSTART=\"TCP\",\"5.120.12.86\",\"7074\"\r\n");
; 0000 024C     scanf("%s%s",at_req,at_res);
; 0000 024D     lcd_clear();
; 0000 024E     lcd_puts(at_req);
; 0000 024F     lcd_puts(trim(at_res));
; 0000 0250 
; 0000 0251 
; 0000 0252     scanf("%s",at_res);
; 0000 0253 
; 0000 0254     lcd_clear();
; 0000 0255     lcd_puts(at_req);
; 0000 0256     lcd_puts(trim(at_res));
; 0000 0257 
; 0000 0258 
; 0000 0259 
; 0000 025A 
; 0000 025B 
; 0000 025C     printf("AT+CIPSTATUS\r\n");
; 0000 025D     scanf("%s%s",at_req,at_res);
; 0000 025E     lcd_clear();
; 0000 025F     lcd_puts(at_req);
; 0000 0260     lcd_puts(trim(at_res));
; 0000 0261 
; 0000 0262 
; 0000 0263 
; 0000 0264 
; 0000 0265     printf("AT+CIPSEND\r\n");
; 0000 0266     printf("amin");
; 0000 0267     printf("%c",26);
; 0000 0268     scanf("%s%s",at_req,at_res);
; 0000 0269     scanf("%s",at_res);
; 0000 026A     lcd_clear();
; 0000 026B     lcd_puts(at_req);
; 0000 026C     lcd_puts(trim(at_res));
; 0000 026D 
; 0000 026E 
; 0000 026F 
; 0000 0270 
; 0000 0271     printf("AT+CIPSHUT\r\n");
; 0000 0272     scanf("%s%s",at_req,at_res);
; 0000 0273     lcd_clear();
; 0000 0274     lcd_puts(at_req);
; 0000 0275     lcd_puts(trim(at_res));
; 0000 0276 
; 0000 0277 
; 0000 0278 
; 0000 0279  */
; 0000 027A  }
;void sim900_call()
; 0000 027C {
; 0000 027D //    printf("ATD09394103465;\r\n");
; 0000 027E //    scanf("%s%s",at_req,at_res);
; 0000 027F //    lcd_clear();
; 0000 0280 //    lcd_puts(at_req);
; 0000 0281 //    lcd_puts(trim(at_res));
; 0000 0282 }
;void sim900_send_sms(unsigned char *data)
; 0000 0284 {
; 0000 0285         //sim900
; 0000 0286 //        printf("AT+CMGS=\"+989394103465\"\r\n");
; 0000 0287 //        scanf("%s%s",at_req,at_res);
; 0000 0288 //        printf("%s",data);
; 0000 0289 //        printf("%c",26);
; 0000 028A //        scanf("%s%s",at_req,at_res);
; 0000 028B //        lcd_clear();
; 0000 028C //        lcd_puts(at_req);
; 0000 028D //        lcd_puts(trim(at_res));
; 0000 028E         //end of sim900
; 0000 028F }
;void main(void)
; 0000 0291 {
_main:
; .FSTART _main
; 0000 0292 // Declare your local variables here
; 0000 0293 unsigned char readed_data;
; 0000 0294 unsigned char str[MAX_LEN];
; 0000 0295 unsigned char i=0;
; 0000 0296 unsigned char lcd_hex_data[6];
; 0000 0297 
; 0000 0298 
; 0000 0299 // Input/Output Ports initialization
; 0000 029A // Port A initialization
; 0000 029B // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 029C DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	SBIW R28,22
;	readed_data -> R17
;	str -> Y+6
;	i -> R16
;	lcd_hex_data -> Y+0
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 029D // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 029E PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 029F 
; 0000 02A0 // Port B initialization
; 0000 02A1 // Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 02A2 DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(191)
	OUT  0x17,R30
; 0000 02A3 // State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 02A4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02A5 
; 0000 02A6 // Port C initialization
; 0000 02A7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02A8 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 02A9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02AA PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 02AB 
; 0000 02AC // Port D initialization
; 0000 02AD // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 02AE DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 02AF // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 02B0 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 02B1 
; 0000 02B2 // USART initialization
; 0000 02B3 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02B4 // USART Receiver: On
; 0000 02B5 // USART Transmitter: On
; 0000 02B6 // USART Mode: Asynchronous
; 0000 02B7 // USART Baud Rate: 9600
; 0000 02B8 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 02B9 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 02BA UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02BB UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02BC UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 02BD 
; 0000 02BE // SPI initialization
; 0000 02BF // SPI Type: Master
; 0000 02C0 // SPI Clock Rate: 2000.000 kHz
; 0000 02C1 // SPI Clock Phase: Cycle Start
; 0000 02C2 // SPI Clock Polarity: Low
; 0000 02C3 // SPI Data Order: MSB First
; 0000 02C4 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 02C5 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 02C6 
; 0000 02C7 // Clear the SPI interrupt flag
; 0000 02C8 #asm
; 0000 02C9     in   r30,spsr
    in   r30,spsr
; 0000 02CA     in   r30,spdr
    in   r30,spdr
; 0000 02CB #endasm
; 0000 02CC 
; 0000 02CD // Alphanumeric LCD initialization
; 0000 02CE // Connections are specified in the
; 0000 02CF // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 02D0 // RS - PORTA Bit 0
; 0000 02D1 // RD - PORTA Bit 1
; 0000 02D2 // EN - PORTA Bit 2
; 0000 02D3 // D4 - PORTA Bit 4
; 0000 02D4 // D5 - PORTA Bit 5
; 0000 02D5 // D6 - PORTA Bit 6
; 0000 02D6 // D7 - PORTA Bit 7
; 0000 02D7 // Characters/line: 16
; 0000 02D8 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 02D9 PORTB.0=1;
	SBI  0x18,0
; 0000 02DA //lcd_putsf("aminbw");
; 0000 02DB 
; 0000 02DC 
; 0000 02DD // Global enable interrupts
; 0000 02DE #asm("sei")
	sei
; 0000 02DF     //initialize mf
; 0000 02E0     mf_init();
	RCALL _mf_init
; 0000 02E1     //check ver
; 0000 02E2     readed_data = mf_read(VersionReg);
	LDI  R26,LOW(55)
	RCALL _mf_read
	MOV  R17,R30
; 0000 02E3 	if(readed_data == 0x92)
	CPI  R17,146
	BRNE _0x3A
; 0000 02E4 	{
; 0000 02E5 		lcd_putsf("MIFARE RC522v2");
	__POINTW2FN _0x0,228
	RCALL _lcd_putsf
; 0000 02E6 		lcd_putsf("Detected");
	__POINTW2FN _0x0,243
	RJMP _0x4D
; 0000 02E7 	}else if(readed_data == 0x91 || readed_data==0x90)
_0x3A:
	CPI  R17,145
	BREQ _0x3D
	CPI  R17,144
	BRNE _0x3C
_0x3D:
; 0000 02E8 	{
; 0000 02E9 		lcd_putsf("MIFARE RC522v1");
	__POINTW2FN _0x0,252
	RCALL _lcd_putsf
; 0000 02EA 		lcd_putsf("Detected");
	__POINTW2FN _0x0,243
	RJMP _0x4D
; 0000 02EB 	}else
_0x3C:
; 0000 02EC 	{
; 0000 02ED 		lcd_putsf("No reader found");
	__POINTW2FN _0x0,267
_0x4D:
	RCALL _lcd_putsf
; 0000 02EE 	}
; 0000 02EF     //end of check ver
; 0000 02F0 //read card enable
; 0000 02F1     readed_data = mf_read(ComIEnReg);
	LDI  R26,LOW(2)
	RCALL _mf_read
	MOV  R17,R30
; 0000 02F2 	mf_write(ComIEnReg,readed_data|0x20);
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R30,R17
	ORI  R30,0x20
	MOV  R26,R30
	RCALL _mf_write
; 0000 02F3 	readed_data = mf_read(DivIEnReg);
	LDI  R26,LOW(3)
	RCALL _mf_read
	MOV  R17,R30
; 0000 02F4 	mf_write(DivIEnReg,readed_data|0x80);
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOV  R30,R17
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _mf_write
; 0000 02F5 
; 0000 02F6 
; 0000 02F7 
; 0000 02F8 
; 0000 02F9     sim900_HTTP_init();
	RCALL _sim900_HTTP_init
; 0000 02FA 
; 0000 02FB 
; 0000 02FC 
; 0000 02FD 
; 0000 02FE 
; 0000 02FF //end of read card enable
; 0000 0300 while (1)
_0x40:
; 0000 0301       {
; 0000 0302 
; 0000 0303       // Place your code here
; 0000 0304       for(i=0;i<MAX_LEN;i++)
	LDI  R16,LOW(0)
_0x44:
	CPI  R16,16
	BRSH _0x45
; 0000 0305         str[i]=0;
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R16,-1
	RJMP _0x44
_0x45:
; 0000 0306 readed_data=mf_request(0x52               ,str);
	LDI  R30,LOW(82)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _mf_request
	MOV  R17,R30
; 0000 0307         if(readed_data==CARD_FOUND)
	CPI  R17,1
	BREQ PC+2
	RJMP _0x46
; 0000 0308         {
; 0000 0309         readed_data=mf_get_card_serial(str);
	MOVW R26,R28
	ADIW R26,6
	RCALL _mf_get_card_serial
	MOV  R17,R30
; 0000 030A         sprintf(lcd_data,"%X%X%X%X%X%X%X%X%d",str[0],str[1],str[2],str[3],str[4],str[5],str[6],str[7],readed_data);
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,283
	CALL SUBOPT_0xC
; 0000 030B     send_HTTP_request(lcd_data);
	LDI  R26,LOW(_lcd_data)
	LDI  R27,HIGH(_lcd_data)
	RCALL _send_HTTP_request
; 0000 030C     scanf("%s%s",at_req,at_res);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	LDI  R24,8
	CALL _scanf
	ADIW R28,10
; 0000 030D     scanf("%s",at_res);
	CALL SUBOPT_0xD
	LDI  R24,4
	CALL _scanf
	ADIW R28,6
; 0000 030E     if(strstr(at_res,"GRANTED")!=NULL)
	CALL SUBOPT_0xE
	__POINTW2MN _0x48,0
	CALL _strstr
	SBIW R30,0
	BREQ _0x47
; 0000 030F     {
; 0000 0310         PORTC=1<<7;
	LDI  R30,LOW(128)
	OUT  0x15,R30
; 0000 0311         scanf("%s",at_res);
	CALL SUBOPT_0xD
	LDI  R24,4
	CALL _scanf
	ADIW R28,6
; 0000 0312 
; 0000 0313     }
; 0000 0314     else if(strstr(at_res,"DENAID")!=NULL)
	RJMP _0x49
_0x47:
	CALL SUBOPT_0xE
	__POINTW2MN _0x48,8
	CALL _strstr
	SBIW R30,0
	BREQ _0x4A
; 0000 0315     {
; 0000 0316         PORTC=1<<6;
	LDI  R30,LOW(64)
	OUT  0x15,R30
; 0000 0317         strcpy(at_res,"DENAID");
	CALL SUBOPT_0xE
	__POINTW2MN _0x48,15
	CALL _strcpy
; 0000 0318 
; 0000 0319     }
; 0000 031A     lcd_clear();
_0x4A:
_0x49:
	RCALL _lcd_clear
; 0000 031B     lcd_puts(at_res);
	LDI  R26,LOW(_at_res)
	LDI  R27,HIGH(_at_res)
	RCALL _lcd_puts
; 0000 031C     delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 031D 
; 0000 031E 
; 0000 031F 
; 0000 0320 
; 0000 0321         }
; 0000 0322         sprintf(lcd_data,"%X %X %X %X %X %X %X %X %d",str[0],str[1],str[2],str[3],str[4],str[5],str[6],str[7],readed_dat ...
_0x46:
	LDI  R30,LOW(_lcd_data)
	LDI  R31,HIGH(_lcd_data)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,317
	CALL SUBOPT_0xC
; 0000 0323         lcd_clear();
	RCALL _lcd_clear
; 0000 0324        delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0325        PORTC=0;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0326             lcd_puts(lcd_data);
	LDI  R26,LOW(_lcd_data)
	LDI  R27,HIGH(_lcd_data)
	RCALL _lcd_puts
; 0000 0327 
; 0000 0328 
; 0000 0329         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 032A       }
	RJMP _0x40
; 0000 032B }
_0x4B:
	RJMP _0x4B
; .FEND

	.DSEG
_0x48:
	.BYTE 0x16
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	JMP  _0x20A0006
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	JMP  _0x20A0006
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
_0x20A0007:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xF
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xF
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R7,R9
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	JMP  _0x20A0006
_0x2000007:
_0x2000004:
	INC  R7
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	JMP  _0x20A0006
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	JMP  _0x20A0005
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
	LDD  R17,Y+0
	JMP  _0x20A0005
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x20A0006
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20A0006:
	ADIW R28,1
	RET
; .FEND
_put_usart_G101:
; .FSTART _put_usart_G101
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x11
_0x20A0005:
	ADIW R28,3
	RET
; .FEND
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x11
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x11
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0003
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x12
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x12
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x13
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x14
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x13
	CALL SUBOPT_0x15
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x13
	CALL SUBOPT_0x15
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x13
	CALL SUBOPT_0x16
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x16
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x12
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x14
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x17
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x17
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x18
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x18
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND
_get_usart_G101:
; .FSTART _get_usart_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020078
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x2020079
_0x2020078:
	RCALL _getchar
	MOV  R17,R30
_0x2020079:
	MOV  R30,R17
	LDD  R17,Y+0
_0x20A0003:
	ADIW R28,5
	RET
; .FEND
__scanf_G101:
; .FSTART __scanf_G101
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x202007F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020081
	CALL SUBOPT_0x19
	BREQ _0x2020082
_0x2020083:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x1A
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2020086
	CALL SUBOPT_0x19
	BRNE _0x2020087
_0x2020086:
	RJMP _0x2020085
_0x2020087:
	CALL SUBOPT_0x1B
	BRGE _0x2020088
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2020088:
	RJMP _0x2020083
_0x2020085:
	MOV  R20,R19
	RJMP _0x2020089
_0x2020082:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x202008A
	LDI  R21,LOW(0)
_0x202008B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LPM  R19,Z+
	STD  Y+16,R30
	STD  Y+16+1,R31
	CPI  R19,48
	BRLO _0x202008F
	CPI  R19,58
	BRLO _0x202008E
_0x202008F:
	RJMP _0x202008D
_0x202008E:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202008B
_0x202008D:
	CPI  R19,0
	BRNE _0x2020091
	RJMP _0x2020081
_0x2020091:
_0x2020092:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x1A
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x2020094
	CALL SUBOPT_0x1B
	BRGE _0x2020095
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2020095:
	RJMP _0x2020092
_0x2020094:
	CPI  R18,0
	BRNE _0x2020096
	RJMP _0x2020097
_0x2020096:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x2020098
	LDI  R21,LOW(255)
_0x2020098:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x202009C
	CALL SUBOPT_0x1C
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x1A
	POP  R20
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x1B
	BRGE _0x202009D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x202009D:
	RJMP _0x202009B
_0x202009C:
	CPI  R30,LOW(0x73)
	BRNE _0x20200A6
	CALL SUBOPT_0x1C
_0x202009F:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20200A1
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x1A
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20200A3
	CALL SUBOPT_0x19
	BREQ _0x20200A2
_0x20200A3:
	CALL SUBOPT_0x1B
	BRGE _0x20200A5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x20200A5:
	RJMP _0x20200A1
_0x20200A2:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x202009F
_0x20200A1:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x202009B
_0x20200A6:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20200AB
	CPI  R30,LOW(0x69)
	BRNE _0x20200AC
_0x20200AB:
	CLT
	BLD  R15,1
	RJMP _0x20200AD
_0x20200AC:
	CPI  R30,LOW(0x75)
	BRNE _0x20200AE
_0x20200AD:
	LDI  R18,LOW(10)
	RJMP _0x20200A9
_0x20200AE:
	CPI  R30,LOW(0x78)
	BRNE _0x20200AF
	LDI  R18,LOW(16)
	RJMP _0x20200A9
_0x20200AF:
	CPI  R30,LOW(0x25)
	BRNE _0x20200B2
	RJMP _0x20200B1
_0x20200B2:
	RJMP _0x20A0002
_0x20200A9:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	SET
	BLD  R15,0
_0x20200B3:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200B5
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x1A
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20200B6
	CALL SUBOPT_0x1B
	BRGE _0x20200B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x20200B7:
	RJMP _0x20200B8
_0x20200B6:
	SBRC R15,1
	RJMP _0x20200B9
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x20200BA
	BLD  R15,2
	RJMP _0x20200B3
_0x20200BA:
	CPI  R19,43
	BREQ _0x20200B3
_0x20200B9:
	CPI  R18,16
	BRNE _0x20200BC
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20200B8
	RJMP _0x20200BE
_0x20200BC:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x20200BF
_0x20200B8:
	SBRC R15,0
	RJMP _0x20200C1
	MOV  R20,R19
	RJMP _0x20200B5
_0x20200BF:
_0x20200BE:
	CPI  R19,97
	BRLO _0x20200C2
	SUBI R19,LOW(87)
	RJMP _0x20200C3
_0x20200C2:
	CPI  R19,65
	BRLO _0x20200C4
	SUBI R19,LOW(55)
	RJMP _0x20200C5
_0x20200C4:
	SUBI R19,LOW(48)
_0x20200C5:
_0x20200C3:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	CLT
	BLD  R15,0
	RJMP _0x20200B3
_0x20200B5:
	CALL SUBOPT_0x1C
	SBRS R15,2
	RJMP _0x20200C6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x20200C6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x202009B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x20200C7
_0x202008A:
_0x20200B1:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x1A
	POP  R20
	CP   R30,R19
	BREQ _0x20200C8
	CALL SUBOPT_0x1B
	BRGE _0x20200C9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x20200C9:
_0x2020097:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20200CA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x20200CA:
	RJMP _0x2020081
_0x20200C8:
_0x20200C7:
_0x2020089:
	RJMP _0x202007F
_0x2020081:
_0x20200C1:
_0x20A0002:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20A0001:
	CALL __LOADLOCR6
	ADIW R28,18
	POP  R15
	RET
; .FEND
_scanf:
; .FSTART _scanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+3,R30
	STD  Y+3+1,R30
	MOVW R26,R28
	ADIW R26,5
	CALL SUBOPT_0x18
	LDI  R30,LOW(_get_usart_G101)
	LDI  R31,HIGH(_get_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.DSEG
_lcd_data:
	.BYTE 0x32
_at_req:
	.BYTE 0xC8
_at_res:
	.BYTE 0xC8
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _mf_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	MOV  R30,R21
	ORI  R30,0x80
	MOV  R26,R30
	JMP  _mf_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	__SUBD1N -1
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDD  R26,Y+52
	LDD  R27,Y+52+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:145 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_at_req)
	LDI  R31,HIGH(_at_req)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R30,LOW(_at_res)
	LDI  R31,HIGH(_at_res)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _scanf
	ADIW R28,10
	CALL _lcd_clear
	LDI  R26,LOW(_at_req)
	LDI  R27,HIGH(_at_req)
	CALL _lcd_puts
	LDI  R26,LOW(_at_res)
	LDI  R27,HIGH(_at_res)
	CALL _trim
	MOVW R26,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_at_req)
	LDI  R31,HIGH(_at_req)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R30,LOW(_at_res)
	LDI  R31,HIGH(_at_res)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _scanf
	ADIW R28,10
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_at_res)
	LDI  R31,HIGH(_at_res)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _scanf
	ADIW R28,6
	CALL _lcd_clear
	LDI  R26,LOW(_at_req)
	LDI  R27,HIGH(_at_req)
	CALL _lcd_puts
	LDI  R26,LOW(_at_res)
	LDI  R27,HIGH(_at_res)
	CALL _trim
	MOVW R26,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_at_req)
	LDI  R31,HIGH(_at_req)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_at_res)
	LDI  R31,HIGH(_at_res)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+15
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+20
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+25
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+30
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+35
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+40
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+45
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,36
	CALL _sprintf
	ADIW R28,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(_at_res)
	LDI  R31,HIGH(_at_res)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
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
