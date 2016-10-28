//
//  LCBannerView.m
//
//  Created by BrUjO 
//
//

#import "LCBannerView.h"
#import "UIImageView+AFNetworking.h"
#import "Tools.h"
#import "Benefit.h"

static CGFloat LCPageDistance = 5.0f;  // distance to bottom of pageControl

@interface LCBannerView () <UIScrollViewDelegate>

@property (nonatomic, weak  ) id<LCBannerViewDelegate> delegate;

@property (nonatomic, assign) CGFloat       timeInterval;

@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, weak  ) UIScrollView  *scrollView;
@property (nonatomic, weak  ) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger     oldURLCount;

@end

@implementation LCBannerView

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageName:(NSString *)imageName count:(NSInteger)count timeInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {

    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             imageName:imageName
                                 count:count
                         timeInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImageName:(NSString *)placeholderImageName timeInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {

    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             imageURLs:imageURLs
                  placeholderImageName:placeholderImageName
                         timeInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}



- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageName:(NSString *)imageName count:(NSInteger)count timeInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {

    if (self = [super initWithFrame:frame]) {

        _delegate                      = delegate;
        _imageName                     = imageName;
        _count                         = count;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        _pageIndicatorTintColor        = pageIndicatorTintColor;

        [self setupMainView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImageName:(NSString *)placeholderImageName timeInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {

    if (self = [super initWithFrame:frame]) {

        _delegate                      = delegate;
        _imageURLs                     = imageURLs;
        _count                         = imageURLs.count;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        _pageIndicatorTintColor        = pageIndicatorTintColor;
        _placeholderImageName          = placeholderImageName;

        _oldURLCount                   = _count;

        [self setupMainView];
    }
    return self;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate benefitsArray:(NSArray *)benefitArrays placeholderImageName:(NSString *)placeholderImageName timeInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             benefitsArray:benefitArrays
                  placeholderImageName:placeholderImageName
                          timeInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate benefitsArray:(NSArray *)benefitsArray placeholderImageName:(NSString *)placeholderImageName timeInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    if (self = [super initWithFrame:frame]) {
        
        _delegate                      = delegate;
        _benefitsArray                 = benefitsArray;
        _count                         = benefitsArray.count;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        _pageIndicatorTintColor        = pageIndicatorTintColor;
        _placeholderImageName          = placeholderImageName;
        
        _oldURLCount                   = _count;
        
        [self setupCustomMainView];
    }
    return self;
}


- (void)setupMainView {

    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;

    // set up scrollView
    [self addSubview:({

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];

        [self addSubviewToScrollView:scrollView];

        scrollView.delegate                       = self;
        scrollView.scrollsToTop                   = NO;
        scrollView.pagingEnabled                  = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentOffset                  = CGPointMake(scrollW, 0);
        scrollView.contentSize                    = CGSizeMake((self.count + 2) * scrollW, 0);

        self.scrollView = scrollView;
    })];

    [self addTimer];

    // set up pageControl
    
    [self addSubview:({

        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollH  - LCPageDistance, scrollW, 30.0f)];
        pageControl.numberOfPages                 = self.count;
        pageControl.userInteractionEnabled        = NO;
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor ?: [UIColor orangeColor];
        pageControl.pageIndicatorTintColor        = self.pageIndicatorTintColor ?: [UIColor lightGrayColor];

        self.pageControl = pageControl;
    })];
    
//    [self handleDidScroll];
}

- (void)setupCustomMainView {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    
    // set up scrollView
    [self addSubview:({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
        
        [self addCustomSubviewToScrollView:scrollView];
        
        scrollView.delegate                       = self;
        scrollView.scrollsToTop                   = NO;
        scrollView.pagingEnabled                  = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentOffset                  = CGPointMake(scrollW, 0);
        scrollView.contentSize                    = CGSizeMake((self.count + 2) * scrollW, 0);
        
        self.scrollView = scrollView;
    })];
    
    [self addTimer];
    
    // set up pageControl
    
    [self addSubview:({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollH  - LCPageDistance, scrollW, 30.0f)];
        pageControl.numberOfPages                 = self.count;
        pageControl.userInteractionEnabled        = NO;
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor ?: [UIColor orangeColor];
        pageControl.pageIndicatorTintColor        = self.pageIndicatorTintColor ?: [UIColor lightGrayColor];
        
        self.pageControl = pageControl;
    })];
    
    //    [self handleDidScroll];
}


- (void)addCustomSubviewToScrollView:(UIScrollView *)scrollView {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    Benefit *beneficio;
    for (int i = 0; i < self.count + 2; i++) {
        
        NSInteger tag = 0;
        NSString *currentImageName = nil;
        
        if (i == 0) {
            
            tag = self.count;
            
            currentImageName = [NSString stringWithFormat:@"%@_%02ld", self.imageName, (long)self.count];
            
        } else if (i == self.count + 1) {
            
            tag = 1;
            
            currentImageName = [NSString stringWithFormat:@"%@_01", self.imageName];
            
        } else {
            
            tag = i;
            
            currentImageName = [NSString stringWithFormat:@"%@_%02d", self.imageName, i];
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = tag;
        
        if (self.imageName.length > 0) {    // from local
            
            UIImage *image = [UIImage imageNamed:currentImageName];
            if (!image) {
                
                NSLog(@"ERROR: No image named `%@`!", currentImageName);
            }
            
            imageView.image = image;
            
        } else {    // from internet ESTE SII
            
            beneficio = (Benefit*)self.benefitsArray[tag - 1];
            
            NSLog(@"BENEFITS ARRAY %@", _benefitsArray);
            NSLog(@"ESTOY EN POSICION DOS");
            
            NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
            
            UIImage *imagencita = [Tools decodeBase64ToImage:[arr lastObject]];


            // note: replace "ImageUtils" with the class where you pasted the method above
            UIImage *img = [self drawBenefitTitle:beneficio.title andSunmmary:beneficio.summary andDiscount:beneficio.desclabel inImage:imagencita ];

            imageView.image = img;

        }
        
        imageView.clipsToBounds          = YES;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode            = UIViewContentModeScaleAspectFill;
        imageView.frame                  = CGRectMake(scrollW * i, 0, scrollW, scrollH);
        [scrollView addSubview:imageView];
        

        UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
        [imageView addGestureRecognizer:tap];
    }
}


- (void)addSubviewToScrollView:(UIScrollView *)scrollView {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    Benefit *beneficio;
    for (int i = 0; i < self.count + 2; i++) {
        
        NSInteger tag = 0;
        NSString *currentImageName = nil;
        
        if (i == 0) {
            
            tag = self.count;
            
            currentImageName = [NSString stringWithFormat:@"%@_%02ld", self.imageName, (long)self.count];
            
        } else if (i == self.count + 1) {
            
            tag = 1;
            
            currentImageName = [NSString stringWithFormat:@"%@_01", self.imageName];
            
        } else {
            
            tag = i;
            
            currentImageName = [NSString stringWithFormat:@"%@_%02d", self.imageName, i];
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = tag;
        
        if (self.imageName.length > 0) {    // from local
            
            UIImage *image = [UIImage imageNamed:currentImageName];
            if (!image) {
                
                NSLog(@"ERROR: No image named `%@`!", currentImageName);
            }
            
            imageView.image = image;
            
        } else {    // from internet
           beneficio = (Benefit*)self.benefitsArray[tag - 1];
            
            NSLog(@"BENEFITS ARRAY %@", _benefitsArray);
            NSLog(@"ESTOY ACA LPOOONYIII");

            NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
            
            //Now data is decoded. You can convert them to UIImage
    
            
            UIImage *imagencita = [Tools decodeBase64ToImage:[arr lastObject]];


            // note: replace "ImageUtils" with the class where you pasted the method above
            UIImage *img = [self drawBenefitTitle:beneficio.title andSunmmary:beneficio.summary andDiscount:beneficio.desclabel inImage:imagencita
                                          ];
 
            imageView.image = img;

        }
        

        imageView.clipsToBounds          = YES;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode            = UIViewContentModeScaleAspectFill;
        imageView.frame                  = CGRectMake(scrollW * i, 0, scrollW, scrollH);
        [scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
        [imageView addGestureRecognizer:tap];
    }
}


- (void)imageViewTaped:(UITapGestureRecognizer *)tap {

    if ([self.delegate respondsToSelector:@selector(bannerView:didClickedImageIndex:)]) {
        [self.delegate bannerView:self didClickedImageIndex:tap.view.tag - 1];
    }
    
    if (self.didClickedImageIndexBlock) {
        self.didClickedImageIndexBlock(self, tap.view.tag - 1);
    }
}

- (void)setPageDistance:(CGFloat)pageDistance {
    _pageDistance = pageDistance;

    if (pageDistance != LCPageDistance) {
        CGRect frame           = self.pageControl.frame;
        frame.origin.y         = self.frame.size.height - 10.0f - pageDistance;
        self.pageControl.frame = frame;
    }
}

- (void)setNotScrolling:(BOOL)notScrolling {
    _notScrolling = notScrolling;

    if (notScrolling) {
        self.pageControl.hidden       = YES;
        self.scrollView.scrollEnabled = NO;

        if (self.timer) {
            [self removeTimer];
        }
    }
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    
    self.pageControl.hidden = hidePageControl;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    
    [self refreshMainViewCountChanged:NO];
}

- (void)setImageURLs:(NSArray *)imageURLs {
    _imageURLs = imageURLs;
    
    [self refreshMainViewCountChanged:imageURLs.count != self.oldURLCount];
    
    self.oldURLCount = imageURLs.count;
}

- (void)setBenefitTextArray:(NSArray *)benefitTextArray {
    _benefitTextArray = benefitTextArray;
    

}

- (void)setIdBenefitArray:(NSArray *)idBenefitArray  {
    _idBenefitArray = idBenefitArray;
    
}

- (void)setTitleTextArray:(NSArray *)titleTextArray  {
    _titleTextArray = titleTextArray;
    
}

- (void)setSummaryTextArray:(NSArray *)summaryTextArray {
    _summaryTextArray = summaryTextArray;
    
}

- (void)setBenefitsArray:(NSArray *)benefitsArray{
    _benefitsArray = benefitsArray;
    [self refreshMainViewCountChanged:benefitsArray.count != self.oldURLCount];
    
    self.oldURLCount = benefitsArray.count;
    
}

- (void)setCount:(NSInteger)count {
    _count = count;
    
    [self refreshMainViewCountChanged:YES];
}

- (void)setPlaceholderImageName:(NSString *)placeholderImageName {
    _placeholderImageName = placeholderImageName;
    
    [self refreshMainViewCountChanged:NO];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor ?: [UIColor orangeColor];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor ?: [UIColor lightGrayColor];
}

- (void)refreshMainViewCountChanged:(BOOL)changed {
    if (changed) {
        
        for (UIView *childView in self.scrollView.subviews) {
            [childView removeFromSuperview];
        }
        
        if (self.imageName.length == 0) {
            _count = self.imageURLs.count;
        }
        
        [self addSubviewToScrollView:self.scrollView];
        
        self.pageControl.numberOfPages = self.count;
        
    } else {
        
        for (int i = 0; i < self.count + 2; i++) {
            
            NSInteger tag = 0;
            NSString *currentImageName = nil;
            
            if (i == 0) {
                
                tag = self.count;
                
                currentImageName = [NSString stringWithFormat:@"%@_%02ld", self.imageName, (long)self.count];
                
            } else if (i == self.count + 1) {
                
                tag = 1;
                
                currentImageName = [NSString stringWithFormat:@"%@_01", self.imageName];
                
            } else {
                
                tag = i;
                
                currentImageName = [NSString stringWithFormat:@"%@_%02d", self.imageName, i];
            }
            
            UIImageView *imageView = [self.scrollView viewWithTag:tag];
            
            if (self.imageName.length > 0) {    // from local
                
                UIImage *image = [UIImage imageNamed:currentImageName];
                if (!image) {
                    
                    NSLog(@"ERROR: No image named `%@`!", currentImageName);
                }
                
                imageView.image = image;
                
            } else {    // from internet
                
               Benefit * beneficio = (Benefit*)self.benefitsArray[tag - 1];
                
                NSLog(@"BENEFITS ARRAY %@", _benefitsArray);
                NSLog(@"ESTOY ACA LPOOONYIII");
                
                NSArray * arr = [beneficio.imagenNormalString componentsSeparatedByString:@","];
                
                //Now data is decoded. You can convert them to UIImage
                
                
                UIImage *imagencita = [Tools decodeBase64ToImage:[arr lastObject]];


                // note: replace "ImageUtils" with the class where you pasted the method above
                UIImage *img = [self drawBenefitTitle:beneficio.title andSunmmary:beneficio.summary andDiscount:beneficio.desclabel inImage:imagencita
                                ];

                imageView.image = img;
                   }
        }
    }
}

- (void)handleDidScroll {
    
    if ([self.delegate respondsToSelector:@selector(bannerView:didScrollToIndex:)]) {
        [self.delegate bannerView:self didScrollToIndex:self.pageControl.currentPage];
    }
    
    if (self.didScrollToIndexBlock) {
        self.didScrollToIndexBlock(self, self.pageControl.currentPage);
    }
}

#pragma mark - Timer

- (void)addTimer {

    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextImage) userInfo:nil repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {

    if (self.timer) {

        [self.timer invalidate];

        self.timer = nil;
    }
}

- (void)nextImage {

    NSInteger currentPage = self.pageControl.currentPage;

    [self.scrollView setContentOffset:CGPointMake((currentPage + 2) * self.scrollView.frame.size.width, 0)
                             animated:YES];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat scrollW = self.scrollView.frame.size.width;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;

    if (currentPage == self.count + 1) {

        self.pageControl.currentPage = 0;

    } else if (currentPage == 0) {

        self.pageControl.currentPage = self.count;

    } else {

        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGFloat scrollW = self.scrollView.frame.size.width;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;

    if (currentPage == self.count + 1) {

        self.pageControl.currentPage = 0;

        [self.scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];

    } else if (currentPage == 0) {

        self.pageControl.currentPage = self.count;

        [self.scrollView setContentOffset:CGPointMake(self.count * scrollW, 0) animated:NO];

    } else {

        self.pageControl.currentPage = currentPage - 1;
    }
    
    [self handleDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    [self addTimer];
}

- (UIImage*) drawBenefitTitle:(NSString*) title andSunmmary:(NSString*)summary andDiscount:(NSString*)discount
              inImage:(UIImage*)  image

{
  
    
    UIImage *myImage = image;//[self filledImageFrom:image withColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];

    UIGraphicsBeginImageContext(myImage.size);
    [myImage drawInRect:CGRectMake(0,0,myImage.size.width,myImage.size.height)];
    
    
        //// tituloBeneficio Drawing
    UITextView *myText = [[UITextView alloc] init];
    myText.text = title;

    CGSize maximumLabelSize = CGSizeMake(myImage.size.width,myImage.size.height);
    CGSize expectedLabelSize = [myText.text sizeWithFont:myText.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:UILineBreakModeWordWrap];
    myText.textColor = [UIColor whiteColor];
    myText.layer.shadowColor = [[UIColor blackColor] CGColor];
    myText.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    myText.layer.shadowOpacity = 1.0f;
    myText.layer.shadowRadius = 1.0f;
    
    myText.frame = CGRectMake(10 , 35 ,
                              myImage.size.width-10,
                              myImage.size.height);
    
    [[UIColor whiteColor] set];
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 2;
    shadow.shadowOffset = CGSizeMake(2, 2);

    NSDictionary * textAttributes =
  @{ NSForegroundColorAttributeName : [UIColor whiteColor],
     NSShadowAttributeName          : shadow,
     NSFontAttributeName            : [UIFont fontWithName:@"PTSans-Bold" size:32.0f] };
    
   // myText.attributedText = [[NSAttributedString alloc] initWithString:title
     //                                                         attributes:textAttributes];
    
    [myText.text drawInRect:myText.frame withAttributes:textAttributes];
    //Summary
    UITextView *mySummary = [[UITextView alloc] init];
    CGSize maximumLabelSize2 = CGSizeMake(myImage.size.width,myImage.size.height);
    CGSize expectedLabelSize2 = [mySummary.text sizeWithFont:mySummary.font
                                        constrainedToSize:maximumLabelSize2
                                            lineBreakMode:UILineBreakModeWordWrap];
    mySummary.text = summary;
    mySummary.layer.shadowColor = [[UIColor blackColor] CGColor];
    mySummary.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    mySummary.layer.shadowOpacity = 1.0f;
    mySummary.layer.shadowRadius = 2.0f;
    mySummary.frame = CGRectMake(10 , 100 ,
                                 myImage.size.width-15,
                                 myImage.size.height);
    [[UIColor whiteColor] set];

    NSShadow * shadow2 = [[NSShadow alloc] init];
    shadow2.shadowColor = [UIColor blackColor];
    shadow2.shadowBlurRadius = 3;
    shadow2.shadowOffset = CGSizeMake(3, 3);



 

    NSDictionary * summaryAttributes =
    @{ NSForegroundColorAttributeName : [UIColor whiteColor],
       NSShadowAttributeName          : shadow2,
       NSFontAttributeName            : [UIFont fontWithName:@"PTSans-Bold" size:32.0f] };
    
    [mySummary.text drawInRect:mySummary.frame withAttributes:summaryAttributes];
    
    //Discount
    
    NSDictionary * discountAttributes =
    @{ NSForegroundColorAttributeName : [UIColor whiteColor],
       NSShadowAttributeName          : shadow,
       NSFontAttributeName            : [UIFont fontWithName:@"PTSans-Bold" size:30.0f] };
    
    UITextView *myDiscount = [[UITextView alloc] init];
    
    
    
    myDiscount.textColor = [UIColor whiteColor];
    myDiscount.text = discount;
    
    
    myDiscount.frame = CGRectMake(20 ,  myImage.size.height-65 ,
                                 myImage.size.width-10,
                                 myImage.size.height);
    
    [[UIColor whiteColor] set];
    [myDiscount.text drawInRect:myDiscount.frame withAttributes:discountAttributes];
    
    
    UIImage *myNewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myNewImage;
}

/*-(UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color{
    

    UIImage *newImage = source;
    so
    return newImage;
}
*/
@end
