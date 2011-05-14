#import <Cocoa/Cocoa.h>

@interface NSSet (Concrete)

- (BOOL)any:(BOOL(^)(id a))block;
- (BOOL)all:(BOOL(^)(id a))block;

- (NSSet *)map:(id(^)(id a))block;
- (NSSet *)filter:(BOOL(^)(id a))block;
- (id)selectOne:(BOOL(^)(id))block;
- (NSArray *)partition:(BOOL(^)(id))block;

@end
