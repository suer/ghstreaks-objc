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
    
    AppDelegate *delegate = [AppDelegate sharedDelegate];
    self.deviceTokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 100)];
    const unsigned *tokenBytes = [[delegate getDeviceToken] bytes];
    NSString *token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                            ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                            ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                            ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    self.deviceTokenLabel.text = token;

    [self.deviceTokenLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:self.deviceTokenLabel];
    
    UIButton *sendingMailDeviceTokenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendingMailDeviceTokenButton.frame = CGRectMake(10, 100, 300, 30);
    [sendingMailDeviceTokenButton setTitle:@"デバイストークンをメールで送信" forState:UIControlStateNormal];
    [sendingMailDeviceTokenButton addTarget:self action:@selector(sendingMailDeviceTokenButtonTapped:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sendingMailDeviceTokenButton];
}

-(void)sendingMailDeviceTokenButtonTapped:(UIButton *)button
{
    if([MFMailComposeViewController canSendMail] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"メール送信の設定されていません。操作を中止します。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    [mailViewController setSubject:@"デバイストークン"];
    [mailViewController setMessageBody:self.deviceTokenLabel.text isHTML:false];
    mailViewController.mailComposeDelegate = self;
    
    [self presentViewController:mailViewController animated:true completion:nil];
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
