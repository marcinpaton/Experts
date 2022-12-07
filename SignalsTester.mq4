//+------------------------------------------------------------------+
//|                                                SignalsTester.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

struct Signal {
   datetime time;
   string type;
   double stopLoss;
   double takeProfit;
};

bool signalsInitialized = false;
Signal signals[];
datetime lastTime = NULL;
int lastFoundIdx = 0;

void initSignals() {
   if (signalsInitialized) {
      return;   
   }
   ArrayResize(signals, 1000000, 1000000);

   string fileName = "EURUSD_signals.csv";
   int fileHandle = FileOpen(fileName, FILE_READ | FILE_TXT, 0, CP_ACP);
   if (fileHandle == INVALID_HANDLE) {
      PrintFormat("Failed to open %s file, Error code = %d", fileName, GetLastError());
   } else {
      Print("File opened successfuly");
   }
   
   int idx = 0;
   while(!FileIsEnding(fileHandle)) {
      string line = FileReadString(fileHandle);
      string splitedResult[];
      StringSplit(line, ';', splitedResult); 
      StringReplace(splitedResult[2], ",", ".");
      StringReplace(splitedResult[3], ",", ".");
      
      signals[idx].time = StrToTime(splitedResult[0]);
      signals[idx].type = splitedResult[1];
      signals[idx].stopLoss = StrToDouble(splitedResult[2]);
      signals[idx].takeProfit = StrToDouble(splitedResult[3]);
      
      printf("-->>> " + signals[idx].time + " " + signals[idx].type + " " + signals[idx].stopLoss +" " +  signals[idx].takeProfit);
      idx++;
   }
   
   FileClose(fileHandle);
   signalsInitialized = true;
}


int OnInit() {
   return(INIT_SUCCEEDED);
}

void OnTick() {
   initSignals();   
   datetime currentTime  = iTime(Symbol(),Period(),0);
   
   if (lastTime == currentTime || OrdersTotal() > 0) {
      return;
   }
   
   int operation;
   double price;
   double stopLoss;
   double takeProfit;
   for(int idx = lastFoundIdx; idx < ArraySize(signals); idx++) {
      if (signals[idx].time == currentTime) {
         lastFoundIdx = idx;
         
         if (StringCompare(signals[idx].type, "BUY") == 0) {
            operation = OP_BUY;
            price = Ask;
            stopLoss = signals[idx].stopLoss; 
            takeProfit = signals[idx].takeProfit;
         } else {
            operation = OP_SELL;
            price = Bid;
            stopLoss = signals[idx].stopLoss + 90*Point;
            takeProfit = signals[idx].takeProfit + 60*Point;
         }
         
         int ticket = OrderSend(
            Symbol(),         // symbol
            operation,           // operation
            0.1,              // volume
            price,               // price
            2,            // slippage
            signals[idx].stopLoss,          // take profit
            takeProfit,          // take profit
            "hehe",        // comment
            0,             // magic number
            0,          // pending order expiration
            clrYellow  // color
            );
         if(ticket<0) {
           Print("OrderSend failed with error #",GetLastError());
           Print("StopLevel = ", (int)MarketInfo(Symbol(), MODE_STOPLEVEL));
           Print("stopLoss = ", signals[idx].stopLoss);
           Print("takeProfit = ", signals[idx].takeProfit);
           Print("price = ", price);
         } else {
           Print("OrderSend placed successfully");
         }
         break;
      }
   }
   
   lastTime = currentTime;      
}
  