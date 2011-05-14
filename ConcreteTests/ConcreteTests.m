/* Concrete - Adding Blocks to Foundation
 * 
 * Copyright 2011 Tim Horton. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY TIM HORTON "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL TIM HORTON OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ConcreteTests.h"
#import "NSArray+Concrete.h"

@implementation ConcreteTests

- (void)testNSArrayCategory
{
    NSArray * testArray = [NSArray arrayWithObjects:@"one", @"two", @"three", @"four", nil];
    NSArray * testNumArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                                       [NSNumber numberWithInt:2],
                                                       [NSNumber numberWithInt:3],
                                                       [NSNumber numberWithInt:4],
                                                       [NSNumber numberWithInt:5], nil];
    
    STAssertEquals([testNumArray all:^(id a){return (BOOL)([a intValue] < 10);}], YES, nil);
    STAssertEquals([testNumArray all:^(id a){return (BOOL)([a intValue] > 3);}], NO, nil);
    
    STAssertEquals([testNumArray any:^(id a){return (BOOL)([a intValue] > 10);}], NO, nil);
    STAssertEquals([testNumArray any:^(id a){return (BOOL)([a intValue] > 3);}], YES, nil);
    
    NSArray * expectedMapArray = [NSArray arrayWithObjects:@"one more", @"two more", @"three more", @"four more", nil];
    NSArray * mapArray = [testArray map:^(id a)
                          {
                              return [a stringByAppendingString:@" more"];
                          }];
    STAssertEqualObjects(expectedMapArray, mapArray, nil);
    
    NSArray * expectedNullMapArray = [NSArray arrayWithObjects:[NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
    NSArray * nullMapArray = [testArray map:^(id a)
                              {
                                  return (id)nil;
                              }];
    STAssertEqualObjects(expectedNullMapArray, nullMapArray, nil);
    
    NSArray * expectedMapIndexedArray = [NSArray arrayWithObjects:@"one0", @"two1", @"three2", @"four3", nil];
    NSArray * mapIndexedArray = [testArray mapIndexed:^(NSUInteger index, id a)
                          {
                              return [a stringByAppendingFormat:@"%d",index];
                          }];
    STAssertEqualObjects(expectedMapIndexedArray, mapIndexedArray, nil);
    
    NSArray * expectedFilterArray = [NSArray arrayWithObjects:@"two", @"three", nil];
    NSArray * filterArray = [testArray filter:^(id a)
                             {
                                 return [a hasPrefix:@"t"];
                             }];
    STAssertEqualObjects(expectedFilterArray, filterArray, nil);
    
    NSNumber * selectOneResult = [testNumArray selectOne:^(id a)
                                  {
                                      return (BOOL)(([a intValue] % 2) == 1); // Why do we have to cast to bool?
                                  }];
    STAssertTrue([selectOneResult intValue] % 2 == 1, nil);
    
    NSNumber * expectedReduceResult = [NSNumber numberWithInt:15];
    NSNumber * reduceResult = [testNumArray reduce:^(id a, id b)
                               {
                                   return [NSNumber numberWithInt:([a intValue] + [b intValue])];
                               }];
    STAssertEqualObjects(expectedReduceResult, reduceResult, nil);
    
    NSArray * expectedZipWithArray = [NSArray arrayWithObjects:@"one=1", @"two=2", @"three=3", @"four=4", nil];
    NSArray * zipWithArray = [testArray zip:testNumArray with:^(id a, id b)
                              {
                                  return [a stringByAppendingFormat:@"=%@", b, nil];
                              }];
    STAssertEqualObjects(expectedZipWithArray, zipWithArray, nil);
    
    NSArray * expectedPartitionArrayYES = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                                                    [NSNumber numberWithInt:3],
                                                                    [NSNumber numberWithInt:5], nil];
    NSArray * expectedPartitionArrayNO = [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
                                                                   [NSNumber numberWithInt:4], nil];
    NSArray * partitionArray = [testNumArray partition:^(id a)
                              {
                                  return (BOOL)(([a intValue] % 2) == 1); // Why do we have to cast to bool?
                              }];
    STAssertEqualObjects(expectedPartitionArrayNO, [partitionArray objectAtIndex:0], nil);
    STAssertEqualObjects(expectedPartitionArrayYES, [partitionArray objectAtIndex:1], nil);
    
    NSArray * expectedTakeWhileArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
    NSArray * takeWhileArray = [testNumArray takeWhile:^(id a)
                                 {
                                     return (BOOL)([a intValue] < 3);
                                 }];
    STAssertEqualObjects(expectedTakeWhileArray, takeWhileArray, nil);
    
    NSArray * expectedDropWhileArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil];
    NSArray * dropWhileArray = [testNumArray dropWhile:^(id a)
                                {
                                    return (BOOL)([a intValue] < 4);
                                }];
    STAssertEqualObjects(expectedDropWhileArray, dropWhileArray, nil);
}

@end
