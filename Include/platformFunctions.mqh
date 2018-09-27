#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>  
#include <Trade\OrderInfo.mqh>  
CPositionInfo  m_position;                   // trade position object
CTrade         m_trade;                      // trading object
CSymbolInfo    m_symbol;                     // symbol info object
COrderInfo     m_order;

int orderBuyCount(string sym){
 int count = 0;
 for(int i=OrdersTotal()-1;i>=0;i--) // returns the number of current orders
      if(m_order.SelectByIndex(i)){    // selects the pending order by index for further access to its properties
         
         if(m_order.Symbol() == sym && m_order.OrderType()==ORDER_TYPE_BUY_LIMIT ){
            
            count++;
          }    
      } 
   return(count);
}
int orderSellCount(string sym){
   int count = 0;
    for(int i=OrdersTotal()-1;i>=0;i--) // returns the number of current orders
         if(m_order.SelectByIndex(i)){    // selects the pending order by index for further access to its properties
            
             if(m_order.Symbol() == sym && m_order.OrderType()==ORDER_TYPE_SELL_LIMIT ){
               count++;
             }    
         } 
      return(count);
}


string getPositions(){
      string msg = "";
      
   // how many positions do we have
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(m_position.SelectByIndex(i)){
      
      string sym = m_position.Symbol();
      
         // Build the message string
        msg += "\n" +   sym +" "+ DoubleToString(m_position.PriceCurrent(),8) +         "\n"+
        "Entry: " +  DoubleToString( m_position.PriceOpen(),8)  +"\n"+
        "Profit: " +  DoubleToString( m_position.Profit(),8)  +"\n"+
        "Size: " +  DoubleToString( m_position.Volume(),1)  +"\n"+
      //  "Swap: " +  DoubleToString( m_position.Swap(),8)  +"\n"+ // not needed for Crypto
        
        "Action: /close" +  IntegerToString(m_position.Ticket() )  +"\n"+
        "Action: /delete" +  sym + " ("+ IntegerToString(orderBuyCount(sym)) +"|" + IntegerToString(orderSellCount(sym)) + ")" +"\n"+
        
        "";
        
       }
    }
  return(msg);
}

void closePosition(long ticket_number){
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(m_position.SelectByIndex(i)){
      
         if( m_position.Ticket() == ticket_number){
         
               m_trade.PositionClose(ticket_number,0);
               
         }
      
      }
   
   }

}

int deleteOrders(string sym){
   int count = 0;
   for(int i=OrdersTotal()-1;i>=0;i--) // returns the number of current orders
      if(m_order.SelectByIndex(i)){    // selects the pending order by index for further access to its properties
         
         if(m_order.Symbol() == sym){
            // delete all orders
             m_trade.OrderDelete(m_order.Ticket());
             count++;
          }    
      } 
      return(count);
}

string getUserAccount(){
   string id_Server = AccountInfoString(ACCOUNT_SERVER);
   long id_Login = AccountInfoInteger(ACCOUNT_LOGIN);
   string id_Currency = AccountInfoString(ACCOUNT_CURRENCY);
   double id_Acc = AccountInfoDouble(ACCOUNT_PROFIT);
   double id_Bal = AccountInfoDouble(ACCOUNT_BALANCE);
   string msg = "";
   
   msg = "Profit/Loss: "+DoubleToString(id_Acc,8) + " ("+id_Currency+")"+  " (" + DoubleToString((id_Acc/id_Bal)*100,1) + "% PNL)"   +   "\n"+
                     "Balance: " + DoubleToString(id_Bal,8) + "\n"+
                     "Equity: " + DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),8)+"\n"+
                     "Free Margin: " + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_FREE),8)+"\n"+
                     "\n"+
                     "Server: " + id_Server + "\n"+
                     "Account: " + IntegerToString(id_Login) + "\n\n"+
                     
                      getPositions();
        
        return(msg);             

}
