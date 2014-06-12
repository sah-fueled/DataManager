//
//  DataManager.h
//  RestkitExample
//
//  Created by sah-fueled on 12/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, assign) BOOL isDataPerisistent;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *conditionParameters;

- (void)fetchObjectsWithCompletion:(void(^)(NSArray *objects, NSError *error))block;

@end
