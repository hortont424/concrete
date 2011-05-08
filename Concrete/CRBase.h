#define CR_NIL_BLOCK_CHECK(x) { if(x == nil) [NSException raise:@"Block cannot be null" format:@""]; }
