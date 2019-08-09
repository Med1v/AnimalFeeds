global without sharing class ccTraining_hk_Order extends ccrz.cc_hk_Order 
{

  private void updateAccountCreditLimitForOrder(ccrz__E_Order__c currentOrder) 
  {
    Account currentAccount = [SELECT CreditLimit__c FROM Account
                              WHERE Id = :currentOrder.ccrz__Account__c LIMIT 1]; 

    ccrz__E_Order__c refetchedOrder = [SELECT ccrz__TotalAmount__c FROM ccrz__E_Order__c
                                    WHERE Id = :currentOrder.Id LIMIT 1]; 

    Decimal orderTotal = refetchedOrder.ccrz__TotalAmount__c;
    currentAccount.CreditLimit__c -= orderTotal; 

    update currentAccount;
  }


  global override Map<String, Object> place(Map<String, Object> inputData) 
  {
    String currentStep = (String) inputData.get(ccrz.cc_hk_Order.PARAM_PLACE_STEP);

    if (ccrz.cc_hk_Order.STEP_END.equals(currentStep)) 
     {
      ccrz__E_Order__c currentOrder =
        (ccrz__E_Order__c)inputData.get(ccrz.cc_hk_Order.PARAM_ORDER);

        
      updateAccountCreditLimitForOrder(currentOrder);
    }
    return inputData; 
  }


}