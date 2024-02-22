// myMapComponent.js
import { LightningElement, track } from "lwc";

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

  @track myMapArray = Object.keys(this.myMap)
    .filter((key) => Array.isArray(this.myMap[key]))
    .map((key) => ({
      key: key,
      value: this.myMap[key]
    }));

  columns = [
    { label: "Name", fieldName: "name" },
    { label: "Value", fieldName: "value" }
  ];
}
