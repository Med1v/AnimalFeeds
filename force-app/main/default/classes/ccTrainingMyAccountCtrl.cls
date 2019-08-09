global with sharing class ccTrainingMyAccountCtrl 
{
    global Decimal remainingCredit{get;private set;} 
    
    global String userCurrency{get;private set;} 
    
    global ccTrainingMyAccountCtrl() 
    {
        
        List<Object> acctRes = (List<Object>)ccrz.ccApiAccount.fetch(new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiAccount.ID => ccrz.cc_CallContext.currAccountId,
                ccrz.ccApi.SIZING=>new Map<String, Object>{
                    ccrz.ccApiAccount.ENTITYNAME => new Map<String, Object>{
                        ccrz.ccAPI.SZ_SKIPTRZ=>true
                    }
                }
        }).get(ccrz.ccApiAccount.ACCOUNTS);
        
        Account account = null;
        
        if(acctRes.get(0) != null)
        {
            account = (Account)acctRes.get(0);
            
            remainingCredit = account.CreditLimit__c; 
        }
        
        userCurrency = ccrz.cc_CallContext.userCurrency; 
    }
}