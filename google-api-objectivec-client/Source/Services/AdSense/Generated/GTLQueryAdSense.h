/* Copyright (c) 2015 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  GTLQueryAdSense.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   AdSense Management API (adsense/v1.4)
// Description:
//   Gives AdSense publishers access to their inventory and the ability to
//   generate reports
// Documentation:
//   https://developers.google.com/adsense/management/
// Classes:
//   GTLQueryAdSense (38 custom class methods, 22 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLQuery.h"
#else
  #import "GTLQuery.h"
#endif

@interface GTLQueryAdSense : GTLQuery

//
// Parameters valid on all methods.
//

// Selector specifying which fields to include in a partial response.
@property (nonatomic, copy) NSString *fields;

//
// Method-specific parameters; see the comments below for more information.
//
// "accountId" has different types for some query methods; see the documentation
// for the right type for each query method.
@property (nonatomic, retain) id accountId;
@property (nonatomic, copy) NSString *adClientId;
@property (nonatomic, copy) NSString *adUnitId;
@property (nonatomic, copy) NSString *alertId;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *customChannelId;
@property (nonatomic, retain) NSArray *dimension;  // of NSString
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, retain) NSArray *filter;  // of NSString
@property (nonatomic, assign) BOOL includeInactive;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, assign) NSInteger maxResults;
@property (nonatomic, retain) NSArray *metric;  // of NSString
@property (nonatomic, copy) NSString *pageToken;
@property (nonatomic, copy) NSString *savedAdStyleId;
@property (nonatomic, copy) NSString *savedReportId;
@property (nonatomic, retain) NSArray *sort;  // of NSString
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) BOOL tree;
@property (nonatomic, assign) BOOL useTimezoneReporting;

#pragma mark - "accounts.adclients" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.adclients.list
// List all ad clients in the specified account.
//  Required:
//   accountId: Account for which to list ad clients.
//  Optional:
//   maxResults: The maximum number of ad clients to include in the response,
//     used for paging. (0..10000)
//   pageToken: A continuation token, used to page through ad clients. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdClients.
+ (instancetype)queryForAccountsAdclientsListWithAccountId:(NSString *)accountId;

#pragma mark - "accounts.adunits.customchannels" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.adunits.customchannels.list
// List all custom channels which the specified ad unit belongs to.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client which contains the ad unit.
//   adUnitId: Ad unit for which to list custom channels.
//  Optional:
//   maxResults: The maximum number of custom channels to include in the
//     response, used for paging. (0..10000)
//   pageToken: A continuation token, used to page through custom channels. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseCustomChannels.
+ (instancetype)queryForAccountsAdunitsCustomchannelsListWithAccountId:(NSString *)accountId
                                                            adClientId:(NSString *)adClientId
                                                              adUnitId:(NSString *)adUnitId;

#pragma mark - "accounts.adunits" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.adunits.get
// Gets the specified ad unit in the specified ad client for the specified
// account.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client for which to get the ad unit.
//   adUnitId: Ad unit to retrieve.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdUnit.
+ (instancetype)queryForAccountsAdunitsGetWithAccountId:(NSString *)accountId
                                             adClientId:(NSString *)adClientId
                                               adUnitId:(NSString *)adUnitId;

// Method: adsense.accounts.adunits.getAdCode
// Get ad code for the specified ad unit.
//  Required:
//   accountId: Account which contains the ad client.
//   adClientId: Ad client with contains the ad unit.
//   adUnitId: Ad unit to get the code for.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdCode.
+ (instancetype)queryForAccountsAdunitsGetAdCodeWithAccountId:(NSString *)accountId
                                                   adClientId:(NSString *)adClientId
                                                     adUnitId:(NSString *)adUnitId;

// Method: adsense.accounts.adunits.list
// List all ad units in the specified ad client for the specified account.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client for which to list ad units.
//  Optional:
//   includeInactive: Whether to include inactive ad units. Default: true.
//   maxResults: The maximum number of ad units to include in the response, used
//     for paging. (0..10000)
//   pageToken: A continuation token, used to page through ad units. To retrieve
//     the next page, set this parameter to the value of "nextPageToken" from
//     the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdUnits.
+ (instancetype)queryForAccountsAdunitsListWithAccountId:(NSString *)accountId
                                              adClientId:(NSString *)adClientId;

#pragma mark - "accounts.alerts" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.alerts.delete
// Dismiss (delete) the specified alert from the specified publisher AdSense
// account.
//  Required:
//   accountId: Account which contains the ad unit.
//   alertId: Alert to delete.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
+ (instancetype)queryForAccountsAlertsDeleteWithAccountId:(NSString *)accountId
                                                  alertId:(NSString *)alertId;

// Method: adsense.accounts.alerts.list
// List the alerts for the specified AdSense account.
//  Required:
//   accountId: Account for which to retrieve the alerts.
//  Optional:
//   locale: The locale to use for translating alert messages. The account
//     locale will be used if this is not supplied. The AdSense default
//     (English) will be used if the supplied locale is invalid or unsupported.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAlerts.
+ (instancetype)queryForAccountsAlertsListWithAccountId:(NSString *)accountId;

#pragma mark - "accounts.customchannels.adunits" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.customchannels.adunits.list
// List all ad units in the specified custom channel.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client which contains the custom channel.
//   customChannelId: Custom channel for which to list ad units.
//  Optional:
//   includeInactive: Whether to include inactive ad units. Default: true.
//   maxResults: The maximum number of ad units to include in the response, used
//     for paging. (0..10000)
//   pageToken: A continuation token, used to page through ad units. To retrieve
//     the next page, set this parameter to the value of "nextPageToken" from
//     the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdUnits.
+ (instancetype)queryForAccountsCustomchannelsAdunitsListWithAccountId:(NSString *)accountId
                                                            adClientId:(NSString *)adClientId
                                                       customChannelId:(NSString *)customChannelId;

#pragma mark - "accounts.customchannels" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.customchannels.get
// Get the specified custom channel from the specified ad client for the
// specified account.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client which contains the custom channel.
//   customChannelId: Custom channel to retrieve.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseCustomChannel.
+ (instancetype)queryForAccountsCustomchannelsGetWithAccountId:(NSString *)accountId
                                                    adClientId:(NSString *)adClientId
                                               customChannelId:(NSString *)customChannelId;

// Method: adsense.accounts.customchannels.list
// List all custom channels in the specified ad client for the specified
// account.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client for which to list custom channels.
//  Optional:
//   maxResults: The maximum number of custom channels to include in the
//     response, used for paging. (0..10000)
//   pageToken: A continuation token, used to page through custom channels. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseCustomChannels.
+ (instancetype)queryForAccountsCustomchannelsListWithAccountId:(NSString *)accountId
                                                     adClientId:(NSString *)adClientId;

#pragma mark - "accounts" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.get
// Get information about the selected AdSense account.
//  Required:
//   accountId: Account to get information about.
//  Optional:
//   tree: Whether the tree of sub accounts should be returned.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAccount.
+ (instancetype)queryForAccountsGetWithAccountId:(NSString *)accountId;

// Method: adsense.accounts.list
// List all accounts available to this AdSense account.
//  Optional:
//   maxResults: The maximum number of accounts to include in the response, used
//     for paging. (0..10000)
//   pageToken: A continuation token, used to page through accounts. To retrieve
//     the next page, set this parameter to the value of "nextPageToken" from
//     the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAccounts.
+ (instancetype)queryForAccountsList;

#pragma mark - "accounts.payments" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.payments.list
// List the payments for the specified AdSense account.
//  Required:
//   accountId: Account for which to retrieve the payments.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSensePayments.
+ (instancetype)queryForAccountsPaymentsListWithAccountId:(NSString *)accountId;

#pragma mark - "accounts.reports" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.reports.generate
// Generate an AdSense report based on the report request sent in the query
// parameters. Returns the result as JSON; to retrieve output in CSV format
// specify "alt=csv" as a query parameter.
//  Required:
//   accountId: Account upon which to report.
//   startDate: Start of the date range to report on in "YYYY-MM-DD" format,
//     inclusive.
//   endDate: End of the date range to report on in "YYYY-MM-DD" format,
//     inclusive.
//  Optional:
//   currency: Optional currency to use when reporting on monetary metrics.
//     Defaults to the account's currency if not set.
//   dimension: Dimensions to base the report on.
//   filter: Filters to be run on the report.
//   locale: Optional locale to use for translating report output to a local
//     language. Defaults to "en_US" if not specified.
//   maxResults: The maximum number of rows of report data to return. (0..50000)
//   metric: Numeric columns to include in the report.
//   sort: The name of a dimension or metric to sort the resulting report on,
//     optionally prefixed with "+" to sort ascending or "-" to sort descending.
//     If no prefix is specified, the column is sorted ascending.
//   startIndex: Index of the first row of report data to return. (0..5000)
//   useTimezoneReporting: Whether the report should be generated in the AdSense
//     account's local timezone. If false default PST/PDT timezone will be used.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdsenseReportsGenerateResponse.
+ (instancetype)queryForAccountsReportsGenerateWithAccountId:(NSString *)accountId
                                                   startDate:(NSString *)startDate
                                                     endDate:(NSString *)endDate;

#pragma mark - "accounts.reports.saved" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.reports.saved.generate
// Generate an AdSense report based on the saved report ID sent in the query
// parameters.
//  Required:
//   accountId: Account to which the saved reports belong.
//   savedReportId: The saved report to retrieve.
//  Optional:
//   locale: Optional locale to use for translating report output to a local
//     language. Defaults to "en_US" if not specified.
//   maxResults: The maximum number of rows of report data to return. (0..50000)
//   startIndex: Index of the first row of report data to return. (0..5000)
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdsenseReportsGenerateResponse.
+ (instancetype)queryForAccountsReportsSavedGenerateWithAccountId:(NSString *)accountId
                                                    savedReportId:(NSString *)savedReportId;

// Method: adsense.accounts.reports.saved.list
// List all saved reports in the specified AdSense account.
//  Required:
//   accountId: Account to which the saved reports belong.
//  Optional:
//   maxResults: The maximum number of saved reports to include in the response,
//     used for paging. (0..100)
//   pageToken: A continuation token, used to page through saved reports. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseSavedReports.
+ (instancetype)queryForAccountsReportsSavedListWithAccountId:(NSString *)accountId;

#pragma mark - "accounts.savedadstyles" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.savedadstyles.get
// List a specific saved ad style for the specified account.
//  Required:
//   accountId: Account for which to get the saved ad style.
//   savedAdStyleId: Saved ad style to retrieve.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseSavedAdStyle.
+ (instancetype)queryForAccountsSavedadstylesGetWithAccountId:(NSString *)accountId
                                               savedAdStyleId:(NSString *)savedAdStyleId;

// Method: adsense.accounts.savedadstyles.list
// List all saved ad styles in the specified account.
//  Required:
//   accountId: Account for which to list saved ad styles.
//  Optional:
//   maxResults: The maximum number of saved ad styles to include in the
//     response, used for paging. (0..10000)
//   pageToken: A continuation token, used to page through saved ad styles. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseSavedAdStyles.
+ (instancetype)queryForAccountsSavedadstylesListWithAccountId:(NSString *)accountId;

#pragma mark - "accounts.urlchannels" methods
// These create a GTLQueryAdSense object.

// Method: adsense.accounts.urlchannels.list
// List all URL channels in the specified ad client for the specified account.
//  Required:
//   accountId: Account to which the ad client belongs.
//   adClientId: Ad client for which to list URL channels.
//  Optional:
//   maxResults: The maximum number of URL channels to include in the response,
//     used for paging. (0..10000)
//   pageToken: A continuation token, used to page through URL channels. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseUrlChannels.
+ (instancetype)queryForAccountsUrlchannelsListWithAccountId:(NSString *)accountId
                                                  adClientId:(NSString *)adClientId;

#pragma mark - "adclients" methods
// These create a GTLQueryAdSense object.

// Method: adsense.adclients.list
// List all ad clients in this AdSense account.
//  Optional:
//   maxResults: The maximum number of ad clients to include in the response,
//     used for paging. (0..10000)
//   pageToken: A continuation token, used to page through ad clients. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdClients.
+ (instancetype)queryForAdclientsList;

#pragma mark - "adunits.customchannels" methods
// These create a GTLQueryAdSense object.

// Method: adsense.adunits.customchannels.list
// List all custom channels which the specified ad unit belongs to.
//  Required:
//   adClientId: Ad client which contains the ad unit.
//   adUnitId: Ad unit for which to list custom channels.
//  Optional:
//   maxResults: The maximum number of custom channels to include in the
//     response, used for paging. (0..10000)
//   pageToken: A continuation token, used to page through custom channels. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseCustomChannels.
+ (instancetype)queryForAdunitsCustomchannelsListWithAdClientId:(NSString *)adClientId
                                                       adUnitId:(NSString *)adUnitId;

#pragma mark - "adunits" methods
// These create a GTLQueryAdSense object.

// Method: adsense.adunits.get
// Gets the specified ad unit in the specified ad client.
//  Required:
//   adClientId: Ad client for which to get the ad unit.
//   adUnitId: Ad unit to retrieve.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdUnit.
+ (instancetype)queryForAdunitsGetWithAdClientId:(NSString *)adClientId
                                        adUnitId:(NSString *)adUnitId;

// Method: adsense.adunits.getAdCode
// Get ad code for the specified ad unit.
//  Required:
//   adClientId: Ad client with contains the ad unit.
//   adUnitId: Ad unit to get the code for.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdCode.
+ (instancetype)queryForAdunitsGetAdCodeWithAdClientId:(NSString *)adClientId
                                              adUnitId:(NSString *)adUnitId;

// Method: adsense.adunits.list
// List all ad units in the specified ad client for this AdSense account.
//  Required:
//   adClientId: Ad client for which to list ad units.
//  Optional:
//   includeInactive: Whether to include inactive ad units. Default: true.
//   maxResults: The maximum number of ad units to include in the response, used
//     for paging. (0..10000)
//   pageToken: A continuation token, used to page through ad units. To retrieve
//     the next page, set this parameter to the value of "nextPageToken" from
//     the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdUnits.
+ (instancetype)queryForAdunitsListWithAdClientId:(NSString *)adClientId;

#pragma mark - "alerts" methods
// These create a GTLQueryAdSense object.

// Method: adsense.alerts.delete
// Dismiss (delete) the specified alert from the publisher's AdSense account.
//  Required:
//   alertId: Alert to delete.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
+ (instancetype)queryForAlertsDeleteWithAlertId:(NSString *)alertId;

// Method: adsense.alerts.list
// List the alerts for this AdSense account.
//  Optional:
//   locale: The locale to use for translating alert messages. The account
//     locale will be used if this is not supplied. The AdSense default
//     (English) will be used if the supplied locale is invalid or unsupported.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAlerts.
+ (instancetype)queryForAlertsList;

#pragma mark - "customchannels.adunits" methods
// These create a GTLQueryAdSense object.

// Method: adsense.customchannels.adunits.list
// List all ad units in the specified custom channel.
//  Required:
//   adClientId: Ad client which contains the custom channel.
//   customChannelId: Custom channel for which to list ad units.
//  Optional:
//   includeInactive: Whether to include inactive ad units. Default: true.
//   maxResults: The maximum number of ad units to include in the response, used
//     for paging. (0..10000)
//   pageToken: A continuation token, used to page through ad units. To retrieve
//     the next page, set this parameter to the value of "nextPageToken" from
//     the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdUnits.
+ (instancetype)queryForCustomchannelsAdunitsListWithAdClientId:(NSString *)adClientId
                                                customChannelId:(NSString *)customChannelId;

#pragma mark - "customchannels" methods
// These create a GTLQueryAdSense object.

// Method: adsense.customchannels.get
// Get the specified custom channel from the specified ad client.
//  Required:
//   adClientId: Ad client which contains the custom channel.
//   customChannelId: Custom channel to retrieve.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseCustomChannel.
+ (instancetype)queryForCustomchannelsGetWithAdClientId:(NSString *)adClientId
                                        customChannelId:(NSString *)customChannelId;

// Method: adsense.customchannels.list
// List all custom channels in the specified ad client for this AdSense account.
//  Required:
//   adClientId: Ad client for which to list custom channels.
//  Optional:
//   maxResults: The maximum number of custom channels to include in the
//     response, used for paging. (0..10000)
//   pageToken: A continuation token, used to page through custom channels. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseCustomChannels.
+ (instancetype)queryForCustomchannelsListWithAdClientId:(NSString *)adClientId;

#pragma mark - "metadata.dimensions" methods
// These create a GTLQueryAdSense object.

// Method: adsense.metadata.dimensions.list
// List the metadata for the dimensions available to this AdSense account.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseMetadata.
+ (instancetype)queryForMetadataDimensionsList;

#pragma mark - "metadata.metrics" methods
// These create a GTLQueryAdSense object.

// Method: adsense.metadata.metrics.list
// List the metadata for the metrics available to this AdSense account.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseMetadata.
+ (instancetype)queryForMetadataMetricsList;

#pragma mark - "payments" methods
// These create a GTLQueryAdSense object.

// Method: adsense.payments.list
// List the payments for this AdSense account.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSensePayments.
+ (instancetype)queryForPaymentsList;

#pragma mark - "reports" methods
// These create a GTLQueryAdSense object.

// Method: adsense.reports.generate
// Generate an AdSense report based on the report request sent in the query
// parameters. Returns the result as JSON; to retrieve output in CSV format
// specify "alt=csv" as a query parameter.
//  Required:
//   startDate: Start of the date range to report on in "YYYY-MM-DD" format,
//     inclusive.
//   endDate: End of the date range to report on in "YYYY-MM-DD" format,
//     inclusive.
//  Optional:
//   accountId: Accounts upon which to report.
//     Note: For this method, "accountId" should be of type NSArray<NSString>.
//   currency: Optional currency to use when reporting on monetary metrics.
//     Defaults to the account's currency if not set.
//   dimension: Dimensions to base the report on.
//   filter: Filters to be run on the report.
//   locale: Optional locale to use for translating report output to a local
//     language. Defaults to "en_US" if not specified.
//   maxResults: The maximum number of rows of report data to return. (0..50000)
//   metric: Numeric columns to include in the report.
//   sort: The name of a dimension or metric to sort the resulting report on,
//     optionally prefixed with "+" to sort ascending or "-" to sort descending.
//     If no prefix is specified, the column is sorted ascending.
//   startIndex: Index of the first row of report data to return. (0..5000)
//   useTimezoneReporting: Whether the report should be generated in the AdSense
//     account's local timezone. If false default PST/PDT timezone will be used.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdsenseReportsGenerateResponse.
+ (instancetype)queryForReportsGenerateWithStartDate:(NSString *)startDate
                                             endDate:(NSString *)endDate;

#pragma mark - "reports.saved" methods
// These create a GTLQueryAdSense object.

// Method: adsense.reports.saved.generate
// Generate an AdSense report based on the saved report ID sent in the query
// parameters.
//  Required:
//   savedReportId: The saved report to retrieve.
//  Optional:
//   locale: Optional locale to use for translating report output to a local
//     language. Defaults to "en_US" if not specified.
//   maxResults: The maximum number of rows of report data to return. (0..50000)
//   startIndex: Index of the first row of report data to return. (0..5000)
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseAdsenseReportsGenerateResponse.
+ (instancetype)queryForReportsSavedGenerateWithSavedReportId:(NSString *)savedReportId;

// Method: adsense.reports.saved.list
// List all saved reports in this AdSense account.
//  Optional:
//   maxResults: The maximum number of saved reports to include in the response,
//     used for paging. (0..100)
//   pageToken: A continuation token, used to page through saved reports. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseSavedReports.
+ (instancetype)queryForReportsSavedList;

#pragma mark - "savedadstyles" methods
// These create a GTLQueryAdSense object.

// Method: adsense.savedadstyles.get
// Get a specific saved ad style from the user's account.
//  Required:
//   savedAdStyleId: Saved ad style to retrieve.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseSavedAdStyle.
+ (instancetype)queryForSavedadstylesGetWithSavedAdStyleId:(NSString *)savedAdStyleId;

// Method: adsense.savedadstyles.list
// List all saved ad styles in the user's account.
//  Optional:
//   maxResults: The maximum number of saved ad styles to include in the
//     response, used for paging. (0..10000)
//   pageToken: A continuation token, used to page through saved ad styles. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseSavedAdStyles.
+ (instancetype)queryForSavedadstylesList;

#pragma mark - "urlchannels" methods
// These create a GTLQueryAdSense object.

// Method: adsense.urlchannels.list
// List all URL channels in the specified ad client for this AdSense account.
//  Required:
//   adClientId: Ad client for which to list URL channels.
//  Optional:
//   maxResults: The maximum number of URL channels to include in the response,
//     used for paging. (0..10000)
//   pageToken: A continuation token, used to page through URL channels. To
//     retrieve the next page, set this parameter to the value of
//     "nextPageToken" from the previous response.
//  Authorization scope(s):
//   kGTLAuthScopeAdSense
//   kGTLAuthScopeAdSenseReadonly
// Fetches a GTLAdSenseUrlChannels.
+ (instancetype)queryForUrlchannelsListWithAdClientId:(NSString *)adClientId;

@end
