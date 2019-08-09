global without sharing class ccTraining_hk_Invoice extends ccrz.cc_hk_Invoice 
{
  global override Map<String, Object> applyPayment(Map<String, Object> inputData) 
  {
    Map<String, Object> retData = super.applyPayment(inputData); 

    Map<String, Object> invoicePaymentMap =
      (Map<String, Object>)inputData.get(ccrz.cc_hk_Invoice.PARAM_INVOICE_PAYMENTS); 

    Decimal totalAmountPaid = 0.0; 

    for (Object paymentAmountObject : invoicePaymentMap.values()) 
     {
      Decimal paymentAmountVal = Decimal.valueOf((String)paymentAmountObject);
      totalAmountPaid += paymentAmountVal.setScale(2,System.RoundingMode.HALF_EVEN); 
    }

    Account currentAccount = [SELECT CreditLimit__c FROM Account
              WHERE Id = :ccrz.cc_CallContext.currAccountId LIMIT 1]; 

    currentAccount.CreditLimit__c += totalAmountPaid; 

    update currentAccount;

    return retData; 
  }
}