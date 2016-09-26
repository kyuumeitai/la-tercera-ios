//
//  CategoriaViewController.h
//  La Tercera
//
//  Created by diseno on 14-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "YSLContainerViewController.h"

@interface CategoriaViewController : UIViewController<YSLContainerViewControllerDelegate>{
    
NSMutableArray * categoryItemsArray;
int categoryId;
NSString* categoryName;
NSString* categoryUrl;
NSMutableArray * benefitsItemsArray;
    Categoria *category;
    __weak IBOutlet UIView *viewCat;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property  int categoryId;
@property (nonatomic, assign) Categoria* category;
@property (nonatomic, assign) NSString* categoryName;
@property (nonatomic, assign) NSString* categoryUrl;
@property (nonatomic, assign) NSMutableArray * categoryItemsArray;

@end
