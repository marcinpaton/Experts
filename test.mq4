//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
//--- get minimum stop level 
   double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL); 
   Print("Minimum Stop Level=",minstoplevel," points"); 
   double price=Ask; 
//--- calculated SL and TP prices must be normalized 
   double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits); 
   double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits); 
//--- place market order to buy 1 lot 
   int ticket=OrderSend(Symbol(),OP_BUY,1,price,3,stoploss,takeprofit,"My order",16384,0,clrGreen); 
   if(ticket<0) 
     { 
      Print("OrderSend failed with error #",GetLastError()); 
     } 
   else 
      Print("OrderSend placed successfully"); 
   
  }
//+------------------------------------------------------------------+
