//
//  PartyListViewController.h
//  UCup
//
//  Created by Dominic Ong on 12/28/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartyDataController;

@interface PartyListViewController : UITableViewController

@property (strong,nonatomic) PartyDataController *dataController;


@end
