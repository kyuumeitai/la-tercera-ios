//
//  ConnectionManager.h
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
typedef void (^getDataBlock)(BOOL success, NSArray* arrayJson, NSError *error);

@interface ConnectionManager : NSObject{
    BOOL isConnected;
}

-(BOOL)verifyConnection;
-(void)getAllCategories:(getDataBlock)completionBlock;
-(void)getMainCategories:(getDataBlock)completionBlock;
-(void)getHeadlinesForCategoryId:(getDataBlock)completionBlock :(int)idCat;

-(void)getHeadlinesForCategoryId:(getDataBlock)completionBlock :(int)idCat andPage:(int)pageNumber;


-(void)getArticleWithId:(getDataBlock)completionBlock :(int)idArticle;
-(void)getBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat;
-(void)getStarredBenefits:(getDataBlock)completionBlock;

-(void)getBenefitWithBenefitId:(getDataBlock)completionBlock :(int)idBenefit;
-(void)getContestWithContestId:(getDataBlock)completionBlock :(int)idBenefit;
-(void)getEventWithEventId:(getDataBlock)completionBlock :(int)idEvent;

-(NSDictionary*)getSubCategoriesForCatId:(int)catId;
-(NSDictionary*)getCategoryForCatId:(int)catId;
-(void)getStoreWithId:(getDataBlock)completionBlock :(int)idStore;
-(void)getStoresAndBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat;
-(void)getNearStoresAndBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat andLatitud:(double)xPoint andLonguitud:(double)yPoint ;
-(void)getBenefits:(getDataBlock)completionBlock;
-(void)getPagedBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat andPage:(int)pageNumber;
-(void)getCommerces:(getDataBlock)completionBlock;
-(void)getStores:(getDataBlock)completionBlock;
-(NSString*)getVirtualCardWithEmail:(NSString *)email;
-(void)getDigitalPaper:(getDataBlock)completionBlock;
-(NSString*)sendRegisterDataWithEmail:(NSString *)email firstName:(NSString*)firstName lastName:(NSString*)lastName gender:(NSString*)gender birthdate:(NSString*)birthdate uid:(NSString*)uid os:(NSString*)os gigyaId:(NSString*)gigyaId;
- (NSString*)sendLoginDataWithEmail:(NSString *)email gigyaId:(NSString*)gigyaId firstName:(NSString*)firstName lastName:(NSString*)lastName gender:(NSString*)gender birthdate:(NSString*)birthdate uid:(NSString*)uid andOs:(NSString*)os;
-(NSString*)sendLoginDataWithEmail:(NSString *)email andGigyaId:(NSString*)gigyaId;
-(NSString*)UseBenefitWithIdBenefit:(NSString *)idBeneficio codigoComercio:(NSString*)codComercio email:(NSString*)email monto:(int)monto;
-(NSString*)getCommerceFromBenefitWithIdBenefit:(int)idBeneficio;
-(NSString*)getCommerceById:(int)idCommerce;
- (NSString*)getHistoryWithEmail:(NSString *)email;
-(void)getPagedContests:(getDataBlock)completionBlock forPage:(int)pageNumber;
-(void)getPagedEvents:(getDataBlock)completionBlock forPage:(int)pageNumber;

@property  BOOL isConnected;

@end
