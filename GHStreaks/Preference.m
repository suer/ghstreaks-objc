//
//  Preference.m
//  GHStreaks
//
//  Created by suer on 2014/02/02.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "Preference.h"

@implementation Preference

NSString * const USER_DEFAULTS_KEY_GITHUB_USER = @"GITHUB_USER";
NSString * const USER_DEFAULTS_KEY_NOTIFICATION_HOUR = @"NOTIFICATION_HOUR";

- (id)init
{
    return self;
}

+ (NSString *)getServiceURL
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [bundle pathForResource:@"preference" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:path];
    return [root objectForKey:@"ServiceURL"];
}

- (NSString *)getGitHubUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_DEFAULTS_KEY_GITHUB_USER];
}

- (void)setGitHubUser:(NSString *)gitHubUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:gitHubUser forKey:USER_DEFAULTS_KEY_GITHUB_USER];
}

- (NSString *)getNotificationHour
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:USER_DEFAULTS_KEY_NOTIFICATION_HOUR];
}

- (void)setNotificationHour:(NSString *)notificationHour
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:notificationHour forKey:USER_DEFAULTS_KEY_NOTIFICATION_HOUR];
}

@end
