//
//  Singleton.h
//  AppBaniosCercanos
//
//  Created by BrUjO on 24-02-16.
//
//

#import <Foundation/Foundation.h>
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SingletonManager : NSObject {
    NSString *storyBoardName;
    int profileCode;
    NSString *profileType;
    NSString *profileEmail;
    NSString *profileGigyaId;
    CLLocation *userLocation;
    SWRevealViewController *leftSlideMenu;
    NSMutableArray *categoryList;
    NSMutableArray *preferencesList;
    int width;
    

}

@property (nonatomic, retain) NSString *storyBoardName;

@property (nonatomic, retain) NSString *profileType;
@property (nonatomic, retain) NSString *profileEmail;
@property (nonatomic, retain) NSString *profileGigyaId;
@property (nonatomic, strong) NSMutableArray *categoryList;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic,retain) SWRevealViewController *leftSlideMenu;

@property  int profileCode;
@property  int width;
+ (id)singletonManager;

@end