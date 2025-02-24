public with sharing class UserProfileController {
    
    @AuraEnabled(cacheable=true)
    //@AuraEnabled(cacheable=true) : Optimise la récupération des données pour LWC.
    public static String getUserProfile() {
        try {
            User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            //SELECT Profile.Name FROM User : Récupère le nom du profil.
            //UserInfo.getUserId() : Permet d’obtenir l’ID de l’utilisateur connecté
            return currentUser.Profile.Name;
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération du profil utilisateur : ' + e.getMessage());
        }
    }
}
