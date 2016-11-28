//
//  DetalleEventosViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 16-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleEventosViewController : UIViewController

@property (strong,nonatomic) NSString* eventoTitle;
@property (nonatomic,assign)  int eventoId;

@property (strong,nonatomic) NSString* eventoSubtitle;
@property (strong,nonatomic) NSString* benefitAddress;
@property (strong,nonatomic) NSString* eventoDescription;
@property (strong,nonatomic) UIImage* eventoImage;

@property (weak, nonatomic) IBOutlet UILabel *profileEventoLabel;

@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventoTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventoSubtitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *eventoSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventoDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventoAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventoConditionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventoDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *eventoImageView;

-(void)loadEventForEventId:(int)idEvent;

@end
