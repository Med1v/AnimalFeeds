global with sharing class ccTrainingLogicCartAddTo extends ccrz.ccLogicCartAddTo 
{
   global virtual override Map<String,Object> processInputData(Map<String,Object> inputData) 
   {
        Boolean restrictedProduct = false;

        String couponCode = (String)inputData.get(ccrz.ccAPICart.COUPON_CODE);

        if(!ccrz.ccUtil.isKeyValued(inputData, ccrz.ccApiCart.COUPON_CODE)) 
        {
           List<Object> incomingLineData = (List<Object>) inputData.get(ccrz.ccApiCart.LINE_DATA);

            Set<String> productSkuSet = new Set<String>();

            Set<String> productIdSet = new Set<String>();

            for(Object lineData : incomingLineData)
            {
                Map<String, Object> castlineData = (Map<String, Object>) lineData;

                String prodId = (String)castlineData.get('productId');
                String prodSku = (String)castlineData.get('sku');

                if(!String.isEmpty(prodId))
                {
                    productIdSet.add(prodId);
                }
                else if(!String.isEmpty(prodSku))
                {
                    productSkuSet.add(prodSku);
                }
            }

            Map<String, Object> inputMap = new Map<String, Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccAPI.SIZING => new Map<String, Object>{
                    ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                            ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                    }
                }
            };

            if(productIdSet.size() > 0)
            {
                inputMap.put(ccrz.ccApiProduct.PRODUCTIDLIST, productIdSet);
            }
            else if(productSkuSet.size() > 0)
            {
              inputMap.put(ccrz.ccApiProduct.PRODUCTSKULIST, productSkuSet);
            }

            Map<String, Object> productData = ccrz.ccAPIProduct.fetch(inputMap); 

            List<Map<String, Object>> outputProductList = (List<Map<String, Object>>) productData.get(ccrz.ccAPIProduct.PRODUCTLIST);

            if(outputProductList[0].get('material') != null) 
            {
                String restrictedProdMaterial = (String) outputProductList[0].get('material');

                if(!String.isEmpty(restrictedProdMaterial))
                {
                    
                    Map<String,Object> accountData = ccrz.ccApiAccount.fetch(new Map<String,Object>{
                        ccrz.ccApi.API_VERSION => inputData.get(ccrz.ccApi.API_VERSION),
                        ccrz.ccApiAccount.ID => ccrz.cc_CallContext.effAccountId,
                        ccrz.ccAPI.SIZING => new Map<String, Object>{
                            ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                            }
                        }
                    });

                    List<Map<String, Object>> outputAccountList = (List<Map<String, Object>>) accountData.get(ccrz.ccAPIAccount.ACCOUNTS); 

                    if(outputAccountList[0].get('restrictedMaterial') != null) 
                    {
                        String restrictedMaterialAccount = (String) outputAccountList[0].get('restrictedMaterial'); 

                        if(!String.isEmpty(restrictedMaterialAccount))
                        {
                            if(restrictedMaterialAccount.equals(restrictedProdMaterial)) 
                            {
                                ccrz.cclog.log('restricted product for account'); 

                                restrictedProduct = true;
                            }
                        }
                    }
                 }
            }
        }

        // empty out the line item data if the product is restricted
        if (restrictedProduct)
        {
            
            inputData.put(ccrz.ccAPICart.LINE_DATA,null);
        }

        return super.processInputData(inputData);
   }

}