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
#import "UserProfile.h"

@interface SessionManager : NSObject {
    
    NSString *storyBoardName;
    
    BOOL isLogged;
    
    //temp
    int profileCode;
    NSString * profileType;
    NSString *profileEmail;
    NSString *profileGigyaId;
    NSMutableArray *preferencesList;
    //End Temp
    
    UserProfile * userProfile;
    
    CLLocation * userLocation;
    SWRevealViewController * leftSlideMenu;
    NSMutableArray * categoryList;

    int width;
    
}
@property  BOOL isLogged;
@property (nonatomic, retain) NSString *storyBoardName;
@property (nonatomic, retain) UserProfile * userProfile;
@property (nonatomic, retain) NSString *profileType;
@property (nonatomic, retain) NSString *profileEmail;
@property (nonatomic, retain) NSString *profileGigyaId;
@property (nonatomic, strong) NSMutableArray *categoryList;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic,retain) SWRevealViewController *leftSlideMenu;

@property  int profileCode;
@property  int width;

+ (id)session;
-(NSString*)sessionDescription;
-(NSString*)profileDescription;
-(UserProfile *)getUserProfile;
-(void) resetUserProfile;

@end