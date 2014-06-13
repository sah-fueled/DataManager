//
//  DataManager.h
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Restkit/CoreData.h>

#import "Restkit.h"

@interface DataManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) BOOL isDataPersistent;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *conditionParameters;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) RKPaginator *paginator;

- (void)shouldDataPersist:(BOOL)shouldPersist;

- (void)setupRoutes;
- (void)setupResponseDescriptors;
- (void)setupRequestDescriptors;
- (void)setupRequestDescriptorsForStore:(RKManagedObjectStore *)store;
- (void)setupResponseDescriptorsForStore:(RKManagedObjectStore *)store;
- (void)setupPagination;

- (void)authorizeWithCompletion:(void (^)(BOOL success))block;
- (void)fetchObjectsWithCompletion:(void(^)(NSArray *objects, NSError *error))block;
@end
