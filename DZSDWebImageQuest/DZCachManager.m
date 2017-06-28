//
//  DZCachManager.m
//  DZSDWebImageQuest
//

#import "DZCachManager.h"

@interface DZCachManager ()
{
    NSCache *_cach;
}

@end


@implementation DZCachManager

-(instancetype)init
{
    if (self = [super init]) {
        _cach = [[NSCache alloc] init];
        _cach.totalCostLimit = 1024*1024*30; //30MB
        _cach.countLimit = 10; //缓存对象个数
    }
    return self;
}

-(void)dz_loadPictWithUrl:(NSString *)url complete:(void(^)(NSData *image_data))block
{
    NSPurgeableData *purges_data = [self->_cach objectForKey:url];
    if (purges_data.length) {
        [purges_data beginContentAccess];
        block(purges_data);
        [purges_data endContentAccess];
    }else
    {
        NSURLRequest *url_req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        __weak typeof(self) weakSelf = self;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[[NSOperationQueue alloc] init]];
        
        [[session dataTaskWithRequest:url_req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSPurgeableData *cach_data = [NSPurgeableData dataWithData:data];
            [strongSelf->_cach setObject:cach_data forKey:url];
            block(cach_data);
            [cach_data endContentAccess];
            
        }] resume];

    }
}
- (void)removeCach
{
    [self->_cach removeAllObjects];
}


@end
