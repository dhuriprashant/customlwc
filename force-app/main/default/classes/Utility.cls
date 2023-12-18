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

  public static Map<Id, Integer> getChildRecordCounts(String childObjectName, String relationshipFieldName) {
    String query = 'SELECT ' + relationshipFieldName + ', COUNT(Id) childCount FROM ' + childObjectName + ' GROUP BY ' + relationshipFieldName;
    List<AggregateResult> results = Database.query(query);

    Map<Id, Integer> childCountByParentId = new Map<Id, Integer>();
    for (AggregateResult result : results) {
      Id parentId = (Id) result.get(relationshipFieldName);
      Integer count = (Integer) result.get('childCount');
      childCountByParentId.put(parentId, count);
    }

    return childCountByParentId;
  }

  public static void countChildRecordsForObject(String parentObjectName) {
    // Get the describe result for the object
    Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(parentObjectName).getDescribe();

    // Iterate over all child relationships
    for (Schema.ChildRelationship cr : dsr.getChildRelationships()) {
      // Get the child object name and relationship field name
      String childObjectName = cr.getChildSObject().getDescribe().getName();
      String relationshipFieldName = cr.getField().getDescribe().getName();

      if (cr.getChildSObject().getDescribe().isQueryable() && cr.getField().getDescribe().isAccessible() && cr.getField().getDescribe().isFilterable() && !childObjectName.equals('ContentDocumentLink')) {
        System.debug('Parent Object: ' + parentObjectName + ', Child Object: ' + childObjectName + ', Relationship Field: ' + relationshipFieldName);
        // Get the child record count
        Integer count = getChildRecordCountsForARelationship(childObjectName, relationshipFieldName);

        System.debug('Parent Object: ' + parentObjectName + ', Child Object: ' + childObjectName + ', Relationship Field: ' + relationshipFieldName + ', Child Record Count: ' + count);
      }else {
        System.debug('Parent Object: ' + parentObjectName + ', Child Object: ' + childObjectName + ', Relationship Field: ' + relationshipFieldName + ', Child Record Count: Not Queryable');
      }

    }
  }

  public static Integer getChildRecordCountsForARelationship(String childObjectName, String relationshipFieldName) {
    String query = 'SELECT COUNT() FROM ' + childObjectName + ' WHERE ' + relationshipFieldName + ' != null';
    Integer count = Database.countQuery(query);

    return count;
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

Register the Module: You need to register your module with ForceDI. This is typically done in a trigger, a Visualforce page controller, or a Lightning component controller. Here's an example:
Injector.Org.registerModule(WelcomeAppBindings.class);

   */
}
