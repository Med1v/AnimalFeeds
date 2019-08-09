global with sharing  class ccTrainingProductService extends ccrz.ccServiceProduct 
{

    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) 
    {
        inputData = super.getFieldsMap(inputData); 

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS); 

        objectFields += ',Brand__c,Material__c' ;
        
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'Fields from ccTrainingProductService', objectFields);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'Fields from ccTrainingProductService', objectFields.split(',').size());

        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields}; 
    }

}