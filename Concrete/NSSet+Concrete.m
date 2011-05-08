#import "NSArray+Concrete.h"

@implementation NSSet (Concrete)

/**
 * Executes a block for every element in the set,
 * returning a list of the results.
 *
 * If block is nil, returns a set of NSNull.
 *
 * @param block The block to execute for each element in the set.
 *
 * @return A set of the results of each application.
 */
- (NSSet *)map:(id(^)(id))block;
{
    if(block == nil)
    {
        return [[[NSSet alloc] initWithObjects:[NSNull null], nil] autorelease];
    }
    
    NSMutableSet * result = [[NSMutableSet alloc] initWithCapacity:[self count]];
    
    for(id obj in self)
    {
        [result addObject:block(obj)];
    }
    
    return [result autorelease];
}

/**
 * Executes a block for every element in the set,
 * returning a list including only those elements
 * for which block returned YES.
 *
 * If block is nil, returns the original set.
 *
 * @param block The block to execute for each element
 * in the set.
 *
 * @return A set including only elements for which
 * the block returned YES.
 */
- (NSSet *)filter:(BOOL(^)(id))block
{
    if(block == nil)
    {
        return [[self copy] autorelease];
    }
    
    NSMutableSet * result = [[NSMutableSet alloc] initWithCapacity:[self count]];

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
 * Executes a block for every element in the set
 * until the block returns YES.
 *
 * If block is nil, returns nil.
 *
 * @param block The block to execute for each element
 * in the set.
 *
 * @return The first element in the set for which
 * the block returned YES. If the block never returns YES,
 * nil is returned.
 */
- (id)selectOne:(BOOL(^)(id))block
{
    if(block == nil)
    {
        return nil;
    }
    
    for(id obj in self)
    {
        if(block(obj))
        {
            return obj;
        }
    }
    
    return nil;
}

@end
