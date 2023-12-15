public class Utility {
  public static String getAllObjectNamesAndLabels() {
    List<String> objectNamesAndLabels = new List<String>();
    Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    for (String objectName : globalDescribe.keySet()) {
      Schema.SObjectType sObjectType = globalDescribe.get(objectName);
      Schema.DescribeSObjectResult describeSObjectResult = sObjectType.getDescribe();
      objectNamesAndLabels.add(
        'API Name: ' +
          describeSObjectResult.getName() +
          ', Label: ' +
          describeSObjectResult.getLabel()
      );
    }
    return JSON.serialize(objectNamesAndLabels);
  }

  public static String getObjectRelationships(String objectName) {
    List<String> objectRelationships = new List<String>();
    Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
    Schema.DescribeSObjectResult describeSObjectResult = sObjectType.getDescribe();
    List<Schema.ChildRelationship> childRelationships = describeSObjectResult.getChildRelationships();
    for (Schema.ChildRelationship childRelationship : childRelationships) {
      Schema.SObjectField field = childRelationship.getField();
      Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
      String relationshipType = fieldDescribe.getRelationshipOrder() == 0 ? 'Master-Detail' : 'Lookup';
      objectRelationships.add(
        'Child Object: ' +
          childRelationship.getChildSObject() +
          ', Field: ' +
          childRelationship.getField() +
          ', Relationship Name: ' +
          childRelationship.getRelationshipName() +
          ', Relationship Type: ' +
          relationshipType
      );
    }
    return JSON.serialize(objectRelationships);
  }

  /*
  public static Object createObjectFromMetadata(String metadataName) {
    // Query the custom metadata
    MyCustomMetadata__mdt metadata = [SELECT DeveloperName FROM MyCustomMetadata__mdt WHERE DeveloperName = :metadataName LIMIT 1];

    // Get the class name from the custom metadata
    String className = metadata.DeveloperName;

    // Get a Type object for the class
    Type t = Type.forName(className);

    // Check if the class implements MyInterface
    if (MyInterface.class.isAssignableFrom(t)) {
      System.debug('The class implements MyInterface');
    } else {
      System.debug('The class does not implement MyInterface');
    }

    // Create a new instance of the class
    Object obj = t.newInstance();

    return obj;
  }*/


  /*
  public class WelcomeAppBindings extends di_Module {
    public override void configure() {

	// Query the custom metadata
    List<BindingMetadata__mdt> bindings = [SELECT Interface__c, Implementation__c, OutOfOffice__c FROM BindingMetadata__mdt];

    // Iterate over the results and set up the bindings
    for (BindingMetadata__mdt binding : bindings) {
        // Get the classes for the interface and implementation
        Type interfaceType = Type.forName(binding.Interface__c);
        Type implementationType = Type.forName(binding.Implementation__c);

		// Named binding
        bind(interfaceType).named('MyNamedBinding').to(implementationType);
    }

    }
}

And here's how you can get an instance of a named binding:
IMyInterface myInstance = (IMyInterface) Injector.Org.getInstance(IMyInterface.class, 'MyNamedBinding');

   */
}
