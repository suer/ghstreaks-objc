//
//  MainViewController.m
//  GHStreaks
//
//  Created by suer on 2014/01/28.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "MainViewController.h"
#import "PreferenceViewController.h"
#import <LRResty.h>

@interface MainViewController ()

@property (nonatomic) UIBarButtonItem *preferenceButton;

@property (nonatomic) UILabel *streaksLabel;
@end

@implementation MainViewController

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

    [self loadToolBarButtons];
    [self loadText];
}

- (void)loadToolBarButtons
{
    [self.navigationController setToolbarHidden:NO animated:YES];

    UIBarButtonItem *reloadButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                           target:self
                                                                           action:@selector(reload:)];

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil
                               action:nil];

    self.preferenceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preference-button.png"]
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(openPreferenceWindow:)];

    self.toolbarItems = @[reloadButton, spacer, self.preferenceButton];
}

- (void)loadText
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UILabel *titleLabel = [UILabelHelper createUILabel:0 pointY:140 width:screenRect.size.width height:30 fontSize:30 text:@"Current Streaks"];
    [self.view addSubview:titleLabel];

    self.streaksLabel = [UILabelHelper createUILabel:0 pointY:200 width:screenRect.size.width height:100 fontSize:100 text:@""];
    NSString *user = [[AppDelegate sharedDelegate] getGitHubUser];
    if (user != nil) {
        [self showCurrentStreaks:user];
    }
    [self.view addSubview:self.streaksLabel];
}

- (void)showCurrentStreaks:(NSString *)user
{
    if ([user isEqualToString:@""]) {
        self.streaksLabel.text = @"";
    }
    [SVProgressHUD showWithStatus:@"Getting streaks..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *url = [NSString stringWithFormat:@"https://ghstreaks-service.herokuapp.com/streaks/%@", user];
    [[LRResty client] get:url withBlock:^(LRRestyResponse *response) {
        NSString *json = [response asString];
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
        if (error != nil) {
            NSLog(@"failed to parse Json %ld", (long)error.code);
            [SVProgressHUD showErrorWithStatus:@"Failure"];
        } else {
            self.streaksLabel.text = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"current_streaks"] intValue]];
            [SVProgressHUD showSuccessWithStatus:@"Success"];
        }
    }];
}

- (void)reload:(id)sender
{
    NSString *user = [[AppDelegate sharedDelegate] getGitHubUser];
    if (user != nil) {
        [self showCurrentStreaks:user];
    }
}

- (void)openPreferenceWindow:(id)sender
{
    PreferenceViewController *preferenceViewController = [[PreferenceViewController alloc] initWithNibName:nil bundle:nil];
    preferenceViewController.title = @"設定";
    [self.navigationController pushViewController:preferenceViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
