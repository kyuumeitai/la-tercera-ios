//
//  Singleton.h
//  AppBaniosCercanos
//
//  Created by diseno on 24-02-16.
//
//

#import <foundation/Foundation.h>
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SingletonManager : NSObject {
    NSString *storyBoardName;
    CLLocation *userLocation;
    SWRevealViewController *leftSlideMenu;
    int width;
    

}

@property (nonatomic, retain) NSString *storyBoardName;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic,retain) SWRevealViewController *leftSlideMenu;
@property  int width;
+ (id)singletonManager;

@end