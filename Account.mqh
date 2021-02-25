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

class CAccount : public CObject
  {
private:
    
protected:    
    
public:
    void          Get();         // 获取账户数据
    bool          Save();        // 保存账户信息
    double        FreeMarginCheck(string symbol,int type,double lots){return AccountFreeMarginCheck(symbol,type,lots);};
    long          Number(){return AccountInfoInteger(ACCOUNT_LOGIN);};                                                     // 交易账号,  MQL4还可使用 AccountNumber();
    ENUM_ACCOUNT_TRADE_MODE  TradeMode(){return (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);};         // 账户交易方式
    long          Leverage(){return AccountInfoInteger(ACCOUNT_LEVERAGE);};                                                // 账户杠杆，MQL4还可使用AccountLeverage();
  };
//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
void CAccount::Get()
{
   //--- Account integer properties
   account_info.login              = ::AccountInfoInteger(ACCOUNT_LOGIN);  // 交易账号,  MQL4还可使用 AccountNumber();
   account_info.trade_mode         = (ENUM_ACCOUNT_TRADE_MODE)::AccountInfoInteger(ACCOUNT_TRADE_MODE); // 账户交易方式
   account_info.leverage           = ::AccountInfoInteger(ACCOUNT_LEVERAGE);           // 账户杠杆，MQL4还可使用AccountLeverage();
   account_info.limit_orders       = ::AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);       // 最多持仓数量
   account_info.margin_so_mode     = (ENUM_ACCOUNT_STOPOUT_MODE)::AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE); // 创建订单最少使用保证金方式
   account_info.trade_allowed      = (bool)::AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);  // 是否允许账户交易
   account_info.trade_expert       = (bool)::AccountInfoInteger(ACCOUNT_TRADE_EXPERT);   // 是否允许EA交易
   account_info.margin_mode        = #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_MARGIN_MODE) #else ACCOUNT_MARGIN_MODE_RETAIL_HEDGING #endif ;  	// 预付款计算模式
   account_info.currency_digits    = #ifdef __MQL5__::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif ;  // 账户货币的小数位数
   account_info.server_type        = (::TerminalInfoString(TERMINAL_NAME)=="MetaTrader 5" ? 5 : 4);  // 交易平台类型
   account_info.server_connect     = #ifdef __MQL5__::TerminalInfoInteger(TERMINAL_CONNECTED) #else ::IsConnected() #endif;  // 是否连接交易服务器
   /*
     ACCOUNT_FIFO_CLOSE，仅限mql5可用
     表示只能通过FIFO规则平仓的一种指示。如果该属性值设为true，那么每个交易品种都将按照持仓的相同顺序进行平仓，从最早持仓的开始。如果试图以不同的顺序平仓，那么交易者将收到一个对应的错误提示。
     对于采用非锁仓持仓账户模式的账户 (ACCOUNT_MARGIN_MODE!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)，该属性值始终为false。
   */
   account_info.fifo_close         = (#ifdef __MQL5__::TerminalInfoInteger(TERMINAL_BUILD)<2155 ? false : ::AccountInfoInteger(ACCOUNT_FIFO_CLOSE) #else false #endif );
   account_info.stop_out_level     = #ifdef __MQL5__ 100 #else ::AccountStopoutLevel() #endif ;  // 强制平仓水平
   account_info.stop_out_mode      = (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);  // MQL4还可使用AccountStopoutMode();
     
   //--- Account real properties
   account_info.balance            = ::AccountInfoDouble(ACCOUNT_BALANCE); // MQL4还可使用AccountBalance();
   account_info.credit             = ::AccountInfoDouble(ACCOUNT_CREDIT);  // MQL4还可使用AccountCredit();
   account_info.profit             = ::AccountInfoDouble(ACCOUNT_PROFIT);  // MQL4还可使用AccountProfit();
   account_info.equity             = ::AccountInfoDouble(ACCOUNT_EQUITY);  // MQL4还可使用AccountEquity();
   account_info.margin             = ::AccountInfoDouble(ACCOUNT_MARGIN);  // MQL4还可使用AccountMargin();
   account_info.margin_free        = ::AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   account_info.margin_level       = ::AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   account_info.margin_so_call     = ::AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
   account_info.margin_so_so       = ::AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
   account_info.margin_initial     = ::AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);
   account_info.margin_maintenance = ::AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);
   account_info.assets             = ::AccountInfoDouble(ACCOUNT_ASSETS);
   account_info.liabilities        = ::AccountInfoDouble(ACCOUNT_LIABILITIES);
   account_info.comission_blocked  = ::AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);
   account_info.free_margin        = ::AccountFreeMarginMode();
   account_info.free_margin_mode   = ::AccountFreeMargin();
   
   //--- Account string properties
   account_info.name               = ::AccountInfoString(ACCOUNT_NAME);     // MQL4还可使用AccountName();
   account_info.server             = ::AccountInfoString(ACCOUNT_SERVER);   // MQL4还可使用AccountServer();
   account_info.currency           = ::AccountInfoString(ACCOUNT_CURRENCY); // MQL4还可使用AccountCurrency()
   account_info.company            = ::AccountInfoString(ACCOUNT_COMPANY);  // MQL4还可使用AccountCompany();
   account_info.expert_name        = ::WindowExpertName();
}
//+------------------------------------------------------------------+
//| 交易账户信息                                                     |
//+------------------------------------------------------------------+
bool CAccount::Save()
{
   Get(); // 获取当前账户信息
   // 交易账户信息
   string content = "{"
   + "\"ea_running_time\":\"" + day_time.FormatDatetime(TimeLocal()) + "\","
   + "\"ea_name\":\"" + account_info.expert_name + "\","
   + "\"name\":\"" + account_info.name + "\","
   + "\"account_number\":\"" + IntegerToString(account_info.login) + "\","
   + "\"server\":\"" + account_info.server + "\","
   + "\"server_time\":\"" + day_time.FormatDatetime(TimeCurrent()) + "\","
   + "\"connect\":\"" + IntegerToString(account_info.server_connect) + "\","
   + "\"company\":\"" + account_info.company + "\","
   + "\"balance\":\"" + DoubleToStr(account_info.balance,2) + "\","
   + "\"currency\":\"" + account_info.currency + "\","
   + "\"credit\":\"" + DoubleToStr(account_info.credit,2) + "\","
   + "\"equity\":\"" + DoubleToStr(account_info.equity,2) + "\","
   + "\"free_margin_mode\":\"" + DoubleToStr(account_info.free_margin_mode,2) + "\","
   + "\"margin_free\":\"" + DoubleToStr(account_info.free_margin,2) + "\","
   + "\"leverage\":\"" + DoubleToStr(account_info.leverage,2) + "\","
   + "\"margin\":\"" + DoubleToStr(account_info.margin,2) + "\","
   + "\"profit\":\"" + DoubleToStr(account_info.profit,2) + "\","
   + "\"stop_out_level\":\"" + DoubleToStr(account_info.stop_out_level,0) + "\","
   + "\"stop_out_mode\":\"" + IntegerToString(account_info.stop_out_mode) + "\","
   + "\"margin_level\":\"" + DoubleToStr(account_info.margin_level,2) + "\","
   + "\"limit_orders\":\"" + IntegerToString(account_info.limit_orders) + "\","
   + "\"trade_allowed\":\"" + IntegerToString(account_info.trade_allowed) + "\","
   + "\"ea_trade_allowed\":\"" + IntegerToString(account_info.trade_expert) + "\","
   + "\"account_type\":\"" + IntegerToString(account_info.trade_mode) + "\","
   + "\"margin_so_call\":\"" + DoubleToStr(account_info.margin_so_call,0) + "\","
   + "\"margin_so_so\":\"" + DoubleToStr( account_info.margin_so_so,0) + "\""
   + "}";
   // 保存账户信息到文件
   return json.Write(ACCOUNT_INFO,content);
}
