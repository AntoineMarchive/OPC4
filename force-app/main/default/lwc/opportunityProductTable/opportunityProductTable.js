import { LightningElement, wire, api } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';
import getUserProfile from '@salesforce/apex/UserProfileController.getUserProfile';

export default class OpportunityProductTable extends LightningElement {
    @api recordId; //rend la propriété public
    products;
    userProfile;
    isAdmin = false;

    connectedCallback(event) {
        console.log('ID ' + this.recordId) // salessforce appel cette methode et premet de verrifier si le recordId est bien recupéré.
    }

    @wire(getOpportunityProducts, { opportunityId: '$recordId' }) // recordId : saleforce le rempli automatiquement , obligation d'avoir le @api sinon il ne comprend pas
    // $ = recupere les données quand il y a des changements 
    //Récupère les produits d’une opportunité
    wiredProducts({ error, data }) {
        console.log("in products")
        if (data) {
            console.log("in products 2")
            this.products = data;
            console.log(JSON.stringify(this.products));
        } else if (error) {
            this.products = undefined;
        }
    }

    @wire(getUserProfile)
    wiredUserProfile({ error, data }) {
        console.log("in profile")
        if (data) {
            console.log("in profile 2")
            this.userProfile = data;
            this.isAdmin = data === 'System Administrator';
            console.log(JSON.stringify(data));
            console.log("in profile 3")
        }
    }

    get hasproducts() {
        return this.products && this.products.length > 0; 
    }
}

// Rôle :

// Récupère les données de OpportunityProductController.cls via @wire
// Stocke et gère l'affichage des produits liés à une opportunité
// Vérifie si l'utilisateur est "Admin" ou "Commercial" pour afficher les bons éléments
// Met à jour dynamiquement l'affichage selon les informations reçues