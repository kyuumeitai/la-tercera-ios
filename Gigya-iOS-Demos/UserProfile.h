//
//  UserProfile.h
//  La Tercera
//
//  Created by diseno on 28-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic,strong) NSString * title;
@property  int pageNumber;
@property (nonatomic,strong) NSString * categoria;
@property (nonatomic,strong) NSString * urlThumbnail;
@property (nonatomic,strong) NSString * urlDetail;

-(void)logDescription;

@end
