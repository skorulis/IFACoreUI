//
// Created by Marcelo Schroeder on 20/08/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Crash reporting related utilities.
*/
@interface IFACrashReportingUtils : NSObject

/**
* Formats context information to be included in crash reports. It attempts to convert non string types to strings.
* @param contextInfo Dictionary containing unformatted context info.
* @param shouldAddUserDefaults Set to YES to include the standard user defaults contents.
* @returns Formatted context information.
*/
+ (NSDictionary *)formatContextInfo:(NSDictionary *)contextInfo
              shouldAddUserDefaults:(BOOL)shouldAddUserDefaults;
@end