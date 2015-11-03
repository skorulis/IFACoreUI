//
// Created by Marcelo Schroeder on 10/06/2014.
// Copyright (c) 2014 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by Marcelo Schroeder on 14/08/09.
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

#import "IFAFoundation.h"


@implementation IFADispatchQueueManager {

}

#pragma mark - Public

- (void)dispatchAsyncMainThreadBlock:(dispatch_block_t)a_block{
    dispatch_async(dispatch_get_main_queue(), a_block);
}

- (void)dispatchAsyncMainThreadBlock:(dispatch_block_t)a_block afterDelay:(NSTimeInterval)a_delay{
    dispatch_after([self.class dispatchTimeForDelay:a_delay], dispatch_get_main_queue(), a_block);
}

- (void)dispatchSyncMainThreadBlock:(dispatch_block_t)a_block{
    dispatch_sync(dispatch_get_main_queue(), a_block);
}

- (void)dispatchAsyncGlobalHighPriorityQueueBlock:(dispatch_block_t)a_block{
    [self dispatchAsyncGlobalQueueBlock:a_block priority:DISPATCH_QUEUE_PRIORITY_HIGH];
}

- (void)dispatchAsyncGlobalDefaultPriorityQueueBlock:(dispatch_block_t)a_block{
    [self dispatchAsyncGlobalQueueBlock:a_block priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (void)dispatchAsyncGlobalQueueBlock:(dispatch_block_t)a_block priority:(dispatch_queue_priority_t)a_priority{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(a_priority, 0);
    NSAssert(dispatchQueue != nil, @"Dispatch queue is nil");
    dispatch_async(dispatchQueue, a_block);
}

+ (dispatch_queue_t)createSerialDispatchQueueWithLabel:(NSString *)label
                                 qualityOfServiceClass:(dispatch_qos_class_t)qualityOfServiceClass {
    dispatch_queue_attr_t queueAttributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qualityOfServiceClass, 0);
    return dispatch_queue_create(label.UTF8String, queueAttributes);
}

// Inspired by http://www.takingnotes.co/blog/2013/01/03/coalescing/
- (void)coalescedPerformSelector:(SEL)sel
                        onTarget:(id)target {

    // Cancel any previous perform requests to keep calls from piling up.
    [NSObject cancelPreviousPerformRequestsWithTarget:target selector:sel object:nil];

    // Schedule the call, it will hit during the next turn of the current run loop
    [target performSelector:sel withObject:nil afterDelay:0.0];

}

+ (dispatch_time_t)dispatchTimeForDelay:(NSTimeInterval)a_delay {
    int64_t l_delta = (int64_t)(1.0e9 * a_delay);
    dispatch_time_t l_dispatchTimeDelay = dispatch_time(DISPATCH_TIME_NOW, l_delta);
    return l_dispatchTimeDelay;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static IFADispatchQueueManager *c_instance;
    void (^instanceBlock)(void) = ^(void) {
        c_instance = [self new];
    };
    dispatch_once(&c_dispatchOncePredicate, instanceBlock);
    return c_instance;
}

@end