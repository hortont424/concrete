#import <Cocoa/Cocoa.h>

@interface NSSet (Concrete)

- (NSSet *)map:(id(^)(id a))block;
- (NSSet *)filter:(BOOL(^)(id a))block;

@end
