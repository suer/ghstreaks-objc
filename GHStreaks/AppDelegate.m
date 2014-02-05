//
//  AppDelegate.m
//  GHStreaks
//
//  Created by suer on 2014/01/27.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize navigationController = _navigationController;

@synthesize mainViewController = _mainViewController;

@synthesize preferenceViewController = _preferenceViewController;

@synthesize currentStreaks = _currentStreaks;

+ (AppDelegate *)sharedDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)setup:(UIApplication *)application
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self loadRootViewController];
    [self setupNotification:application];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [self setup:application];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self setup:application];
}

- (void)loadRootViewController
{
    self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.window addSubview:navController.view];
    self.window.rootViewController = navController;
}

- (void)setupNotification:(UIApplication *)application
{

    [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge|
                                                      UIRemoteNotificationTypeSound|
                                                      UIRemoteNotificationTypeAlert)];
}

- (NSData *)getDeviceToken
{
    return self.deviceToken;
}

-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.deviceToken = deviceToken;
    NSLog(@"got deviceToken: %@", self.deviceToken);
}

- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err
{
    NSLog(@"got err: %@", err);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerForRemoteNotifications
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
}

+ (NSString *)userDefaultsKeyGitHubUser
{
    return @"GITHUB_USER";
}
@end
