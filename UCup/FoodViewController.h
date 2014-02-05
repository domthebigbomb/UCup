//
//  FoodViewController.h
//  UCup
//
//  Created by Dominic Ong on 1/6/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodDataController;

@interface FoodViewController : UITableViewController<UIAlertViewDelegate>

@property (strong, nonatomic) FoodDataController *foodController;

@end
