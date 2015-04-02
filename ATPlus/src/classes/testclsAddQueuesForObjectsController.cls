@isTest(seealldata=true)
private class testclsAddQueuesForObjectsController {

static testMethod void addQueueTest() {

test.startTest();
 
clsAddQueuesForObjectsController testAQCont=new clsAddQueuesForObjectsController();

String confirmMessage='setting a message in test class';
testAQCont.confirmMessage=confirmMessage;
//confirmMessage= testAQCont.confirmMessage;

List<Selectoption> testSO = new List<Selectoption>();
testSO=testAQCont.customObjects;

String[] mySelectCObjSelected=new List<String>{'Activity__c', 'Award_EXT__c', 'Award__c'};
List<QueueSobject> newQSobjects = new List<QueueSobject>();
QueueSobject q = new QueueSobject();

Map<String,Group> allQueuesMap = new Map<String,Group>();
Map<String,QueueSobject> existQSobjectsMap = new Map<String,QueueSobject>();

List<Group> allQueues = new List<Group>([select id, Name, DeveloperName From Group Where type = 'Queue']);
List<QueueSobject> existQSobjects = new List<QueueSobject>([Select Id, QueueId, SobjectType From QueueSobject order by QueueId]);

for(Group g: allQueues){
     allQueuesMap.put(g.Id,g);               
}

for(QueueSobject qs: existQSobjects){           
     existQSobjectsMap.put((String)qs.QueueId+(String)qs.SobjectType,qs);            
}
  

testAQCont.addToQueue();
testAQCont.getQueue();

test.stopTest();
}     
}