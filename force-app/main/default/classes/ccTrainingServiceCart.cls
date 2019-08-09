global with sharing class ccTrainingServiceCart extends ccrz.ccServiceCart 
{
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) 
    {
        inputData = super.getFieldsMap(inputData); 

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS); 

        objectFields += ',CreditOverride__c' ; 

        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields}; 
    }
}