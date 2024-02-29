public with sharing class AccountDetails {
  @AuraEnabled
  public String accountName { get; set; }
  @AuraEnabled
  public String accountNumber { get; set; }
  @AuraEnabled
  public String accountPhone { get; set; }
  @AuraEnabled
  public String accountWebsite { get; set; }
  @AuraEnabled
  public String accountType { get; set; }
  @AuraEnabled
  public String accountIndustry { get; set; }
  @AuraEnabled
  public String accountRating { get; set; }
  @AuraEnabled
  public String accountAnnualRevenue { get; set; }
  @AuraEnabled
  public String accountNumberOfEmployees { get; set; }
}
