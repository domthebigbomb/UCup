//
//  MusicViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/29/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "MusicViewController.h"
#import "SPArrayExtensions.h"
//#include "appkey.c"
@interface MusicViewController()
- (IBAction)spotifyButton:(UIButton *)sender;
- (IBAction)playButton:(UIButton *)sender;
- (IBAction)nextButton:(UIButton *)sender;
- (IBAction)previousButton:(UIButton *)sender;
- (IBAction)setPosition:(UISlider *)sender;
- (IBAction)setVolume:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *playlistTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UISlider *positionSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MusicViewController

@synthesize currentTrack;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_playbackManager setIsPlaying:NO];
    _currentTrack = nil;
    self.currentTrack = nil;
    [self removeObserver:self forKeyPath:@"currentTrack.name"];
    [self removeObserver:self forKeyPath:@"currentTrack.artists"];
    [self removeObserver:self forKeyPath:@"currentTrack.duration"];
    [self removeObserver:self forKeyPath:@"currentTrack.album.cover.image"];
    [self removeObserver:self forKeyPath:@"_playbackManager.trackPosition"];
    _playbackManager = nil;
    
    [[SPSession sharedSession] logout:^{}];
    [[SPSession sharedSession] setDelegate:nil];
    if ([[segue identifier] isEqualToString:@"ToSpotifyPlayer"]) {
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{

}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSError *error = nil;

    if(error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
    
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    [[SPSession sharedSession] setDelegate:self];
    [self waitAndFillTrackPool];
    
    [self addObserver:self forKeyPath:@"currentTrack.name" options:0 context:nil];
	[self addObserver:self forKeyPath:@"currentTrack.artists" options:0 context:nil];
	[self addObserver:self forKeyPath:@"currentTrack.duration" options:0 context:nil];
	[self addObserver:self forKeyPath:@"currentTrack.album.cover.image" options:0 context:nil];
	[self addObserver:self forKeyPath:@"_playbackManager.trackPosition" options:0 context:nil];
    
}

-(void)showLogin {
    
	SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
	controller.allowsCancel = NO;
    [self presentViewController:controller animated:NO completion:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentTrack.name"]){
        _trackTitleLabel.text = _currentTrack.name;
    }else if([keyPath isEqualToString:@"currentTrack.artists"]){
        _trackArtistLabel.text = [[_currentTrack.artists valueForKey:@"name"] componentsJoinedByString:@","];
    }else if([keyPath isEqualToString:@"currentTrack.album.cover.image"]){
       _coverImageView.image = _currentTrack.album.cover.image;
    }else if([keyPath isEqualToString:@"currentTrack.duration"]){
        _positionSlider.maximumValue = _currentTrack.duration;
    }else if([keyPath isEqualToString:@"_playbackManager.trackPosition"]){
        if(!_positionSlider.highlighted)
            _positionSlider.value = _playbackManager.trackPosition;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(UIViewController *)viewControllerToPresentLoginViewForSession:(SPSession *)aSession {
	return self;
}

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
    [self waitAndFillTrackPool];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
    [self performSelector:@selector(showLogin) withObject:nil afterDelay:0.0];
	// Invoked by SPSession after a failed login.
}

-(void)sessionDidLogOut:(SPSession *)aSession {
	
	SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
	
	if (self.presentedViewController != nil) return;
	
	controller.allowsCancel = NO;
	
	//[self presentModalViewController:controller animated:YES];
}

-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {}
-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {}
-(void)sessionDidChangeMetadata:(SPSession *)aSession; {}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
	return;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
													message:aMessage
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

-(void)waitAndFillTrackPool {
	
	[SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedession, NSArray *notLoadedSession) {
		
		// The session is logged in and loaded — now wait for the userPlaylists to load.
		NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Session loaded.");
		
		[SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
			
			// User playlists are loaded — wait for playlists to load their metadata.
			NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Container loaded.");
			
            NSURL *playlistURL = [NSURL URLWithString:@"spotify:user:spotify:playlist:5ILSWr90l2Bgk89xuhsysy"];
            //spotify:user:spotify:playlist:5ILSWr90l2Bgk89xuhsysy
            //spotify:user:128760718:playlist:7DlNWlxAM280PZ6EVGK4IF
			NSMutableArray *playlists = [NSMutableArray array];
            [[SPSession sharedSession] playlistForURL:playlistURL callback:^(SPPlaylist *playlist) {
                if(playlist != nil){
                    [SPAsyncLoading waitUntilLoaded:playlist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                        [playlists addObjectsFromArray: [playlist items]];
                        NSLog(@"[%@ %@]: %@ of %@ playlists loaded.", NSStringFromClass([self class]), NSStringFromSelector(_cmd),
                              [NSNumber numberWithInteger:loadedItems.count], [NSNumber numberWithInteger:loadedItems.count + notLoadedItems.count]);
                    
                        NSArray *playlistItems = [loadedItems valueForKeyPath:@"@unionOfArrays.items"];
                        NSArray *tracks = [self tracksFromPlaylistItems: playlistItems];
                    
                        [SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
                            
                            // All of our tracks have loaded their metadata. Hooray!
                            NSLog(@"[%@ %@]: %@ of %@ tracks loaded.", NSStringFromClass([self class]), NSStringFromSelector(_cmd),
                                  [NSNumber numberWithInteger:loadedTracks.count], [NSNumber numberWithInteger:loadedTracks.count + notLoadedTracks.count]);
                            [_activityIndicator stopAnimating];
                            
                            NSMutableArray *theTrackPool = [NSMutableArray arrayWithCapacity:loadedTracks.count];
                            
                            for (SPTrack *aTrack in loadedTracks) {
                                if (aTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE && [aTrack.name length] > 0)
                                    [theTrackPool addObject:aTrack];
                            }
                            
                            self.trackPool = [NSMutableArray arrayWithArray:[[NSSet setWithArray:theTrackPool] allObjects]];
                            // ^ Thin out duplicates.
                            _prevTrackPool = [[NSMutableArray alloc] init];
                            _playButton.enabled = YES;
                            //[self performSelector:@selector(playButton:)];
                        }];
                        
                        _playlistTitleLabel.text = [playlist name];
                        
                    }];
                    
                }
            }];
        }];
	}];
}



-(NSArray *)playlistsInFolder:(SPPlaylistFolder *)aFolder {
	
	NSMutableArray *playlists = [NSMutableArray arrayWithCapacity:[[aFolder playlists] count]];
	
	for (id playlistOrFolder in aFolder.playlists) {
		if ([playlistOrFolder isKindOfClass:[SPPlaylist class]]) {
			[playlists addObject:playlistOrFolder];
		} else {
			[playlists addObjectsFromArray:[self playlistsInFolder:playlistOrFolder]];
		}
	}
	return [NSArray arrayWithArray:playlists];
}


-(NSArray *)tracksFromPlaylistItems:(NSArray *)items {
	
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:items.count];
	
	for (SPPlaylistItem *anItem in items) {
		if (anItem.itemClass == [SPTrack class]) {
			[tracks addObject:anItem.item];
		}
	}
	
	return [NSArray arrayWithArray:tracks];
}

- (void)startPlaybackOfTrack:(SPTrack *)aTrack {
	
	[SPAsyncLoading waitUntilLoaded:aTrack timeout:5.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
		[self.playbackManager playTrack:aTrack callback:^(NSError *error) {
			if (!error){
                self.currentTrack = aTrack;
                [_playButton setImage:[UIImage imageNamed:@"Pause Button.png"] forState:UIControlStateNormal];
                [self performSelector:@selector(saveTrackInStack:) withObject:aTrack afterDelay:1.0];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Play"
                                                                message:error.localizedDescription
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
		}];
	}];

}

-(void)saveTrackInStack:(SPTrack *)playingTrack{
    if([_playbackManager.currentTrack isEqual: playingTrack]){
        [_prevTrackPool addObject:_currentTrack];
    }
}

- (IBAction)spotifyButton:(UIButton *)sender {
    [SPSession launchSpotifyClientIfInstalled];
}

- (IBAction)playButton:(UIButton *)sender {
    if(_currentTrack == nil){
        //Load track if there is none currently playing
        while(!_currentTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE){
            _currentTrack = [self.trackPool randomObject];
        }
        
        [self startPlaybackOfTrack:_currentTrack];
    }else{
        //Handle is there is a current track loaded
        if([_playbackManager isPlaying]){
            [_playbackManager setIsPlaying:NO];
            [_playButton setImage:[UIImage imageNamed:@"Play Button.png"] forState:UIControlStateNormal];
        }else{
            [_playbackManager setIsPlaying:YES];
            [_playButton setImage:[UIImage imageNamed:@"Pause Button.png"] forState:UIControlStateNormal];
        }
        
    }

}

-(void)playNextTrack{
    if (self.playbackManager.currentTrack != nil) {
		[self.playlist addItem:self.playbackManager.currentTrack atIndex:self.playlist.items.count callback:^(NSError *error) {
			if (error) NSLog(@"%@", error);
		}];
	}
    
    _currentTrack = nil;
    while(!_currentTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE){
        _currentTrack = [self.trackPool randomObject];
    }
    [self startPlaybackOfTrack:_currentTrack];
}

- (IBAction)nextButton:(UIButton *)sender {
    [self playNextTrack];
}

- (IBAction)previousButton:(UIButton *)sender {
    if([_prevTrackPool count] >0){
        SPTrack *prevTrack = [_prevTrackPool lastObject];
        [_prevTrackPool removeLastObject];
        _currentTrack = prevTrack;
        [self startPlaybackOfTrack:_currentTrack];
        //_coverImageView.image = prevTrack.album.cover.image;
    }
}

- (IBAction)setPosition:(UISlider *)sender {
    [_playbackManager seekToTrackPosition:self.positionSlider.value];
}

- (IBAction)setVolume:(UISlider *)sender {
    _playbackManager.volume = [(UISlider *)sender value];
}

@end
