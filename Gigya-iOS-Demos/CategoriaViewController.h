//
//  CategoriaViewController.h
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, copy) NSString* categoryName;
@end