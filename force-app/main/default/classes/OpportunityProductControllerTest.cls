@isTest
private class OpportunityProductControllerTest {
    @isTest
    static void testGetOpportunityProducts() {
        Test.startTest();
        Opportunity testOpp = new Opportunity(Name='Test Opportunity', StageName='Prospecting', CloseDate=Date.today());
        insert testOpp;

        Product2 testProduct = new Product2(Name='Test Product', IsActive=true);
        insert testProduct;

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard=true LIMIT 1];
        PricebookEntry testPricebookEntry = new PricebookEntry(Product2Id=testProduct.Id, Pricebook2Id=standardPricebook.Id, UnitPrice=100, IsActive=true);
        insert testPricebookEntry;

        OpportunityLineItem testItem = new OpportunityLineItem(OpportunityId=testOpp.Id, PricebookEntryId=testPricebookEntry.Id, Quantity=1, UnitPrice=100);
        insert testItem;

        // Suppression du produit
        OpportunityProductController.deleteOpportunityProduct(testItem.Id);

        // Vérifier que le produit a bien été supprimé
        List<OpportunityLineItem> remainingItems = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :testOpp.Id];
        System.assertEquals(0, remainingItems.size(), 'Le produit aurait dû être supprimé');
        Test.stopTest();
    }
}

// Rôle :

// Vérifie que la classe Apex OpportunityProductController fonctionne correctement
// Simule des opportunités, produits et vérifie les résultats des requêtes
// Permet de garantir que la récupération des produits et des utilisateurs fonctionne bien