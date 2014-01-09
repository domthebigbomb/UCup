//
//  AddPartyViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "AddPartyViewController.h"
#import "Party.h"
#import <Firebase/Firebase.h>

#define numRowsInTable 6

@interface AddPartyViewController()

@property (strong, nonatomic)UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UILabel *guestAllowedLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyPrivacyLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyTimeLabel;
- (IBAction)guestIncrementer:(UIStepper *)sender;
- (IBAction)partyPrivacySwitch:(UISwitch *)sender;
- (IBAction)updateTime:(UIButton *)sender;
@property (strong, nonatomic)UITextField *currField;
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property NSDate *partyTime;

@end

@implementation AddPartyViewController{
    NSString *partyListUrl;
    Firebase *partyList;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    partyListUrl = @"https://ucup-party-list.firebaseio.com/";
    
    partyList = [[Firebase alloc] initWithUrl:partyListUrl];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = NO;
    [self.view addGestureRecognizer:_tap];
    
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnCreateParty"]) {
        if([_nameInput.text length] && [_locationInput.text length] &&
           [_costInput.text length]){
            Party *party;
            
            party = [[Party alloc] initWithName:_nameInput.text location:_locationInput.text cost:_costInput.text partyTime: _partyTimeLabel.text numberOfGuestsAllowed:[_numGuests value]isPublic:[_isPrivate isOn]];
            self.party = party;
            [[partyList childByAppendingPath:_nameInput.text] setValue:[party getObject]];
        }
    }
    
}





- (IBAction)guestIncrementer:(id)sender {
    _guestAllowedLabel.text = [NSString stringWithFormat:@"Guests Allowed: %d",(int)[_numGuests value]];
}

- (IBAction)partyPrivacySwitch:(UISwitch *)sender {
    if([_isPrivate isOn])
        _partyPrivacyLabel.text = @"Is This Party Private?   Yes";
    else
        _partyPrivacyLabel.text = @"Is This Party Private?   No";
}

- (IBAction)updateTime:(UIButton *)sender {
    NSString *time = [self.dateFormatter stringFromDate:[_datePicker date]];

    _partyTimeLabel.text = time;
}



@end
