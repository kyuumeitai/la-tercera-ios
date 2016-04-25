//
//  LaTerceraTV.h
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"


@interface LectiosViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (nonatomic, strong) YMCAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;


@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;


@end
