//
//  AppDelegate.h
//  Gigya-iOS-Demos
//
//  Created by Jay Reardon & Giovanni Alvarez on 12/22/14.
//  Copyright (c) 2014 Gigya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Headers/MOCA.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, MOCAProximityEventsDelegate, MOCAProximityActionsDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property BOOL videoIsPlaying;
- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data


@end

