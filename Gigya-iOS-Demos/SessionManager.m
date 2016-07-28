//
//  Singleton.m
//  AppBaniosCercanos
//
//  Created by diseno on 24-02-16.
//
//

#import "SessionManager.h"

@implementation SessionManager

@synthesize profileCode;
@synthesize profileType;
@synthesize profileEmail;
@synthesize profileGigyaId;
@synthesize storyBoardName;
@synthesize userLocation;
@synthesize leftSlideMenu;
@synthesize width;
@synthesize categoryList;
@synthesize userProfile;
@synthesize isLogged;

#pragma mark Singleton Methods

+ (id)session{
    static SessionManager *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[self alloc] init];
    });
    return session;
}

- (id)init {
    if (self = [super init]) {
        
        storyBoardName =  @"MainStoryBoard";
        
        //Temp vars
        profileGigyaId =  @"noneId ";
        profileEmail = @"    - ";
        profileCode = -1;
        profileType = @"anonimo";
        //End temp vars
        
        userLocation = nil;
        leftSlideMenu = nil;
        
        categoryList = [[NSMutableArray alloc]init];
        
        userProfile = [[UserProfile alloc] init];
        userProfile.userProfileId = -1;
        userProfile.rut = @"";
        userProfile.name = @"";
        userProfile.lastName = @"";
        userProfile.email = @"";
        userProfile.status = false;
        userProfile.suscriber = false;
        userProfile.token = @"";
        userProfile.other_emails = [[NSMutableArray alloc]init];
        userProfile.gender = @"";
        userProfile.birthdate = @"";
        userProfile.profileType = @"anonimo";
        userProfile.profileLevel = 0;
        userProfile.preferences = [[NSMutableArray alloc]init];
        userProfile.site = @"";
        userProfile.notificacionesClub = false;
        userProfile.notificacionesNoticias = false;
        userProfile.horario1 = false;
        userProfile.horario2 = false;
        userProfile.horario3 = false;
        userProfile.device = -1;
         

        width = 0;
        NSLog(@"Estamos OK con el Singleton");
    }
    return self;
}


-(NSString*)sessionDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@" Está logueado: %d ,  Storyboard: %@  User ProfileId: %d   ", self.isLogged, self.storyBoardName, self.userProfile.userProfileId];
    
    return mensaje;
    
}

-(NSString*)profileDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@"Email %@ , Nombres: %@ %@, ProfileLevel: %d, es Suscriptor?: %d , ProfileType: %@  User status: %d   ", userProfile.email,userProfile.name, userProfile.lastName, userProfile.profileLevel , userProfile.suscriber, userProfile.profileType, userProfile.status];
    
    return mensaje;
    
}

-(void) resetUserProfile{
    
    NSLog(@"Reset user profile");
    
    //Temp vars
    profileGigyaId =  @"noneId ";
    profileEmail = @"    - ";
    profileCode = -1;
    profileType = @"anonimo";
    //End temp vars
    
    userLocation = nil;
    leftSlideMenu = nil;
    
    categoryList = [[NSMutableArray alloc]init];
    
    userProfile = [[UserProfile alloc] init];
    userProfile.userProfileId = -1;
    userProfile.rut = @"";
    userProfile.name = @"";
    userProfile.lastName = @"";
    userProfile.email = @"";
    userProfile.status = false;
    userProfile.suscriber = false;
    userProfile.token = @"";
    userProfile.other_emails = [[NSMutableArray alloc]init];
    userProfile.gender = @"";
    userProfile.birthdate = @"";
    userProfile.profileType = @"anonimo";
    userProfile.profileLevel = 0;
    userProfile.preferences = [[NSMutableArray alloc]init];
    userProfile.site = @"";
    userProfile.notificacionesClub = false;
    userProfile.notificacionesNoticias = false;
    userProfile.horario1 = false;
    userProfile.horario2 = false;
    userProfile.horario3 = false;
    userProfile.device = -1;
}

-(UserProfile *)getUserProfile{
    
    return userProfile;
    
}


@end