//
//  MainViewController.m
//  GHStreaks
//
//  Created by suer on 2014/01/28.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import "MainViewController.h"
#import "PreferenceViewController.h"

@interface MainViewController ()

@property (nonatomic) UIBarButtonItem *preferenceButton;

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
}

- (void)loadToolBarButtons
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.preferenceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preference-button.png"]
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(openPreferenceWindow:)];

    self.toolbarItems = @[self.preferenceButton];
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
