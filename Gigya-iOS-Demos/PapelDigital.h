//
//  PapelDigital.h
//  La Tercera
//
//  Created by diseno on 07-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLContainerViewController.h"

@interface PapelDigital : UIViewController <YSLContainerViewControllerDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIWebView *webViewLTPapelDigital;

@end
