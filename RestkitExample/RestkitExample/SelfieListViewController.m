//
//  SelfieListViewController.m
//  RestkitExample
//
//  Created by sah-fueled on 10/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "SelfieListViewController.h"
#import "SelfieManager.h"
#import "SelfieTableViewCell.h"
#import "Restkit.h"
#import "ObjectManager.h"

@interface SelfieListViewController ()<NSFetchedResultsControllerDelegate , UITableViewDataSource, UITableViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isPaginatingData;

@property (nonatomic, assign) BOOL userInitiatedScrolling;
@property (nonatomic, assign) BOOL userScrolling;
@end

@implementation SelfieListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView registerClass:[SelfieTableViewCell class] forCellReuseIdentifier:@"selfieCell"];
  [self.tableView registerNib:[UINib nibWithNibName:@"SelfieTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"selfieCell"];
  [self configureFetchResultsController];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [SelfieManager loadPaginatedSelfieForUser:self.user success:^(NSArray *selfies, NSError *error) {
   
 }];
//  [SelfieManager loadSelfieForUser:self.user success:^(NSArray *selfies, NSError *error) {
//    NSLog(@"array = %@ error = %@",selfies,error);
//  }];
}

- (void)configureFetchResultsController {
  
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Selfie"];
  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"selfieId" ascending:NO];
  fetchRequest.sortDescriptors = @[descriptor];
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.user == %@",self.user]; 
//  [fetchRequest setPredicate:predicate];
  NSError *error = nil;
  RKManagedObjectStore *store = [ObjectManager sharedManager].store;
  NSLog(@"object store = %@ in List",store);
  NSLog(@"managed object conetxt = %@ in List",store.mainQueueManagedObjectContext);
  // Setup fetched results
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                      managedObjectContext: store.mainQueueManagedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
  [self.fetchedResultsController setDelegate:self];
  BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
//  NSAssert([[self.fetchedResultsController fetchedObjects] count], @"Seeding didn't work...");
  if (! fetchSuccessful) {
    NSLog(@"Error fetching data");
  }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.fetchedResultsController.fetchedObjects.count;
}

- (SelfieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SelfieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selfieCell"];
//  NSLog(@"selfie inside cell = %@",[self.fetchedResultsController objectAtIndexPath:indexPath]);
  [cell initializeWithSelfie:[self.fetchedResultsController objectAtIndexPath:indexPath]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 250;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSLog(@"object count = %d",self.fetchedResultsController.fetchedObjects.count);
  self.items = [NSArray arrayWithArray:self.fetchedResultsController.fetchedObjects];
  [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  self.userInitiatedScrolling = YES;
  self.userScrolling = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if(self.userInitiatedScrolling) {
    CGFloat currentOffset = scrollView.contentOffset.y + scrollView.frame.size.height;
    if(currentOffset > (scrollView.contentSize.height ) && self.userScrolling) {
      if ([[ObjectManager sharedManager].paginator isLoaded] && [[ObjectManager sharedManager].paginator hasNextPage]) {
        [[ObjectManager sharedManager].paginator loadNextPage];
        NSLog(@"Load next");
      }

    }
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  self.userScrolling = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  self.userInitiatedScrolling = NO;
}

@end
