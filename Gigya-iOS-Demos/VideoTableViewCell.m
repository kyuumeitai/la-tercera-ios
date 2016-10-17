//
//  VideoTableViewCell.m
//  La Tercera
//
//  Created by diseno on 12-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell 
NSURLRequest *requestObj;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    // URL Request Object

    // Configure the view for the selected state
}

-(void)loadBanner{
    

    requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:_rudoVideoUrl]];
    [self.rudoPlayer loadRequest:requestObj];
    // Load the request in the UIWebView
    //[self.rudoPlayer loadRequest:requestObj];
    self.rudoPlayer.scrollView.scrollEnabled = NO;
}

@end
