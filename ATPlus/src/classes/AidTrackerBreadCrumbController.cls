public with sharing class AidTrackerBreadCrumbController {

    public AidTrackerBreadCrumbController() {}
//HOME » WHAT WE DO » AGRICULTURE AND FOOD SECURITY
    public String getWhereWeWorkLink() {
        String l = ApexPages.currentPage().getParameters().get('l');
        String w = ApexPages.currentPage().getParameters().get('w');
        String s = ApexPages.currentPage().getParameters().get('s');
        String html = '<a href="http://www.usaid.gov/">Home</a> » ';
        if (!String.isBlank(s)) {
            html += '<a href="http://www.usaid.gov/what-we-do/">What We Do</a>';
            List<Sector__c> ss = [SELECT secCode__c, secName__c, secBannerURL__c FROM Sector__c WHERE secCode__c = :s];
            if (ss != null && ss.size() > 0) {
                html += ' » <a href="' + ss[0].secBannerURL__c + '">' + ss[0].secName__c + '</a>';
            }
        } else {            
            html += '<a href="http://www.usaid.gov/where-we-work/">Where We Work</a>';
            if (l == 'local' && !String.isBlank(w)) {
                List<orgUnitGeography__c> geos = [SELECT orgUnitId__r.ouWebSiteURL__c FROM orgUnitGeography__c
                                                  WHERE cntryCode__c = :w
                                                  OR cntryName__c = :w];                
                if (geos != null && geos.size() > 0 && !String.isBlank(geos[0].orgUnitId__r.ouWebSiteURL__c)) {
                    String clink = geos[0].orgUnitId__r.ouWebSiteURL__c;
                    String c = clink.substringAfterLast('/');
                    String rLink = clink.substringBeforeLast('/');
                    String r = rLink.substringAfterLast('/');
                    r = r.replace('-', ' ').toUpperCase();
                    html += ' » <a href="' + rLink + '">' + r + '</a> » <a href="' + cLink + '">' + c + '</a>';
                }                                             
            } else if (l == 'regional' && !String.isBlank(w)) {
                List<geoRegion__c> regs = [SELECT regCode__c, regName__c, regWebSiteURL__c, regBounds__c 
                                            FROM geoRegion__c 
                                            WHERE regCode__c = :w
                                            OR regName__c = :w];
                if (regs != null && regs.size() > 0 && !String.isBlank(regs[0].regWebSiteURL__c)) {
                    String rlink = regs[0].regWebSiteURL__c;
                    String r = rLink.substringAfterLast('/');
                    r = r.replace('-', ' ').toUpperCase();
                    html += ' » <a href="' + rLink + '">' + r + '</a>';         
                }
            } 
        }
        html += ' » Interactive Map';         
        return html;
    }
    
    
    
   // @IsTest(SeeAllData=true)
 @IsTest public static void testAll() {
            ClsTestUtility testIndicatorUtil = new ClsTestUtility();
            String OrgUnitId = testIndicatorUtil.getOrgUnitForBureauId(testIndicatorUtil.getBureauId());            
            GeoRegion__c gr = testIndicatorUtil.getGeoRegion();
            GeoCountry__c gc = testIndicatorUtil.getGeoCountry(gr.Id);
            OrgUnitGeography__c og = testIndicatorUtil.getOrgUnitGeography(OrgUnitId,gc.Id);
            Sector__c ss = testIndicatorUtil.getSector();
            Map<String, String> x = ApexPages.currentPage().getParameters();
            x.put('l', 'local');
            x.put('w', 'India');
          //  x.put('s','Global Health');
            AidTrackerBreadCrumbController c = new AidTrackerBreadCrumbController();
           // System.assertEquals('http://www.usaid.gov/where-we-work/asia/india', c.getWhereWeWorkLink());
            System.assertEquals('<a href="http://www.usaid.gov/">Home</a> » <a href="http://www.usaid.gov/where-we-work/">Where We Work</a> » <a href="http://www.usaid.gov/where-we-work/asia">ASIA</a> » <a href="http://www.usaid.gov/where-we-work/asia/india">india</a> » Interactive Map', c.getWhereWeWorkLink()); 
            x.put('l', 'regional');
            x.put('w', 'ASIA');
            c = new AidTrackerBreadCrumbController();
           // System.assertEquals('http://www.usaid.gov/where-we-work/asia', c.getWhereWeWorkLink());
           System.assertEquals('<a href="http://www.usaid.gov/">Home</a> » <a href="http://www.usaid.gov/where-we-work/">Where We Work</a> » <a href="http://www.usaid.gov/where-we-work/asia">ASIA</a> » Interactive Map', c.getWhereWeWorkLink());
          x.put('s','GH');
           c.getWhereWeWorkLink();
        }
    
}