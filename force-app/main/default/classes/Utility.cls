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
      System.debug(
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
}
