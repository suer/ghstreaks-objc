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

static NSString *DEFAULT_NOTIFICATION_HOUR =  @"18:00";

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
    self.title = NSLocalizedString(@"PreferenceViewTitle", nil);
    self.serviceURL = [Preference getServiceURL];
    [self addUserNameTextField];
    [self addHourTextField];
    [self addRegisterButton];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];

    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)addUserNameTextField
{
    UILabel *userNameLabel = [UILabelHelper createUILabel:10 pointY:120 width:90 height:40 text:NSLocalizedString(@"UserNameTextFieldLabel", nil)];
    [self.view addSubview:userNameLabel];
    
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 120, 210, 40)];
    self.userNameTextField.text = [[[Preference alloc] init] getGitHubUser];
    self.userNameTextField.placeholder = NSLocalizedString(@"UserTextFieldPlaceHolder", nil);
    self.userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.userNameTextField.delegate = self;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0, 320.0, 44)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(userNameTextEditDone:)];
    toolBar.items = @[flexibleSpace, buttonItem];
    self.userNameTextField.inputAccessoryView = toolBar;
    [self.view addSubview:self.userNameTextField];
}

- (void)addHourTextField
{
    UILabel *hourLabel = [UILabelHelper createUILabel:10 pointY:180 width:90 height:40 text:NSLocalizedString(@"NotifyAtTextFieldLabel", nil)];
    [self.view addSubview:hourLabel];
    
    self.hourTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 180, 210, 40)];
    self.hourTextField.text = [[[Preference alloc] init] getNotificationHour];
    if ([self.hourTextField.text compare:@""] == NSOrderedSame) {
        self.hourTextField.text = DEFAULT_NOTIFICATION_HOUR;
    }
    self.hourTextField.placeholder = NSLocalizedString(@"HourTextFieldPlaceHolder", nil);
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
    [self selectRowByTextField];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0, 320.0, 44)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(hourTextEditDone:)];
    toolBar.items = @[flexibleSpace, buttonItem];
    self.hourTextField.inputView = self.hourPickerView;
    self.hourTextField.inputAccessoryView = toolBar;
    [self.view addSubview:self.hourPickerView];
}


- (void)addRegisterButton
{
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerButton.frame = CGRectMake(10, 250, 300, 30);
    [registerButton setTitle:NSLocalizedString(@"RegisterButtonLabel", nil) forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonTapped:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registerButton];
}

- (void)registerButtonTapped:(id)sender
{
    if ([self.userNameTextField.text compare:@""] == NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                        message:NSLocalizedString(@"GitHubUserNameRequired", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil
                              ];
        [alert show];
        return;
    }

    [SVProgressHUD showWithStatus:NSLocalizedString(@"Registering", nil) maskType:SVProgressHUDMaskTypeBlack];

    NSURL *baseURL = [NSURL URLWithString:self.serviceURL];
    NSURL *registrationURL = [NSURL URLWithString:@"/notifications" relativeToURL:baseURL];
    NSString *utc_offset =  [NSString stringWithFormat:@"%d", (int)([[NSTimeZone defaultTimeZone] secondsFromGMT] / 3600)];
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userNameTextField.text forKey:@"notification[name]"];
    [params setValue:[[AppDelegate sharedDelegate] getDeviceTokenString] forKey:@"notification[device_token]"];
    [params setValue:[self getHourFromString:self.hourTextField.text] forKey:@"notification[hour]"];
    [params setValue:utc_offset forKey:@"notification[utc_offset]"];
    
    [[LRResty client] post:[registrationURL absoluteString] payload:params withBlock:^(LRRestyResponse *response) {
        if ([response status] < 300) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"ProgressSuccess", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ProgressFailure", nil)];
        }
    }];

    Preference *preference = [[Preference alloc] init];
    [preference setGitHubUser:self.userNameTextField.text];
    [preference setNotificationHour:self.hourTextField.text];
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

- (void)selectRowByTextField {
    for (int i = 0; i < 24; i++) {
        if ([self.hourTextField.text isEqualToString:[NSString stringWithFormat:@"%2d:00", i]]) {
            [self.hourPickerView selectRow:i inComponent:0 animated:NO];
            return;
        }
    }
}

- (void)userNameTextEditDone:(id)sender {
    [self.userNameTextField resignFirstResponder];
}

- (void)hourTextEditDone:(id)sender {
    [self.hourTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
