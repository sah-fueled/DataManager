//
//  ObjectManager.h
//  RestkitExample
//
//  Created by sah-fueled on 09/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "RKObjectManager.h"
#import "User.h"

@interface ObjectManager : RKObjectManager

@property (nonatomic, strong) RKPaginator *paginator;

+ (instancetype) sharedManager;

- (void) setupRequestDescriptors;
- (void) setupResponseDescriptors;

- (void)authorizeWithCompletion:(void (^)(BOOL success))block;

- (RKManagedObjectStore *)store;
- (void)configureManagedObjectStore;
- (void)setupPaginator;

@end
