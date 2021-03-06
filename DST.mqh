//+------------------------------------------------------------------+
//|                                                          DST.mqh |
//|                                                    Akimasa Ohara |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Akimasa Ohara"
#property link      ""
#property version   "1.00"


class DST{
public: 
   static bool           IsDST(bool IsUK, datetime inputDate);
   static int            TimeToJPTime(int currentTime, bool dst);
};




// 入力の日付がサマータイムかどうかを判定する処理
static bool DST::IsDST(bool isUK, datetime inputDate){
   bool dst;
   
   MqlDateTime inputDateStruct;
   TimeToStruct(inputDate, inputDateStruct);
   
   datetime startDate, endDate;
   MqlDateTime startDateStruct, endDateStruct;
   
   string strYear = IntegerToString(inputDateStruct.year);
   string strMon = IntegerToString(inputDateStruct.mon);
   string strDay = IntegerToString(inputDateStruct.day);

   // 2007以降米国式
   if(!isUK && inputDateStruct.year >= 2007){
      TimeToStruct(StringToTime(strYear + ".3.14"),startDateStruct);
      startDate = StringToTime(strYear + ".3." + (string)(14 - startDateStruct.day_of_week));
      TimeToStruct(StringToTime(strYear + ".11.7"),endDateStruct);
      endDate = StringToTime(strYear + ".11." + (string)(7 - startDateStruct.day_of_week));
      
   }else{
      // 英国式
      if(isUK){
         TimeToStruct(StringToTime(strYear + ".3.31"),startDateStruct);
         startDate = StringToTime(strYear + ".3." + (string)(31 - startDateStruct.day_of_week));
      // 2006以前の米国式
      }else{
         TimeToStruct(StringToTime(strYear + ".4.7"),startDateStruct);
         startDate = StringToTime(strYear + ".4." + (string)(7 - startDateStruct.day_of_week));
      }

      TimeToStruct(StringToTime(strYear + ".10.31"),endDateStruct);
      endDate = StringToTime(strYear + ".10." + (string)(31 - startDateStruct.day_of_week));
   }

   // サマータイム判定
   if(inputDate >= startDate && inputDate < endDate) dst = true;
   else dst = false;

   return(dst);
}

// 入力された時間を日本時間に変換する処理
static int DST::TimeToJPTime(int currentTime, bool dst){
   int jpTime;
   
   if(dst){
      jpTime = currentTime + 6;
   }else{
      jpTime = currentTime + 7;
   }
   
   return(jpTime);
}