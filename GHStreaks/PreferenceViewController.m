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
#import <LRResty.h>
#import "Preference.h"

@interface PreferenceViewController ()<MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UITextField *userNameTextField;

@property (strong, nonatomic) NSString *serviceURL;

@property (strong, nonatomic) NSMutableArray *hourChoices;
@property (strong, nonatomic) UITextField *hourTextField;
@property (strong, nonatomic) UIPickerView *hourPickerView;

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
    self.serviceURL = [[[Preference alloc] init] serviceURL];
    [self addUserNameTextField];
    [self addHourTextField];
    [self addRegisterButton];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];

    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)addUserNameTextField
{
    UILabel *userNameLabel = [UILabelHelper createUILabel:10 pointY:120 width:90 height:40 text:@"ユーザ名:"];
    [self.view addSubview:userNameLabel];
    
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 120, 210, 40)];
    self.userNameTextField.text = [[AppDelegate sharedDelegate] getGitHubUser];
    self.userNameTextField.placeholder = @"GitHub User Name";
    self.userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.userNameTextField.delegate = self;
    [self.view addSubview:self.userNameTextField];
}

- (void)addHourTextField
{
    UILabel *hourLabel = [UILabelHelper createUILabel:10 pointY:180 width:90 height:40 text:@"通知時刻:"];
    [self.view addSubview:hourLabel];
    
    self.hourTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 180, 210, 40)];
    self.hourTextField.text = [[AppDelegate sharedDelegate] getNotificationHour];
    self.hourTextField.placeholder = @"hour";
    self.hourTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.hourTextField.delegate = self;
    [self.view addSubview:self.hourTextField];

    self.hourChoices = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i++) {
        [self.hourChoices addObject:[NSString stringWithFormat:@"%2d:00", i]];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hourPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenRect.size.height, screenRect.size.width, 216)];
    self.hourPickerView.delegate = self;
    self.hourPickerView.dataSource = self;
    self.hourPickerView.showsSelectionIndicator = YES;
    self.hourPickerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.hourPickerView];
}


- (void)addRegisterButton
{
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(10, 250, 300, 30);
    [registerButton setTitle:@"登録する" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonTapped:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registerButton];
}

- (void)registerButtonTapped:(id)sender
{
    [SVProgressHUD showWithStatus:@"Registering..." maskType:SVProgressHUDMaskTypeBlack];

    NSURL *baseURL = [NSURL URLWithString:self.serviceURL];
    NSURL *registrationURL = [NSURL URLWithString:@"/notifications" relativeToURL:baseURL];
    NSString *utc_offset =  [NSString stringWithFormat:@"%d", (int)([[NSTimeZone defaultTimeZone] secondsFromGMT] / 3600)];
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userNameTextField.text forKey:@"notification[name]"];
    [params setValue:[[AppDelegate sharedDelegate] getDeviceTokenString] forKey:@"notification[device_token]"];
    [params setValue:[self getHourFromString:self.hourTextField.text] forKey:@"notification[hour]"];
    [params setValue:utc_offset forKey:@"notification[utc_offset]"];
    
    [[LRResty client] post:[registrationURL absoluteString] payload:params withBlock:^(LRRestyResponse *response) {
        NSLog(@"%@", [response asString]);
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.navigationController popViewControllerAnimated:YES];
    }];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userNameTextField.text forKey:[AppDelegate userDefaultsKeyGitHubUser]];
    [userDefaults setObject:self.hourTextField.text forKey:[AppDelegate userDefaultsKeyNotificationHour]];

}

- (NSString *)getHourFromString:hourText
{
    NSArray *array = [hourText componentsSeparatedByString:@":"];
    return array[0];
}

- ( void )mailComposeController:( MFMailComposeViewController* )controller didFinishWithResult:( MFMailComposeResult )result error:( NSError* )error
{
    [controller dismissViewControllerAnimated:true completion:nil];
}


- (void)showPicker {
    [self closeSoftKeyboard];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hourPickerView.frame = CGRectMake(0, screenRect.size.height - 240, screenRect.size.width, 300);
	[UIView commitAnimations];

	if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
    }
}
- (void)hidePicker {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hourPickerView.frame = CGRectMake(0, screenRect.size.height, screenRect.size.width, 216);
	[UIView commitAnimations];
    
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}


- (void)done:(id)sender {
	[self hidePicker];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self hidePicker];
        return YES;
    } else if (textField == self.hourTextField) {
        [self showPicker];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    return self.hourChoices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.hourChoices[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.hourTextField.text = self.hourChoices[row];
}

- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}

@end
