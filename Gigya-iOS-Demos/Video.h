//
//  Video.h
//  La Tercera
//
//  Created by diseno on 12-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject
@property (nonatomic,assign) int idVideo;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * summary;
@property (nonatomic,strong) NSString *imagenThumbString;
@property (nonatomic,strong) NSString *link;


-(void)logDescription;

@end
