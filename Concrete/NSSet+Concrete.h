#import <Cocoa/Cocoa.h>

@interface NSSet (Concrete)

- (NSSet *)map:(id(^)(id a))block;
- (NSSet *)filter:(BOOL(^)(id a))block;
- (id)selectOne:(BOOL(^)(id))block;
- (NSArray *)partition:(BOOL(^)(id))block;

@end
