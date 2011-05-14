#import "NSArray+Concrete.h"
#import "CRBase.h"

@implementation NSArray (Concrete)

/**
 * Determine if a block returns true for any of the elements
 * in the array.
 *
 * @param block The block to execute for each element in the array.
 *
 * @return YES if the block returns true for one or more elements,
 * NO otherwise
 */
- (BOOL)any:(BOOL(^)(id a))block
{
    for(id obj in self)
    {
        if(block(obj))
        {
            return YES;
        }
    }
    
    return NO;
}

/**
 * Determine if a block returns true for all of the elements
 * in the array.
 *
 * @param block The block to execute for each element in the array.
 *
 * @return YES if the block returns true for all elements, NO otherwise
 */
- (BOOL)all:(BOOL(^)(id a))block
{
    for(id obj in self)
    {
        if(!block(obj))
        {
            return NO;
        }
    }
    
    return YES;
}

/**
 * Executes a block for every element in the array,
 * returning a list of the results.
 *
 * @param block The block to execute for each element in the array.
 *
 * @return An array of the results of each application.
 */
- (NSArray *)map:(id(^)(id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for(id obj in self)
    {
        id value = block(obj);
        
        [result addObject:value ? value : [NSNull null]];
    }
    
    return [result autorelease];
}

/**
 * Executes a block for every element in the array,
 * returning a list of the results. In addition to
 * the element, the block is provided with the index
 * of that element in the array.
 *
 * @param block The block to execute for each element in the array.
 *
 * @return An array of the results of each application.
 */
- (NSArray *)mapIndexed:(id(^)(NSUInteger, id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSUInteger index = 0;
    
    for(id obj in self)
    {
        id value = block(index, obj);
        
        [result addObject:value ? value : [NSNull null]];
        
        index++;
    }
    
    return [result autorelease];
}

/**
 * Executes a block for every element in the array,
 * returning a list including only those elements
 * for which block returned YES.
 *
 * @param block The block to execute for each element
 * in the array.
 *
 * @return An array including only elements for which
 * the block returned YES.
 */
- (NSArray *)filter:(BOOL(^)(id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:[self count]];

    for(id obj in self)
    {
        if(block(obj))
        {
            [result addObject:obj];
        }
    }

    return [result autorelease];
}

/**
 * Executes a block for every element in the array
 * until the block returns YES.
 *
 * @param block The block to execute for each element
 * in the array.
 *
 * @return The first element in the array for which
 * the block returned YES. If the block never returns YES,
 * nil is returned.
 */
- (id)selectOne:(BOOL(^)(id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    for(id obj in self)
    {
        if(block(obj))
        {
            return obj;
        }
    }
    
    return nil;
}

/**
 * Executes a block for every element in the array,
 * accumulating the results in the block's first argument.
 *
 * Each invocation merges two values into one, effectively
 * eventually reducing the list to a single value.
 *
 * @param block The block to execute for each element
 * in the array.
 *
 * @return The value returned by the final application.
 */
- (id)reduce:(id(^)(id, id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    id result = block([self objectAtIndex:0], [self objectAtIndex:1]);

    for(id obj in [self subarrayWithRange:NSMakeRange(2, [self count] - 2)])
    {
        result = block(result, obj);
    }

    return [result autorelease];
}

/**
 * Executes a block for corresponding pairs of
 * elements in two arrays, returning a list of the results.
 *
 * If one array is longer than the other, the resultant array
 * will be the length of the shorter array.
 *
 * @param block The block to execute for corresponding pairs
 * of elements in the arrays.
 *
 * @return An array of the results of each application.
 */
- (NSArray *)zip:(NSArray *)other with:(id(^)(id, id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:MIN([self count], [other count])];

    NSEnumerator * selfEnumerator = [self objectEnumerator];
    NSEnumerator * otherEnumerator = [other objectEnumerator];

    id obja, objb;

    while((obja = [selfEnumerator nextObject]) && (objb = [otherEnumerator nextObject]))
    {
        id value = block(obja, objb);
        
        [result addObject:value ? value : [NSNull null]];
    }

    return [result autorelease];
}

/**
 * Executes a block for every element in the array,
 * partitioning the elements into two arrays depending
 * on the boolean return value of the block.
 *
 * @param block The block to execute for each element in the array.
 *
 * @return An array with two elements: an array containing
 * all elements for which the block returned NO, and all
 * for which it returned YES, in that order.
 */
- (NSArray *)partition:(BOOL(^)(id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableArray * positiveSet = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSMutableArray * negativeSet = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for(id obj in self)
    {
        if(block(obj))
        {
            [positiveSet addObject:obj];
        }
        else
        {
            [negativeSet addObject:obj];
        }
    }
    
    return [[NSArray arrayWithObjects:[negativeSet autorelease], [positiveSet autorelease], nil] autorelease];
}

@end
