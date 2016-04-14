//
//  NewspaperPage.h
//  La Tercera
//
//  Created by diseno on 13-04-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface NewspaperPage : NSObject
@property (nonatomic,strong) NSString * title;
@property  int pageNumber;
@property (nonatomic,strong) NSString * categoria;
@property (nonatomic,strong) NSString * urlThumbnail;
@property (nonatomic,strong) NSString * urlDetail;
@property (nonatomic,strong) UIImage *imagenThumbnail;
@property (nonatomic,strong) UIImage *imagenBig;

-(void)logDescription;

@end
