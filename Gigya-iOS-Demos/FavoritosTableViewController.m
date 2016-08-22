//
//  FavoritosTableViewController.m
//  La Tercera
//
//  Created by BrUjO on 29-07-16.
//  Copyright © 2016 Gigya. All rights reserved.
//

#import "FavoritosTableViewController.h"
#import "FavoritosTableViewCell.h"
#import "CoreData/CoreData.h"

@interface FavoritosTableViewController ()

@end

@implementation FavoritosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Noticia"];
    self.arrayFavoritos = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"Array de favoritos: %@", self.arrayFavoritos);
    
    [self.tableView reloadData];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    //UIImage *imagen = [UIImage imageWithData:[device valueForKey:@"imageLink"]];
    //[cell.imageView setImage:imagen];
    
    return cell;
    
}

@end
