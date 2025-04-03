@isTest
private class UserProfileControllerTest {
    @isTest
    static void testGetUserProfile() {
        // Création d’un utilisateur de test avec un profil standard (par ex : Standard User)
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = profile.Id
        );

        System.runAs(testUser) {
            Test.startTest();
            String profileName = UserProfileController.getUserProfile();
            Test.stopTest();

            System.assertEquals('Standard User', profileName, 'Le nom du profil doit être "Standard User"');
        }
    }
}
