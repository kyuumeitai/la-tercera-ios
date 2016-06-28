//
//  Singleton.m
//  AppBaniosCercanos
//
//  Created by diseno on 24-02-16.
//
//

#import "SingletonManager.h"

@implementation SingletonManager

@synthesize profileCode;
@synthesize profileType;
@synthesize profileEmail;
@synthesize profileGigyaId;
@synthesize storyBoardName;
@synthesize userLocation;
@synthesize leftSlideMenu;
@synthesize width;
@synthesize dictProfile;
@synthesize categoryList;

#pragma mark Singleton Methods

+ (id)singletonManager {
    static SingletonManager *singletonManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonManager = [[self alloc] init];
    });
    return singletonManager;
}

- (id)init {
    if (self = [super init]) {
        
        storyBoardName =  @"MainStoryBoard";
        profileGigyaId =  @"noneId ";
        profileEmail = @"anyone@anywhere.com";
        profileCode = -1;
        profileType = @"anonimo";
        
        userLocation = nil;
        leftSlideMenu = nil;
        categoryList = [[NSMutableArray alloc]init];
        dictProfile = [NSMutableDictionary
                                     dictionaryWithDictionary:@{
                                                                @"id": @26,
                                                                @"rut": @"",
                                                                @"name": @"nombre1",
                                                                @"token": @"",
                                                                @"status": @true,
                                                                @"lastname": @"nombre2",
                                                                @"email": @"perico@cool.com",
                                                                @"other_emails": @"nil",
                                                                @"gigya_id": @"8238328",
                                                                @"gender": @"M",
                                                                @"birthdate": @"1987-05-23",
                                                                @"profile_type": @"",
                                                                @"profile_level": @"nil",
                                                                @"preferences": @"nil",
                                                                @"site": @"MOBILE_LT",
                                                                @"notificaciones_club": @true,
                                                                @"notificaciones_noticias": @true,
                                                                @"horario_1": @true,
                                                                @"horario_2": @true,
                                                                @"horario_3": @true,
                                                                @"device": @1
                                                                }];
        width = 0;
        NSLog(@"Estamos OK con el Singleton");
    }
    return self;
}

-(NSString*)description{
    
    NSString *mensaje = [NSString stringWithFormat:@"\r***** Singleton ***** \r Storyboard Name: %@ \r ProfileGigyaId: %@ \r ProfileEmail: %@ \r ProfileCode: %d \r ProfileType: %@ \r DictionaryProfile: %@ \r User Location: (%f,%f)\r", storyBoardName,profileGigyaId,profileEmail, profileCode, profileType, dictProfile.description, userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    
    return mensaje;
    
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end