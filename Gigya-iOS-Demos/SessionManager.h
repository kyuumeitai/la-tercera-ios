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
#import <CoreData/CoreData.h>
#import "UserProfile.h"

@interface SessionManager : NSObject<NSFetchedResultsControllerDelegate> {
    
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
@property  BOOL hasShownMailConfirmation;
@property (nonatomic, retain) NSString *storyBoardName;
@property (nonatomic, retain) UserProfile * userProfile;
@property (nonatomic, retain) NSString *profileType;
@property (nonatomic, retain) NSString *profileEmail;
@property (nonatomic, retain) NSString *profileGigyaId;
@property (nonatomic, copy) NSMutableArray *categoryList;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic,retain) SWRevealViewController *leftSlideMenu;

@property  int profileCode;
@property  int width;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

+ (id)session;
-(NSString*)sessionDescription;
-(NSString*)profileDescription;
-(UserProfile *)getUserProfile;
-(void) resetUserProfile;
-(BOOL) saveMiSeleccionCategoryWithId:(int)idCat andCategoryName:(NSString*)categoryName;
-(BOOL) deleteMiSeleccionCategoryWithId:(int)idCat andCategoryName:(NSString*)categoryName;
-(BOOL) existCategory:(NSString*)categoryName;
-(NSArray*) getMiSeleccionArray;
-(NSMutableArray*) getMiSeleccionCategoryIdsArray;
-(NSMutableArray*) getMiSeleccionCategoryTitlesArray;
-(BOOL)isRepeatedForSelectedCategory:(int)idCat;
-(void) deleteNoticiaWithId:(int)idNoticia;
-(BOOL)isFavoriteNewsWithArticleId:(int)idArticle;

@end
