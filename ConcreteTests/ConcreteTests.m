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
    STAssertEqualObjects(testArray, [testArray filter:nil], nil);
    
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
}

@end
