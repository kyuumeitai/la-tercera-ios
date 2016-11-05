//
//  DetalleViewController.h
//  La Tercera
//
//  Created by diseno on 16-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetalleBeneficioViewControllerFromMap : UIViewController

@property (strong,nonatomic) NSString* benefitTitle;
@property (nonatomic,assign)  int benefitId;
@property (nonatomic,assign)  int benefitRemoteId;
@property (nonatomic,assign)  int storeRemoteId;
@property (strong,nonatomic) NSString* benefitSubtitle;
@property (strong,nonatomic) NSString* benefitDiscount;
@property (strong,nonatomic) NSString* benefitAddress;
@property (strong,nonatomic) CLLocation* benefitLocation;
@property (strong,nonatomic) NSString* benefitDescription;
@property (strong,nonatomic) UIImage* benefitImage;
 
@property (weak, nonatomic) IBOutlet UILabel *profileBenefitLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitAdressLabel;
@property (weak, nonatomic) IBOutlet UITextView *benefitDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *benefitImageView;

-(void)loadBenefitForBenefitId:(int)idBenefit;
//-(void)loadBenefitForBenefitId:(int)idBenefit andStore:(NSString*)_idStore;
-(void)loadBenefitForBenefitId:(int)idBenefit andStore:(NSString*)_idStore  andAddress:(NSString*)_address  andLocation:(CLLocation*)_location;

@end
