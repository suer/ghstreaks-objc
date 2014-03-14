//
//  Preference.h
//  GHStreaks
//
//  Created by suer on 2014/02/02.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preference : NSObject

+ (NSString *)getServiceURL;

- (NSString *)getGitHubUser;
- (void)setGitHubUser:(NSString *)gitHubUser;

- (NSString *)getNotificationHour;
- (void)setNotificationHour:(NSString *)notificationHour;

- (BOOL)isSet;
@end
