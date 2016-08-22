//
//  CollectionViewCellBanner.m
//  La Tercera
//
//  Created by diseno on 09-06-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "CollectionViewCellBanner.h"
@implementation CollectionViewCellBanner


DFPRequest *request;

- (void)awakeFromNib {
    
    [super awakeFromNib];
   
    //NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);

    // Initialization code
}

/*
- (void)initBanner{
   
   // [self.bannerView loadRequest:[GADRequest request]];
   self.bannerView.adUnitID = self.bannerUnitID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
 
   request = [DFPRequest request];

}
 */
-(void)cellBannerView:(UIViewController*)rootVC {

   // [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.adUnitID = self.bannerUnitID;
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = rootVC;
    request = [DFPRequest request];
  
    //[self.contentView addSubview:self.bannerView];
    [self.bannerView loadRequest:request];
}

-(void)loadBanner{
    
        [self.bannerView loadRequest:request];
}
- (void)adViewDidReceiveAd:(DFPBannerView *)bannerView {
    NSLog(@"Mostrando el Ad %@ : %@",self.bannerView.adUnitID,  bannerView.adNetworkClassName);

}

- (void)adView:(DFPBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Ha falado Mostrando el Ad %@ : %@",self.bannerView.adUnitID,  bannerView.adNetworkClassName);

}

+(NSString*)resuseIdentifier {
    return @"collectionViewBanner";
}

-(void)prepareForReuse {
    [super prepareForReuse];
}

@end
