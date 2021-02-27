//+------------------------------------------------------------------+
//|                                                         Time.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>
#include <EasyMQL\Defines.mqh>

class CDayTime : public CObject
  {
private:
     datetime        NowTime();

protected:
    // 指定日期的日开始、结束时间
    datetime         DayBeginTime(datetime time);                          // 日开始时间
    datetime         DayEndTime(datetime time){return DayBeginTime(time) + ONE_DAY_TIME - 1;};                // 日结束时间    
    datetime         LastDayBeginTime(datetime time){return DayBeginTime(time) - ONE_DAY_TIME;};              // 下一日开始时间
    datetime         LastDayEndTime(datetime time){return DayBeginTime(time)-1;};                             // 下一日结束时间
    // 指定日期的周开始、结束时间
    datetime         WeekBeginTime(datetime time);
    datetime         WeekEndTime(datetime time){return WeekBeginTime(time) + ONE_DAY_TIME * 7 - 1;};
    datetime         LastWeekBeginTime(datetime time){return WeekBeginTime(time) - ONE_DAY_TIME * 7;};
    datetime         LastWeekEndTime(datetime time){return WeekBeginTime(time)-1;};    
    datetime         Last7DaysBeginTime(datetime time){return DayBeginTime(time) - ONE_DAY_TIME * 7;};
    datetime         Last7DaysEndTime(datetime time){return DayBeginTime(time)-1;};
    // 指定月份的日开始、结束时间
    datetime         MonthBeginTime(datetime time);       // 月开始时间
    datetime         MonthEndTime(datetime time);                                                                                                      // 月结束时间
    datetime         LastMonthBeginTime(datetime time);                                                                                                // 下一月开始时间
    datetime         LastMonthEndTime(datetime time){return MonthEndTime(LastMonthBeginTime(time));};                                                  // 下一月结束时间
    // 指定年份的日开始、结束时间
    datetime         YearBeginTime(datetime time);     // 年开始时间
    datetime         YearEndTime(datetime time);       // 年结束时间
    datetime         LastYearBeginTime(datetime time); // 下一年开始时间
    datetime         LastYearEndTime(datetime time);   // 下一年结束时间
                           
public:    
    string           FormatDatetime(datetime time);   // 时间格式化 （使用 - 分隔时间）
    
    // 日期的起始和结束时间
    datetime         DayBegin(datetime time){return DayBeginTime(time);};                // 日开始时间
    datetime         DayEnd(datetime time){return DayEndTime(time);};                    // 日开始时间    
    datetime         TodayBegin(){return DayBeginTime(NowTime());};                      // 今日开始时间
    datetime         TodayEnd(){return DayEndTime(NowTime());};                          // 今日结束时间
    datetime         YesterdayBegin(){return LastDayBeginTime(NowTime());};              // 昨日开始时间 
    datetime         YesterdayEnd(){return LastDayEndTime(NowTime());};                  // 昨日结束时间  
    datetime         LastDayBegin(datetime time){return LastDayBeginTime(time);};        // 上一日开始时间
    datetime         LastDayEnd(datetime time){return LastDayEndTime(time);};            // 上一日开始时间
    // 周的起始和结束时间
    datetime         WeekBegin(datetime time){return WeekBeginTime(time);};
    datetime         WeekEnd(datetime time){return WeekEndTime(time);};
    datetime         CurrentWeekBegin(){return WeekBeginTime(NowTime());};
    datetime         CurrentWeekEnd(){return WeekEndTime(NowTime());};
    datetime         LastWeekBegin(datetime time){return LastWeekBeginTime(time);};
    datetime         LastWeekEnd(datetime time){return LastWeekEndTime(time);};
                     // 前7日的开始和结束时间(不包括当日)
    datetime         Last7DaysBegin(datetime time){return Last7DaysBeginTime(time);};
    datetime         Last7DaysEnd(datetime time){return Last7DaysEndTime(time);};
    // 月份的起始和结束时间
    datetime         MonthBegin(datetime time){return MonthBeginTime(time);};                 // 月开始时间
    datetime         MonthEnd(datetime time){return MonthEndTime(time);};                     // 月结束时间
    datetime         CurrentMonthBegin(){return MonthBeginTime(NowTime());};                  // 本月开始时间
    datetime         CurrentMonthEnd(){return MonthEndTime(NowTime());};                      // 本月结束时间         
    datetime         LastMonthBegin(datetime time){return LastMonthBeginTime(time);};         // 上一月开始时间
    datetime         LastMonthEnd(datetime time){return LastMonthEndTime(time);}; 
    // 年份的起始和结束时间
    datetime         YearBegin(datetime time){return YearBeginTime(time);};     
    datetime         YearEnd(datetime time){return YearEndTime(time);};
    datetime         CurrentYearBegin(){return YearBeginTime(NowTime());};     
    datetime         CurrentYearEnd(){return YearEndTime(NowTime());};   
    datetime         LastYearBegin(datetime time){return LastYearBeginTime(time);};            // 上一年开始时间
    datetime         LastYearEnd(datetime time){return LastYearEndTime(time);};                // 上一年开始时间
    
  };
//+------------------------------------------------------------------+
//| 当前时间                                                         |
//+------------------------------------------------------------------+
datetime CDayTime::NowTime()
{
       datetime time = TimeCurrent();
       if(TRADER_TIME>TimeCurrent())
       {
          time = TRADER_TIME;
       }
       return time;
}
//+------------------------------------------------------------------+
//| 日开始时间                                                       |
//+------------------------------------------------------------------+
datetime CDayTime::DayBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);  
   return StringToTime(IntegerToString(mql_time.year)+"."+IntegerToString(mql_time.mon)+"."+IntegerToString(mql_time.day));
}
//+------------------------------------------------------------------+
//| 指定时间当月的开始时间                                           |
//+------------------------------------------------------------------+
datetime CDayTime::MonthBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);   
   return StringToTime(IntegerToString(mql_time.year)+"."+IntegerToString(mql_time.mon)+".01");
}
//+------------------------------------------------------------------+
//| 指定时间当月的最后时间                                           |
//+------------------------------------------------------------------+
datetime CDayTime::MonthEndTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);  
   int year = mql_time.year;
   int month = mql_time.mon;
   int next_month;
   int next_month_year;
   if(month==12)
   {
      next_month = 1;
      next_month_year  = year + 1;
   } else {
      next_month = month + 1;
      next_month_year  = year;
   }
   string next_month_str;
   if(next_month<10)
   {
     next_month_str = "0"+IntegerToString(next_month);
   } else {
     next_month_str = IntegerToString(next_month);
   }
   datetime next_month_time = StringToTime(IntegerToString(next_month_year)+"."+next_month_str+".01") -1;
   return next_month_time;
}
//+------------------------------------------------------------------+
//| 指定时间上一月的开始时间                                         |
//+------------------------------------------------------------------+
datetime CDayTime::LastMonthBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time); 
   int year = mql_time.year;
   int month = mql_time.mon;
   int last_month;
   int last_month_year;
   if(month==1)
   {
      last_month = 12;
      last_month_year = year -1;
   } else {
      last_month = month -1 ;
      last_month_year = year;   
   }
   string last_month_str;
   if(last_month<10)
   {
     last_month_str = "0"+IntegerToString(last_month);
   } else {
     last_month_str = IntegerToString(last_month);
   }   
   datetime next_month_time = StringToTime(IntegerToString(last_month_year)+"."+last_month_str+".01");
   return next_month_time;
}
//+------------------------------------------------------------------+
//| 指定时间周的开始时间                                             |
//+------------------------------------------------------------------+
datetime CDayTime::WeekBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);  
   int day_of_week = mql_time.day_of_week;
   if(day_of_week==0)
   {
      day_of_week = 7;
   }
   return DayBegin(time) - (day_of_week -1) * ONE_DAY_TIME;
}
//+------------------------------------------------------------------+
//| 指定年的开始时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::YearBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time); 
   return StringToTime(IntegerToString(mql_time.year)+".01.01");
}
//+------------------------------------------------------------------+
//| 指定年的结束时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::YearEndTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   return StringToTime(IntegerToString(mql_time.year)+".12.31");
}
//+------------------------------------------------------------------+
//| 下一年的开始时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::LastYearBeginTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   return StringToTime(IntegerToString(mql_time.year-1)+".01.01");
}
//+------------------------------------------------------------------+
//| 下一年的结束时间                                                 |
//+------------------------------------------------------------------+
datetime CDayTime::LastYearEndTime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   return StringToTime(IntegerToString(mql_time.year-1)+".12.31");
}
//+------------------------------------------------------------------+
//| 格式化时间：使用 - 分隔 YYYY-MM-DD h:i:s                         |
//+------------------------------------------------------------------+
string CDayTime::FormatDatetime(datetime time)
{
   MqlDateTime mql_time;
   TimeToStruct(time,mql_time);
   string time_str = IntegerToString(mql_time.year)+"-"+IntegerToString(mql_time.mon)+"-"+IntegerToString(mql_time.day)
                     +" "+IntegerToString(mql_time.hour)+":"+IntegerToString(mql_time.min)+":"+IntegerToString(mql_time.sec);
   return time_str;
}