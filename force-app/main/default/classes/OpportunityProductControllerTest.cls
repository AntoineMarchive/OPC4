@isTest
private class OpportunityProductControllerTest {
    @isTest
    static void testGetAndDeleteOpportunityProduct() {
        // Création d'une opportunité
        Opportunity testOpp = new Opportunity(Name='Test Opportunity', StageName='Prospecting', CloseDate=Date.today());
        insert testOpp;
        
        // Création d'un produit actif
        Product2 testProduct = new Product2(Name='Test Product', IsActive=true, QuantityInStock__c=10);
        insert testProduct;
        
        // Récupération du Pricebook standard
        Id pricebookId = Test.getStandardPricebookId() ;
        
        
        // Création de l'entrée dans le Pricebook
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Product2Id=testProduct.Id,
        Pricebook2Id=pricebookId,
        UnitPrice=100,
        IsActive=true
            );
        insert testPricebookEntry;
        
        // Création d'une ligne de produit liée à l'opportunité
        OpportunityLineItem testItem = new OpportunityLineItem(
            OpportunityId=testOpp.Id,
        PricebookEntryId=testPricebookEntry.Id,
        Quantity=1,
        UnitPrice=100
            );
        insert testItem;
        
        // Test de récupération des produits
        List<OpportunityLineItem> result = OpportunityProductController.getOpportunityProducts(testOpp.Id);
        System.assertNotEquals(0, result.size(), 'Les produits de l’opportunité doivent être récupérés');
        System.assertEquals(testItem.Id, result[0].Id, 'Le produit récupéré doit correspondre au produit inséré');
        
        // Test de suppression
        OpportunityProductController.deleteOpportunityProduct(testItem.Id);
        
        // Vérifier que le produit a bien été supprimé
        List<OpportunityLineItem> remainingItems = [
            SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :testOpp.Id
        ];
        System.assertEquals(0, remainingItems.size(), 'Le produit aurait dû être supprimé');
    }
    
    @isTest
    static void testGetOpportunityProducts_KO_NullOpportunityId() {
        // Test de la méthode getOpportunityProducts avec un ID d'opportunité null
        
        try {
            List<OpportunityLineItem> result = OpportunityProductController.getOpportunityProducts(null);
        } catch (AuraHandledException e) {
            System.assertEquals('Opportunity Id is required', e.getMessage(), 'Le message d’erreur doit être correct');
        }
    }
    
    @isTest
    static void testDeleteOpportunityProduct_KO_NullProductId() {
        try {
            OpportunityProductController.deleteOpportunityProduct(null);
        } catch (AuraHandledException e) {
            System.assertEquals('L’ID du produit est requis pour la suppression.', e.getMessage(), 'Le message d’erreur doit être correct');
        }
    }
}


// Rôle :

// Vérifie que la classe Apex OpportunityProductController fonctionne correctement
// Simule des opportunités, produits et vérifie les résultats des requêtes
// Permet de garantir que la récupération des produits et des utilisateurs fonctionne bien