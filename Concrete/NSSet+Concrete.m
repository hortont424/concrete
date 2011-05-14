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

#import "NSArray+Concrete.h"
#import "CRBase.h"

@implementation NSSet (Concrete)

/**
 * Determine if a block returns true for any of the elements
 * in the set.
 *
 * @param block The block to execute for each element in the set.
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
 * in the set.
 *
 * @param block The block to execute for each element in the set.
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
 * Executes a block for every element in the set,
 * returning a list of the results.
 *
 * @param block The block to execute for each element in the set.
 *
 * @return A set of the results of each application.
 */
- (NSSet *)map:(id(^)(id))block;
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableSet * result = [[NSMutableSet alloc] initWithCapacity:[self count]];
    
    for(id obj in self)
    {
        id value = block(obj);
        
        [result addObject:value ? value : [NSNull null]];
    }
    
    return [result autorelease];
}

/**
 * Executes a block for every element in the set,
 * returning a list including only those elements
 * for which block returned YES.
 *
 * @param block The block to execute for each element
 * in the set.
 *
 * @return A set including only elements for which
 * the block returned YES.
 */
- (NSSet *)filter:(BOOL(^)(id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
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
 * @param block The block to execute for each element
 * in the set.
 *
 * @return The first element in the set for which
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
 * Executes a block for every element in the set,
 * partitioning the elements into two sets depending
 * on the boolean return value of the block.
 *
 * @param block The block to execute for each element in the set.
 *
 * @return An array with two elements: a set containing
 * all elements for which the block returned NO, and all
 * for which it returned YES, in that order.
 */
- (NSArray *)partition:(BOOL(^)(id))block
{
    CR_NIL_BLOCK_CHECK(block);
    
    NSMutableSet * positiveSet = [[NSMutableSet alloc] initWithCapacity:[self count]];
    NSMutableSet * negativeSet = [[NSMutableSet alloc] initWithCapacity:[self count]];
    
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
