//
//  MusicViewController.h
//  UCup
//
//  Created by Dominic Ong on 12/29/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"
@interface MusicViewController : UIViewController<SPSessionDelegate, SPSessionPlaybackDelegate>{
    SPPlaybackManager *playbackManger;
    SPTrack *_currentTrack;
}

@property (nonatomic, strong, readwrite) SPTrack *currentTrack;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;

@property (nonatomic, getter = isLoggedIn) BOOL loggedIn;

@property (nonatomic, strong) NSString *trackURI;

@property (nonatomic, readwrite, strong) SPPlaylist	*playlist;
@property (nonatomic, readwrite, strong) NSMutableArray *trackPool;
@property (nonatomic, readwrite, strong) NSMutableArray *prevTrackPool;

-(void)waitAndFillTrackPool;
-(NSArray *)playlistsInFolder:(SPPlaylistFolder *)aFolder;
-(NSArray *)tracksFromPlaylistItems:(NSArray *)items;


@end
