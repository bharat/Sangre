//
//  DateUtils.m
//  Sangre
//
//  Created by Bharat Mediratta on 2/17/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateUtils.h"

@implementation DateUtils

+ (NSDate *)convertLocalTimezoneToSystemTimezone:(NSDate *)date {
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *pstTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    
    NSInteger currentPstOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger pstOffset = [pstTimeZone secondsFromGMTForDate:date];
    NSTimeInterval delta = pstOffset - currentPstOffset;
    NSDate *pstDate = [[[NSDate alloc] initWithTimeInterval:delta sinceDate:date] autorelease];
    return pstDate;
}

+ (NSDate *)googleDocsStringToDate:(NSString *)timestampString {
    static NSDateFormatter* formatter;
    static dispatch_once_t token;
    dispatch_once(&token, ^(void){
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    });

    return [formatter dateFromString:timestampString];
}

+ (NSString*)toTimeString:(NSDate*)date {
    static NSDateFormatter* formatter;
    static dispatch_once_t token;
    dispatch_once(&token, ^(void){
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"hh:mm aaa";
    });

    return [formatter stringFromDate:date];
}

+ (NSString*)toDateString:(NSDate*)date {
    static NSDateFormatter* formatter;
    static dispatch_once_t token;
    dispatch_once(&token, ^(void){
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMMM dd";
    });

    return [formatter stringFromDate:date];
}

+ (NSString*)toGoogleDocsString:(NSDate*)date {
    static NSDateFormatter* formatter;
    static dispatch_once_t token;
    dispatch_once(&token, ^(void){
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    });

    return [formatter stringFromDate:date];
}
@end