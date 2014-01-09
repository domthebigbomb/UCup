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


@interface UCupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createPartyButton;
@property (weak, nonatomic) IBOutlet UIButton *findPartyButton;
@property (weak, nonatomic) IBOutlet UIButton *weatherButton;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end

@implementation UCupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)create:(UIStoryboardSegue *)segue{
    if([[segue identifier] isEqualToString:@"ReturnCreateParty"]){
        AddPartyViewController *addController = [segue sourceViewController];
        if(addController.party){
            [self.dataController addParty: addController.party];
        }
    }
}

-(IBAction)cancel:(UIStoryboardSegue *)segue{
    if([[segue identifier] isEqualToString:@"CancelCreateParty"]){
    }
}

-(IBAction)goHome:(UIStoryboardSegue *)segue{

}

@end
