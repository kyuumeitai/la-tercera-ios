//
//  FavoritosTableViewController.m
//  La Tercera
//
//  Created by BrUjO on 29-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "FavoritosTableViewController.h"
#import "FavoritosTableViewCell.h"
#import "FavoritoDetailViewController.h"
#import "CoreData/CoreData.h"
#import "Headline.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"

@interface FavoritosTableViewController ()

@end

@implementation FavoritosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Noticia"];
    
    NSMutableArray *tempResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    tempResults = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.arrayFavoritos = (NSMutableArray*)[[tempResults reverseObjectEnumerator] allObjects];

    
    NSLog(@"Array de favoritos: %@", self.arrayFavoritos);
    
    [self.tableView reloadData];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MiPerfil/favoritos"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [super viewWillAppear:animated];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayFavoritos.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *CellIdentifier = @"favoriteCell";
    
    FavoritosTableViewCell *cell = (FavoritosTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *device = [self.arrayFavoritos objectAtIndex:indexPath.row];
    [cell.labelTitle setText:[NSString stringWithFormat:@"%@ ", [device valueForKey:@"title"]]];
    [cell.labelFecha setText:[device valueForKey:@"date"]];
    [cell.labelCategory setText:[device valueForKey:@"category"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"ENtonces el indexpath es: %ld",(long)[indexPath row]);
    if([indexPath row]==5 || (([indexPath row]% 6)-5) == 0  ){
        return ;
        
    }else{
        
        // Configure the cell...
        NSManagedObject *device = [self.arrayFavoritos objectAtIndex:indexPath.row];
        UIImage *imagen = [UIImage imageWithData:[device valueForKey:@"imageLink"]];
        NSLog(@"id titulo = %@",[device valueForKey:@"title"]);
        FavoritoDetailViewController *detalleNews =  (FavoritoDetailViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"detalleNewsFavorito"];
        detalleNews.newsCategory = [device valueForKey:@"category"];
        detalleNews.newsTitle = [device valueForKey:@"title"];
        detalleNews.newsSummary = [device valueForKey:@"summary"];
        detalleNews.newsContent = [device valueForKey:@"content"];
        detalleNews.newsDate = [device valueForKey:@"date"];
        detalleNews.newsAuthor = [device valueForKey:@"author"];
        detalleNews.newsImage = imagen;
 
        [self.navigationController pushViewController:detalleNews animated:YES];
    }
    
}

@end
