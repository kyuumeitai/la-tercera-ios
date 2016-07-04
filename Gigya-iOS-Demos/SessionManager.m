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
        profileEmail = @"anyone@anywhere.com";
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
        userProfile.profileType = @"";
        userProfile.profileLevel = -1;
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
    
    NSString *mensaje = [NSString stringWithFormat:@" Está logueado: %d ,  Storyboard: %@  User ProfileId: %d   ", isLogged, storyBoardName, userProfile.userProfileId];
    
    return mensaje;
    
}

-(NSString*)profileDescription{
    
    NSString *mensaje = [NSString stringWithFormat:@" GigyaId: %@ Email %@ ProfileLevel: %d  ProfileType: %@  User status: %d   ",  profileGigyaId,profileEmail, userProfile.profileLevel, profileType, userProfile.status];
    
    return mensaje;
    
}

-(UserProfile *)getUserProfile{
    
    return userProfile;
    
}


@end