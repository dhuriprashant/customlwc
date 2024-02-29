public with sharing class AccountTypeController {
  @AuraEnabled(cacheable=true)
  public static Map<String, AccountType> getAccountTypes(List<String> types) {
    Map<String, AccountType> myMap = new Map<String, AccountType>();

    //only add the types that are in the list
    if (types.contains('Prospect')) {
      AccountType prospect = new AccountType();
      prospect.name = 'Prospect';
      prospect.icon = 'standard:opportunity';
      prospect.label = 'blue';
      myMap.put('Prospect', prospect);
    }

    if (types.contains('Customer')) {
      AccountType customer = new AccountType();
      customer.name = 'Customer';
      customer.icon = 'standard:account';
      customer.label = 'green';
      myMap.put('Customer', customer);
    }

    if (types.contains('Partner')) {
      AccountType partner = new AccountType();
      partner.name = 'Partner';
      partner.icon = 'standard:partner';
      partner.label = 'yellow';
      myMap.put('Partner', partner);
    }

    /*
    myMap.put('Key1', 'Value1');
    myMap.put('Key2', 'Value2');
    myMap.put('Key3', 'Value3');*/

    return myMap;
  }

  //add a new action to return the map of all types with account details
  @AuraEnabled(cacheable=true)
  public static Map<String, AccountDetails> getAccountTypesWithDetails() {
    Map<String, AccountDetails> myMap = new Map<String, AccountDetails>();

    AccountDetails prospect = new AccountDetails();
    prospect.accountName = 'PDQ Manufacturing';
    prospect.accountNumber = '12345';
    prospect.accountPhone = '123-456-7890';
    prospect.accountWebsite = 'www.salesforce.com';
    prospect.accountType = 'Prospect';
    myMap.put('Prospect', prospect);

    AccountDetails customer = new AccountDetails();
    customer.accountName = 'Acme Corporation';
    customer.accountNumber = '54321';
    customer.accountPhone = '123-456';
    customer.accountWebsite = 'www.salesforce.com';
    customer.accountType = 'Customer';

    myMap.put('Customer', customer);

    AccountDetails partner = new AccountDetails();
    partner.accountName = 'XYZ Corporation';
    partner.accountNumber = '67890';
    partner.accountPhone = '123-456-7890';
    partner.accountWebsite = 'www.salesforce.com';
    partner.accountType = 'Partner';

    myMap.put('Partner', partner);

    return myMap;
  }
}
