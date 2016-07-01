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
static NSString * const PapelBaseURLString = @"http://papeldigital.info/";

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


-(NSString*)sendRegisterDataWithEmail:(NSString *)email firstName:(NSString*)firstName lastName:(NSString*)lastName gender:(NSString*)gender birthdate:(NSString*)birthdate uid:(NSString*)uid os:(NSString*)os gigyaId:(NSString*)gigyaId{
    
    NSString * responseString;
    // Send a synchronous request
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/profiles/register/",BaseURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@&firstName=%@&lastName=%@&gender=%@&birthdate=%@&device_id=%@&os=%@&gigya_id=%@",email,firstName,lastName,gender,birthdate,uid,os,gigyaId];
    NSLog(@"Postring register: %@ ",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse * response = nil;
  NSError * error = nil;
  NSData * data = [NSURLConnection sendSynchronousRequest:request
                                        returningResponse:&response
                                                    error:&error];
        if (error == nil)
        {
            responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        }
        return responseString;
}

-(NSString*)sendLoginDataWithEmail:(NSString *)email andGigyaId:(NSString*)gigyaId{
    
    NSString * responseString;
    // Send a synchronous request
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/profiles/login/",BaseURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@&gigya_id=%@",email,gigyaId];
    NSLog(@"Postring Login: %@ ",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
    return responseString;
}


//News Stuffs

-(void)getHeadlinesForCategoryId:(getDataBlock)completionBlock :(int)idCat {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@contenido/headlines/%d/?format=json",BaseURLString,idCat]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}

-(void)getArticleWithId:(getDataBlock)completionBlock :(int)idArticle {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@contenido/articles/%d/?format=json",BaseURLString,idArticle]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
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


-(void)getDigitalPaper:(getDataBlock)completionBlock{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@lt",PapelBaseURLString]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
         NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"EL objeto es: %@",data);
        //completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"ACA VAAAA %@",ErrorResponse);
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

-(void)getBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/categories/%d/?format=json",BaseURLString,idCat]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}

-(void)getStoresAndBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/storeBenefits/%d/?format=json",BaseURLString,idCat]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}



-(void)getNearStoresAndBenefitsForCategoryId:(getDataBlock)completionBlock :(int)idCat andLatitud:(double)xPoint andLonguitud:(double)yPoint {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/storeBenefits/%d/?format=json&x=%f&y=%f",BaseURLString,idCat, xPoint,yPoint]];
   
    if (idCat == -99)
    URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/storeBenefits/?format=json&x=%f&y=%f",BaseURLString, xPoint,yPoint]];
        
     NSLog(@"La URL ES: %@", URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        completionBlock(NO,nil,error);
        
    }];
}


-(void)getStoreWithId:(getDataBlock)completionBlock :(int)idStore{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/store/%d/?format=json",BaseURLString,idStore]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSArray *jsonArray = (NSArray *) responseObject;
        
        completionBlock(YES,jsonArray ,nil);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO,nil,error);
    }];
}

-(NSString*)getVirtualCardWithEmail:(NSString *)email{
    
    NSString * responseString;
    // Send a synchronous request
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/benefitCard/",BaseURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@",email];
    NSLog(@"Virtual Card Postring Login: %@ ",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
    return responseString;
}


-(void)getBenefitWithBenefitId:(getDataBlock)completionBlock :(int)idBenefit {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/benefits/%d/?format=json",BaseURLString,idBenefit]];
    
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

-(NSString*)UseBenefitWithIdBenefit:(NSString *)idBeneficio codigoComercio:(NSString*)codComercio sucursal:(NSString*)sucursal email:(NSString*)email monto:(int)monto {
    
    NSString * responseString = @"";
    // Send a synchronous request
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@club/useBenefit/",BaseURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5.0];
     //id_beneficio, cod_comercio, sucursal, email, monto
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"id_beneficio=%@&cod_comercio=%@&sucursal=%@&email=%@&monto=%d",idBeneficio,codComercio,sucursal,email,monto];
    NSLog(@"Postring register: %@ ",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }else{
        responseString = error.description;
    }
    return responseString;
}

@end
