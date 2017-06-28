//
//  DZCachManager.h
//  DZSDWebImageQuest
//

#import <Foundation/Foundation.h>

@interface DZCachManager : NSObject

- (void)dz_loadPictWithUrl:(NSString *)url complete:(void(^)(NSData *image_data))block;

- (void)removeCach;

@end
