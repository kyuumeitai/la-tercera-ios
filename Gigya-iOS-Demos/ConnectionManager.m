//
//  ConnectionManager.m
//  La Tercera
//
//  Created by diseno on 24-03-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "ConnectionManager.h"
#import <foundation/Foundation.h>
#import "Reachability.h"
#import "AFNetworking.h"

@implementation ConnectionManager

@synthesize isConnected;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //isConnected = [self verifyConnection];
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
        NSLog(@"reachable via wifi");
        return true;
    }
    return false;
}

-(NSDictionary*)getAllCategories{
    
    NSDictionary * dictionary = nil;
    
    isConnected = YES;
    //[self verifyConnection];
    if(isConnected){
    
        // Send a synchronous request
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ltrest.multinetlabs.com/club/categories/"]];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        
        if (error == nil)
        {
            // Parse data here
            
           dictionary= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            return  dictionary;
            
        }else{
            NSLog(@"Existe un error");
        }

    }
    
    return dictionary;
}



-(NSDictionary*)getMainCategories{
    NSDictionary * dictionary = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://ltrest.multinetlabs.com/club/categories/?format=json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    return dictionary;
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

//[self registrarConsumoDelBeneficio:27 idSucursal:1 mailUsuario:@"mail@mail.cl" monto:2500];//no acepta el input post del emailUsuario
// [self obtenerTarjetaVirtualDelUsuario:@"mail@mail.cl"];//no acepta el input post del emailUsuario
//[self obtenerHistorialDelUsuario:@"acornejo@copesa.cl"];//no acepta el input post del emailUsuario

// [self registrarParticipacionDelConcurso:1 nombres:@"Nombres" apellidos:@"Apellidos" rutUsuario:111111111 fechaNacimiento:@"2014-01-01" emailContacto:@"email@email.cl" fonoContacto:55555555 actividad:@"Actividad" comuna:@"Comuna" emailUsuario:@"email@asicom.cl"];//no acepta el input post del emailUsuario


@end
