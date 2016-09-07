//
//  MOCAEvent.h
//
//  MOCA iOS SDK
//
//  This module is part of InnoQuant MOCA Platform.
//
//  Copyright (c) 2012-2015 InnoQuant Strategic Analytics, S.L.
//  All rights reserved.
//
//  All rights to this software by InnoQuant are owned by InnoQuant
//  and only limited rights are provided by the licensing or contract
//  under which this software is provided.
//
//  Any use of the software for any commercial purpose without
//  the written permission of InnoQuant is prohibited.
//  You may not alter, modify, or in any way change the appearance
//  and copyright notices on the software. You may not reverse compile
//  the software or publish any protected intellectual property embedded
//  in the software. You may not distribute, sell or make copies of
//  the software available to any entities without the explicit written
//  permission of InnoQuant.
//

#import <Foundation/Foundation.h>
#import "MOCASerializable.h"

/**
 * Stores information about an event to be tracked from an instance.
 *
 * @see MOCAInstance
 */
@interface MOCAEvent : NSObject<MOCASerializable>

/**
 * The autogenerated event identifier. 
 *
 * Note the identifier is automatically generated when the event is created. UUID is used for that.
 */
@property (readonly) NSString *     identifier;

/**
 * Instant time the event happened.
 *
 * Timestamp coded as milliseconds since Epoch GMT time in a <code>long long</code> number.
 */
@property (readonly) NSNumber *     timestamp;

/**
 * Local instant time the event happened.
 *
 * Timestamp coded as milliseconds since Epoch GMT time in a <code>long long</code> number 
 * having into account the time zone.
 */
@property (readonly) NSNumber *     localTimestamp;

/**
 * Event type.
 *
 * For all events tracked by the user the type is "_track"
 */
@property (readonly) NSString *     type;

/**
 * Performed action verb.
 */
@property (readonly) NSString *     verb;

/**
 * Item associated with the event.
 *
 * It may be <code>nil</code> if none.
 */
@property (readonly) NSString *     item;

/**
 * Category the item belongs to.
 *
 * It may be <code>nil</code> if none.
 */
@property (readonly) NSString *     category;

/**
 * Value associated with the event.
 *
 * It may be <code>nil</code> if none.
 *
 * It is coded as a NSInteger number.
 */
@property (readonly) NSNumber *     value; // int or NSInteger

/**
 * Application identifier.
 *
 * This is automatically loaded when the event is created.
 */
@property (readonly) NSString *     application;

/**
 * Instance identifier.
 *
 * This is automatically loaded when the event is created.
 */
@property (readonly) NSString *     instance;

/**
 * User identifier if any has been logged in or <code>nil</code>.
 *
 * This is automatically loaded when the event is created.
 */
@property (readonly) NSString *     user;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @param value Value associated with the event.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb withValue:(NSNumber*)value;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @param item Item associated with the event.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb forItem:(NSString*)item;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @param item Item associated with the event.
 * @param value Value associated with the event.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb forItem:(NSString*)item withValue:(NSNumber*)value;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @param item Item associated with the event.
 * @param category Category the item belongs to.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb forItem:(NSString*)item belongingTo:(NSString*)category;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @param item Item associated with the event.
 * @param category Category the item belongs to.
 * @param value Value associated with the event.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb forItem:(NSString*)item belongingTo:(NSString*)category withValue:(NSNumber*)value;

/**
 * Tracks an event.
 *
 * @param verb Action verb.
 * @param item Item associated with the event.
 * @param category Category the item belongs to.
 * @param value Value associated with the event.
 * @return <code>YES</code> in case of success, <code>NO</code> in case of error.
 */
+ (BOOL) track:(NSString*)verb forItem:(NSString*)item belongingTo:(NSString*)category withIntValue:(int)value;

/**
 * Initializes a newly allocated event as a copy of another given event.
 *
 * @param event Other event.
 * @return An initialized event or <code>nil</code> in case of error.
 */
- (id) initWithEvent:(MOCAEvent*)event;

/**
 * Returns a Boolean value that indicates whether the receiving event
 * is equal to another event.
 *
 * @param other Other event.
 * @return <code>YES</code> if the other user has the same identifier and content,
 * otherwise <code>NO</code>.
 */
- (BOOL) isEqualToEvent:(MOCAEvent*)other;

@end
