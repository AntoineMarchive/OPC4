public with sharing class OpportunityProductController {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
        //récupère les produits associés à une opportunité
        if (opportunityId == null) {
            throw new AuraHandledException('Opportunity Id is required');
        }
        return [
            SELECT Id, OpportunityId, PricebookEntry.Product2.Name, PricebookEntry.UnitPrice, Quantity, TotalPrice
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
    }
}

// Rôle :
// Fournit des méthodes Apex accessibles aux composants Lightning (@AuraEnabled)
// Récupère la liste des produits associés à une opportunité
// Récupère les produits disponibles dans le Pricebook standard