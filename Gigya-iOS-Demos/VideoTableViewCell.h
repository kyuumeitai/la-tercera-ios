//
//  VideoTableViewCell.h
//  La Tercera
//
//  Created by diseno on 12-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTituloVideo;
@property (weak, nonatomic) IBOutlet UILabel *labelSummary;
@property (weak, nonatomic) IBOutlet UIWebView *rudoPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewThumb;


-(void)loadBanner;
@property (nonatomic, copy) NSString* rudoVideoUrl;
@property (nonatomic, copy) NSString* videoImageUrl;

@end
