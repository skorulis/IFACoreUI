//
//  TestCoreDataEntity4+CoreDataProperties.h
//  IFACoreUI
//
//  Created by Marcelo Schroeder on 4/3/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

#import "TestCoreDataEntity4+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TestCoreDataEntity4 (CoreDataProperties)

+ (NSFetchRequest<TestCoreDataEntity4 *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *attribute1;
@property (nullable, nonatomic, copy) NSNumber *attribute2;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) TestCoreDataEntity5 *entity5ToOne;
@property (nullable, nonatomic, retain) NSSet<TestCoreDataEntity5 *> *entity5ToMany;

@end

@interface TestCoreDataEntity4 (CoreDataGeneratedAccessors)

- (void)addEntity5ToManyObject:(TestCoreDataEntity5 *)value;
- (void)removeEntity5ToManyObject:(TestCoreDataEntity5 *)value;
- (void)addEntity5ToMany:(NSSet<TestCoreDataEntity5 *> *)values;
- (void)removeEntity5ToMany:(NSSet<TestCoreDataEntity5 *> *)values;

@end

NS_ASSUME_NONNULL_END
