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
        NSLog(@"reachable via wwan ok");
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
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/categories/?type=json",BaseURLString]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;

        completionBlock(YES,jsonArray ,nil);
        
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

-(void)getBenefits:(getDataBlock)completionBlock{

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/benefits/?format=json",BaseURLString]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;

        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}

-(void)getCommerces:(getDataBlock)completionBlock{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/commerce/?format=json",BaseURLString]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}

-(void)getStores:(getDataBlock)completionBlock{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/store/?format=json",BaseURLString]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}

@end
