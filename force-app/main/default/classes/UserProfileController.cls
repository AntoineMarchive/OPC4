public with sharing class UserProfileController {
    
    @AuraEnabled(cacheable=true)
    //@AuraEnabled(cacheable=true) : Optimise la récupération des données pour LWC.
    public static String getUserProfile() {
        try {
            User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].Profile.Name;
            //SELECT Profile.Name FROM User : Récupère le nom du profil.
            //UserInfo.getUserId() : Permet d’obtenir l’ID de l’utilisateur connecté

        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération du profil utilisateur : ' + e.getMessage());
            // Gère les erreurs en cas de problème lors de l’exécution de la requête
        }
    }
}

// Rôle :

// Récupère le nom du profil de l'utilisateur actuellement connecté
// Optimise la récupération des données en utilisant @AuraEnabled(cacheable=true)
// Gère les erreurs en renvoyant un message approprié si la récupération échoue