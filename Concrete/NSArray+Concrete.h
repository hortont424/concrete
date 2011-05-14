#import <Cocoa/Cocoa.h>

@interface NSArray (Concrete)

- (BOOL)any:(BOOL(^)(id a))block;
- (BOOL)all:(BOOL(^)(id a))block;

- (NSArray *)map:(id(^)(id a))block;
- (NSArray *)mapIndexed:(id(^)(NSUInteger, id))block;
- (NSArray *)filter:(BOOL(^)(id a))block;
- (id)selectOne:(BOOL(^)(id))block;
- (id)reduce:(id(^)(id a, id b))block;
- (NSArray *)zip:(NSArray *)other with:(id(^)(id a, id b))block;
- (NSArray *)partition:(BOOL(^)(id))block;
- (NSArray *)takeWhile:(BOOL(^)(id))block;
- (NSArray *)dropWhile:(BOOL(^)(id))block;

@end
