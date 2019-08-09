global with sharing class ccTrainingServiceAccount extends ccrz.ccServiceAccount 
{
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) 
    {
        inputData = super.getFieldsMap(inputData); 

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS); 

        objectFields += ',RestrictedMaterial__c,CreditLimit__c' ; 

        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields}; 
    }
}