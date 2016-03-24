//
//  ConnectionManager.h
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ConnectionManager : NSObject{
    BOOL isConnected;
}

-(BOOL)verifyConnection;
-(NSDictionary*)getAllCategories;
-(NSDictionary*)getMainCategories;
-(NSDictionary*)getSubCategoriesForCatId:(int)catId;
-(NSDictionary*)getCategoryForCatId:(int)catId;
-(NSDictionary*)getBenefits;

@property  BOOL isConnected;

@end
