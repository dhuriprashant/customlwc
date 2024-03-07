public with sharing class myMapController {
  //write a method to retun an object with the lat and long of the current user
  @AuraEnabled
  public static Object getMap() {
    myMap m = new myMap();
    m.lat = '37.7749';
    m.longg = '-122.4194';
    m.markersBlue = new List<Marker>();
    m.markersBlue.add(new Marker('37.7749', '-122.4194', 'San Francisco', '1'));
    m.markersBlue.add(new Marker('37.7749', '-122.4194', 'San ', '2'));
    m.markersBlue.add(new Marker('37.7749', '-122.4194', 'San Franc', '3'));

    m.markersRed = new List<Marker>();
    m.markersRed.add(new Marker('37.7749', '-122.4194', 'San Francisco', '1'));
    m.markersRed.add(new Marker('37.7749', '-122.4194', 'San ', '2'));
    m.markersRed.add(new Marker('37.7749', '-122.4194', 'San Franc', '3'));

    m.markersGreen = new List<Marker>();
    m.markersGreen.add(
      new Marker('37.7749', '-122.4194', 'San Francisco', '1')
    );
    m.markersGreen.add(new Marker('37.7749', '-122.4194', 'San ', '2'));
    m.markersGreen.add(new Marker('37.7749', '-122.4194', 'San Franc', '3'));

    return m;
  }

  class myMap {
    @AuraEnabled
    public String lat { get; set; }
    @AuraEnabled
    public String longg { get; set; }
    //add an list of markers
    @AuraEnabled
    public List<Marker> markersBlue { get; set; }
    @AuraEnabled
    public List<Marker> markersRed { get; set; }
    @AuraEnabled
    public List<Marker> markersGreen { get; set; }
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
