global with sharing class ccAnimal_hk_UserInterface extends ccrz.cc_hk_UserInterface.v004 {
    global override virtual String standardIncludes() {
        String str = super().standardIncludes();
        str += '<script type="text/javascript" src="'+resourcePath(CCThemeAnimal, 'js/material-components-web.js')+'"></script>\n';
        rerturn str;
    }
}
