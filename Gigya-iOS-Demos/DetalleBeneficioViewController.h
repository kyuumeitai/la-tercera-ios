//
//  DetalleViewController.h
//  La Tercera
//
//  Created by diseno on 16-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleBeneficioViewController : UIViewController

@property (strong,nonatomic) NSString* benefitTitle;
@property (nonatomic,assign)  int benefitId;
@property (strong,nonatomic) NSString* benefitSubtitle;
@property (strong,nonatomic) NSString* benefitDiscount;
@property (strong,nonatomic) NSString* benefitAddress;
@property (strong,nonatomic) NSString* benefitDescription;
@property (strong,nonatomic) UIImage* benefitImage;
 
@property (weak, nonatomic) IBOutlet UILabel *profileBenefitLabel;

@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *benefitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitSubtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *benefitDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitAdressLabel;

@property (weak, nonatomic) IBOutlet UILabel *benefitConditionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *benefitDescriptionTextView;

@property (weak, nonatomic) IBOutlet UIImageView *benefitImageView;

-(void)loadBenefitForBenefitId:(int)idBenefit;
@end
