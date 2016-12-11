//
//  VideoPlayerViewController.h
//  La Tercera
//
//  Created by Mario Alejandro on 19-10-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayerViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;
@property (strong,nonatomic) NSString* videoURL;
@property (strong,nonatomic) NSString* seccion;
@property (strong,nonatomic) NSString* titulo;

@end
