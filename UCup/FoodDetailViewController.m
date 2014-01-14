//
//  FoodDetailViewController.m
//  UCup
//
//  Created by Dominic Ong on 1/12/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "LocationHandler.h"
#import "Business.h"
@interface FoodDetailViewController()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
- (IBAction)directionButton:(UIButton *)sender;

@end

@implementation FoodDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [_phoneButton setTitle:[_business getPhone]forState:UIControlStateNormal];
    UIImage *businessPic = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_business getImageUrl]]]];
    UIImage *ratingImg = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_business getRatingUrlWithSize:@"large"]]]];
    [_businessImage setImage:businessPic];
    [_ratingImage setImage:ratingImg];
    [_distanceLabel setText:[NSString stringWithFormat:@"Distance: %.2f miles",[_business getDistance]]];
    [_nameLabel setText:[_business getName]];
    [_streetLabel setText:[_business getStreet]];
    [_cityStateZipLabel setText:[_business getCityStateZip]];
    _mapView.delegate = self;
}




- (IBAction)phoneButton:(UIButton *)sender {
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] isEqualToString:@"iPhone"]){
        NSString *phoneNum = [NSString stringWithFormat:@"tel:%@",[_phoneButton currentTitle]];
        phoneNum = [phoneNum stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        NSURL *phoneUrl = [NSURL URLWithString:phoneNum];
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}
- (IBAction)openDirections:(UIButton *)sender {
}
- (IBAction)directionButton:(UIButton *)sender {
}
@end
