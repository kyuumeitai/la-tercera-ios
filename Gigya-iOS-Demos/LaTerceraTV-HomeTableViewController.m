//
//  LaTerceraTV-HomeTableViewController.m
//  La Tercera
//
//  Created by diseno on 11-08-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "LaTerceraTV-HomeTableViewController.h"
#import "ConnectionManager.h"
#import "CollectionViewCellGrande.h"
#import "CollectionViewCellMediana.h"
#import "CollectionViewCellHorizontal.h"
#import "CollectionViewCellBanner.h"
#import "NewspaperPage.h"
#import "NewsPageViewController.h"
#import "Tools.h"
#import "Headline.h"
#import "DetalleNewsViewController.h"
#import "Article.h"
#import "UIImageView+AFNetworking.h"
#import "SessionManager.h"
#import "SVPullToRefresh.h"
#import "ContentType.h"

//#import "SDWebImage/UIImageView+WebCache.h"

#define categorySlug @"terceratv"

@interface LaTerceraTV_HomeTableViewController ()

@end

@implementation LaTerceraTV_HomeTableViewController
@synthesize headlinesArray;
@synthesize collectionView;
@synthesize categoryId;
static NSString * const reuseIdentifierGrande = @"collectionViewGrande";

static NSString * const reuseIdentifierMediana = @"collectionViewMediana";
static NSString * const reuseIdentifierHorizontal = @"collectionViewHorizontal";
static NSString * const reuseIdentifierBanner = @"collectionViewBanner";

//New Pagination code
int currentPageNumber ;
BOOL isPageRefreshingLaTerceraTV =  false;
BOOL firstTimeLaTerceraTV = false;
NSArray *bannersLaTerceraTV= nil;
BOOL _isScrollingLaTerceraTV;
int numeroPaginas;
NSString *day;
NSString *month;
NSString *year;
NSString *storyBoardName;

- (void)viewDidLoad {
    [super viewDidLoad];
    SessionManager *sesion = [SessionManager session];
    storyBoardName = sesion.storyBoardName;
    
    for (ContentType *contenido in sesion.categoryList) {
        if([contenido.contentSlug isEqualToString:categorySlug])
            self.categoryId = contenido.contentId;
    }
    
    NSLog(@" El nombre del storboard es: %@", storyBoardName);
    NSLog(@"CategoryId: %d", self.categoryId);
    __weak  LaTerceraTV_HomeTableViewController *weakSelf = self;
    headlinesArray = [[NSMutableArray alloc] init];
    
    bannersLaTerceraTV = [NSArray arrayWithObjects:@"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-A", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-B", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-C", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-D", @"/124506296/La_Tercera_com/La_Tercera_com_APP/LaTerceraTV_300x250-E", nil];
    
    //Celda Grande
    UINib *cellNib ;
    
    if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande4-5" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionViewGrande4-5"];
        
    }else{
        
        cellNib = [UINib nibWithNibName:@"CollectionViewCellGrande" bundle: nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifierGrande];
    }
    
    
    //Celda Mediana
    UINib *cellNib2 ;
    
    if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana4-5" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:@"collectionViewMediana4-5"];
        
    }else{
        
        cellNib2 = [UINib nibWithNibName:@"CollectionViewCellMediana" bundle: nil];
        [self.collectionView registerNib:cellNib2 forCellWithReuseIdentifier:reuseIdentifierMediana];
    }
    
    
    //Celda Horizontal
    UINib *cellNib3 ;
    
    if([storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone4"] || [storyBoardName isEqualToString:@"LaTerceraStoryboard-iPhone5"]){
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal4-5" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:@"collectionViewHorizontal4-5"];
        
    }else{
        
        cellNib3 = [UINib nibWithNibName:@"CollectionViewCellHorizontal" bundle: nil];
        [self.collectionView registerNib:cellNib3 forCellWithReuseIdentifier:reuseIdentifierHorizontal];
    }
    
    
    UINib *cellNib4 = [UINib nibWithNibName:@"CollectionViewCellBanner" bundle: nil];
    
    [self.collectionView registerNib:cellNib4 forCellWithReuseIdentifier:reuseIdentifierBanner];
    
    currentPageNumber = 1;
    firstTimeLaTerceraTV = true;
    
    //[self.collectionView setAlpha:0.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
       // [self loadHeadlinesWithCategory:self.categoryId];
    });
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
      //  [weakSelf loadMoreRows];
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
