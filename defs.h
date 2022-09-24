#define BACKLIGHT PORTC.2
#define SELECT PINA.0          
#define FLAG PINA.1 
#define LEFT PINA.2 
#define RIGHT PINA.3 
#define UP PINA.4 
#define DOWN PINA.5


/* definitions / defines file */
#define DEFS_H

#define wdogtrig()			#asm("wdr") // call often if Watchdog timer enabled