//
//  IFANavigationListViewController.m
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 28/07/10.
//  Copyright 2010 InfoAccent Pty Limited. All rights reserved.
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

#import "IFACoreUI.h"

@interface IFANavigationListViewController ()
@property (nonatomic) UIBarButtonItem *deleteBarButtonItem;
@property (nonatomic) UIBarButtonItem *duplicateBarButtonItem;
@end

@implementation IFANavigationListViewController {
    
}

#pragma mark Public

- (UIBarButtonItem *)deleteBarButtonItem {
    if (!_deleteBarButtonItem) {
        _deleteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Delete", @"IFALocalizable", nil) style:UIBarButtonItemStylePlain target:self action:@selector(IFA_onDeleteButtonTap)];
    }
    return _deleteBarButtonItem;
}

- (UIBarButtonItem *)duplicateBarButtonItem {
    if (!_duplicateBarButtonItem) {
        _duplicateBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Duplicate", @"IFALocalizable", nil) style:UIBarButtonItemStylePlain target:self action:@selector(IFA_onDuplicateButtonTap)];
    }
    return _duplicateBarButtonItem;
}

#pragma mark - Private

-(void)IFA_updateLeftBarButtonItemsStates {
    if (!self.pagingContainer || self.selectedViewControllerInPagingContainer) {
        [self ifa_addLeftBarButtonItem:self.addBarButtonItem];
    }
}

-(UITableViewCellAccessoryType)IFA_tableViewCellAccessoryType {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)iFA_handleSelectionForEditingAtIndexPath:(NSIndexPath *)a_indexPath {
    [self showEditFormForManagedObject:(NSManagedObject *) [self objectForIndexPath:a_indexPath]];
}

- (void)IFA_updateEditingToolbarStateForTableView:(UITableView *)tableView {
    if (!(_deleteBarButtonItem || _duplicateBarButtonItem)) {
        return;
    }
    if (tableView.indexPathsForSelectedRows.count > 0) {
        self.deleteBarButtonItem.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Delete (%@)", @"IFALocalizable", @"Delete (SELECTED_ITEMS_COUNT)"), @(tableView.indexPathsForSelectedRows.count)];
        self.deleteBarButtonItem.enabled = YES;
    } else {
        self.deleteBarButtonItem.title = NSLocalizedStringFromTable(@"Delete", @"IFALocalizable", nil);
        self.deleteBarButtonItem.enabled = NO;
    }
    self.duplicateBarButtonItem.enabled = tableView.indexPathsForSelectedRows.count == 1;
}

- (void)IFA_onDuplicateButtonTap {
    IFAPersistenceManager *persistenceManager = [IFAPersistenceManager sharedInstance];
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    NSManagedObject *managedObjectOriginal = (NSManagedObject *) [self objectForIndexPath:selectedIndexPath];
    NSManagedObject *managedObjectDuplicate = [NSClassFromString(self.entityName) ifa_instantiate];
    NSMutableSet <NSString *> *ignoredKeys = [NSMutableSet new];
    if ([persistenceManager.entityConfig listReorderAllowedForObject:managedObjectDuplicate] && [managedObjectDuplicate respondsToSelector:NSSelectorFromString(@"seq")]) {
        [ignoredKeys addObject:@"seq"];
    }
    [managedObjectOriginal duplicateToTarget:managedObjectDuplicate ignoringKeys:ignoredKeys];
    if ([managedObjectDuplicate conformsToProtocol:@protocol(IFADuplication)]) {
        id<IFADuplication> duplicate = (id <IFADuplication>) managedObjectDuplicate;
        duplicate.uniqueNameForDuplication = [IFADuplicationUtils nameForDuplicateOf:duplicate inItems:self.objects];
    }
    [persistenceManager saveObject:managedObjectDuplicate validationAlertPresenter:nil];
    if (!self.fetchedResultsController && self.fetchingStrategy == IFAListViewControllerFetchingStrategyFindEntities) {
        [self refreshDataWithFindEntitiesSynchronously];
        [self refreshSectionsWithRows];
        NSUInteger managedObjectDuplicateIndex = [self.entities indexOfObject:managedObjectDuplicate];
        NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForItem:managedObjectDuplicateIndex inSection:0];
        NSArray *indexPathsToInsert = @[indexPathToInsert];
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        NSUInteger managedObjectOriginalIndex = [self.entities indexOfObject:managedObjectOriginal];
        NSIndexPath *indexPathToDeselect = [NSIndexPath indexPathForItem:managedObjectOriginalIndex inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPathToDeselect animated:YES];
    }
    self.editing = NO;
}

- (void)IFA_onDeleteButtonTap {
    NSUInteger selectedItemsCount = self.tableView.indexPathsForSelectedRows.count;
    NSAssert(selectedItemsCount > 0, nil);
    void (^destructiveActionBlock)() = ^{
        self.shouldIgnoreStaleDataChanges = YES;
        __block BOOL success = NO;
        NSArray<NSIndexPath *> *selectedIndexPaths = self.tableView.indexPathsForSelectedRows;
        NSMutableArray <NSManagedObject *> *deletedManagedObjects = [NSMutableArray new];
        [selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            NSManagedObject *managedObject = (NSManagedObject *) [self objectForIndexPath:indexPath];
            [deletedManagedObjects addObject:managedObject];
            success = [[IFAPersistenceManager sharedInstance] deleteObject:managedObject validationAlertPresenter:nil];
            if (!success) {
                *stop = YES;
            }
        }];
        if (success) {
            success = [[IFAPersistenceManager sharedInstance] save];
            if (success) {
                [self IFA_updateUiAfterDeletionAtIndexPaths:selectedIndexPaths deletedManagedObjects:deletedManagedObjects];
                [IFAUIUtils showAndHideUserActionConfirmationHudWithText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ item(s) deleted", @"IFALocalizable", @"<SELECTED_ITEMS_COUNT> item(s) deleted"),
                                                                                                    @(selectedItemsCount)]];
                self.editing = NO;
            }
        } else {
            [[IFAPersistenceManager sharedInstance] rollback];
        }
        self.shouldIgnoreStaleDataChanges = NO;
        NSAssert(success == YES, nil);  // Deletion should never fail
    };
    NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Are you sure you want to delete the %@ selected item(s)?", @"IFALocalizable", @"Are you sure you want to delete the <SELECTED_ITEMS_COUNT> selected item(s)?"), @(selectedItemsCount)];
    NSString *destructiveActionButtonTitle = NSLocalizedStringFromTable(@"Delete", @"IFALocalizable", nil);
    [self ifa_presentAlertControllerWithTitle:nil
                                      message:message
                 destructiveActionButtonTitle:destructiveActionButtonTitle
                       destructiveActionBlock:destructiveActionBlock
                                  cancelBlock:nil];
}

- (void)IFA_updateUiAfterDeletionAtIndexPaths:(NSArray <NSIndexPath *> *)indexPaths deletedManagedObjects:(NSArray <NSManagedObject *> *)deletedManagedObjects {

    if (!self.fetchedResultsController) {

        // Update the main entities array
        [self.entities removeObjectsInArray:deletedManagedObjects];

        // Update the "sections with rows" array
        NSMutableIndexSet *sectionsToDeleteIndexSet = [NSMutableIndexSet new];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            NSMutableArray *sectionRows = (self.sectionsWithRows)[(NSUInteger) indexPath.section];
            if (self.listGroupedBy) {
                [sectionRows removeObjectAtIndex:(NSUInteger) indexPath.row];
                if ([sectionRows count] == 0) {
                    [self.sectionsWithRows removeObjectAtIndex:(NSUInteger) indexPath.section];
                    [sectionsToDeleteIndexSet addIndex:indexPath.section];
                }
            }
        }];

        // Update the table view
        [self.tableView beginUpdates];
        [self.tableView ifa_deleteRowsAtIndexPaths:indexPaths];
        [self.tableView deleteSections:sectionsToDeleteIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];

    }

    if (self.objects.count == 0) {
        self.staleData = YES;
        if (self.editing) {
            [self setEditing:NO animated:YES];
        }
    } else {
        [self showEmptyListPlaceholder];
    }

    [self IFA_updateEditingToolbarStateForTableView:self.tableView];

}

#pragma mark - UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        [self IFA_updateEditingToolbarStateForTableView:tableView];
        return;
    }
    if (![[[IFAPersistenceManager sharedInstance] entityConfig] disallowDetailDisclosureForEntity:self.entityName]) {
        [self iFA_handleSelectionForEditingAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        [self IFA_updateEditingToolbarStateForTableView:tableView];
        return;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self iFA_handleSelectionForEditingAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section]) {
        return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize * 1.5;
    }else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource Protocol

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSManagedObject	*mo = (NSManagedObject*) [self objectForIndexPath:indexPath];
        void (^completionHandler)(BOOL) = ^(BOOL success) {
            self.shouldIgnoreStaleDataChanges = NO;
            if (success) {
                [self IFA_updateUiAfterDeletionAtIndexPaths:@[indexPath] deletedManagedObjects:@[mo]];

            }
        };
        self.shouldIgnoreStaleDataChanges = YES;
        [IFAUIUtils handleDeletionRequestForManagedObject:mo
                        withAlertPresentingViewController:self
                             shouldAskForUserConfirmation:NO
              shouldShowSuccessfulDeletionHudConfirmation:NO
                                        willDeleteHandler:nil
                                        completionHandler:completionHandler];

    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[IFAPersistenceManager sharedInstance].entityConfig listReorderAllowedForEntity:self.entityName];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    
    if (![fromIndexPath isEqual:toIndexPath]) {
        
        //    NSLog(@"moveRowAtIndexPath: %u", fromIndexPath.row);
        //    NSLog(@"toIndexPath: %u", toIndexPath.row);
        NSManagedObject *fromManagedObject = (NSManagedObject *) [self objectForIndexPath:fromIndexPath];
        NSManagedObject *toManagedObject = (NSManagedObject *) [self objectForIndexPath:toIndexPath];
        //    NSLog(@"fromManagedObject: %u", [[fromManagedObject valueForKey:@"seq"] unsignedIntValue]);
        //    NSLog(@"toManagedObject: %u", [[toManagedObject valueForKey:@"seq"] unsignedIntValue]);
        
        // Determine new sequence
        uint seq = [[toManagedObject valueForKey:@"seq"] unsignedIntValue];
        if (fromIndexPath.row<toIndexPath.row) {
            seq++;
        }else{
            seq--;
        }
        //    NSLog(@"new fromManagedObject seq: %u", seq);
        [fromManagedObject setValue:@(seq) forKey:@"seq"];
        
        // Save changes
        self.shouldIgnoreStaleDataChanges = YES;
        [[IFAPersistenceManager sharedInstance] save];
        self.shouldIgnoreStaleDataChanges = NO;

        if (!self.fetchedResultsController) {

            // Re-order backing entity array
            //    NSLog(@"entities BEFORE sorting: %@", [self.entities description]);
            NSSortDescriptor *l_sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seq" ascending:YES];
            [self.entities sortUsingDescriptors:@[l_sortDescriptor]];
            //    NSLog(@"entities AFTER sorting: %@", [self.entities description]);

        }

    }

//    if (!self.fetchedResultsController) {
//        [self reloadInvolvedSectionsAfterImplicitAnimationForRowMovedFromIndexPath:fromIndexPath
//                                                                       toIndexPath:toIndexPath];
//    }

}

#pragma mark - Overrides

-(UITableViewCell *)createReusableCellWithIdentifier:(NSString *)a_reuseIdentifier atIndexPath:(NSIndexPath *)a_indexPath{
	UITableViewCell *l_cell = [super createReusableCellWithIdentifier:a_reuseIdentifier atIndexPath:a_indexPath];
    if ([[[IFAPersistenceManager sharedInstance] entityConfig] disallowDetailDisclosureForEntity:self.entityName]) {
        l_cell.accessoryType = UITableViewCellAccessoryNone;
        l_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        l_cell.accessoryType = [self IFA_tableViewCellAccessoryType];
    }
	l_cell.showsReorderControl = YES;
    [[self ifa_appearanceTheme] setAppearanceForView:l_cell.textLabel];
	return l_cell;
}

- (void)viewDidLoad {

    [super viewDidLoad];
	
    if (![[[IFAPersistenceManager sharedInstance] entityConfig] disallowUserAdditionForEntity:self.entityName]) {
        self.addBarButtonItem = [IFAUIUtils barButtonItemForType:IFABarButtonItemTypeAdd target:self
                                                          action:@selector(onAddButtonTap:)];
    }

    self.editButtonItem.tag = IFABarItemTagEditButton;
    [self ifa_addRightBarButtonItem:self.editButtonItem];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self IFA_updateLeftBarButtonItemsStates];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self showEmptyListPlaceholder];
//    UIButton *l_helpButton = (UIButton*)[self.navigationController.view viewWithTag:IFAViewTagHelpButton];
//    l_helpButton.enabled = !editing;
    [self IFA_updateEditingToolbarStateForTableView:self.tableView];
}

-(void)didRefreshAndReloadData {
    [super didRefreshAndReloadData];
    if (![self ifa_isReturningVisibleViewController] && self.editing) { // If it was left editing previously, reset it to non-editing mode.
        [self quitEditing];
    }else{
        [self showEmptyListPlaceholder];
    }
}

-(void)ifa_reset {
    [super ifa_reset];
    // If it was left editing previously, reset it to non-editing mode.
    if (![self ifa_isReturningVisibleViewController] && self.editing && !self.staleData) {  // If it's stale data, then quitEditing will be performed by the didRefreshAndReloadData method
        [self quitEditing];
    }
}

@end
