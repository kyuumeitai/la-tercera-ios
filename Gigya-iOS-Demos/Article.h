//
//  Article.h
//  La Tercera
//
//  Created by diseno on 14-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Article : NSObject

@property (nonatomic,assign) int idArt;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * author;
@property (nonatomic,strong) NSString * summary;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * slug;
@property (nonatomic,strong) NSString * epigraph;
@property (nonatomic,strong) UIImage *imagenNormal;
@property (nonatomic,strong) NSString *imagenThumbString;
@property (nonatomic,strong) NSString *imagenNormalString;
@property (nonatomic,strong) NSString *relatedHeadline;
@property (nonatomic,strong) NSString * articleType;

-(void)logDescription;

@end
