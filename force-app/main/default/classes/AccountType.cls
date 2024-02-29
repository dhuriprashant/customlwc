public with sharing class AccountType {
  @AuraEnabled
  public String name { get; set; }
  @AuraEnabled
  public String label { get; set; }
  @AuraEnabled
  public String icon { get; set; }
}
