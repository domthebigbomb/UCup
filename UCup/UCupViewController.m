//
//  UCupViewController.m
//  UCup
//
//  Created by Dominic Ong on 12/27/13.
//  Copyright (c) 2013 DTech. All rights reserved.
//

#import "UCupViewController.h"
#import "AddPartyViewController.h"
#import "PartyDataController.h"
#import "LocationHandler.h"

@interface UCupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createPartyButton;
@property (weak, nonatomic) IBOutlet UIButton *findPartyButton;
@property (weak, nonatomic) IBOutlet UIButton *weatherButton;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
- (IBAction)sendFeedback:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)switchFbProfile:(UIButton *)sender;

@end

@implementation UCupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocationHandler getSharedInstance]startUpdating];
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
    loginView.delegate = self;
    
    loginView.frame = CGRectOffset(loginView.frame, 52, 450);
    [self.view addSubview:loginView];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"HeitiSC" size:16.0], NSFontAttributeName,nil]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    _profilePictureView.profileID = [user id];
    [_statusLabel setText:[NSString stringWithFormat:@"Welcome to UCup, %@!",[user first_name]]];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"Logged in");
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    _profilePictureView.profileID = nil;
    [_statusLabel setText:@"Sign in with Facebook!"];
}
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)create:(UIStoryboardSegue *)segue{
    if([[segue identifier] isEqualToString:@"ReturnCreateParty"]){
        AddPartyViewController *addController = [segue sourceViewController];
        if(addController.party){
            [self.dataController addParty: addController.party];
            
        }
    }
}

-(void)publishStory{
    
}

-(IBAction)cancel:(UIStoryboardSegue *)segue{
    if([[segue identifier] isEqualToString:@"CancelCreateParty"]){
    }
}

-(IBAction)goHome:(UIStoryboardSegue *)segue{
}

- (IBAction)sendFeedback:(UIButton *)sender {
    NSString *mailString = @"mailto:domthebigbomb@gmail.com?&subject=UCup Feedback";
    mailString = [mailString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSURL *mailUrl = [NSURL URLWithString:mailString];
    [[UIApplication sharedApplication] openURL:mailUrl];
    
}
- (IBAction)switchFbProfile:(UIButton *)sender {
}
@end
