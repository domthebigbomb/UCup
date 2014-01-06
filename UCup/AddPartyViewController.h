//
//  AddPartyViewController.h
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Party;

@interface AddPartyViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UITextField *costInput;
@property (weak, nonatomic) IBOutlet UIStepper *numGuests;
@property (weak, nonatomic) IBOutlet UISwitch *isPrivate;
@property (strong,nonatomic) Party *party;
@end
