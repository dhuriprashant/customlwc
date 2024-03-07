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

  columnMap = new Map([
    [
      "markersBlue",
      [
        { label: "Name", fieldName: "name" },
        { label: "Value", fieldName: "value" }
      ]
    ],
    [
      "markersRed",
      [
        { label: "Name", fieldName: "name" },
        { label: "Value", fieldName: "value" },
        { label: "lat", fieldName: "lat" }
      ]
    ],
    [
      "markersGreen",
      [
        { label: "Name", fieldName: "name" },
        { label: "Value", fieldName: "value" },
        { label: "lat", fieldName: "lat" },
        { label: "long", fieldName: "long" }
      ]
    ]
  ]);

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
            value: this.myMap[key],
            displayColumns: this.columnMap.get(key)
          }));
      })
      .catch((error) => {
        this.error = error;
      });
  }

  @track columns = [
    { label: "Name", fieldName: "name" },
    { label: "Value", fieldName: "value" }
  ];

  /*
  //define handleResetColumnWidth
  handleResetColumnWidth() {
    // Force a re-render of the table by assigning a new array to this.columns
    this.columns = [...this.columns];
  }*/

  handleResetColumnWidth(event) {
    // Retrieve the key from the event
    const key = event.target.dataset.key;

    // Find the item with the given key
    const item = this.myMapArray.find((i) => i.key === key);

    // Reset displayColumns to its original state
    if (item) {
      item.displayColumns = [...this.columnMap.get(key)];
    }
  }
}
