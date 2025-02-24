public with sharing class OpportunityProductController {
    @AuraEnabled
    public static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
        return [SELECT Id, OpportunityId, Product2.Name, UnitPrice, Quantity 
                FROM OpportunityLineItem 
                WHERE OpportunityId = :opportunityId];
    }
}
