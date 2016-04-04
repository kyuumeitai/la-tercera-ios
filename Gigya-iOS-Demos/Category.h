//
//  Category.h
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 03-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface Category : NSObject
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * idCat;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) UIImage *imagenDestacada;
-(void)logDescription;
@end
