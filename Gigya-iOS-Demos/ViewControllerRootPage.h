//
//  ViewControllerRootPage.h
//  La Tercera
//
//  Created by diseno on 25-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerRootPage : UIViewController  <UIPageViewControllerDataSource>
@property NSUInteger pageIndex;
@property NSString *imageFile;
@property (strong, nonatomic) NSArray *pageImages;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@end
