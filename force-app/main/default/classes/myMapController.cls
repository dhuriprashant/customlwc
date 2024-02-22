public with sharing class myMapController {
  //write a method to retun an object with the lat and long of the current user
  @AuraEnabled
  public static Object getMap() {
    myMap m = new myMap();
    m.lat = '37.7749';
    m.longg = '-122.4194';
    m.markers = new List<Marker>();
    m.markers.add(new Marker('37.7749', '-122.4194', 'San Francisco', '1'));
    m.markers.add(new Marker('37.7749', '-122.4194', 'San Francisco', '2'));
    m.markers.add(new Marker('37.7749', '-122.4194', 'San Francisco', '3'));
    return m;
  }

  class myMap {
    @AuraEnabled
    public String lat { get; set; }
    @AuraEnabled
    public String longg { get; set; }
    //add an list of markers
    @AuraEnabled
    public List<Marker> markers { get; set; }
  }

  class Marker {
    @AuraEnabled
    public String lat { get; set; }
    @AuraEnabled
    public String longg { get; set; }
    @AuraEnabled
    public String name { get; set; }
    @AuraEnabled
    public String value { get; set; }

    public Marker(String lat, String longg, String name, String value) {
      this.lat = lat;
      this.longg = longg;
      this.name = name;
      this.value = value;
    }
  }
}
