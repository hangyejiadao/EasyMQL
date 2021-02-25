//+------------------------------------------------------------------+
//|                                                       Config.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>
#include <EasyMQL\Defines.mqh>
#include <EasyMQL\ToMQL4.mqh>
#include <EasyMQL\Data.mqh>
#include <EasyMQL\Json.mqh>
#include <EasyMQL\Chart.mqh>

CData    data;
CJson    json;
CChart   chart;

ORDER_PARAM       order_param;  // 订单参数
ACCOUNT_DATA      account_info; // 当前账户信息 

class CConfig : public CObject
  {
private:
   
protected:

public:
   // 设置交易配置
   void                 Set(ENUM_ORDER_PARAM name,string value);
   string               FirstSymbol(void){return order_param.first_symbol;};
   string               SecondSymbol(void){return order_param.second_symbol;};
   string               CommentPrefix(void){return order_param.comment_prefix;};   
   
  };

//+------------------------------------------------------------------+
//|     设置配置                                                     |
//+------------------------------------------------------------------+
void CConfig::Set(ENUM_ORDER_PARAM name,string value)
{
     switch(name)
     {
        case FIRST_SYMBOL:
             order_param.first_symbol = value;
             break;
        case SECOND_SYMBOL:
             order_param.second_symbol = value;
             break;   
        case COMMENT:
             order_param.comment_prefix = value;
             break;    
     }
     return;
}