#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

class IndicatorsRow {
   private:
      void setAC(int shift);
      void setADX(int shift);
      void setAlligator(int shift);
      void setAO(int shift);
      void setATR(int shift);
      void setBullsBears(int shift);
      void setBands(int shift);
      void setCci(int shift);
      void setDeMarker(int shift);
      void setEnvelopes(int shift);
      void setForce(int shift);
      void setFractals(int shift);
      void setGator(int shift);
      void setIchimoku(int shift);
      void setMomentum(int shift);
      void setMFI(int shift);
      void setMA(int shift);
      void setOsma(int shift);
      void setSar(int shift);
      void setRsi(int shift);
      void setRvi(int shift);
      void setSto(int shift);
      void setWpr(int shift);
   public:
      IndicatorsRow();
     ~IndicatorsRow();
      void load(int shift);
      
      double ac;
      double adx;
      double alligator;
      double ao;
      double atr;
      double bullsBears;
      double bandUpper;
      double bandLower;
      double cci;      
      double deMarker; 
      double envelopes;
      double force;
      double fractals;
      double gator;
      double ichimoku;
      double momentum;
      double mfi;
      double ma;
      double osma;
      double sar;
      double rsi;
      double rvi;
      double sto;
      double wpr;
  };
  
IndicatorsRow::IndicatorsRow(){
}


IndicatorsRow::~IndicatorsRow(){
}

void IndicatorsRow::load(int shift) {
      setAC(shift);
      setADX(shift);
      setAlligator(shift);
      setAO(shift);
      setATR(shift);
      setBullsBears(shift);
      setBands(shift);
      setCci(shift);
      setDeMarker(shift);
      setEnvelopes(shift);
      setForce(shift);
      setFractals(shift);
      setGator(shift);
      setIchimoku(shift);
      setMomentum(shift);
      setMFI(shift);
      setMA(shift);
      setOsma(shift);
      setSar(shift);
      setRsi(shift);
      setRvi(shift);
      setSto(shift);
      setWpr(shift);
}

void IndicatorsRow::setWpr(int shift) {
   sto = iWPR(Symbol(), Period(),14,shift);
   if (sto >= -20) {
      wpr = 1;
   } else if (sto <= -80) {
      wpr = -1;
   } else {
      wpr = 0;
   }
}

void IndicatorsRow::setSto(int shift) {
   sto = iStochastic(Symbol(), Period(),15,8,8,MODE_EMA,0,MODE_SIGNAL,shift);
   if (sto <= 20) {
      sto = 1;
   } else if (sto >= 80) {
      sto = -1;
   } else {
      sto = 0;
   }
}

void IndicatorsRow::setRvi(int shift) {
   rvi = iRVI(Symbol(), Period(), 10, MODE_MAIN, shift) 
          - iRVI(Symbol(), Period(), 10, MODE_SIGNAL, shift);
}

void IndicatorsRow::setRsi(int shift) {
   rsi = iRSI(Symbol(), Period(), 14, PRICE_CLOSE, shift);
   if (rsi < 30) {
      rsi = 1;
   } else if (rsi > 70) {
      rsi = -1;
   } else {
      rsi = 0;
   }
}

void IndicatorsRow::setSar(int shift) {
   if (iSAR(Symbol(), Period(), 0.02, 0.2, shift) > iClose(Symbol(), Period(), shift)) {
      sar = 1;
   } else {
      sar = -1;
   }
}

void IndicatorsRow::setOsma(int shift) {
   osma = iOsMA(Symbol(), Period(), 12, 26, 9, PRICE_CLOSE, shift);
}

void IndicatorsRow::setMA(int shift) {
   ma = iMA(Symbol(),Period(), 14, 0, MODE_EMA, PRICE_CLOSE, shift);
   double close = iClose(Symbol(), Period(),shift); 
   ma = close - ma;
}

void IndicatorsRow::setMFI(int shift) {
   mfi = iMFI(Symbol(),Period(), 14, shift);
}

void IndicatorsRow::setMomentum(int shift) {
   double momentumPrev = iMomentum(Symbol(),Period(), 14, PRICE_CLOSE, shift + 1);
   double momentumCurr = iMomentum(Symbol(),Period(), 14, PRICE_CLOSE, shift);
   
   if(momentumPrev < momentumCurr && momentumCurr > 100.0) {
      momentum = 1;
   } else if(momentumPrev > momentumCurr && momentumCurr < 100.0) {
      momentum = -1;
   } else {
      momentum = 0;
   }
}

void IndicatorsRow::setIchimoku(int shift) {
   double close = iClose(Symbol(),Period(),shift);      
   double senkouSpanA = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, shift);
   double senkouSpanB = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, shift);
   double senkouSpanAPrev = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANA, shift + 1);
   double senkouSpanBPrev = iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_SENKOUSPANB, shift + 1);
   
   if (senkouSpanAPrev < senkouSpanA && senkouSpanBPrev < senkouSpanB) {
      ichimoku = 1;
   } else if (senkouSpanAPrev > senkouSpanA && senkouSpanBPrev > senkouSpanB) {
      ichimoku = -1;
   } else {
      ichimoku = 0;
   }
}

void IndicatorsRow::setGator(int shift) {
   double upperPrev = iGator(Symbol(), Period(), 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER, shift + 1);
   double upperCurr = iGator(Symbol(), Period(), 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER, shift);
   bool upperGreen = false;
   if (upperPrev < upperCurr) {
      upperGreen = true;
   }   
   
   double lowerPrev = iGator(Symbol(), Period(), 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_LOWER, shift + 1);
   double lowerCurr = iGator(Symbol(), Period(), 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_LOWER, shift);
   bool lowerGreen = false;
   if (lowerPrev > lowerCurr) {
      lowerGreen = true;
   }
   if(upperGreen && lowerGreen) {
      gator = 1;
   } else if(upperGreen && !lowerGreen) {
      gator = 0.3;
   } else if(!upperGreen && lowerGreen) {
      gator = -0.3;
   } else {
      gator = -1;
   }
}

void IndicatorsRow::setFractals(int shift) {
   if (iFractals(Symbol(), PERIOD_CURRENT, MODE_UPPER, shift + 1) != 0) {
      fractals = 1;
   } else if (iFractals(Symbol(), PERIOD_CURRENT, MODE_LOWER, shift + 1) != 0){
      fractals = -1;
   } else {
      fractals = 0;
   }
   Print("setFractals ", fractals);
}

void IndicatorsRow::setForce(int shift) {
   force = iForce(Symbol(), Period(), 13, MODE_EMA, PRICE_CLOSE, shift);
   if(force > 0) {
      force = 1;
   } else if (force < 0) {
      force = -1;
   } else {
     force = 0;
   }
}

void IndicatorsRow::setEnvelopes(int shift) {
   if (iHigh(Symbol(),Period(),shift) > iEnvelopes(Symbol(), Period(), 20, MODE_EMA, 0, PRICE_CLOSE, 0.1, MODE_UPPER, shift)) {
      envelopes = 1;  
   } else if (iLow(Symbol(),Period(),shift) < iEnvelopes(Symbol(), Period(), 20, MODE_EMA, 0, PRICE_CLOSE, 0.1, MODE_LOWER, shift)) {
      envelopes = -1;
   } else {
      envelopes = 0;
   }
}

void IndicatorsRow::setDeMarker(int shift){
   deMarker = iDeMarker(Symbol(), Period(), 14, shift);
   if(deMarker > 0.7) {
      deMarker = 1;
   } else if(deMarker < 0.3) {
      deMarker = -1;
   } else {
      deMarker = 0;
   }
}

void IndicatorsRow::setCci(int shift){
   cci = iCCI(Symbol(),Period(),20,PRICE_CLOSE,shift);
   if(cci > 100) {
      cci = 1.0;
   } else if (cci < -100) {
      cci = -1.0;
   } else {
      cci = 0;
   }
}

void IndicatorsRow::setBands(int shift){
   bandUpper = iBands(Symbol(),Period(),20,2,0,PRICE_HIGH,MODE_UPPER,shift);
   bandLower = iBands(Symbol(),Period(),20,2,0,PRICE_LOW,MODE_LOWER,shift);

   bandUpper = bandUpper - iHigh(Symbol(),Period(),shift);
   if(bandUpper > 0.001){
      bandUpper = 0.001;
   }
   if(bandUpper < -0.001){
      bandUpper = -0.001;
   }
   bandLower = iLow(Symbol(),Period(),shift) - bandLower;
   if(bandLower > 0.001){
      bandLower = 0.001;
   }
   if(bandLower < -0.001){
      bandLower = -0.001;
   }
}

void IndicatorsRow::setAO(int shift){
   double ao0 = iAO(Symbol(),Period(),shift);
   double ao1 = iAO(Symbol(),Period(),shift + 1);
   double ao2 = iAO(Symbol(),Period(),shift + 2);
   double ao3 = iAO(Symbol(),Period(),shift + 3);
   
   if (ao1 < 0 && ao0 > 0){
      ao = 1;
   } else if (ao1 > 0 && ao0 < 0){
      ao = -1;
   } else if (ao3 > ao2 && ao2 > ao1 && ao1 < ao0 && ao0 > ao1) {
      ao = 1;   
   } else if (ao3 < ao2 && ao2 < ao1 && ao1 > ao0 && ao0 < ao1) {
      ao = -1;   
   } else {
      ao = 0;
   }
}

void IndicatorsRow::setAC(int shift){
   double ac0 = iAC(Symbol(),Period(),shift);
   double ac1 = iAC(Symbol(),Period(),shift + 1);
   double ac2 = iAC(Symbol(),Period(),shift + 2);
   double ac3 = iAC(Symbol(),Period(),shift + 3);
   
   if (ac0 > 0 && ac2 < ac1 && ac1 < ac0){
      ac = 1;
   } else if(ac0 < 0 && ac3 < ac2 && ac2 < ac1 && ac1 < ac0){
      ac = 1;
   } else if(ac0 < 0 && ac2 > ac1 && ac1 > ac0){
      ac = -1;
   } else if(ac0 > 0 && ac3 > ac2 && ac2 > ac1 && ac1 > ac0){
      ac = -1;
   } else {
      ac = 0;
   }
}

void IndicatorsRow::setATR(int shift){
   atr = iATR(Symbol(),Period(),14,shift);
}

void IndicatorsRow::setADX(int shift){
   adx = iADX(Symbol(),Period(),14,PRICE_CLOSE,MODE_MAIN,shift);
   if(adx > 25) adx = 1;
   else if (adx < 20) adx = -1;
   else adx = 0;
}

void IndicatorsRow::setAlligator(int shift){
   double alligatorJaw=iAlligator(Symbol(),Period(),13,8,8,5,5,3,MODE_SMMA,PRICE_CLOSE,MODE_GATORJAW,shift);
   double alligatorTeeth=iAlligator(Symbol(),Period(),13,8,8,5,5,3,MODE_SMMA,PRICE_CLOSE,MODE_GATORTEETH,shift);
   double alligatorLips=iAlligator(Symbol(),Period(),13,8,8,5,5,3,MODE_SMMA,PRICE_CLOSE,MODE_GATORLIPS,shift);
   if (alligatorJaw < alligatorTeeth && alligatorTeeth < alligatorLips) {
      alligator = 1;
   } else if (alligatorJaw > alligatorTeeth && alligatorTeeth > alligatorLips) {
      alligator = -1;
   } else {
      alligator = 0;
   }
}

void IndicatorsRow::setBullsBears(int shift){
   double maPrev1 = iMA(Symbol(),Period(),13,0,MODE_EMA,PRICE_CLOSE,shift);
   double maPrev2 = iMA(Symbol(),Period(),13,0,MODE_EMA,PRICE_CLOSE,shift + 1);
   bool maUp = false;
   if (maPrev2 < maPrev1) {
      maUp = true;
   }
   
   double bullsPrev1 = iBullsPower(Symbol(),Period(),13,PRICE_CLOSE,shift);
   double bullsPrev2 = iBullsPower(Symbol(),Period(),13,PRICE_CLOSE,shift + 1);
   double bearsPrev1 = iBearsPower(Symbol(),Period(),13,PRICE_CLOSE,shift);
   double bearsPrev2 = iBearsPower(Symbol(),Period(),13,PRICE_CLOSE,shift + 1);
   
   bullsBears = 0;   
   if (!maUp && bullsPrev1 > 0 && bullsPrev2 > 0 && bullsPrev2 > bullsPrev1) {
      bullsBears = -1;
   } else if (maUp && bearsPrev1 < 0 && bearsPrev2 < 0 && bearsPrev2 < bearsPrev1) {
      bullsBears = 1;
   }
}

