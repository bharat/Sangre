//
//  Backend.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backend.h"
#import "DateUtils.h"
@import UIKit;

@implementation BackendEntry {
    NSDate* mDate;
    NSString* mValue;
    HistoryEntryType mType;
    id mEntryId;
}

- (id) initWithDate:(NSDate*)date andValue:(NSString*)value andId:(id)entryId {
    self = [super init];
    mDate = date;
    mValue = value;
    mType = kBloodSugar;
    mEntryId = entryId;
    return self;
}

- (HistoryEntryType) type {
    return mType;
}

- (NSDate*) date {
    return mDate;
}

- (NSString*) value {
    return mValue;
}

- (id)entryId {
    return mEntryId;
}
@end

@implementation BackendDate {
    NSString* mTitle;
    NSMutableArray* mEntries;
}

-(id)initWithTitle:(NSString *)title {
    self = [super init];
    mTitle = title;
    mEntries = [[NSMutableArray alloc] init];
    return self;
}

-(NSString*) title {
    return mTitle;
}

-(BackendEntry*) entryAtIndex:(NSInteger)index {
    return (BackendEntry*)[mEntries objectAtIndex:index];
}

-(NSInteger) count {
    return [mEntries count];
}

-(void) add:(BackendEntry *)entry {
    [mEntries addObject:entry];
}

-(void)deleteAtIndex:(NSInteger)index andThen:(void (^)(BOOL))callback {
    [[Backend singleton] deleteEntry:[[self entryAtIndex:index] entryId] andThen:^(BOOL success){
        if (success) {
            [mEntries removeObjectAtIndex:index];
        }
        callback(success);
    }];
}
@end


@implementation BackendDateArray {
    NSMutableDictionary* mDates;
    NSMutableArray* mDateOrder;
}

-(id) init {
    self = [super init];
    mDates = [[NSMutableDictionary alloc] init];
    mDateOrder = [[NSMutableArray alloc] init];
    return self;
}

-(void) add:(BackendEntry*)entry {
    NSString* title = [DateUtils toDateString:entry.date];
    if (![mDates valueForKey:title]) {
        [mDates setValue:[[BackendDate alloc] initWithTitle:title] forKey:title];
        [mDateOrder addObject:title];
    }
    [[mDates valueForKey:title] add:entry];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [mDates objectForKey:[mDateOrder objectAtIndex:index]];
}

- (NSInteger)count {
    return [mDateOrder count];
}
@end


@implementation Backend {
    GDataFeedSpreadsheet* mFeed;
    GTMOAuth2Authentication* mAuth;
    BackendDateArray* mDateArray;
}

NSString *kKeychainItemName = @"com.menalto.Sangre";
NSString *kMyClientID = @"336095338870-fqh5c3k8ug6772lcms8rmo07b0kqieh5.apps.googleusercontent.com";
NSString *kMyClientSecret = @"Pn2jFjL39S94ko0diFdb4z8_";
NSString *scope = @"https://spreadsheets.google.com/feeds";

+ (id) singleton {
    static Backend *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

#pragma mark OAuth

+ (void) loadAuthenticationFromKeychain {
    GTMOAuth2Authentication* auth;
    auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                 clientID:kMyClientID
                                                             clientSecret:kMyClientSecret];
    [[Backend singleton] setAuthentication:auth];
}

- (BOOL) isAuthenticated {
    return mAuth && [mAuth canAuthorize];
}

- (UIViewController*) getAuthenticationViewController {
    // Authenticate for spreadsheet feeds using OAuth

    GTMOAuth2ViewControllerTouch* viewController = [GTMOAuth2ViewControllerTouch alloc];
    [viewController initWithScope:scope
                         clientID:kMyClientID
                     clientSecret:kMyClientSecret
                 keychainItemName:kKeychainItemName
                completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                    if (error) {
                        [[UIAlertView alloc] initWithTitle:@"auth error"
                                                   message:[error debugDescription]
                                                  delegate:self
                                         cancelButtonTitle:@"cancel"
                                         otherButtonTitles:@"ok", nil];
                    } else {
                        [[Backend singleton] setAuthentication:auth];
                    }
                }];
    [viewController autorelease];
    return viewController;
}

- (void) setAuthentication:(GTMOAuth2Authentication *)auth {
    [mAuth autorelease];
    mAuth = [auth retain];
}

#pragma mark GData

- (void)setFeed:(GDataFeedSpreadsheet *)feed {
    [mFeed autorelease];
    mFeed = [feed retain];
}

- (GDataServiceGoogleSpreadsheet *)spreadsheetService {
    static GDataServiceGoogleSpreadsheet* service = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        service = [[GDataServiceGoogleSpreadsheet alloc] init];
        
        [service setShouldCacheResponseData:NO];
        [service setServiceShouldFollowNextLinks:YES];
        [service setAuthorizer:mAuth];
    });
    
    return service;
}

#pragma mark Backend

- (BackendDate*) dateAtIndex:(NSInteger)index {
    return [mDateArray objectAtIndex:index];
}

- (BackendEntry*) entryAt:(NSInteger)entryIndex forDateAtIndex:(NSInteger)dateIndex {
    return [[mDateArray objectAtIndex:dateIndex] objectAtIndex:entryIndex];
}

- (NSString*) titleForDateAtIndex:(NSInteger)index {
    return [[mDateArray objectAtIndex:index] title];
}

- (NSInteger) dateCount {
    return [mDateArray count];
}

-(void) loadEvents:(void(^)(BOOL))callback {
    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    NSURL *eventsFeedURL =
      [NSURL URLWithString:@"https://spreadsheets.google.com/feeds/list/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/1/private/full"];
    
    [service fetchFeedWithURL:eventsFeedURL
        completionHandler:^(GDataServiceTicket *ticket, GDataFeedBase *feed, NSError *error) {
            if (error) {
                [[UIAlertView alloc] initWithTitle:@"feed error"
                                           message:[error debugDescription]
                                          delegate:self
                                 cancelButtonTitle:@"cancel"
                                 otherButtonTitles:@"ok", nil];
            } else {
                mDateArray = [[BackendDateArray alloc] init];
                for (GDataEntrySpreadsheetList* row in [feed entries]) {
                    NSArray* cols = [row customElements];
                    BackendEntry* entry = [BackendEntry alloc];
                    [entry initWithDate:[DateUtils googleDocsStringToDate:[[cols objectAtIndex:0] stringValue]]
                               andValue:[[cols objectAtIndex:2] stringValue]
                                  andId:row];
                    [mDateArray add:entry];
                }
                [self setFeed:(GDataFeedSpreadsheet*)feed];
            }
            callback(error == nil);
        }
     ];
}

-(void) addBgValue:(NSString*)bgValue andThen:(void(^)(BOOL))callback {
    NSDate* now = [DateUtils convertLocalTimezoneToSystemTimezone:[NSDate date]];
    
    GDataEntrySpreadsheetList *entry = [GDataEntrySpreadsheetList listEntry];
    GDataSpreadsheetCustomElement *obj1 =
        [GDataSpreadsheetCustomElement elementWithName:@"timestamp" stringValue:[DateUtils toGoogleDocsString:now]];
    GDataSpreadsheetCustomElement *obj2 =
        [GDataSpreadsheetCustomElement elementWithName:@"type" stringValue:@"bg"];
    GDataSpreadsheetCustomElement *obj3 =
        [GDataSpreadsheetCustomElement elementWithName:@"value" stringValue:bgValue];
    NSArray* array = [NSArray arrayWithObjects:obj1, obj2, obj3, nil];
    [entry setCustomElements:array];

    GDataServiceGoogleSpreadsheet* service = [self spreadsheetService];
    [service fetchEntryByInsertingEntry:entry
                             forFeedURL:[[mFeed postLink] URL]
                      completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error) {
                          if (error) {
                              [[UIAlertView alloc] initWithTitle:@"feed error"
                                                         message:[error debugDescription]
                                                        delegate:self
                                               cancelButtonTitle:@"cancel"
                                               otherButtonTitles:@"ok", nil];
                          }
                          callback(error == nil);
                      }
     ];
}

-(void) deleteEntry:(id)entryId andThen:(void (^)(BOOL))callback {
    GDataServiceGoogleSpreadsheet* service = [self spreadsheetService];
    [service deleteEntry:entryId
       completionHandler:^(GDataServiceTicket *ticket, GDataEntryBase *entry, NSError *error) {
           if (error) {
               [[UIAlertView alloc] initWithTitle:@"feed error"
                                          message:[error debugDescription]
                                         delegate:self
                                cancelButtonTitle:@"cancel"
                                otherButtonTitles:@"ok", nil];
           }
           callback(error == nil);
       }
     ];
}

@end

