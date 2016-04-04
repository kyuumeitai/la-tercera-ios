//
//  Singleton.m
//  AppBaniosCercanos
//
//  Created by diseno on 24-02-16.
//
//

#import "SingletonManager.h"

@implementation SingletonManager

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
        userLocation = nil;
        leftSlideMenu = nil;
        categoryList = [[NSMutableArray alloc]init];
        width = 0;
        NSLog(@"Estamos OK con el Singleton");
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end