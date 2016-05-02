//
//  Benefit.h
//  La Tercera
//
//  Created by Mario Alejandro Ramos on 03-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface Benefit : NSObject


@property (nonatomic,strong) NSString * title;
@property (nonatomic,assign) int idBen;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * summary;
@property (nonatomic,strong) NSString * desclabel;
@property (nonatomic,strong) UIImage *imagenNormal;

-(void)logDescription;
@end

