#include <mega32.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include <spi.h>
#include <string.h>

unsigned char lcd_cc=0;
unsigned char lcd_data[50];
char at_req[200];
char at_res[200];
char temp; 
// SPI interrupt service routine
unsigned char SPI_PUT(unsigned char data)
{
    //while(!(SPSR & (1<<SPIF)));
    SPDR=data;                 
    while(!(SPSR & (1<<SPIF)));
    return SPDR;
}


//MFRC522 
//status
#define CARD_FOUND        1
#define CARD_NOT_FOUND    2
#define ERROR            3

#define MAX_LEN            16

//Card types
#define Mifare_UltraLight     0x4400
#define Mifare_One_S50        0x0400
#define Mifare_One_S70        0x0200
#define Mifare_Pro_X        0x0800
#define Mifare_DESFire        0x4403

// Mifare_One card command word
# define PICC_REQIDL          0x26               // find the antenna area does not enter hibernation
# define PICC_REQALL          0x52               // find all the cards antenna area
# define PICC_ANTICOLL        0x93               // anti-collision
# define PICC_SElECTTAG       0x93               // election card
# define PICC_AUTHENT1A       0x60               // authentication key A
# define PICC_AUTHENT1B       0x61               // authentication key B
# define PICC_READ            0x30               // Read Block
# define PICC_WRITE           0xA0               // write block
# define PICC_DECREMENT       0xC0               // debit
# define PICC_INCREMENT       0xC1               // recharge
# define PICC_RESTORE         0xC2               // transfer block data to the buffer
# define PICC_TRANSFER        0xB0               // save the data in the buffer
# define PICC_HALT            0x50               // Sleep
//end of status
//registers

#ifndef _MFRC522_REG_H
#define _MFRC522_REG_H

//Page 0 ==> Command and Status

#define Page0_Reserved_1 	0x00
#define CommandReg			0x01
#define ComIEnReg			0x02
#define DivIEnReg			0x03
#define ComIrqReg			0x04
#define DivIrqReg			0x05
#define ErrorReg			0x06
#define Status1Reg			0x07
#define Status2Reg			0x08
#define FIFODataReg			0x09
#define FIFOLevelReg		0x0A
#define WaterLevelReg		0x0B
#define ControlReg			0x0C
#define BitFramingReg		0x0D
#define CollReg				0x0E
#define Page0_Reserved_2	0x0F

//Page 1 ==> Command
#define Page1_Reserved_1	0x10
#define ModeReg				0x11
#define TxModeReg			0x12
#define RxModeReg			0x13
#define TxControlReg		0x14
#define TxASKReg			0x15
#define TxSelReg			0x16
#define RxSelReg			0x17
#define RxThresholdReg		0x18
#define	DemodReg			0x19
#define Page1_Reserved_2	0x1A
#define Page1_Reserved_3	0x1B
#define MfTxReg				0x1C
#define MfRxReg				0x1D
#define Page1_Reserved_4	0x1E
#define SerialSpeedReg		0x1F

//Page 2 ==> CFG
#define Page2_Reserved_1	0x20
#define CRCResultReg_1		0x21
#define CRCResultReg_2		0x22
#define Page2_Reserved_2	0x23
#define ModWidthReg			0x24
#define Page2_Reserved_3	0x25
#define RFCfgReg			0x26
#define GsNReg				0x27
#define CWGsPReg			0x28
#define ModGsPReg			0x29
#define TModeReg			0x2A
#define TPrescalerReg		0x2B
#define TReloadReg_1		0x2C
#define TReloadReg_2		0x2D
#define TCounterValReg_1	0x2E
#define TCounterValReg_2 	0x2F

//Page 3 ==> TestRegister
#define Page3_Reserved_1 	0x30
#define TestSel1Reg			0x31
#define TestSel2Reg			0x32
#define TestPinEnReg		0x33
#define TestPinValueReg		0x34
#define TestBusReg			0x35
#define AutoTestReg			0x36
#define VersionReg			0x37
#define AnalogTestReg		0x38
#define TestDAC1Reg			0x39
#define TestDAC2Reg			0x3A
#define TestADCReg			0x3B
#define Page3_Reserved_2 	0x3C
#define Page3_Reserved_3	0x3D
#define Page3_Reserved_4	0x3E
#define Page3_Reserved_5	0x3F

#endif

//end of registers

//commands

#ifndef MFRC522_CMD_H
#define MFRC522_CMD_H

//command set
#define Idle_CMD 				0x00
#define Mem_CMD					0x01
#define GenerateRandomId_CMD	0x02
#define CalcCRC_CMD				0x03
#define Transmit_CMD			0x04
#define NoCmdChange_CMD			0x07
#define Receive_CMD				0x08
#define Transceive_CMD			0x0C
#define Reserved_CMD			0x0D
#define MFAuthent_CMD			0x0E
#define SoftReset_CMD			0x0F

#endif


//end of commands

void mf_write(unsigned char addr,unsigned char data)
{
    
    PORTB.0=0;
    SPI_PUT((addr<<1)&0x7E);
    SPI_PUT(data);
    PORTB.0=1;
    

}
unsigned char mf_read(unsigned char addr)
{
    unsigned char data;
    PORTB.0=0;
    SPI_PUT(((addr<<1)&0x7E) | 0x80);  
    data=SPI_PUT(0x00);    
    PORTB.0=1;    
    return data;
}
void mf_reset()
{
    mf_write(CommandReg,SoftReset_CMD);
}

void mf_init()
{
    unsigned char cont_reg; 
    mf_reset();
    mf_write(TModeReg, 0x8D);
    mf_write(TPrescalerReg, 0x3E);
    mf_write(TReloadReg_1, 30);   
    mf_write(TReloadReg_2, 0);	
	mf_write(TxASKReg, 0x40);	
	mf_write(ModeReg, 0x3D);
    cont_reg=mf_read(TxControlReg); //read TxControlReg 
    
    if(!(cont_reg&0x03))
        mf_write(TxControlReg,cont_reg|0x03);
}
//end of MFRC522

unsigned char mf_to_card(unsigned char cmd, unsigned char *send_data, unsigned char send_data_len, unsigned char *back_data, long int *back_data_len)
{
    unsigned char status = ERROR;
    unsigned char irqEn = 0x00;
    unsigned char waitIRq = 0x00;
    unsigned char lastBits;
    unsigned char n;
    unsigned char tmp;
    long int i;        
    
    switch (cmd)
    {
        case MFAuthent_CMD:		//Certification cards close
		{
			irqEn = 0x12;
			waitIRq = 0x10;
			break;
		}
		case Transceive_CMD:	//Transmit FIFO data
		{
			irqEn = 0x77;
			waitIRq = 0x30;
			break;
		}
		default:
			break;
    }
   
    //mf_write(ComIEnReg, irqEn|0x80);	//Interrupt request
    n=mf_read(ComIrqReg);
    mf_write(ComIrqReg,n&(~0x80));//clear all interrupt bits
    n=mf_read(FIFOLevelReg);
    mf_write(FIFOLevelReg,n|0x80);//flush FIFO data
    
	mf_write(CommandReg, Idle_CMD);	//NO action; Cancel the current cmd???
                                                                           
    for (i=0; i<send_data_len; i++)
    {   
		mf_write(FIFODataReg, send_data[i]);    
	}
    
    mf_write(CommandReg, cmd);
    if (cmd == Transceive_CMD)
    {    
		n=mf_read(BitFramingReg);
		mf_write(BitFramingReg,n|0x80);  
	}   
    	i = 100000;	//i according to the clock frequency adjustment, the operator M1 card maximum waiting time 25ms???
    do 
    {
		//CommIrqReg[7..0]
		//Set1 TxIRq RxIRq IdleIRq HiAlerIRq LoAlertIRq ErrIRq TimerIRq
        n = mf_read(ComIrqReg);
        i--;
    }
    while ((i!=0) && !(n&0x01) && !(n&waitIRq));

	tmp=mf_read(BitFramingReg);
	mf_write(BitFramingReg,tmp&(~0x80));
	
    if (i != 0)
    {    
        if(!(mf_read(ErrorReg) & 0x1B))	//BufferOvfl Collerr CRCErr ProtecolErr
        {
            status = CARD_FOUND;
            if (n & irqEn & 0x01)
            {   
				status = CARD_NOT_FOUND;			//??   
			}

            if (cmd == Transceive_CMD)
            {
               	n = mf_read(FIFOLevelReg);
              	lastBits = mf_read(ControlReg) & 0x07;
                if (lastBits)
                {   
					*back_data_len = (n-1)*8 + lastBits;   
				}
                else
                {   
					*back_data_len = n*8;   
				}

                if (n == 0)
                {   
					n = 1;    
				}
                if (n > MAX_LEN)
                {   
					n = MAX_LEN;   
				}
				
				//Reading the received data in FIFO
                for (i=0; i<n; i++)
                {   
					back_data[i] = mf_read(FIFODataReg);    
				}
            }
        }
        else
        {   
			status = ERROR;  
		}
        
    }
	
    //SetBitMask(ControlReg,0x80);           //timer stops
    //mf_write(cmdReg, PCD_IDLE); 

    return status;
    
}
unsigned char mf_request(unsigned char req,unsigned char *tag_type)
{
    unsigned char status;
    long int backBits; 
    mf_write(BitFramingReg, 0x07);
    tag_type[0]=req;
    status = mf_to_card(Transceive_CMD, tag_type, 1, tag_type, &backBits);  
    if ((status != CARD_FOUND) || (backBits != 0x10))
	{    
		status = ERROR;
	}
	return status;
}

unsigned char mf_get_card_serial(unsigned char * serial_out)
{
	unsigned char status;
    unsigned char i;
	unsigned char serNumCheck=0;
    long int unLen;
    
	mf_write(BitFramingReg, 0x00);		//TxLastBists = BitFramingReg[2..0]
 
    serial_out[0] = PICC_ANTICOLL;
    serial_out[1] = 0x20;
    status = mf_to_card(Transceive_CMD, serial_out, 2, serial_out, &unLen);
    if (status == CARD_FOUND)
	{
		//Check card serial number
		for (i=0; i<4; i++)
		{   
		 	serNumCheck ^= serial_out[i];
		}
		if (serNumCheck != serial_out[i])
		{   
			status = ERROR;    
		}
    }
            
        
    return status;
}

char *trim(char *s)
{
    unsigned char i=0;
    unsigned char j=0;
    char str[50];
    for(i=0;s[i];i++)
        if(s[i]!='\r' || s[i]!='\n')
            str[j++]=s[i]; 
    s[j]=0;
    return str;    
}



void sim900_HTTP_init()
{
    printf("AT+SAPBR=3,1,\"Contype\",\"GPRS\"\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          

    
    
    printf("AT+SAPBR=3,1,\"APN\",\"internet\"\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          

       
    
    printf("AT+SAPBR=1,1\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          

      
    
    printf("AT+SAPBR=2,1\r\n"); 
    scanf("%s%s",at_req,at_res);
    scanf("%s",at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          

              
    
     printf("AT+HTTPINIT\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          

       
    
     printf("AT+HTTPPARA=\"CID\",1\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          

       
}
void send_HTTP_request(unsigned char *data)
{
    printf("AT+HTTPPARA=\"URL\",\"http://2048game.tk/card_data.php?id=%s\"\r\n",data); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
          
       
    
    printf("AT+HTTPACTION=0\r\n"); 
    scanf("%s%s",at_req,at_res);
    scanf("%s",at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
           

        
    
    printf("AT+HTTPREAD\r\n"); 
}
void sim900_sms_init()
{
//   printf("ATE1\r\n");
//    scanf("%s%s",at_req,at_res);
//    lcd_clear();
//    lcd_puts(at_req);
//    lcd_puts(trim(at_res));
// 
//    
//      
//    printf("AT+CMGF=1\r\n");
//    scanf("%s%s",at_req,at_res);
//    lcd_clear();
//    lcd_puts(at_req);
//    lcd_puts(trim(at_res));
//    
//    
//     
//    printf("AT+CSCS=\"GSM\"\r\n"); 
//    scanf("%s%s",at_req,at_res);
//    lcd_clear();
//    lcd_puts(at_req);
//    lcd_puts(trim(at_res));
}
void sim900_client_init()
{
   /*
    //just for GPRS turn it off for sms or calling  
    printf("ATE1\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
 
    
      
    printf("AT+CMGF=1\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    
     
    printf("AT+CSCS=\"GSM\"\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    
    // for server client mode
          
    
    printf("AT+CGATT=1\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    

    
    printf("AT+CIPMUX=0\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIPMODE=0\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIPCSGP=1,\"internet\"\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CLPORT=\"TCP\",\"2020\"\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CSTT=\"internet\",\"\",\"\"\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIPSRIP=1\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIICR\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIFSR\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIPSTART=\"TCP\",\"5.120.12.86\",\"7074\"\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();                                   
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    
    scanf("%s",at_res);
    
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    


    
    printf("AT+CIPSTATUS\r\n");
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    
 */
 } 
void sim900_client_request(unsigned char *data)
{
/*
    printf("AT+CIPSEND\r\n"); 
    printf(%s,data);
    printf("%c",26);
    scanf("%s%s",at_req,at_res);
    scanf("%s",at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    

    
    printf("AT+CIPSHUT\r\n"); 
    scanf("%s%s",at_req,at_res);
    lcd_clear();
    lcd_puts(at_req);
    lcd_puts(trim(at_res));
    
    
    
 */
}
void sim900_call()
{
//    printf("ATD09394103465;\r\n");
//    scanf("%s%s",at_req,at_res);
//    lcd_clear();
//    lcd_puts(at_req);
//    lcd_puts(trim(at_res));
}
void sim900_send_sms(unsigned char *data)
{
        //sim900       
//        printf("AT+CMGS=\"+989394103465\"\r\n");
//        scanf("%s%s",at_req,at_res);
//        printf("%s",data);
//        printf("%c",26);
//        scanf("%s%s",at_req,at_res);
//        lcd_clear();
//        lcd_puts(at_req);
//        lcd_puts(trim(at_res));
        //end of sim900
}
void main(void)
{
// Declare your local variables here
unsigned char readed_data;
unsigned char str[MAX_LEN];
unsigned char i=0;
unsigned char lcd_hex_data[6];

    
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2000.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// Clear the SPI interrupt flag
#asm
    in   r30,spsr
    in   r30,spdr
#endasm

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);
PORTB.0=1;
//lcd_putsf("aminbw");


// Global enable interrupts
#asm("sei")
    //initialize mf
    mf_init(); 
    //check ver       
    readed_data = mf_read(VersionReg);
	if(readed_data == 0x92)
	{
		lcd_putsf("MIFARE RC522v2");
		lcd_putsf("Detected");
	}else if(readed_data == 0x91 || readed_data==0x90)
	{
		lcd_putsf("MIFARE RC522v1");
		lcd_putsf("Detected");
	}else
	{
		lcd_putsf("No reader found");
	}
    //end of check ver
//read card enable
    readed_data = mf_read(ComIEnReg);
	mf_write(ComIEnReg,readed_data|0x20);
	readed_data = mf_read(DivIEnReg);
	mf_write(DivIEnReg,readed_data|0x80); 
 
 

    
    sim900_HTTP_init(); 





//end of read card enable
while (1)
      {          
      
      // Place your code here
      for(i=0;i<MAX_LEN;i++)  
        str[i]=0;
        readed_data=mf_request(PICC_REQALL,str);
        if(readed_data==CARD_FOUND)
        { 
        readed_data=mf_get_card_serial(str);
        sprintf(lcd_data,"%X%X%X%X%X%X%X%X%d",str[0],str[1],str[2],str[3],str[4],str[5],str[6],str[7],readed_data);  
    send_HTTP_request(lcd_data);
    scanf("%s%s",at_req,at_res);
    scanf("%s",at_res);            
    if(strstr(at_res,"GRANTED")!=NULL)
    {   
        PORTC=1<<7;                    
        scanf("%s",at_res);
        
    }
    else if(strstr(at_res,"DENAID")!=NULL)
    {
        PORTC=1<<6;
        strcpy(at_res,"DENAID");
        
    } 
    lcd_clear();
    lcd_puts(at_res); 
    delay_ms(1500);
           

        
    
        } 
        sprintf(lcd_data,"%X %X %X %X %X %X %X %X %d",str[0],str[1],str[2],str[3],str[4],str[5],str[6],str[7],readed_data);  
        lcd_clear();  
       delay_ms(500);         
       PORTC=0;
            lcd_puts(lcd_data);
    
 
        delay_ms(1000);
      }
}