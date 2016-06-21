//
//  CollectionViewCellBanner.m
//  La Tercera
//
//  Created by diseno on 09-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CollectionViewCellBanner.h"
@implementation CollectionViewCellBanner

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);

    // Initialization code
}

- (void)initBanner{
    
    self.bannerView.adUnitID = self.bannerUnitID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    
    DFPRequest *request=[DFPRequest request];
    //request.testDevices = @[ @"4ed3d28192b2fcc07d35bfefc87bef48" ];
    [self.bannerView loadRequest:request];
}

@end
