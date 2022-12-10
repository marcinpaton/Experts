#include "IndicatorsRow.mqh"
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int Parametr=123;
input string fileDir="d:\\pliki_marcina\\_forex\\";

datetime lastTime = NULL;
int fileHandle = INVALID_HANDLE;

int OnInit() {   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   Print("deinit: ", reason);
   FileClose(fileHandle);
}

void openFile() {
   if (fileHandle != INVALID_HANDLE) {
      return;
   }
   
   string headers = StringConcatenate(
                     "Time;Open;High;Low;Close;AC;ADX;Alligator;AO;ATR;BullsBears;BandUpper;",
                     "BandLower;CCI;DeMarker;Envelopes;Force;Fractals;Gator;Ichimoku;Momentum;",
                     "MFI;MA;OsMA;SAR;RSI;RVI;Stochastic\n");
   Print(headers);
   
   string fileName = StringConcatenate(Symbol(), "_M", Period(), "_prices.csv");
   fileHandle = FileOpen(fileName, FILE_WRITE | FILE_TXT, 0, CP_ACP);
   
   Print("File opened. File handler: ", fileHandle);
   if (fileHandle != INVALID_HANDLE) {
      Print("File opened successfuly");
      FileWriteString(fileHandle, headers);
      Print("Headers written");
   } else {
      PrintFormat("Failed to open %s file, Error code = %d", fileName, GetLastError());
   }
}

void OnTick() {
   datetime currentTime  = iTime(Symbol(),Period(),0);
   
   if (lastTime == currentTime) {
      return;
   }
   lastTime = currentTime;
   
   int shift = 1;   
   datetime time = iTime(Symbol(), Period(), shift);
   double open = iOpen(Symbol(),Period(),shift);
   double high = iHigh(Symbol(),Period(),shift);
   double low = iLow(Symbol(),Period(),shift); 
   double close = iClose(Symbol(),Period(),shift); 
   IndicatorsRow indicatorsRow;
   indicatorsRow.load(shift);
   
   string pricesRow = StringConcatenate(
                     TimeToString(time, TIME_DATE|TIME_SECONDS), ";",
                     DoubleToString(open, Digits()), ";",
                     DoubleToString(high, Digits()), ";",
                     DoubleToString(low, Digits()), ";",
                     DoubleToString(close, Digits()), ";",
                     DoubleToString(indicatorsRow.ac, 0), ";",
                     DoubleToString(indicatorsRow.adx, 0), ";",
                     DoubleToString(indicatorsRow.alligator, 0), ";",
                     DoubleToString(indicatorsRow.ao, 0), ";",
                     DoubleToString(indicatorsRow.atr, Digits()), ";",
                     DoubleToString(indicatorsRow.bullsBears, 0), ";",
                     DoubleToString(indicatorsRow.bandUpper, Digits()), ";",
                     DoubleToString(indicatorsRow.bandLower, Digits()), ";",
                     DoubleToString(indicatorsRow.cci, 0), ";",
                     DoubleToString(indicatorsRow.deMarker, 0), ";",
                     DoubleToString(indicatorsRow.envelopes, 0), ";",
                     DoubleToString(indicatorsRow.force, 0), ";",
                     DoubleToString(indicatorsRow.fractals, 0), ";",
                     DoubleToString(indicatorsRow.gator, 1), ";",
                     DoubleToString(indicatorsRow.ichimoku, 0), ";",
                     DoubleToString(indicatorsRow.momentum, 0), ";",
                     DoubleToString(indicatorsRow.mfi, 2), ";",
                     DoubleToString(indicatorsRow.ma, Digits()), ";",
                     DoubleToString(indicatorsRow.osma, 8), ";",
                     DoubleToString(indicatorsRow.sar, 0), ";",
                     DoubleToString(indicatorsRow.rsi, 0), ";",
                     DoubleToString(indicatorsRow.rvi, 4), ";",
                     DoubleToString(indicatorsRow.sto, 0), ";",
                     "\n");
   Print(pricesRow);
   openFile();
   if (fileHandle != INVALID_HANDLE) {
      FileWriteString(fileHandle, pricesRow);
   } else {
      PrintFormat("Failed to write to file!");
   }
}