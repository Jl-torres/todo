@isTest
     public class GetCaseTest {
         
        @TestSetup
        static void makeData(){
        List<Case> Cases = new List<Case>() ;
        Cases.add(new Case( SuppliedEmail='email@test.com'));  
        insert Cases;  
        }
         
      @isTest static void GetCaseByNumbertest() {
          List<Case> Case_n = [SELECT CaseNumber , Contact.lastname FROM Case limit 1];
          Case[] listCase = GetCase.GetCaseByNumber( Case_n[0].CaseNumber , '' );
           
          System.assertEquals( true , listCase.size() > 0);
    }   
   }