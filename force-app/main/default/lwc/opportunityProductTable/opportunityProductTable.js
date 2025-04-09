import { LightningElement, wire, api } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts'; // méthode Apex permettant de récupérer les produits liés à une opportunité
import deleteOpportunityProduct from '@salesforce/apex/OpportunityProductController.deleteOpportunityProduct'; //méthode Apex permetant de supprimer un produit lié à une oppportunité
import getUserProfile from '@salesforce/apex/UserProfileController.getUserProfile'; //méthode Apex permettant de récupérer le profil de l'utilisateur
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; //permet d'afficher des messages d'erreur ou de succès
import { NavigationMixin } from 'lightning/navigation'; //permet de naviguer vers une page standard de Salesforce

//  Import uniquement les labels créés
import ProductNameLabel from '@salesforce/label/c.Product_Column_Name';
import QuantityLabel from '@salesforce/label/c.Product_Column_Quantity';
import UnitPriceLabel from '@salesforce/label/c.Product_Column_UnitPrice';
import TotalPriceLabel from '@salesforce/label/c.Product_Column_TotalPrice';
import StockLabel from '@salesforce/label/c.Product_Column_Stock';
import DeleteLabel from '@salesforce/label/c.Product_Column_Delete';
import ViewLabel from '@salesforce/label/c.Product_Column_View';
import StockErrorMessage from '@salesforce/label/c.Stock_Error_Message';
import NoProductsTitle from '@salesforce/label/c.No_Product_Title';
import NoProductsMessage from '@salesforce/label/c.No_Product_Message_Full';
import StockErrorAlert from '@salesforce/label/c.Stock_Error_Alert';
import AdministratorSystem from '@salesforce/label/c.Administrator_System';
import AdminWelcomeMessage from '@salesforce/label/c.Admin_Welcome_Message';
import CommercialWelcomeMessage from '@salesforce/label/c.Commercial_Welcome_Message';

  const COLUMNS = [
    { label: ProductNameLabel, fieldName: 'productName', type: 'text' },
    {
        label: QuantityLabel,
        fieldName: 'Quantity',
        type: 'number',
        cellAttributes: {
            class: { fieldName: 'quantityClass' }
        }
    },
    { label: UnitPriceLabel, fieldName: 'unitPrice', type: 'currency' },
    { label: TotalPriceLabel, fieldName: 'TotalPrice', type: 'currency' },
    { label: StockLabel, fieldName: 'QuantityInStock', type: 'number' },
    { label: DeleteLabel, type: 'button-icon', initialWidth: 50, typeAttributes: { //typeAttributes permet de définir les propriétés du bouton
        iconName: 'utility:delete', 
        name: 'delete', 
        alternativeText: DeleteLabel, 
        title: DeleteLabel, 
        variant: 'border-filled' 
    }}
];

const COLUMNS_ADMIN = [
    { label: ViewLabel, type: 'button', typeAttributes: {
        label: ViewLabel,
        name: 'view',
        title: ViewLabel,
        variant: 'brand'
    }}
];


export default class OpportunityProductTable extends NavigationMixin(LightningElement) {
    @api recordId;
    products;
    userProfile;
    isAdmin = false;
    isCommercial = false;
    columns = COLUMNS;
    showError = false;

     // Labels accessibles dans le HTML
     labels = {
     administratorSystem : AdministratorSystem,
     stockError : StockErrorMessage,
     noProductTitle : NoProductsTitle,
     noProductMessage : NoProductsMessage,
     stockErrorAlert : StockErrorAlert,
     adminWelcomeMessage : AdminWelcomeMessage,
     commercialWelcomeMessage : CommercialWelcomeMessage
     }

    connectedCallback(event) {
        console.log('ID ' + this.recordId) // salessforce appel cette methode et premet de verrifier si le recordId est bien recupéré.
    }

    @wire(getOpportunityProducts, { opportunityId: '$recordId' }) 
    //Récupère les produits d’une opportunité
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data.map(item => {
                const quantity = item.Quantity;
                const stock = item.PricebookEntry?.Product2?.QuantityInStock__c;
                return {
                    ...item,
                    productName: item.PricebookEntry?.Product2?.Name,
                    unitPrice: item.PricebookEntry?.UnitPrice,
                    QuantityInStock: stock,
                    quantityClass: quantity > stock ? 'slds-text-color_error' : ''
                };
            });
            this.showError = this.products.some(item => item.Quantity > item.QuantityInStock);
            console.log(JSON.stringify(this.products));
        } else if (error) {
            this.products = undefined;
        }
    }

    @wire(getUserProfile) // recupere le profil de l'utilisateur et verifie si c'est un admin ou un commercial
    wiredUserProfile({ error, data }) {

        if (data) {
            this.userProfile = data;
            this.isAdmin = data === this.labels.administratorSystem; // detecte si le profil est un administrateur
            if (this.isAdmin) { // si admin, on ajoute les collonnes d'admin specifiques
                this.columns = [...COLUMNS, ...COLUMNS_ADMIN];
            }
            
            this.isCommercial = data === 'Commercial'; // detecte si l'utilisateur est un commercial
        }
    }

    get hasproducts() {
        return this.products && this.products.length > 0; 
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'delete') { //supprime un produit; Si l’action est "delete", on appelle la méthode handleDelete (vue précédemment) en lui passant l’ID du produit à supprimer.
            this.handleDelete(row.Id);
        } else if (actionName === 'view') { // navigue vers la fiche produit;  Si l’action est "view", on appelle une méthode handleView pour naviguer vers la fiche produit.
            this.handleView(row.PricebookEntry?.Product2?.Id);
        }
    }

        
    handleDelete(productId) {
        // Logique pour supprimer le produit (nécessite une méthode Apex pour la suppression)
        deleteOpportunityProduct({ productId })
            .then(() => {
                this.products = this.products.filter(item => item.Id !== productId); //met à jour la liste this.products en retirant le produit supprimé (filtrage par ID).
                this.showToast('Suppression réussie', 'Produit supprimé avec succès.', 'success');
            })
            .catch(error => {
                this.showToast('Erreur', 'Impossible de supprimer le produit.', 'error');
                console.error(error);
            });
    }

    handleView(productId) {
        // Logique pour afficher la fiche produit
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: productId,
                actionName: 'view'
            }
        });
    }

    showToast(title, message, variant) { // affiche un toast = notification temporaire pour informer l'utilisateur d'une action effectuée ou d'une erreur
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }

}

// Rôle :

// Récupère les données de OpportunityProductController.cls via @wire
// Stocke et gère l'affichage des produits liés à une opportunité
// Vérifie si l'utilisateur est "Admin" ou "Commercial" pour afficher les bons éléments
// Met à jour dynamiquement l'affichage selon les informations reçues