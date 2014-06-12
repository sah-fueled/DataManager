//
//  User.h
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Selfie;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *selfies;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addSelfiesObject:(Selfie *)value;
- (void)removeSelfiesObject:(Selfie *)value;
- (void)addSelfies:(NSSet *)values;
- (void)removeSelfies:(NSSet *)values;

@end
