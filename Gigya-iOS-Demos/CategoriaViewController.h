//
//  CategoriaViewController.h
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface CategoriaViewController : UIViewController{
    
NSMutableArray * categoryItemsArray;
int categoryId;
NSString* categoryName;
NSString* categoryUrl;
NSMutableArray * benefitsItemsArray;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property  int categoryId;
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* categoryUrl;
@property (nonatomic, retain) NSMutableArray * categoryItemsArray;

@end
