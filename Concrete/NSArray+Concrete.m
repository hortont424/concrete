#import "NSArray+Concrete.h"

@implementation NSArray (Concrete)

/**
 * Executes a block for every element in the array,
 * returning a list of the results.
 *
 * If block is nil, returns a list of NSNull.
 *
 * @param block The block to execute for each element in the array.
 *
 * @return An array of the results of each application.
 */
- (NSArray *)map:(id(^)(id))block;
{
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:[self count]];

    for(id obj in self)
    {
        if(block == nil)
        {
            [result addObject:[NSNull null]];
        }
        else
        {
            [result addObject:block(obj)];
        }
    }

    return [result autorelease];
}

/**
 * Executes a block for every element in the array,
 * returning a list including only those elements
 * for which block returned YES.
 *
 * If block is nil, returns the original array.
 *
 * @param block The block to execute for each element
 * in the array.
 *
 * @return An array including only elements for which
 * the block returned YES.
 */
- (NSArray *)filter:(BOOL(^)(id))block
{
    if(block == nil)
    {
        return [[self copy] autorelease];
    }
    
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
 * Executes a block for every element in the array,
 * accumulating the results in the block's first argument.
 *
 * Each invocation merges two values into one, effectively
 * eventually reducing the list to a single value.
 *
 * If block is nil, returns nil.
 *
 * @param block The block to execute for each element
 * in the array.
 *
 * @return The value returned by the final application.
 */
- (id)reduce:(id(^)(id, id))block
{
    if(block == nil)
    {
        return nil;
    }
    
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
 * If block is nil, returns a list of NSNull.
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
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:MIN([self count], [other count])];

    NSEnumerator * selfEnumerator = [self objectEnumerator];
    NSEnumerator * otherEnumerator = [other objectEnumerator];

    id obja, objb;

    while((obja = [selfEnumerator nextObject]) && (objb = [otherEnumerator nextObject]))
    {
        if(block == nil)
        {
            [result addObject:[NSNull null]];
        }
        else
        {
            [result addObject:block(obja, objb)];
        }
    }

    return [result autorelease];
}

@end
