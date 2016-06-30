//
//  UserProfile.h
//  La Tercera
//
//  Created by diseno on 28-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property  int userProfileId;
@property (nonatomic,strong) NSString * gigyaId;
@property (nonatomic,strong) NSString * rut;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * lastName;
@property (nonatomic,strong) NSString * email;
@property BOOL suscriber;
@property BOOL status;
@property (nonatomic,strong) NSString * gender;
@property (nonatomic,strong) NSString * birthdate;
@property (nonatomic,strong) NSString * profileType;
@property int profileLevel;
@property (nonatomic,strong) NSMutableArray * preferences;
@property (nonatomic,strong) NSMutableArray * other_emails;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * site;
@property BOOL notificacionesClub;
@property BOOL notificacionesNoticias;
@property BOOL horario1;
@property BOOL horario2;
@property BOOL horario3;
@property  int device;

-(void)logDescription;

@end
