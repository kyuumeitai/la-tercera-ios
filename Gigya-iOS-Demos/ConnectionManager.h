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
-(NSDictionary*)getSubCategoriesForCatId:(int)catId;
-(NSDictionary*)getCategoryForCatId:(int)catId;
-(void)getBenefits:(getDataBlock)completionBlock;
-(void)getCommerces:(getDataBlock)completionBlock;
-(void)getStores:(getDataBlock)completionBlock;
-(void)getDigitalPaper:(getDataBlock)completionBlock;
@property  BOOL isConnected;

@end
