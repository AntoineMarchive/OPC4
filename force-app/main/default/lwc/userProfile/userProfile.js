import { LightningElement, wire, track } from 'lwc';
import getUserProfile from '@salesforce/apex/UserProfileController.getUserProfile';

export default class UserProfile extends LightningElement {
    @track userProfile;
    isAdmin = false;
    isCommercial = false;
    isOtherProfile = false;

    @wire(getUserProfile)
    //@wire(getUserProfile) : Appelle la méthode Apex et stocke le profil utilisateur.
    wiredProfile({ error, data }) {
        if (data) {
            this.userProfile = data;
            this.isAdmin = data === 'System Administrator';
            //this.isAdmin = data === 'System Administrator' : Vérifie si l'utilisateur est admin
            this.isCommercial = data === 'Commercial';
            //this.isCommercial = data === 'Commercial' : Vérifie si l'utilisateur est commercial
            this.isOtherProfile = !this.isAdmin && !this.isCommercial; 
            // Si ce n'est ni l'un ni l'autre
        } else if (error) {
            console.error('Erreur lors de la récupération du profil utilisateur', error);
        }
    }
}

// Rôle :

// Récupère le profil de l’utilisateur via Apex
// Définit des variables pour vérifier quel type de profil a l’utilisateur
// Affiche un message conditionnel selon le profil détecté