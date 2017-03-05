//
//  IFAListViewController.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 22/07/10.
//  Copyright 2009 InfoAccent Pty Limited. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IFAFetchedResultsTableViewController.h"
#import "IFASelectionManager.h"
#import "UIViewController+IFACoreUI.h"
#import "IFAHelpTarget.h"

@class NSManagedObjectID;
@class IFAFormViewController;
@class NSManagedObject;
@protocol IFAListViewControllerDataSource;

/**
* Determines the persistent object fetching strategy.
* IFAListViewControllerFetchingStrategyFetchedResultsController: Uses an NSFetchedResultsController to fetch data. Consult the IFAFetchedResultsTableViewController API documentation for further details.
* IFAListViewControllerFetchingStrategyFindEntities: Calls the "findEntities" method to fetch data.
*/
typedef NS_ENUM(NSUInteger, IFAListViewControllerFetchingStrategy){
    IFAListViewControllerFetchingStrategyFetchedResultsController,
    IFAListViewControllerFetchingStrategyFindEntities,
};

@interface IFAListViewController : IFAFetchedResultsTableViewController <IFAFetchedResultsTableViewControllerDataSource, IFAViewControllerDelegate, IFASelectionManagerDataSource, IFAHelpTarget>

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSDate *lastRefreshAndReloadDate;
@property (nonatomic, readonly) BOOL refreshAndReloadDataRequested;
@property (nonatomic, strong) UIBarButtonItem *addBarButtonItem;
@property (nonatomic, strong) NSManagedObjectID *editedManagedObjectId;
@property(nonatomic, strong, readonly) UILabel *noDataPlaceholderAddHintPrefixLabel;
@property(nonatomic, strong, readonly) UIImageView *noDataPlaceholderAddHintImageView;
@property(nonatomic, strong, readonly) UILabel *noDataPlaceholderAddHintSuffixLabel;
@property(nonatomic, strong, readonly) UILabel *noDataPlaceholderDescriptionLabel;
@property (nonatomic, weak) id<IFAListViewControllerDataSource> listViewControllerDataSource;

/**
* Set this property to YES to force the view controller to refresh and reload data next time the view appears.
*/
@property (nonatomic) BOOL shouldRefreshAndReloadDataNextTimeViewAppears;

/**
* Specifies the property name that corresponds to a persistent entity to group by, which will also determine the table view section arrangement.
* This value is obtained directly from the "listGroupedBy" entity config property for the entity specified by the "entityName" property.
* If the property is not nil then the fetching strategy is automatically set to IFAListViewControllerFetchingStrategyFindEntities.
*/
@property (nonatomic, strong, readonly) NSString *listGroupedBy;

/**
* Determines whether this view controller will observe persistence changes and refresh data automatically when the view is re-displayed (i.e. after being fully hidden).
* When set to YES, the "staleData" property will be automatically set to YES when the persistence changes are detected.
* This provides functionality above and beyond to what NSFetchedResultsController offers as it can detect any changes in the Core Data model including related entities.
* Default = NO.
*/
@property (nonatomic) BOOL shouldObservePersistenceChanges;

/**
* Called by IFAAbstractPagingContainerViewController to request a data refresh and reload to a child view controller
*/
@property (nonatomic, strong, readonly) dispatch_block_t pagingContainerChildRefreshAndReloadDataAsynchronousBlock;

/**
* Used to indicate whether the data is stale and it needs to be re-fetched next time the view is displayed (i.e. after being fully hidden).
* Automatically set to YES when shouldObservePersistenceChanges is set to YES and Core Data model changes are detected.
*/
@property BOOL staleData;

/**
* Set this property to YES to cause changes to the <staleData> property to be ignored for the purpose of automatically refreshing and reloading table data.

* This is useful in cases where Core Data object changes made by a given instance of this class will cause the <staleData> property to be set to YES but a data refresh and reload is not desirable.
*/
@property(nonatomic) BOOL shouldIgnoreStaleDataChanges;

/**
* Used to determine the persistent object fetching strategy.
* The default is IFAListViewControllerFetchingStrategyFetchedResultsController unless the "listGroupedBy" entity config property for the entity specified by the "entityName" property is not nil. In that case, the strategy will be set to IFAListViewControllerFetchingStrategyFindEntities automatically.
*/
@property (nonatomic) IFAListViewControllerFetchingStrategy fetchingStrategy;

/* "findEntities" fetching strategy specific properties */
@property (nonatomic, strong) NSMutableArray *entities;
@property (nonatomic, strong) NSMutableArray *sectionHeaderTitles;
@property (nonatomic, strong) NSMutableArray *sectionsWithRows;

/**
* Determines whether the data fetch will be asynchronous.
* Asynchronous fetches should only be used when fetchingStrategy is set to IFAListViewControllerFetchingStrategyFindEntities.
* Default = NO.
*/
@property (nonatomic) BOOL asynchronousFetch;

/**
* Designated initializer.
* @param anEntityName Determines the persistent entity to be used to populate the list view.
*/
- (id)initWithEntityName:(NSString *)anEntityName;

/* "fetchedResultsController" fetching strategy specific methods */
-(void)refreshSectionsWithRows;

/**
* This method is called to fetch data when the fetchingStrategy is set to IFAListViewControllerFetchingStrategyFindEntities.
* The default implementation of this method is to find all objects specified by the "entityName" property.
*/
- (NSArray*)findEntities;

- (NSObject *)objectForIndexPath:(NSIndexPath*)a_indexPath;
- (NSIndexPath*)indexPathForObject:(NSObject *)a_object;
- (NSArray *)objects;

/**
* Trigger a data refresh followed by a reload of the view.
*/
- (void)refreshAndReloadData;

/**
* Called before a data refresh and reload is performed.
*/
- (void)willRefreshAndReloadData;

/**
* Called after a data refresh and reload has been performed.
*/
- (void)didRefreshAndReloadData;

- (UITableViewStyle)tableViewStyle;
- (UITableViewCell*)cellForTableView:(UITableView*)a_tableView;

- (BOOL)shouldShowEmptyListPlaceholder;

- (void)showEmptyListPlaceholder;

/**
 * Sets the entities properties with the latest state from the database, synchronously.
 * This method is to be used when a data refresh is required outside the control of the framework and it only makes sense when the fetchingStrategy property is set to IFAListViewControllerFetchingStrategyFindEntities.
 */
- (void)refreshDataWithFindEntitiesSynchronously;

- (IFAFormViewController *)formViewControllerForManagedObject:(NSManagedObject *)aManagedObject createMode:(BOOL)aCreateMode;
- (NSManagedObject*)newManagedobject;

/**
 * Called to show the edit form for a managed object (existing or new object).
 * Override to change behaviour.
 * @param aManagedObject Managed object to show the edit form for. This parameter is nil for a new managed object (i.e. when the "+" button is tapped).
 */
- (void)showEditFormForManagedObject:(NSManagedObject *)aManagedObject;

/**
 * Called to show the form for the creation of a new managed object (i.e. when the "+" button is tapped).
 * Override to change behaviour.
 */
- (void)showCreateManagedObjectForm;

- (void)onAddButtonTap:(id)sender;
- (NSString*)editFormNameForCreateMode:(BOOL)aCreateMode;

@end

@protocol IFAListViewControllerDataSource <NSObject>

@optional

/**
* Called when the list view controller needs to know whether the "add hint" should be shown or not when the list is empty.
* Example of "add hint": "Tap + to add a report".
* If this method is not implemented, then the "add hint" will be shown.
* @param a_listViewController The sender.
* @return YES to show the "add hint", NO to hide the "add hint".
*/
- (BOOL)shouldShowNoDataPlaceholderAddHintViewForListViewController:(IFAListViewController *)a_listViewController;

/**
* Implement this method to override the placeholder text shown for empty lists.
* If this method is not implemented, the text used as a placeholder is the string returned by the IFAHelpManager emptyListHelpForEntityName: method.
* @param a_listViewController The sender.
* @return The text to be used as a placeholder for empty lists.
*/
- (NSString *)noDataPlaceholderDescriptionForListViewController:(IFAListViewController *)a_listViewController;

/**
* Implement this method to indicate whether the view controller should refresh and reload backing data when any external changes to the main parent managed object context are detected.
*
* The <staleData> property will be set to NO after handling a change to YES when this method is implemented and the view controller is visible. This behaviour allows the next change to be detected correctly (not applicable when the view controller's pagingContainer property is not nil).
* @param a_listViewController The sender.
* @returns YES if the view controller should refresh and reload backing data when any external changes to the main parent managed object context are detected, otherwise NO.
*/
- (BOOL)shouldRefreshAndReloadDataWhenDataBecomesStaleAndViewIsVisibleForListViewController:(IFAListViewController *)a_listViewController;

@end