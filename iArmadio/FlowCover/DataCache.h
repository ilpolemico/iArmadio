#import <Foundation/Foundation.h>


@interface DataCache : NSObject 
{
	int fCapacity;
	NSMutableDictionary *fDictionary;
	NSMutableArray *fAge;
}

- (id)initWithCapacity:(int)cap;

- (id)objectForKey:(id)key;
- (void)setObject:(id)value forKey:(id)key;
- (void) emptyCache;

@end
