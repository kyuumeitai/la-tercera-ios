//
//  JPSThumbnailAnnotationView.m
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

@import QuartzCore;
#import "JPSThumbnailAnnotationView.h"
#import "JPSThumbnail.h"
//#import "DetalleBanioViewController.h"

NSString * const kJPSThumbnailAnnotationViewReuseID = @"JPSThumbnailAnnotationView";

static CGFloat const kJPSThumbnailAnnotationViewStandardWidth     = 100.0f;
static CGFloat const kJPSThumbnailAnnotationViewStandardHeight    = 110.0f;
static CGFloat const kJPSThumbnailAnnotationViewExpandOffset      = 230.0f;
static CGFloat const kJPSThumbnailAnnotationViewVerticalOffset    = 0.0f;
static CGFloat const kJPSThumbnailAnnotationViewAnimationDuration = 0.20f;

@interface JPSThumbnailAnnotationView ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *imagenInicial;
@property (nonatomic, strong) UIImage *imagenDetalle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic, strong) ActionBlock disclosureBlock;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIButton *disclosureButton;
@property (nonatomic, assign) JPSThumbnailAnnotationViewState state;
@property BOOL isOpen ;

@end

@implementation JPSThumbnailAnnotationView

#pragma mark - Setup

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super initWithAnnotation:annotation reuseIdentifier:kJPSThumbnailAnnotationViewReuseID];
    
    if (self) {
        self.canShowCallout = NO;
        //self.userInteractionEnabled = NO;
        self.frame = CGRectMake(0, 0, kJPSThumbnailAnnotationViewStandardWidth, kJPSThumbnailAnnotationViewStandardHeight);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -kJPSThumbnailAnnotationViewVerticalOffset);
        
        _state = JPSThumbnailAnnotationViewStateCollapsed;
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    [self setupImageView];
    [self setupTitleLabel];
    [self setupSubtitleLabel];
    [self setupDisclosureButton];
    //
    [self setDetailGroupAlpha:0.0f];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5f, 12.5f, 70.0f, 70.0f)];
    _imageView.layer.cornerRadius = 4.0f;
    _imageView.layer.masksToBounds = YES;
    //_imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //_imageView.layer.borderWidth = 0.5f;
    [self addSubview:_imageView];
    self.likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 26, 40, 35)];
    self.likesLabel.textAlignment = NSTextAlignmentCenter;
    self.likesLabel.textColor = [UIColor whiteColor];
    
    self.likesLabel.font = [self.likesLabel.font fontWithSize:14];
    [self addSubview:self.likesLabel];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20.0f, 16.0f, 190.0f, 20.0f)];
    _titleLabel.textColor = [UIColor colorWithRed:0.267f green:0.776f blue:0.851f alpha:1.0f];
    _titleLabel.font = [UIFont fontWithName:@"VAGRoundedBold" size:18];
    _titleLabel.minimumScaleFactor = 0.8f;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
}

- (void)setupSubtitleLabel {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20.0f, 32.0f, 200.0f, 50.0f)];
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleLabel.numberOfLines = 3;
    _subtitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_subtitleLabel];
}

- (void)setupDisclosureButton {
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f;
    UIButtonType buttonType = iOS7 ? UIButtonTypeSystem : UIButtonTypeCustom;
    _disclosureButton = [UIButton buttonWithType:buttonType];
    //_disclosureButton.backgroundColor = [UIColor grayColor];
    UIImage *disclosureIndicatorImage = [UIImage imageNamed:@"none"];
    //[JPSThumbnailAnnotationView disclosureButtonImage];
    [_disclosureButton setImage:disclosureIndicatorImage forState:UIControlStateNormal];
    //_disclosureButton.frame = CGRectMake(kJPSThumbnailAnnotationViewExpandOffset/2.0f + self.frame.size.width/2.0f - 10.0f,25.5f, 90, 90);
    _disclosureButton.frame = CGRectMake( -28 ,12, 230, 72);
    
    [_disclosureButton addTarget:self action:@selector(didTapDisclosureButton) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_disclosureButton];
}

- (void)setLayerProperties {
    _bgLayer = [CAShapeLayer layer];
    CGPathRef path = [self newBubbleWithRect:self.bounds];
    _bgLayer.path = path;
    CFRelease(path);
    _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    
    _bgLayer.shadowColor = [UIColor blackColor].CGColor;
    _bgLayer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    _bgLayer.shadowRadius = 7.0f;
    _bgLayer.shadowOpacity = 0.5f;
    
    _bgLayer.masksToBounds = NO;

    [self.layer insertSublayer:_bgLayer atIndex:0];
}

#pragma mark - Updating

- (void)updateWithThumbnail:(JPSThumbnail *)thumbnail {
    self.coordinate = thumbnail.coordinate;
    self.titleLabel.text = thumbnail.title;
    self.subtitleLabel.text = thumbnail.subtitle;
    self.imagenInicial = thumbnail.imagenInicial;
    self.imagenDetalle = thumbnail.image;
    self.imageView.image = self.imagenInicial;
    self.likesLabel.text = [NSString stringWithFormat:@"%d", thumbnail.likes];
    self.disclosureBlock = thumbnail.disclosureBlock;
}

#pragma mark - JPSThumbnailAnnotationViewProtocol

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
        [mapView setCenterCoordinate:self.coordinate animated:YES];
        NSLog(@" LLAMAREMOS A EXPAND %ld",(long)self.state);
        
        [self expand];


}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
    NSLog(@" LLAMAREMOS A SHRINK %ld",(long)self.state);
    [self shrink];

}

#pragma mark - Geometry

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 2.0f;
	CGFloat radius = 8.0f;
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat parentX = rect.origin.x + rect.size.width/2.0f;
	
	// Determine Size
	rect.size.width -= stroke + 14.0f;
	rect.size.height -= stroke + 29.0f;
	rect.origin.x += stroke / 2.0f + 7.0f;
	rect.origin.y += stroke / 2.0f + 7.0f;
    
	// Create Callout Bubble Path
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 14.0f, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14.0f);
	CGPathAddLineToPoint(path, NULL, parentX + 14.0f, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1.0f);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1.0f);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1.0f);
	CGPathCloseSubpath(path);
    return path;
}

#pragma mark - Animations

- (void)setDetailGroupAlpha:(CGFloat)alpha {
    self.disclosureButton.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.subtitleLabel.alpha = alpha;
}

- (void)expand {
    
    NSLog(@" El estado de la vista en exapand es: %ld",(long)self.state);
    if (self.state != JPSThumbnailAnnotationViewStateCollapsed) return;
     NSLog(@" expandemos con state: %ld",(long)self.state);
    self.state = JPSThumbnailAnnotationViewStateAnimating;
    [self setLayerProperties];
    self.imageView.image = self.imagenDetalle;

    
    [self animateBubbleWithDirection:JPSThumbnailAnnotationViewAnimationDirectionGrow];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+kJPSThumbnailAnnotationViewExpandOffset, self.frame.size.height);
    self.centerOffset = CGPointMake(kJPSThumbnailAnnotationViewExpandOffset/2.0f, -kJPSThumbnailAnnotationViewVerticalOffset);
    [UIView animateWithDuration:kJPSThumbnailAnnotationViewAnimationDuration/2.0f delay:kJPSThumbnailAnnotationViewAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setDetailGroupAlpha:1.0f];
    } completion:^(BOOL finished) {
        self.state = JPSThumbnailAnnotationViewStateExpanded;
        NSLog(@" El estado de la vista en exapand es: %ld",(long)self.state);

    }];
}

- (void)shrink {
    NSLog(@" El estado de la vista en shrink es: %ld",(long)self.state);

    if (self.state != JPSThumbnailAnnotationViewStateExpanded) return;
    
    self.state = JPSThumbnailAnnotationViewStateAnimating;
     [self.bgLayer removeFromSuperlayer];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width - kJPSThumbnailAnnotationViewExpandOffset,
                            self.frame.size.height);
    
    [UIView animateWithDuration:kJPSThumbnailAnnotationViewAnimationDuration/2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setDetailGroupAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         //self.state = JPSThumbnailAnnotationViewStateCollapsed;
                         NSLog(@" El estado de la vista en shrink es: %ld",(long)self.state);

                         [self animateBubbleWithDirection:JPSThumbnailAnnotationViewAnimationDirectionShrink];
                         self.centerOffset = CGPointMake(0.0f, -kJPSThumbnailAnnotationViewVerticalOffset);
                     }];
    self.imageView.image = nil;
    self.imageView.image = self.imagenInicial;

}

- (void)animateBubbleWithDirection:(JPSThumbnailAnnotationViewAnimationDirection)animationDirection {
    BOOL growing = (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionGrow);
    // Image
    [UIView animateWithDuration:kJPSThumbnailAnnotationViewAnimationDuration animations:^{
        CGFloat xOffset = (growing ? -1 : 1) * kJPSThumbnailAnnotationViewExpandOffset/2.0f;
        self.imageView.frame = CGRectOffset(self.imageView.frame, xOffset, 0.0f);
    } completion:^(BOOL finished) {
        if (animationDirection == JPSThumbnailAnnotationViewAnimationDirectionShrink) {
            self.state = JPSThumbnailAnnotationViewStateCollapsed;
        }
    }];
    
    // Bubble
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = kJPSThumbnailAnnotationViewAnimationDuration;
    
    // Stroke & Shadow From/To Values
    CGRect largeRect = CGRectInset(self.bounds, -kJPSThumbnailAnnotationViewExpandOffset/2.0f, 0.0f);
    
    CGPathRef fromPath = [self newBubbleWithRect:growing ? self.bounds : largeRect];
    animation.fromValue = (__bridge id)fromPath;
    CGPathRelease(fromPath);
    
    CGPathRef toPath = [self newBubbleWithRect:growing ? largeRect : self.bounds];
    animation.toValue = (__bridge id)toPath;
    CGPathRelease(toPath);
    
    [self.bgLayer addAnimation:animation forKey:animation.keyPath];
}

#pragma mark - Disclosure Button

- (void)didTapDisclosureButton {
    if (self.disclosureBlock) self.disclosureBlock();
}

+ (UIImage *)disclosureButtonImage {
    CGSize size = CGSizeMake(100.0f, 100.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(2.0f, 2.0f)];
    [bezierPath addLineToPoint:CGPointMake(10.0f, 10.0f)];
    [bezierPath addLineToPoint:CGPointMake(2.0f, 18.0f)];
    [[UIColor lightGrayColor] setStroke];
    bezierPath.lineWidth = 4.0f;
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
