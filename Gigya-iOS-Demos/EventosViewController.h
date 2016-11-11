//
//  EventosViewController.h
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 26-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface EventosViewController : UIViewController <SWRevealViewControllerDelegate
>@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@end
