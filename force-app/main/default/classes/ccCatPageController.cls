global with sharing class ccCatPageController {
    
    // global List<Map<String, Object>> cats{get;set;}
    global String cats{get;set;}

    global ccCatPageController() {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'CATS', 'constructor');
        
        // cats = [SELECT Name//, productCount, parentCategory, sequence, ownerId, categoryID, sfid
        //         FROM ccrz__E_Category__c
        //         WHERE ccrz__CategoryID__c = 'ProductCategories'];

        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiCategory.ROOTCATEGORYID => 'ProductCategories',
            ccrz.ccAPI.SIZING => new Map<String, Object> {
                ccrz.ccApiCategory.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_L
                }
        }
        };

        Map<String, Object> outputData = ccrz.ccAPICategory.fetchCategoryTree(inputData);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'CATS', outputData);
        if (outputData.get(ccrz.ccAPICategory.CATEGORYTREE) != null) {
            // The cast to List<Map<String, Object>> is necessary...
            List<Map<String, Object>> categoryTree = (List<Map<String, Object>>) outputData.get(ccrz.ccAPICategory.CATEGORYTREE);
            // cats = categoryTree;
            cats = String.valueOf(categoryTree);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'CATS', categoryTree);
        }

        // ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'MY SUPER MESSAGE', objectFields);
    }
}
