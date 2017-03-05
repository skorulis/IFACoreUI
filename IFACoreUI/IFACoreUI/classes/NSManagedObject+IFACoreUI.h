//
//  NSManagedObject+IFACategory.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 30/07/10.
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

@interface NSManagedObject (IFACoreUI)

@property (nonatomic, readonly) NSString *ifa_stringId;
@property (nonatomic, readonly) NSURL *ifa_urlId;

- (NSString*)ifa_labelForKeys:(NSArray*)aKeyArray;
- (BOOL)ifa_validateForSave:(NSError**)anError;
- (void)ifa_willDelete;
- (void)ifa_didDelete;
- (BOOL)ifa_deleteWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter;
- (BOOL)ifa_deleteAndSaveWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter;
- (BOOL)ifa_hasValueChangedForKey:(NSString*)a_key;

/**
 * Duplicate a managed object into a given target.
 * This method copies all properties. It also copies relatioships with the exception of 1-to-1 relationships.
 * For many-to-many relationships, it also duplicates the children to a maximum of one hierarchical level.
 * @param target Managed object instance to duplicate into.
 */
- (void)duplicateToTarget:(NSManagedObject *)target;

+ (instancetype)ifa_instantiate;
+ (NSMutableArray *)ifa_findAll;
+ (NSMutableArray *)ifa_findAllIncludingPendingChanges:(BOOL)a_includePendingChanges;
+ (void)ifa_deleteAllWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter;
+ (void)ifa_deleteAllAndSaveWithValidationAlertPresenter:(UIViewController *)a_validationAlertPresenter;

@end
