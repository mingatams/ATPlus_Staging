public with sharing class ClsCDCSTree {
    /* Gloabl Variables */
    public string paramId{get;set;}
    public List<TreeNode> lnkTree{get;set;}
    public CDCSLINK__c cdcs{get;set;}
    Public String ShowErrors{get;set;}
    Public String ouName{get;set;} 
    Public String Title{get;set;}
    Public String Legend{get;set;}
    
    
    /* Default Constructor */     
    public ClsCDCSTree(){
        lnkTree = new List<TreeNode>();
        
        if (ApexPages.currentPage().getParameters().get('Lid')!=null){
            paramId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('Lid'));
            system.debug('Here is IR/SIR/DO Id------------------------------>' + paramId);
        } 
        
        //Determine the Object Name based on the Record Id received.
        String keyCode  = (string)paramId.subString(0,3);
        String objectName;
        system.debug(' Object Key Code ----------------->' + keyCode);        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(Schema.SObjectType objectInstance : gd.values()){
            if(keyCode.equals(objectInstance.getDescribe().getKeyPrefix())){
                objectName = objectInstance.getDescribe().getName();
            }
        }
        
                
        //This query needs to be limited to 1 record.        
        List<CDCSLINK__c> lnkList = new List<CDCSLINK__c>([Select DO_Code__c, DO_Id__c, DO_Title__c,
                          IR_Code__c, IR_Id__c, IR_Title__c,
                          SIR_Code__c, SIR_Id__c, SIR_Title__c, Link_Type__c, Goal_Id__c, ouId__c, ouName__c     
                    From CDCSLINK__c 
                    where  (IR_Id__c = :paramId OR DO_Id__c = :paramId OR SIR_Id__c = :paramId OR Goal_Id__c = :paramId) and (Link_Type__c = 'Primary DO' OR Link_Type__c = 'Primary IR') limit 1]);
                    
        System.debug('CDCS Record::------>' +cdcs);            
        System.debug('Obj Type::------>' +objectName);
        System.debug('CDCS List::------>' +lnkList);
        System.debug('Parm Id::------>' +paramId);
        
        ShowErrors ='false';
        
        List<DO__c> dList = new List<DO__c>([Select Id, Name, DO_Code__c, DO_Title__c, CDCS_Goal__c, ouCode__c, ouName__c from DO__C where id =:paramId OR CDCS_Goal__c=:paramId Order by DO_Code__c]);
        
        
        
      /*  if((objectName.equalsIgnoreCase('CDCSGoal__c') || objectName.equalsIgnoreCase('DO__c')) && lnkList.isEmpty()){
            if (dList.isEmpty()){
            ShowErrors ='true';
        }else{ 
                DO__c do1 = new DO__c();
                do1=[select id, Do_Code__c, Do_Title__c, CDCS_Goal__c, ouId__c, ouName__c from DO__c where id =: paramId OR CDCS_Goal__c=:paramId];
                ouName = do1.ouName__c;
                If(objectName.equalsIgnoreCase('CDCSGoal__c')){
                    Title='Overall';
                    CDCSGoal__c cg = new CDCSGoal__c();
                    cg = [select id, Name, Goal_statement__c From CDCSGoal__c where id =: do1.CDCS_Goal__c];
                    lnkTree.add(new TreeNode(cg.id,'Goal',(String)cg.Goal_statement__c,'Main',false,false,'G'));
                    set<string> doIds1 = new set<string>{};
                    for(Do__c d: dList){
                        doIds1.add(d.id);
                        lnkTree.add(new TreeNode((String)d.id,(String)d.DO_Code__c,(String)d.Do_Title__c,(String)cg.id,false,false,'D'));
                    }
                } else {
                    lnkTree.add(new TreeNode((String)do1.id,(String)do1.DO_Code__c,(String)do1.Do_Title__c,(String)do1.id,false,false,'D'));
                    Title=do1.DO_Code__c;
                }
            }
        
        } */
        
        if(!lnkList.isEmpty()){
            /*cdcs = [Select ouId__c, ouName__c From CDCSLINK__c 
                    where  (IR_Id__c = :paramId OR DO_Id__c = :paramId OR SIR_Id__c = :paramId 
                    OR Goal_Id__c = :paramId) limit 1];
                    
             ouName = cdcs.ouName__c; */
             
            CDCSLINK__c cl = lnkList[0];
            //ouName = (String)c1.ouName__c;
           // DO__c dd = new DO__c();
           // dd = [select id, Do_Code__c, Do_Title__c, CDCS_Goal__c, ouId__c from DO__c where id = :cl.DO_Id__c];
            if (objectName.equalsIgnoreCase('Sub_Ir__c') || objectName.equalsIgnoreCase('Ir__c') || objectName.equalsIgnoreCase('DO__c')){
               //Following process is to display Three levels up including SIR level.
               Title = (String)cl.DO_Code__c + ' Results Framework for: ' +(String)cl.ouName__c;
               Legend='DLegend'; 
               lnkTree.add(new TreeNode((String)cl.DO_Id__c,(String)cl.DO_Code__c,(String)cl.Do_Title__c,'Main',false,false,'D'));
                
               List<CDCSLINK__c> lnkList11 = new List<CDCSLINK__c>([Select DO_Code__c, DO_Id__c, DO_Title__c,
                                                    IR_Code__c, IR_Id__c, IR_Title__c,SIR_Code__c, SIR_Id__c, SIR_Title__c, Link_Type__c                                
                                        From CDCSLINK__c where DO_Id__c = :cl.DO_Id__c order by IR_Code__c, SIR_Code__c]);
                    
                for(CDCSLINK__c cd: lnkList11){
                    if(cd.SIR_Id__c == null){
                        if (cd.Link_Type__c == 'Secondary Do'){                     
                        lnkTree.add(new TreeNode('Sec'+(String)cd.IR_Id__c,(String)cd.IR_Code__c,(String)cd.IR_Title__c,(String)cd.DO_Id__c,false,true,'I'));
                        }else if (cd.Link_Type__c == 'Primary Do'){
                            lnkTree.add(new TreeNode((String)cd.IR_Id__c,(String)cd.IR_Code__c,(String)cd.IR_Title__c,(String)cd.DO_Id__c,false,false,'I'));
                        }
                    } else {
                        if (cd.Link_Type__c == 'Secondary IR'){
                            lnkTree.add(new TreeNode('Sec'+(String)cd.SIR_Id__c,(String)cd.SIR_Code__c,(String)cd.SIR_Title__c,(String)cd.IR_Id__c,false,true,'S'));
                        } else if (cd.Link_Type__c == 'Primary IR'){
                            lnkTree.add(new TreeNode((String)cd.SIR_Id__c,(String)cd.SIR_Code__c,(String)cd.SIR_Title__c,(String)cd.IR_Id__c,false,false,'S'));
                        }   
                    }
                 }
            } else {
                
                //Following logic is to display Top three level if it is a Goal
                CDCSGoal__c cg = new CDCSGoal__c();
                Title = 'Overall Results Framework for: ' + (String)cl.ouName__c;
                Legend = 'OLegend';
                cg = [select id, Name, Goal_statement__c From CDCSGoal__c where id = :cl.Goal_Id__c];
                lnkTree.add(new TreeNode(cg.id,'Goal',(String)cg.Goal_Statement__c,'Main',false,false,'G'));
                //dList = [select id, Name, Do_Title__c, DO_Code__c From DO__c where CDCS_Goal__c =: dd.CDCS_Goal__c order by DO_Code__c];            
                 
                set<string> doIds = new set<string>{};
                for(Do__c d: dList){
                    doIds.add(d.id);
                    lnkTree.add(new TreeNode((String)d.id,(String)d.DO_Code__c,(String)d.Do_Title__c,(String)cg.id,false,false,'D'));
                }
                List<CDCSLINK__c> lnkList1 = new List<CDCSLINK__c>([Select DO_Code__c, DO_Id__c, DO_Title__c,
                              IR_Code__c, IR_Id__c, IR_Title__c,
                              Link_Type__c      
                        From CDCSLINK__c where DO_Id__c in :doIds and SIR_Id__c = null order by IR_Code__c]);
                    
                for(CDCSLINK__c cd: lnkList1){
                   if (cd.Link_Type__c == 'Secondary Do'){
                        lnkTree.add(new TreeNode('Sec'+(String)cd.IR_Id__c,(String)cd.IR_Code__c,(String)cd.IR_Title__c,(String)cd.DO_Id__c,false,true, 'I'));
                   } else if (cd.Link_Type__c == 'Primary Do') {                     
                        lnkTree.add(new TreeNode((String)cd.IR_Id__c,(String)cd.IR_Code__c,(String)cd.IR_Title__c,(String)cd.DO_Id__c,false,false, 'I'));
                   }        
                    
                 }
                //system.debug('Display final list'+lnkTree);
            }
        } else {
            if (!dList.isEmpty()){              
                DO__c do1 = new DO__c();
                do1 = dList[0];
                Title = 'Overall Results Framework for: '+(String)do1.ouName__c;
                Legend = 'OLegend';
                CDCSGoal__c cg = new CDCSGoal__c();
                cg = [select id, Name, Goal_statement__c From CDCSGoal__c where id =: do1.CDCS_Goal__c];
                List<Do__c> dList1 = new List<Do__c>([Select Id, Name, DO_Code__c, DO_Title__c, CDCS_Goal__c, ouCode__c, ouName__c from DO__C where CDCS_Goal__c=:cg.Id order by DO_Code__c]);
                lnkTree.add(new TreeNode(cg.id,'Goal',(String)cg.Goal_statement__c,'Main',false,false,'G'));                
                for(Do__c d: dList1){                    
                    lnkTree.add(new TreeNode((String)d.id,(String)d.DO_Code__c,(String)d.Do_Title__c,(String)cg.id,false,false,'D'));
                }                               
                    
            } else {
                if (objectName.equalsIgnoreCase('CDCSGoal__c')){
                    ShowErrors = 'True';
                }       
            }
            
        }
    }
    
    /* End of Default Constructor */ 
    Public pageReference Cancel(){  
      PageReference pageRef = new PageReference('/' + paramId ); 
      pageRef.setRedirect(true);
      return pageRef ;
   }   
    /* Wrapper class for the TreeNode */
    public class TreeNode{
        public String nodeId{get; set;}
        public String nodeName{get;set;}
        public String nodeTitle{get;set;}
        public String nodeParent{get;set;}
        public Boolean flag{get;set;}
        public Boolean secondary{get;set;}
        public String nType{get;set;}
        
        /* Default Constructor of the calss TreeNode */
        public TreeNode(String nId,String nName,String nTitle,String nParent,Boolean f,Boolean s, String n){
            nodeId = nId;
            nodeName = nName;
            nodeTitle = nTitle;
            nodeParent = nParent;
            flag = f;
            secondary = s;
            nType = n;
        }   
        /* End of Default constructor of the calss TreeNode */
    }
}