//
//  UCupViewController.h
//  UCup
//
//  Created by Dominic Ong on 12/27/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
@class PartyDataController;

@interface UCupViewController : UIViewController<SPSessionPlaybackDelegate>

@property (nonatomic, strong)PartyDataController *dataController;

-(IBAction)create:(UIStoryboardSegue *)segue;
-(IBAction)cancel:(UIStoryboardSegue *)segue;
-(IBAction)goHome:(UIStoryboardSegue *)segue;
@end
