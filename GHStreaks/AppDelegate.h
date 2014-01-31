//
//  AppDelegate.h
//  GHStreaks
//
//  Created by suer on 2014/01/27.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "PreferenceViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) MainViewController *mainViewController;

@property (strong, nonatomic) PreferenceViewController *preferenceViewController;

@property (strong, nonatomic) NSData *deviceToken;

- (void)registerForRemoteNotifications;

- (NSData *)getDeviceToken;
    
@end
