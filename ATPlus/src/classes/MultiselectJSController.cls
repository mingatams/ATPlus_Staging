public with sharing class MultiselectJSController {

  @RemoteAction
  public static Map<String, String[]> getOpUnitDependencies() {
    Map<String, String[]> dependencies = new Map<String, String[]>();
    for(OperatingUnit__c ou : [Select Region__c, Name, id from operatingUnit__c order by name]) {
      String[] names = dependencies.get(ou.Region__c);
      if(names == null) {
        names = new String[]{ou.Name};
        dependencies.put(ou.Region__c, names);
      } else {
        names.add(ou.Name);
      }
    }
    return dependencies;
    /*
    dependencies.put('Afghanistan and Pakistan Mission', new String[]{
        'Afghanistan', 'Pakistan'});
    dependencies.put('Africa Mission', new String[]{
        'Angola', 'Benin', 'Burundi', 'DRC', 'Djibouti', 'East Africa', 'Ethiopia', 'Ghana', 'Guinea', 'Kenya', 'Liberia', 'Madagascar', 'Malawi', 'Mozambique', 'Namibia', 'Nigeria', 'Rwanda', 'Senegal', 'Somalia', 'South Africa', 'South Sudan', 'Sudan', 'Tanzania', 'Uganda', 'Zambia', 'Zimbabwe'});
    dependencies.put('Asia Mission', new String[]{
        'Bangladesh', 'Burma', 'Cambodia', 'Central Asian republic', 'East Timor', 'India', 'Indonesia', 'Japan', 'Kazakhstan', 'Kyrgyzstan', 'Mongolia', 'Nepal', 'Philippines', 'Regional Development Mission for Asia', 'Sri Lanka', 'Tajikistan', 'Thailand', 'Turkmenistan', 'Uzbekistan', 'Vietnam'});
    dependencies.put('Europe and Eurasia Mission', new String[]{
        'Albania', 'Armenia', 'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia/Herzegovina', 'Cyprus', 'Georgia', 'Hungary', 'Kosovo', 'Macedonia', 'Moldova', 'Montenegro', 'Russia', 'Serbia', 'Switzerland', 'Ukraine'});
    dependencies.put('Latin America and the Caribbean Mission', new String[]{
        'Barbados', 'Bolivia', 'Brazil', 'Columbia', 'Dominican Republic', 'Ecuador', 'El Salvador', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaica', 'Mexico', 'Nicaragua', 'Panama', 'Paraguay', 'Peru'});
    dependencies.put('Middle East Mission', new String[]{
        'Egypt', 'Iraq', 'Jordan', 'Lebanon', 'Morocco', 'Office of Middle East Programs', 'West Bank/Gaza', 'Yemen'});
    dependencies.put('Washington Bureau', new String[]{
        'Africa', 'Asia', 'Center for Accelerating Innovation and Impact', 'DCHA', 'E3 - Development Credit', 'E3 - Economic Policy', 'E3 - Education', 'E3 - Energy and Infrastructure', 'E3 - Forestry and Biodiversity', 'E3 - Gender Equality and Women\'s Empowerment', 'E3 - Global Climate Change', 'E3 - Land Tenure and Resource Management', 'E3 - Microenterprise and Private Enterprise Promotion', 'E3 - Planning, Learning and Coordination', 'E3 - Professional Development and Management Services', 'E3', 'E3- Trade and Regulatory Reform', 'E3 - Water', 'Europe and Eurasia', 'Food Security', 'Global Health - Country Support', 'Global Health - Health Infectious Diseases and Nutrition', 'Global Health - HIV/AIDS', 'Global Health - Population and Reproductive Health', 'Global Health - Professional Development and Management Services', 'Global Health - Programs and Planning', 'Global Health', 'Latin America and the Caribbean', 'Legislative and Public Affairs', 'M/CFO', 'M/CIO', 'M/MPBP', 'M/MS', 'M/OAA', 'Middle East', 'OFDA', 'Policy, Planning and Learning'});
    dependencies.put('Washington Independent Office', new String[]{
        'Afghanistan and Pakistan Affairs', 'Center for Faith Based Initiatives', 'Chief Operating Officer', 'Civil Rights and Diversity', 'Executive Secretariat', 'Foreign Assistance', 'General Counsel', 'Human Resource', 'Innovation and Development Alliances', 'Office of the Administrator', 'Security', 'Small and Disadvantaged Business Utilization'});
    return dependencies;
    */
  }
}