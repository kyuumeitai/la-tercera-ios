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
   
    //NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);

    // Initialization code
}

- (void)initBanner{
   
   // [self.bannerView loadRequest:[GADRequest request]];
   self.bannerView.adUnitID = self.bannerUnitID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    self.bannerView.backgroundColor = [UIColor redColor];
    self.bannerView.autoloadEnabled = YES;
    [self.bannerView layoutSubviews];
 
    DFPRequest *request=[DFPRequest request];

    //request.testDevices = @[ @"1cfe50f939bddb106fe8f60a030ffe93" ];
    [self.bannerView loadRequest:request];
}

@end
