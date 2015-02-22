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

+ (NSDate *)normalizeTimezone:(NSDate *)date {
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *pstTimeZone = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
    
    NSInteger currentPstOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger pstOffset = [pstTimeZone secondsFromGMTForDate:date];
    NSTimeInterval delta = pstOffset - currentPstOffset;
    NSDate *pstDate = [[[NSDate alloc] initWithTimeInterval:delta sinceDate:date] autorelease];
    return pstDate;
}

+ (NSDate *)toDate:(NSString *)timestampString {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    return [formatter dateFromString:timestampString];
}

+ (NSString*)toString:(NSDate*)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MMM HH:mm";
    return [formatter stringFromDate:date];
}
@end