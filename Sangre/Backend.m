//
//  Backend.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/13/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backend.h"

@implementation BackendRow
{
    NSString* mTitle;
    NSString* mContent;
}

- (id) initWithTitle:(NSString*)title andContent:(NSString*)content {
    self = [super init];
    mTitle = title;
    mContent = content;
    return self;
}

- (NSString*) content {
    return mContent;
}

- (NSString*) title {
    return mTitle;
}

@end

@implementation Backend {
    GDataFeedSpreadsheet *mSpreadsheetFeed;
    NSError *mSpreadsheetFetchError;
    SEL mFinishedSelector;
    NSObject* mFinishedObject;
}

- (void) update:(NSObject*)finishedObject withSelector:(SEL)finishedSelector; {
    self = [super init];
    
    NSURL *eventsFeedURL = [NSURL
                            URLWithString:@"https://spreadsheets.google.com/feeds/list/1SCVZzclIEYrSohgpmg5oy4WXWW0P8-3eZnOjRL_dyWc/2/public/full"];
    
    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    [service fetchFeedWithURL:eventsFeedURL delegate:self didFinishSelector:@selector(feedTicket:finishedWithFeed:error:)];
    mFinishedSelector = finishedSelector;
    mFinishedObject = finishedObject;
}

- (void)feedTicket:(GDataServiceTicket *)ticket
  finishedWithFeed:(GDataFeedSpreadsheet *)feed
             error:(NSError *)error {
    
    [self setSpreadsheetFeed:feed];
    if (error) {
        [self setSpreadsheetFetchError:error];
    }
    [mFinishedObject performSelector:mFinishedSelector];
}

- (void)setSpreadsheetFeed:(GDataFeedSpreadsheet *)feed {
    [mSpreadsheetFeed autorelease];
    mSpreadsheetFeed = [feed retain];
}

- (void)setSpreadsheetFetchError:(NSError *)error {
    [mSpreadsheetFetchError release];
    mSpreadsheetFetchError = [error retain];
}

- (GDataFeedSpreadsheet *)spreadsheetFeed {
    return mSpreadsheetFeed;
}

- (GDataServiceGoogleSpreadsheet *)spreadsheetService
{
    static GDataServiceGoogleSpreadsheet* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleSpreadsheet alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    return service;
}

- (NSError *)spreadsheetFetchError {
    return mSpreadsheetFetchError;
}

- (BackendRow *) rowAt:(NSInteger)index {
    GDataEntrySpreadsheet* row = [[mSpreadsheetFeed entries] objectAtIndex:index];
    return [[BackendRow alloc] initWithTitle:[[row title] stringValue] andContent:[[row content] stringValue]];
}

- (NSInteger) count {
    if (mSpreadsheetFeed) {
        return [[mSpreadsheetFeed entries] count];
    }
    return 0;
}

@end

