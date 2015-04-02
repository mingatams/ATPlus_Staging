public with sharing class PageRedirectController {
    
    private ID id;
	
    public PageRedirectController(ApexPages.StandardController stdController) {
        id = stdController.getId();
    }
    
    public PageRedirectController() {}
	
    public PageReference redirectAAPlanDetailView(){
        PageReference redirect = Page.AAPlanDetailView;
        redirect.getParameters().put('id', id);
        redirect.setRedirect(true);
        return redirect;
    }
	
    public PageReference redirectAAPlanDetailEdit(){
        PageReference redirect = Page.AAPlanDetailEdit;
        redirect.getParameters().put('id', id);
        redirect.setRedirect(true);
        return redirect;
    }
    
    public PageReference redirectAAPlanView(){
        PageReference redirect = Page.AAPlanList;
        redirect.getParameters().put('PlanId', id);
        redirect.setRedirect(true);
        return redirect;
    }
    
    public PageReference redirectSfReports(){
        PageReference redirect = new PageReference('/00O/o');
        redirect.setRedirect(true);
        return redirect;
    }
}