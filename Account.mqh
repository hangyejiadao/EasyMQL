//+------------------------------------------------------------------+
//|                                                      Account.mqh |
//|                          Copyright 2021, Feng Hui Software Corp. |
//|                                           https://www.fenghui.hk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Feng Hui Software Corp."
#property link      "https://www.fenghui.hk"
#property version   "1.00"
#property strict

#include <Object.mqh>

#include <EasyMQL\Config.mqh>
#include <EasyMQL\Terminal.mqh>

CTerminal  terminal;

class CAccount : public CObject
  {
private:
    
protected:    
    
public:
    long          Number(){return AccountInfoInteger(ACCOUNT_LOGIN);};                                                     // 交易账号,  MQL4还可使用 AccountNumber();
    ENUM_ACCOUNT_TRADE_MODE  TradeMode(){return (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);};         // 账户交易方式
    long          Leverage(){return AccountInfoInteger(ACCOUNT_LEVERAGE);};                                                // 账户杠杆，MQL4还可使用AccountLeverage();
    long          LimitOrders(){return AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);};                      // 最多持仓订单数量
    ENUM_ACCOUNT_STOPOUT_MODE          MarginSoMode(){return (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);}; // 创建订单最少使用保证金方式
    bool          TradeAllowed(){return (bool)::AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);};  // 是否允许账户交易
    bool          TradeExpert(){return (bool)::AccountInfoInteger(ACCOUNT_TRADE_EXPERT);};   // 是否允许EA交易
    long          MarginMode(){return #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_MARGIN_MODE) #else ACCOUNT_MARGIN_MODE_RETAIL_HEDGING #endif ;};   	// 预付款计算模式
    long          CurrencyDigits(){return #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif ;};   // 账户货币的小数位数
   /*
     ACCOUNT_FIFO_CLOSE，仅限mql5可用
     表示只能通过FIFO规则平仓的一种指示。如果该属性值设为true，那么每个交易品种都将按照持仓的相同顺序进行平仓，从最早持仓的开始。如果试图以不同的顺序平仓，那么交易者将收到一个对应的错误提示。
     对于采用非锁仓持仓账户模式的账户 (ACCOUNT_MARGIN_MODE!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)，该属性值始终为false。
   */
    long          FifoClose(){return (#ifdef __MQL5__::TerminalInfoInteger(TERMINAL_BUILD)<2155 ? false : ::AccountInfoInteger(ACCOUNT_FIFO_CLOSE) #else false #endif );}; 
    long          StopOutLevel(){return #ifdef __MQL5__ 100 #else ::AccountStopoutLevel() #endif ;};   // 强制平仓水平
    ENUM_ACCOUNT_STOPOUT_MODE          StopOutMode(){return (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);};   // MQL4还可使用AccountStopoutMode();
     
   //--- Account real properties
    double        Balance(){return AccountInfoDouble(ACCOUNT_BALANCE);}; // MQL4还可使用AccountBalance();
    double        Credit(){return AccountInfoDouble(ACCOUNT_CREDIT);};  // MQL4还可使用AccountCredit();
    double        Profit(){return AccountInfoDouble(ACCOUNT_PROFIT);};  // MQL4还可使用AccountProfit();
    double        Equity(){return AccountInfoDouble(ACCOUNT_EQUITY);};  // MQL4还可使用AccountEquity();
    double        Margin(){return AccountInfoDouble(ACCOUNT_MARGIN);};  // MQL4还可使用AccountMargin();
    double        MarginFree(){return AccountInfoDouble(ACCOUNT_MARGIN_FREE);};
    double        MarginLevel(){return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);};
    double        MarginSoCall(){return AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);};
    double        MarginSoSo(){return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);};
    double        MarginInitial(){return AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);};
    double        MarginMaintenance(){return AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);};
    double        Assets(){return AccountInfoDouble(ACCOUNT_ASSETS);};
    double        Liabilities(){return AccountInfoDouble(ACCOUNT_LIABILITIES);};
    double        ComissionBlocked(){return AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);};
    double        FreeMargin(){return AccountFreeMarginMode();};
    double        FreeMarginMode(){return AccountFreeMargin();};
    double        FreeMarginCheck(string symbol,int type,double lots){return AccountFreeMarginCheck(symbol,type,lots);};
    
   //--- Account string properties
    string        Name(){return AccountInfoString(ACCOUNT_NAME);};     // MQL4还可使用AccountName();
    string        Server(){return AccountInfoString(ACCOUNT_SERVER);};        // MQL4还可使用AccountServer();
    string        Currency(){return AccountInfoString(ACCOUNT_CURRENCY);};    // MQL4还可使用AccountCurrency()
    string        Company(){return AccountInfoString(ACCOUNT_COMPANY);};      // MQL4还可使用AccountCompany();
    string        ExpertName(){return WindowExpertName();};                   // EA文件名称

    bool          Save();        // 保存账户信息
  };

//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
bool CAccount::Save()
{
   // 交易账户信息
   string content = "{"
   + "\"ea_running_time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\","
   + "\"ea_name\":\"" + ExpertName() + "\","
   + "\"name\":\"" + Name() + "\","
   + "\"account_number\":\"" + IntegerToString(Number()) + "\","
   + "\"server\":\"" + Server() + "\","
   + "\"server_time\":\"" + day_time.FormatDatetime(TimeCurrent()) + "\","
   + "\"connect\":\"" + IntegerToString(terminal.Connected()) + "\","
   + "\"company\":\"" + Company() + "\","
   + "\"balance\":\"" + DoubleToStr(Balance(),2) + "\","
   + "\"currency\":\"" + Currency() + "\","
   + "\"credit\":\"" + DoubleToStr(Credit(),2) + "\","
   + "\"equity\":\"" + DoubleToStr(Equity(),2) + "\","
   + "\"free_margin_mode\":\"" + DoubleToStr(FreeMarginMode(),2) + "\","
   + "\"margin_free\":\"" + DoubleToStr(MarginFree(),2) + "\","
   + "\"leverage\":\"" + DoubleToStr(Leverage(),2) + "\","
   + "\"margin\":\"" + DoubleToStr(Margin(),2) + "\","
   + "\"profit\":\"" + DoubleToStr(Profit(),2) + "\","
   + "\"stop_out_level\":\"" + DoubleToStr(StopOutLevel(),0) + "\","
   + "\"stop_out_mode\":\"" + IntegerToString(StopOutMode()) + "\","
   + "\"margin_level\":\"" + DoubleToStr(MarginLevel(),2) + "\","
   + "\"limit_orders\":\"" + IntegerToString(LimitOrders()) + "\","
   + "\"trade_allowed\":\"" + IntegerToString(TradeAllowed()) + "\","
   + "\"ea_trade_allowed\":\"" + IntegerToString(TradeExpert()) + "\","
   + "\"account_type\":\"" + IntegerToString(TradeMode()) + "\","
   + "\"margin_so_call\":\"" + DoubleToStr(MarginSoCall(),0) + "\","
   + "\"margin_so_so\":\"" + DoubleToStr(MarginSoSo(),0) + "\""
   + "}";
   // 保存账户信息到文件
   return json.Write(ACCOUNT_INFO,content);
}
