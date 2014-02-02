//
//  PreferenceViewController.m
//  GHStreaks
//
//  Created by suer on 2014/01/28.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "PreferenceViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PreferenceViewController ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UILabel *deviceTokenLabel;

@property (strong, nonatomic) UITextField *userNameTextField;

@end

@implementation PreferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDeviceTokenLabel];
    [self addUserNameTextField];
    [self addRegisterButton];
}

- (void)addDeviceTokenLabel
{
    AppDelegate *delegate = [AppDelegate sharedDelegate];
    self.deviceTokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 100)];
    const unsigned *tokenBytes = [[delegate getDeviceToken] bytes];
    NSString *token = @"";
    if (tokenBytes != NULL) {
        [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                       ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                       ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                       ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    }
    self.deviceTokenLabel.text = token;
    
    [self.deviceTokenLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:self.deviceTokenLabel];
}

- (void)addUserNameTextField
{
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 300, 100)];
    self.userNameTextField.placeholder = @"GitHub User Name";
    [self.view addSubview:self.userNameTextField];
}



- (void)addRegisterButton
{
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(10, 200, 300, 30);
    [registerButton setTitle:@"登録する" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonTapped:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registerButton];
}

- (void)registerButtonTapped:(id)sender
{
    
}

- ( void )mailComposeController:( MFMailComposeViewController* )controller didFinishWithResult:( MFMailComposeResult )result error:( NSError* )error
{
    [controller dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
