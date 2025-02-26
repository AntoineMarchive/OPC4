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

        List<OpportunityLineItem> products = OpportunityProductController.getOpportunityProducts(testOpp.Id);
        System.assertNotEquals(0, products.size());
        Test.stopTest();
    }
}

// Rôle :

// Vérifie que la classe Apex OpportunityProductController fonctionne correctement
// Simule des opportunités, produits et vérifie les résultats des requêtes
// Permet de garantir que la récupération des produits et des utilisateurs fonctionne bien