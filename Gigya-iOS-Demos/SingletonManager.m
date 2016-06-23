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
        width = 0;
        NSLog(@"Estamos OK con el Singleton");
    }
    return self;
}

-(NSString*)description{
    
    NSString *mensaje = [NSString stringWithFormat:@"\r***** Singleton ***** \r Storyboard Name: %@ \r ProfileGigyaId: %@ \r ProfileEmail: %@ \r ProfileCode: %d \r ProfileType: %@ \r User Location: (%f,%f)\r", storyBoardName,profileGigyaId,profileEmail, profileCode, profileType, userLocation.coordinate.latitude,userLocation.coordinate.longitude];
    
    return mensaje;
    
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end