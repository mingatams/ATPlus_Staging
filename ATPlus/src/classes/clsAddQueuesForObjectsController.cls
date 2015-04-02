public class clsAddQueuesForObjectsController {

   private String grpQry {get;set;}
   public String confirmMessage {get;set;}
   public String queuesModified {get;set;}
   public String[] mySelectCObj {get;set; }
  
   
  List<QueueSobject> newQSobjects = new List<QueueSobject>();   
  Map<String,Group> allQueuesMap = new Map<String,Group>();
  Map<String,QueueSobject> existQSobjectsMap = new Map<String,QueueSobject>();
 
  public void getQueue() {  
  } 

  public PageReference addToQueue() {
      try {
  // Get all Queues.
      confirmMessage='No records inserted';
        
        List<Group> allQueues = new List<Group>([select id, Name, DeveloperName From Group Where type = 'Queue']);
        List<QueueSobject> existQSobjects = new List<QueueSobject>([Select Id, QueueId, SobjectType From QueueSobject order by QueueId]);
        
        for(Group g: allQueues){
                allQueuesMap.put(g.Id,g);               
        }
  
        for(QueueSobject qs: existQSobjects){           
                existQSobjectsMap.put((String)qs.QueueId+(String)qs.SobjectType,qs);            
        }
  
// System.debug('From VF Selected Objects:::'+mySelectCObjSelected);
// Create Queues for the Selected Objects
if (mySelectCObj.size()>0){
  for (string thisObj:mySelectCObj) {
//    System.debug('Selected Objects Loop:::'+thisObj);
        for(String qStr : allQueuesMap.keySet()){
                if (!existQSobjectsMap.containsKey(qStr+thisObj)){
                       QueueSobject q = new QueueSobject();
//                     System.Debug('Hurrah No Queue exists for this:'+thisObj);
                       q.QueueId = qStr;
                       q.SobjectType =thisObj;  
                       newQSobjects.add(q);                    
                }                
        }
    }
 System.debug('New QSobjects:::' +newQSobjects);
 insert newQSobjects;
}

} 
    
    catch (Exception e) {
      confirmMessage='FAILED: Followinig Records FAILED to Insert: '+e.getMessage();
    }
  confirmMessage='Records Successfully Inserted';
  return null; 
}

public clsAddQueuesForObjectsController(){ 
    confirmMessage='No action yet!!';
}  

/* Populate the list of Custom Objects into a dropdown list */
   public List<Selectoption> customObjects{
    get {
      if (customObjects == null) {
        customObjects = new List<Selectoption>();
        for (Schema.SObjectType typ : Schema.getGlobalDescribe().values() ){
          String sobjName = String.valueOf(typ);
           if ( sobjName.contains('__c') ) {
                    SelectOption curOption=new Selectoption(sobjName,sobjName);
                    customObjects.add(curOption);  
                }      }
            customObjects.sort();
      }
      return customObjects;          
    }
    set;
  }  
   
}