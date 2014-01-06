//
//  MusicLoginViewController.h
//  UCup
//
//  Created by Dominic Ong on 12/31/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
@interface MusicLoginViewController : UIViewController<SPSessionDelegate, SPSessionPlaybackDelegate,SPLoginViewControllerDelegate>
@property (nonatomic, strong) SPPlaybackManager *playbackManager;
@property (nonatomic, getter = isLoggedIn) BOOL loggedIn;
@property (nonatomic,strong) MusicLoginViewController *viewController;

@end
