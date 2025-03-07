public with sharing class OpportunityProductController {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
        //récupère les produits associés à une opportunité
        if (opportunityId == null) {
            throw new AuraHandledException('Opportunity Id is required');
        }
        return [
            SELECT Id, OpportunityId, PricebookEntry.Product2.Name, PricebookEntry.UnitPrice, Quantity, TotalPrice, PricebookEntry.Product2.QuantityInStock__c
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId
        ];
    }

    @AuraEnabled
    public static void deleteOpportunityProduct(Id productId) {
        try {
            if (productId == null) {
                throw new AuraHandledException('L’ID du produit est requis pour la suppression.');
            }

            OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem WHERE Id = :productId LIMIT 1];

            delete oli;
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la suppression : ' + e.getMessage());
        }
    }
}

// Rôle :
// Fournit des méthodes Apex accessibles aux composants Lightning (@AuraEnabled)
// Récupère la liste des produits associés à une opportunité
// Récupère les produits disponibles dans le Pricebook standard