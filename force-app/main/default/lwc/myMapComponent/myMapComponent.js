// myMapComponent.js
import { LightningElement, track } from "lwc";
import getmap from "@salesforce/apex/myMapController.getMap";

export default class MyMapComponent extends LightningElement {
  myMap = {
    Key1: [
      { name: "Object1", value: "Value1" },
      { name: "Object2", value: "Value2" }
    ],
    Key2: [
      { name: "Object3", value: "Value3" },
      { name: "Object4", value: "Value4" }
    ],
    hid: 123,
    hid2: "rtes1234"
  };

  @track myMapArray;

  /*
  this.myMapArray = Object.keys(this.myMap)
    .filter((key) => Array.isArray(this.myMap[key]))
    .map((key) => ({
      key: key,
      value: this.myMap[key]
    }));*/

  //call getmap method from myMapController class on connectedCallback
  connectedCallback() {
    getmap()
      .then((result) => {
        this.myMap = result;
        this.myMapArray = Object.keys(this.myMap)
          .filter((key) => Array.isArray(this.myMap[key]))
          .map((key) => ({
            key: key,
            value: this.myMap[key]
          }));
      })
      .catch((error) => {
        this.error = error;
      });
  }

  columns = [
    { label: "Name", fieldName: "name" },
    { label: "Value", fieldName: "value" }
  ];
}
