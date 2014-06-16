//
//  SelfieListViewController.m
//  RestkitExample
//
//  Created by sah-fueled on 10/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import "SelfieListViewController.h"
#import "SelfieTableViewCell.h"
#import "Restkit.h"
#import "SelfieDataManager.h"
#import "UserDataManager.h"
#import "SelfieDetailViewController.h"
#import "Selfie.h"

@interface SelfieListViewController ()<NSFetchedResultsControllerDelegate , UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isPaginatingData;

@property (nonatomic, assign) BOOL userInitiatedScrolling;
@property (nonatomic, assign) BOOL userScrolling;
@property (nonatomic, strong) Selfie *selectedSelfie;
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
//  [[UserDataManager sharedManager] authorizeWithCompletion:^(BOOL success) {
//    [[UserDataManager sharedManager] shouldDataPersist:YES];
//    [[UserDataManager sharedManager]setPath:@"user/"];
//    [[UserDataManager sharedManager] fetchObjectsWithCompletion:^(NSArray *objects, NSError *error) {
//      [[SelfieDataManager sharedManager]authorizeWithCompletion:^(BOOL success) {
//        NSLog(@"auth = %@",[SelfieDataManager sharedManager].objectManager.HTTPClient.defaultHeaders);
//        [[SelfieDataManager sharedManager] shouldDataPersist:YES];
//        [[SelfieDataManager sharedManager]setupPagination];
//        [[SelfieDataManager sharedManager].paginator loadPage:1];
//        [self configureFetchResultsController];
//        [self.tableView reloadData];
//      }];
//    }];
//    
//  }];
  [[SelfieDataManager sharedManager]authorizeWithCompletion:^(BOOL success) {

    [[SelfieDataManager sharedManager] shouldDataPersist:NO];
    [[SelfieDataManager sharedManager] setPath:@"selfie/"];
    [[SelfieDataManager sharedManager] fetchObjectsWithCompletion:^(NSArray *objects, NSError *error) {
      
    }];
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)configureFetchResultsController {
  
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Selfie"];
  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"selfieId" ascending:NO];
  fetchRequest.sortDescriptors = @[descriptor];
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.user == %@",self.user]; 
//  [fetchRequest setPredicate:predicate];
  NSError *error = nil;
  RKManagedObjectStore *store = [SelfieDataManager sharedManager].objectManager.managedObjectStore;
  NSLog(@"object store = %@ in List",store);
  NSLog(@"managed object conetxt = %@ in List",store.mainQueueManagedObjectContext);
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                      managedObjectContext: store.mainQueueManagedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
  [self.fetchedResultsController setDelegate:self];
  BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
  if (! fetchSuccessful) {
    NSLog(@"Error fetching data");
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSLog(@"Number of objects in coredata = %d",self.fetchedResultsController.fetchedObjects.count);
  return self.fetchedResultsController.fetchedObjects.count;
}

- (SelfieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SelfieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selfieCell"];
//  NSLog(@"selfie inside cell = %@",[self.fetchedResultsController objectAtIndexPath:indexPath]);
  NSLog(@"selfie = %@",[self.fetchedResultsController objectAtIndexPath:indexPath]);
  [cell initializeWithSelfie:[self.fetchedResultsController objectAtIndexPath:indexPath]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedSelfie = [self.fetchedResultsController objectAtIndexPath:indexPath];
  NSLog(@"selected selfie = %@",self.selectedSelfie);
  [self performSegueWithIdentifier:@"showDetails" sender:nil];
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
      if ([[SelfieDataManager sharedManager].paginator isLoaded] && [[SelfieDataManager sharedManager].paginator hasNextPage]) {
        [[SelfieDataManager sharedManager].paginator loadNextPage];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  SelfieDetailViewController *vc = segue.destinationViewController;
  vc.selfie = self.selectedSelfie;
  self.selectedSelfie = nil;
}

- (IBAction)createNew:(id)sender {
  [self performSegueWithIdentifier:@"showDetails" sender:nil];
}

@end
