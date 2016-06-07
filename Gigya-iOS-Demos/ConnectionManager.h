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
-(NSDictionary*)getAllCategories;
-(void)getMainCategories:(getDataBlock)completionBlock;
-(void)getBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat;
-(void)getBenefitWithBenefitId:(getDataBlock)completionBlock :(int)idBenefit;
-(NSDictionary*)getSubCategoriesForCatId:(int)catId;
-(NSDictionary*)getCategoryForCatId:(int)catId;
-(void)getStoreWithId:(getDataBlock)completionBlock :(int)idStore;
-(void)getStoresAndBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat;
-(void)getNearStoresAndBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat andLatitud:(double)xPoint andLonguitud:(double)yPoint ;
-(void)getBenefits:(getDataBlock)completionBlock;
-(void)getCommerces:(getDataBlock)completionBlock;
-(void)getStores:(getDataBlock)completionBlock;
-(void)getDigitalPaper:(getDataBlock)completionBlock;
-(NSString*)sendRegisterDataWithEmail:(NSString *)email firstName:(NSString*)firstName lastName:(NSString*)lastName gender:(NSString*)gender birthdate:(NSString*)birthdate uid:(NSString*)uid os:(NSString*)os;
@property  BOOL isConnected;

@end
