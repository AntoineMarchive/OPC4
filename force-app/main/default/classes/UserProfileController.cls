public with sharing class UserProfileController {
    
    @AuraEnabled(cacheable=true)
    public static String getUserProfile() {
        try {
            User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            return currentUser.Profile.Name;
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération du profil utilisateur : ' + e.getMessage());
        }
    }
}
