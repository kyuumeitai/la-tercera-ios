//
//  contentType.h
//  La Tercera
//
//  Created by diseno on 10-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentType : NSObject

@property  int contentId;
@property (nonatomic,strong) NSString * contentTitle;
@property (nonatomic,strong) NSString * contentSlug;
@property (nonatomic,strong) NSString * contentHeadType;
@property (nonatomic) BOOL * contentVisibility;
@property (nonatomic) BOOL * contentIsShow;
@property (nonatomic) BOOL * contentIsTypeInicio;

-(void)logDescription;
@end
