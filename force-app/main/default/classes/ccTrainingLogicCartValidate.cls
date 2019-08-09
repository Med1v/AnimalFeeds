global with sharing class ccTrainingLogicCartValidate extends ccrz.ccLogicCartValidate{ 

  private Decimal creditOverride {get; set;}

  private Boolean checkAccountCreditLimit(Map<String, Object> inputData) {
    Decimal accountCreditLimit = ccrz.cc_CallContext.currAccount.CreditLimit__c;
    List<Object> cartObjList = (List<Object>) inputData.get(ccrz.ccApiCart.CART_OBJLIST);
    ccrz__E_Cart__c cartRecord = (ccrz__E_Cart__c) cartObjList.get(0);
    creditOverride = cartRecord.CreditOverride__c; 

    if (cartRecord.ccrz__SubTotalAmount__c <= accountCreditLimit
        || cartRecord.ccrz__SubTotalAmount__c <= creditOverride) { 
      return true;
    } else {
      return false;
    }
  }

  global override Map<String, Object> processValidate(Map<String, Object> inputData) {
    Map<String, Object> cartFetchRequest = new Map<String, Object>(inputData);
    cartFetchRequest.put(ccrz.ccApi.SIZING,
        new Map<String, Object> {
            ccrz.ccApiCart.ENTITYNAME => new Map<String, Object> {
                ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L // LARGE is the smallest size OOTB that will return for us SubtotalAmount__c
                ,ccrz.ccApi.SZ_ASSC => FALSE // for this override we are only interested in total amount and not any details of individual line items
                ,ccrz.ccApi.SZ_SKIPTRZ => TRUE // skip transform so, we can work directly with the sObject record here in the backend.
            }
        }
    );

    Map<String, Object> cartFetchResponse = ccrz.ccApiCart.fetch(cartFetchRequest);
    Boolean shouldAllowCheckout = checkAccountCreditLimit(cartFetchResponse);

    List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();

    if(!shouldAllowCheckout) {
      ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
      msg.labelId              = 'CCTraining_CreditExceeded';
      msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM;
      msg.severity             = ccrz.cc_bean_Message.MessageSeverity.ERROR;
      msg.classToAppend        = 'messagingSection-Info';

      retMessages.add(msg);
    } else if (creditOverride > 0.0) { 
      ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
      msg.labelId              = 'CCTraining_CreditOverrideApproved';
      msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM;
      msg.severity             = ccrz.cc_bean_Message.MessageSeverity.INFO;
      msg.classToAppend        = 'messagingSection-Info';

      retMessages.add(msg);
    }

    inputData.put(ccrz.ccApiCart.ALLOW_CHECKOUT, shouldAllowCheckout);
    inputData.put(ccrz.ccApi.MESSAGES, retMessages);

    return inputData;
  }
}