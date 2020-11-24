#include "stm32f4xx.h"
#include <string.h>
#include <stdio.h>

void printMsg(int a)
{
	 float a1=*((float*) &a);
	 
	 char Msg1[100];
	 
	 char *ptr;
	 sprintf(Msg1, "%f, \n", a1);
	 
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 return;
   }
void printNextl()
{
	ITM_SendChar('\n')	 ;
}
void printComma()
{
	
	 ITM_SendChar(',')	 ;
}

void printMessage(int r,int center_x,int center_y)
{
	 char Msg1[100]="Radius =";
	 
	 char *ptr;
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 printMsg(r);
	 printNextl();
	 
	 strcpy(Msg1,"center of circle X =");
	 
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 printMsg(center_x);
	 printNextl();

	 strcpy(Msg1,"center of circle Y =");
	 
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 printMsg(center_y);
	 printNextl();
	 
	 strcpy(Msg1,"ANGLE,X,Y");
	 
	 ptr = Msg1 ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   
	 }
	 printNextl();
	
}	
