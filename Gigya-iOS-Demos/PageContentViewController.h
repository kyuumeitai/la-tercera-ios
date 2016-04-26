//
//  PageContentViewController.h
//  La Tercera
//
//  Created by diseno on 25-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property BOOL isFinalPage;
@property NSUInteger pageIndex;

@property NSString *imageFile;


@end

