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
        userProfile.token = @"";
        userProfile.other_emails = [[NSMutableArray alloc]init];
        userProfile.gender = @"";
        userProfile.birthdate = @"";
        userProfile.profileType = @"";
        userProfile.profileLevel = @"";
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

-(NSString*)description{
    
    NSString *mensaje = [NSString stringWithFormat:@"\r***** Singleton ***** \r Storyboard Name: %@ \r ProfileGigyaId: %@ \r ProfileEmail: %@ \r ProfileCode: %d \r ProfileType: %@ \r User status: %d \r User ProfileId: %d  \r User Location: (%f,%f)\r", storyBoardName,profileGigyaId,profileEmail, profileCode, profileType, userProfile.status, userProfile.userProfileId, userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    
    return mensaje;
    
}

-(UserProfile *)getUserProfile{
    
    return userProfile;
    
}


@end