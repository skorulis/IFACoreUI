//
// Created by Marcelo Schroeder on 26/07/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertController (IFACoreApp)

/**
* Presents the alert controller in a standalone manner.
* A temporary top level window and view controller are specifically created for this purpose and disposed of when the alert is dismissed by the user.
* @param animated Pass YES to animate the presentation; otherwise, pass NO.
* @param completion A completion block to be executed after the view transition has been completed.
*/
- (void)ifa_presentAnimated:(BOOL)animated
             withCompletion:(void (^)(void))completion;

@end
