import { LightningElement, wire, api } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';
import getAvailableProducts from '@salesforce/apex/OpportunityProductController.getAvailableProducts';
import getUserProfile from '@salesforce/apex/UserProfileController.getUserProfile';

export default class OpportunityProductTable extends LightningElement {
    @api recordId;
    products;
    availableProducts;
    userProfile;
    isAdmin = false;
    isCommercial = false;

    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
    //Récupère les produits d’une opportunité
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
        } else if (error) {
            this.products = undefined;
        }
    }

    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
        } else if (error) {
            this.products = undefined;
        }
    }

    @wire(getAvailableProducts)
    wiredAvailableProducts({ error, data }) {
        //Récupère les produits disponibles dans Salesforce
        if (data) {
            this.availableProducts = data;
        }
    }

    @wire(getUserProfile)
    wiredUserProfile({ error, data }) {
        if (data) {
            this.userProfile = data;
            this.isAdmin = data === 'System Administrator';
            this.isCommercial = data === 'Commercial';
        }
    }
}

// Rôle :

// Récupère les données de OpportunityProductController.cls via @wire
// Stocke et gère l'affichage des produits liés à une opportunité
// Vérifie si l'utilisateur est "Admin" ou "Commercial" pour afficher les bons éléments
// Met à jour dynamiquement l'affichage selon les informations reçues