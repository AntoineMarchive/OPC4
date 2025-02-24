@IsTest
private class OpportunityProductControllerTest {
    
    @TestSetup
    static void setupData() {
        // Création du Pricebook personnalisé
        Pricebook2 pb = new Pricebook2(Name='Liste des prix - FRANCE', IsActive=true);
        insert pb;

        // Récupération du Pricebook standard
        Pricebook2 standardPb = [SELECT Id FROM Pricebook2 WHERE IsStandard=true LIMIT 1];

        // Création de produits
        List<Product2> products = new List<Product2>{
            new Product2(Name='Tesla Model S', ProductCode='TES-MS', Description='Voiture électrique haut de gamme', Family='Voitures électriques', StockKeepingUnit='TES-MS-2022', QuantityInStock__c=50),
            new Product2(Name='Ford Mustang Mach-E', ProductCode='FORD-MM', Description='SUV électrique puissant', Family='Voitures électriques', StockKeepingUnit='FORD-MM-2022', QuantityInStock__c=75)
        };
        insert products;

        // Création des PricebookEntries
        List<PricebookEntry> pbeList = new List<PricebookEntry>{
            new PricebookEntry(Pricebook2Id=standardPb.Id, Product2Id=products[0].Id, UnitPrice=25000, IsActive=true),
            new PricebookEntry(Pricebook2Id=pb.Id, Product2Id=products[1].Id, UnitPrice=69900, IsActive=true)
        };
        insert pbeList;

        // Création d'une opportunité
        Opportunity opp = new Opportunity(
            Name = 'Vente Tesla Model S',
            CloseDate = Date.today().addDays(10),
            StageName = 'Prospecting'
        );
        insert opp;

        // Association de produits à l’opportunité
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbeList[0].Id,  // Associer la Tesla Model S
            Quantity = 1,
            UnitPrice = 99990
        );
        insert oli;
    }

    @IsTest
    static void testGetOpportunityProducts() {
        // Récupérer une opportunité test
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        // Exécuter la méthode Apex
        Test.startTest();
        List<OpportunityLineItem> results = OpportunityProductController.getOpportunityProducts(opp.Id);
        Test.stopTest();

        // Vérifier que la liste n'est pas vide et contient bien des données
        System.assertNotEquals(0, results.size(), 'La liste des Opportunité Produits ne devrait pas être vide.');
        System.assertEquals('Tesla Model S', results[0].Product2.Name, 'Le produit associé devrait être la Tesla Model S.');
        System.assertEquals(99990, results[0].UnitPrice, 'Le prix du produit devrait correspondre au Pricebook.');
    }
}
