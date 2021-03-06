//
//  IFACoreUI.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 23/08/14.
//  Copyright (c) 2014 InfoAccent Pty Limited. All rights reserved.
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

#import <CoreData/CoreData.h>
#import <CoreText/CoreText.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <GLKit/GLKit.h>
#import <AdSupport/AdSupport.h>
#import <Accelerate/Accelerate.h>
@import UIKit;

//! Project version number for IFACoreUI.
FOUNDATION_EXPORT double IFACoreUIVersionNumber;

//! Project version string for IFACoreUI.
FOUNDATION_EXPORT const unsigned char IFACoreUIVersionString[];

/*************/
/* 3rd party */
/*************/
// KNSemiModal
#import "UIViewController+IFA_KNSemiModal.h"
// ODRefreshControl
#import "IFA_ODRefreshControl.h"
// GrowingTextView
#import "IFA_HPGrowingTextView.h"
#import "IFA_HPTextViewInternal.h"

@import IFAFoundation;

#import "IFADefaultAppearanceTheme.h"
#import "IFAAbstractFieldEditorViewController.h"
#import "IFAAbstractSelectionListViewController.h"
#import "IFAAppearanceTheme.h"
#import "IFAAppearanceThemeManager.h"
#import "IFAAsynchronousWorkManager.h"
#import "IFACircleView.h"
#import "IFACollectionViewCell.h"
#import "IFACollectionViewController.h"
#import "IFACollectionViewFetchedResultsControllerDelegate.h"
#import "IFACollectionViewFlowLayout.h"
#import "IFAColorScheme.h"
#import "IFACoreUiConstants.h"
#import "IFACurrentLocationManager.h"
#import "IFACustomLayoutSupport.h"
#import "IFADatePickerViewController.h"
#import "IFADirectionsManager.h"
#import "IFAEntityConfig.h"
#import "IFAEnumerationEntity.h"
#import "IFAFetchedResultsTableViewController.h"
#import "IFAFormNumberFieldTableViewCell.h"
#import "IFAFormTableViewCell.h"
#import "IFAFormTableViewCellContentView.h"
#import "IFAFormTextFieldTableViewCell.h"
#import "IFAFormViewController.h"
#import "IFAListViewController.h"
#import "IFALongTextEditorViewController.h"
#import "IFAMapAnnotation.h"
#import "IFAMenuViewController.h"
#import "IFAModalViewController.h"
#import "IFAMultipleSelectionListViewController.h"
#import "IFANavigationController.h"
#import "IFANavigationItemTitleView.h"
#import "IFANavigationListViewController.h"
#import "IFAPageViewController.h"
#import "IFAPagingStateManager.h"
#import "IFAPassthroughView.h"
#import "IFAPersistenceManager.h"
#import "IFAPickerViewController.h"
#import "IFAPinAnnotationView.h"
#import "IFAPreferencesManager.h"
#import "IFAPresenter.h"
#import "IFASegmentedControl.h"
#import "IFASegmentedControlTableViewCell.h"
#import "IFASelectionManager.h"
#import "IFASemaphoreManager.h"
#import "IFASingleSelectionListViewController.h"
#import "IFASingleSelectionManager.h"
#import "IFASlidingFrostedGlassViewController.h"
#import "IFASubjectActivityItem.h"
#import "IFASwitchTableViewCell.h"
#import "IFASystemEntity.h"
#import "IFATabBarController.h"
#import "IFATableCellSelectedBackgroundView.h"
#import "IFATableSectionHeaderView.h"
#import "IFATableViewCell.h"
#import "IFATableViewController.h"
#import "IFATextViewContainer.h"
#import "IFATextViewController.h"
#import "IFAUIUtils.h"
#import "IFAView.h"
#import "IFAViewController.h"
#import "IFAWorkInProgressModalViewManager.h"
#import "NSIndexPath+IFACoreUI.h"
#import "NSManagedObject+IFACoreUI.h"
#import "NSManagedObjectContext+IFACoreUI.h"
#import "UIBarButtonItem+IFACoreUI.h"
#import "UIButton+IFACoreUI.h"
#import "UICollectionView+IFACoreUI.h"
#import "UIColor+IFACoreUI.h"
#import "UIImage+IFACoreUI.h"
//#import "UIPopoverController+IFACoreUI.h"
#import "UIScrollView+IFACoreUI.h"
#import "UIStoryboard+IFACoreUI.h"
#import "UITableView+IFACoreUI.h"
#import "UITableViewCell+IFACoreUI.h"
#import "UITableViewController+IFACoreUI_DynamicCellHeight.h"
#import "UIView+IFACoreUI.h"
#import "UIViewController+IFACoreUI.h"
#import "UIWebView+IFACoreUI.h"
#import "IFAGridViewController.h"
#import "IFAFormInputAccessoryView.h"
#import "IFAMultipleSelectionListViewCell.h"
#import "IFAContextSwitchTarget.h"
#import "IFAContextSwitchingManager.h"
#import "IFAMapViewController.h"
#import "IFAMapSettingsViewController.h"
#import "IFALocationManager.h"
#import "IFAViewControllerTransitioningDelegate.h"
#import "IFAViewControllerAnimatedTransitioning.h"
#import "IFAFadingOverlayPresentationController.h"
#import "IFABlurredFadingOverlayPresentationController.h"
#import "IFAViewControllerFadeTransitioning.h"
#import "IFABlurredFadingOverlayViewControllerTransitioningDelegate.h"
#import "IFAFormSectionHeaderFooterView.h"
#import "IFATableViewHeaderFooterView.h"
#import "IFASingleSelectionListViewControllerHeaderView.h"
#import "IFAHudViewController.h"
#import "IFAHudView.h"
#import "IFADimmedFadingOverlayPresentationController.h"
#import "IFADimmedFadingOverlayViewControllerTransitioningDelegate.h"
#import "IFAFadingOverlayViewControllerTransitioningDelegate.h"
#import "NSObject+IFACoreUI.h"
#import "IFAOperation.h"
#import "NSAttributedString+IFACoreUI.h"
#import "IFALazyTableDataLoadingViewController.h"
#import "IFAPersistenceChangeDetector.h"
#import "IFAHtmlDocument.h"
#import "IFAUIGlobal.h"
#import "IFAUIConfiguration.h"
#import "IFAKeyboardVisibilityManager.h"
#import "IFAPagingContainer.h"
#import "IFAPersistentEntityChangeObserver.h"
#import "UIColor+IFACoreUI_WatchKit.h"
#import "UIAlertController+IFACoreUI.h"
#import "IFACrashReportingUtils.h"
#import "IFAAnalyticsManager.h"
#import "IFAHelpManager.h"
#import "UIButton+IFACoreUI_Help.h"
#import "UIViewController+IFACoreUI_Help.h"
#import "IFAHelpContentViewController.h"
#import "IFAHelpViewController.h"
#import "IFAHelpTarget.h"
#import "IFAHudWrapperViewController.h"
#import "NSMutableArray+IFACoreUI.h"
#import "IFAAlertContainerViewController.h"
