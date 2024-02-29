import { LightningElement, track, api, wire } from "lwc";
import getAccountTypes from "@salesforce/apex/AccountTypeController.getAccountTypes";
import getAccountTypesWithDetails from "@salesforce/apex/AccountTypeController.getAccountTypesWithDetails";

export default class AccountTypeList extends LightningElement {
  _accountTypesToDisplay;
  @track accountTypes = [];
  @track error;
  @track selectedAccountDetails = [];

  @api
  get accountTypesToDisplay() {
    return this._accountTypesToDisplay;
  }
  set accountTypesToDisplay(value) {
    if (this._accountTypesToDisplay !== value) {
      this._accountTypesToDisplay = value;

      getAccountTypes({ types: this._accountTypesToDisplay.split(",") })
        .then((result) => {
          this.accountTypes = Object.keys(result).map((key) => ({
            key: key,
            value: result[key]
          }));
        })
        .catch((error) => {
          this.error = error;
          this.accountTypes = [];
        });
    }
  }

  @wire(getAccountTypesWithDetails)
  wiredAccountTypes({ error, data }) {
    if (data) {
      this.selectedAccountDetails = Object.keys(data)
        .filter((key) => this._accountTypesToDisplay.split(",").includes(key))
        .map((key) => ({
          key: key,
          value: data[key]
        }));
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.accountTypes = [];
    }
  }
}
