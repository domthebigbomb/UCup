//
//  MusicLoginViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/31/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "MusicLoginViewController.h"
#include "appkey.c"
@implementation MusicLoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSError *error = nil;
    ///*
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
											   userAgent:@"com.spotify.UCup"
										   loadingPolicy:SPAsyncLoadingManual
												   error:&error];
	//*/
    if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
    [[SPSession sharedSession] setDelegate:self];
    [self performSelector:@selector(showLogin) withObject:nil afterDelay:.8];
}

-(void)showLogin {
    
	SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
	controller.allowsCancel = YES;
	//controller.loginDelegate = self.viewController;
	[self presentModalViewController:controller animated:NO];
    
}

-(UIViewController *)viewControllerToPresentLoginViewForSession:(SPSession *)aSession {
	return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if(_loggedIn){
        [self performSegueWithIdentifier:@"ToSpotifyPlayer" sender:self];
    }
}


-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
    _loggedIn = YES;
}

-(void)loginViewController:(SPLoginViewController *)controller didCompleteSuccessfully:(BOOL)didLogin {
	
	[self dismissModalViewControllerAnimated:YES];
	
	
}


-(void)sessionDidLogOut:(SPSession *)aSession{
    _loggedIn = NO;
}

@end
