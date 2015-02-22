//
//  DateUtils.h
//  Sangre
//
//  Created by Bharat Mediratta on 2/17/15.
//  Copyright (c) 2015 Menalto. All rights reserved.
//

#ifndef Sangre_DateUtils_h
#define Sangre_DateUtils_h

@interface DateUtils : NSObject
+ (NSDate*)toDate:(NSString*)timestampString;
+ (NSString*)toString:(NSDate*)date;
+ (NSDate*)normalizeTimezone:(NSDate*)date;
@end

#endif
