// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/*
System.debug(Utility.getObjectRelationships('Case'));

System.debug(Utility.getAllObjectNamesAndLabels());

Map<Id, Integer> childCountByParentId = Utility.getChildRecordCounts('Contact', 'AccountId');
System.debug(childCountByParentId);

Integer childCount = Utility.getChildRecordCountsForARelationship('Contact', 'AccountId');
System.debug(childCount);*/

//Utility.countChildRecordsForObject('Case');

System.debug(Utility.getObjectRecordCounts());