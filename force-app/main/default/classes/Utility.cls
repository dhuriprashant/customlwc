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
      String relationshipType = fieldDescribe.getRelationshipOrder() == 0
        ? 'Master-Detail'
        : 'Lookup';
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

  public static Map<Id, Integer> getChildRecordCounts(
    String childObjectName,
    String relationshipFieldName
  ) {
    String query =
      'SELECT ' +
      relationshipFieldName +
      ', COUNT(Id) childCount FROM ' +
      childObjectName +
      ' GROUP BY ' +
      relationshipFieldName;
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
    Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe()
      .get(parentObjectName)
      .getDescribe();

    // Iterate over all child relationships
    for (Schema.ChildRelationship cr : dsr.getChildRelationships()) {
      // Get the child object name and relationship field name
      String childObjectName = cr.getChildSObject().getDescribe().getName();
      String relationshipFieldName = cr.getField().getDescribe().getName();

      if (
        cr.getChildSObject().getDescribe().isQueryable() &&
        cr.getField().getDescribe().isAccessible() &&
        cr.getField().getDescribe().isFilterable() &&
        !childObjectName.equals('ContentDocumentLink')
      ) {
        System.debug(
          'Parent Object: ' +
            parentObjectName +
            ', Child Object: ' +
            childObjectName +
            ', Relationship Field: ' +
            relationshipFieldName
        );
        // Get the child record count
        Integer count = getChildRecordCountsForARelationship(
          childObjectName,
          relationshipFieldName
        );

        System.debug(
          'Parent Object: ' +
            parentObjectName +
            ', Child Object: ' +
            childObjectName +
            ', Relationship Field: ' +
            relationshipFieldName +
            ', Child Record Count: ' +
            count
        );
      } else {
        System.debug(
          'Parent Object: ' +
            parentObjectName +
            ', Child Object: ' +
            childObjectName +
            ', Relationship Field: ' +
            relationshipFieldName +
            ', Child Record Count: Not Queryable'
        );
      }
    }
  }

  public static Integer getChildRecordCountsForARelationship(
    String childObjectName,
    String relationshipFieldName
  ) {
    String query =
      'SELECT COUNT() FROM ' +
      childObjectName +
      ' WHERE ' +
      relationshipFieldName +
      ' != null';
    Integer count = Database.countQuery(query);

    return count;
  }

  public static Map<String, Integer> getObjectRecordCounts(
    List<String> objectNames
  ) {
    Map<String, Integer> recordCounts = new Map<String, Integer>();
    for (String objectName : objectNames) {
      try {
        Integer recordCount = Database.countQuery(
          'SELECT COUNT() FROM ' + objectName
        );
        recordCounts.put(objectName, recordCount);
      } catch (Exception e) {
        // Ignore objects that we can't query
      }
    }
    return recordCounts;
  }

  public static Map<String, Integer> getObjectRecordCounts() {
    Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    List<String> objectNames = new List<String>(globalDescribe.keySet());
    Map<String, Integer> recordCounts = new Map<String, Integer>();
    for (Integer i = 0; i < objectNames.size(); i += 100) {
      List<String> subsetOfObjectNames = new List<String>();
      for (Integer j = i; j < Math.min(i + 100, objectNames.size()); j++) {
        subsetOfObjectNames.add(objectNames[j]);
      }
      recordCounts.putAll(Utility.getObjectRecordCounts(subsetOfObjectNames));
      break;
    }

    return recordCounts;
  }

  public static List<String> getRequiredFields(String objectName) {
    List<String> requiredFields = new List<String>();
    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe()
      .get(objectName)
      .getDescribe()
      .fields.getMap();
    for (String fieldName : fieldMap.keySet()) {
      Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName)
        .getDescribe();
      if (!fieldDescribe.isNillable() && fieldDescribe.isCreateable()) {
        requiredFields.add(fieldName);
      }
    }
    return requiredFields;
  }
}
