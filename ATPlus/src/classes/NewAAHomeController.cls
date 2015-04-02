public with sharing class NewAAHomeController {

	private Id dashboardIconId {get;set;}
	private Id helpIconId {get;set;}
	private Id planIconId {get;set;}
	private Id reportsIconId {get;set;}
	private Id headerIconId {get;set;}
	private Id announcementsIconId {get;set;}
	
	public String dashboardIconUrl {get;set;}
	public String helpIconUrl {get;set;}
	public String planIconUrl {get;set;}
	public String reportsIconUrl {get;set;}
	public String headerIconUrl {get;set;}
	public String announcementsIconUrl {get;set;}
	
	public NewAAHomeController(){
		getIconIds();
		setIconUrls();
	}
	
	private void getIconIds(){
		List<Document> iconList = [SELECT Id, DeveloperName FROM Document WHERE DeveloperName 
									IN ('A_A_Planning_Home_Dashboard_Icon','A_A_Planning_Home_Help_Icon',
										'A_A_Planning_Home_Plan_Icon','A_A_Planning_Home_Reports_Icon',
										'A_A_Planning_Home_Announcements','A_A_Planning_Home_Header')];
		
		for( Document doc : iconList ){
			if(doc.DeveloperName == 'A_A_Planning_Home_Dashboard_Icon'){
				dashboardIconId = doc.Id;
			}
			if(doc.DeveloperName == 'A_A_Planning_Home_Help_Icon'){
				helpIconId = doc.Id;
			}
			if(doc.DeveloperName == 'A_A_Planning_Home_Plan_Icon'){
				planIconId = doc.Id;
			}
			if(doc.DeveloperName == 'A_A_Planning_Home_Reports_Icon'){
				reportsIconId = doc.Id;
			}
			if(doc.DeveloperName == 'A_A_Planning_Home_Announcements'){
				announcementsIconId = doc.Id;
			}
			if(doc.DeveloperName == 'A_A_Planning_Home_Header'){
				headerIconId = doc.Id;
			}
		}
	}
	
	private void setIconUrls(){
		dashBoardIconUrl = '/servlet/servlet.FileDownload?file=' + dashboardIconId;
		helpIconUrl = '/servlet/servlet.FileDownload?file=' + helpIconId;
		planIconUrl = '/servlet/servlet.FileDownload?file=' + planIconId;
		reportsIconUrl = '/servlet/servlet.FileDownload?file=' + reportsIconId;
		headerIconUrl = '/servlet/servlet.FileDownload?file=' + headerIconId;
		announcementsIconUrl = '/servlet/servlet.FileDownload?file=' + announcementsIconId;
 	}
}