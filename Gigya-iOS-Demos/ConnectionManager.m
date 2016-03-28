//
//  ConnectionManager.m
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import <foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"
static NSString * const BaseURLString = @"http://ltrest.multinetlabs.com/";
@implementation ConnectionManager

@synthesize isConnected;

- (instancetype)init
{
    self = [super init];
    if (self) {
        isConnected = [self verifyConnection];
    }
    return self;
}


-(BOOL)verifyConnection{
    // check for internet connection

    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        NSLog(@"not reachable");
        return false;
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        NSLog(@"reachable via wwan");
        return true;
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        NSLog(@"reachable via wifi OK");
        return true;
    }
    return false;
}

-(NSDictionary*)getAllCategories{
    
    
    NSDictionary * dictionary = nil;
    
    return dictionary;
}
-(void)getMainCategories:(getDataBlock)completionBlock{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/categories",BaseURLString]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"task  %@", responseObject);

        NSError *error;
 NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];

        completionBlock(YES,dictionary,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);

    }];
    
}
-(NSDictionary*)getSubCategoriesForCatId:(int)catId{
    NSDictionary * dictionary = nil;
    

    return dictionary;
}
-(NSDictionary*)getCategoryForCatId:(int)catId{
    NSDictionary * dictionary = nil;
    
    return dictionary;
}
-(NSDictionary*)getBenefits{
    NSDictionary * dictionary = nil;
    
    return dictionary;
}

@end
