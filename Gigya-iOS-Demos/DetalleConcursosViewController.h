//
//  DetalleConcursosViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 15-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleConcursosViewController : UIViewController

@property (strong,nonatomic) NSString* concursoTitle;
@property (nonatomic,assign)  int concursoId;

@property (strong,nonatomic) NSString* concursoSubtitle;
@property (strong,nonatomic) NSString* benefitAddress;
@property (strong,nonatomic) NSString* concursoDescription;
@property (strong,nonatomic) UIImage* concursoImage;

@property (weak, nonatomic) IBOutlet UILabel *profileConcursoLabel;
@property (weak, nonatomic) IBOutlet UITextView *concursoSubtitleTextview;
@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *concursoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *concursoSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *concursoDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *concursoAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *concursoConditionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *concursoDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *concursoImageView;

-(void)loadContestForContestId:(int)idContest;

@end
