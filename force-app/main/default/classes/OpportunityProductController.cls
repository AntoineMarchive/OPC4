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

    @AuraEnabled(cacheable=true)
    public static List<Product2> getAvailableProducts() {
        // récupère tous les produits disponibles dans le Pricebook standard
        Pricebook2 standardPb = [SELECT Id FROM Pricebook2 WHERE IsStandard=true LIMIT 1];
        return [
            SELECT Id, Name, ProductCode, Description, Family, (SELECT UnitPrice FROM PricebookEntries WHERE Pricebook2Id = :standardPb.Id)
            FROM Product2
        ];
    }
}

// Rôle :
// Fournit des méthodes Apex accessibles aux composants Lightning (@AuraEnabled)
// Récupère la liste des produits associés à une opportunité
// Récupère les produits disponibles dans le Pricebook standard