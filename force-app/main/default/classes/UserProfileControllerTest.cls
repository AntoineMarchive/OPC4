@isTest
private class UserProfileControllerTest {

    @isTest
    static void testGetUserProfile() {
        // Récupérer n'importe quel profil existant
        Profile p = [SELECT Id, Name FROM Profile LIMIT 1];

        // Créer un utilisateur de test avec ce profil
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = p.Id
        );

        insert testUser;

        System.runAs(testUser) {
            String profileName = UserProfileController.getUserProfile();
            
            System.assertEquals(p.Name, profileName, 'Le nom du profil doit correspondre au profil assigné');
//             On vérifie que le nom du profil retourné par la méthode est bien égal à p.Name.
//             p est probablement une variable de type Profile définie plus tôt dans le code de test.
//             Cette assertion garantit que la méthode getUserProfile renvoie bien le nom du profil du testUser.
        }
    }
}
