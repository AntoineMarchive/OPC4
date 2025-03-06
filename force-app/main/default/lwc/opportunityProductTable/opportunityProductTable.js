import { LightningElement, wire, api } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';
import getUserProfile from '@salesforce/apex/UserProfileController.getUserProfile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    { label: 'Nom du produit', fieldName: 'productName', type: 'text' },
    { label: 'Quantité', fieldName: 'Quantity', type: 'number' },
    { label: 'Prix unitaire', fieldName: 'unitPrice', type: 'currency' },
    { label: 'Prix total', fieldName: 'TotalPrice', type: 'currency' },
    { label: 'Quantité restante', fieldName: 'QuantityInStock__c', type: 'number' },
    { label: '', type: 'button-icon', initialWidth: 50, typeAttributes: { 
        iconName: 'utility:delete', 
        name: 'delete', 
        alternativeText: 'Supprimer', 
        title: 'Supprimer', 
        variant: 'border-filled' 
    }},
    { label: 'Actions', type: 'button', typeAttributes: {
        label: 'Voir produit',
        name: 'view',
        title: 'Voir produit',
        variant: 'brand'
    }}
];


export default class OpportunityProductTable extends LightningElement {
    @api recordId; //rend la propriété public
    products;
    userProfile;
    isAdmin = false;
    columns = COLUMNS;

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
            this.products = data.map(item => ({
                ...item,
                productName: item.PricebookEntry?.Product2?.Name,
                unitPrice: item.PricebookEntry?.UnitPrice,
                QuantityInStock: item.PricebookEntry?.Product2?.QuantityInStock__c
            }));
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

    handleDelete(productId) {
        // Logique pour supprimer le produit (nécessite une méthode Apex pour la suppression)
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Suppression',
                message: 'Produit supprimé avec succès.',
                variant: 'success'
            })
        );
    }

    handleView(productId) {
        // Logique pour afficher la fiche produit
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Voir Produit',
                message: `Ouverture du produit ${productId}`,
                variant: 'info'
            })
        );
    }
}

// Rôle :

// Récupère les données de OpportunityProductController.cls via @wire
// Stocke et gère l'affichage des produits liés à une opportunité
// Vérifie si l'utilisateur est "Admin" ou "Commercial" pour afficher les bons éléments
// Met à jour dynamiquement l'affichage selon les informations reçues