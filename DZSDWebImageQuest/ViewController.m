//
//  ViewController.m
//  DZSDWebImageQuest
//

#import "ViewController.h"
#import "DZCachManager.h"
#import <UIImageView+WebCache.h>
#import <UIImage+MultiFormat.h>
#import <SDWebImageDecoder.h>
#import <SDWebImageCompat.h>


#define kWeakSelf   __weak typeof(self) weakSelf = self;
#define kStrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

@interface ViewController ()

@property(nonatomic, strong)UIImageView *dz_pict_imgview;

@property(nonatomic, strong)DZCachManager *dz_cach_mananger;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dz_createView];
//    [self.dz_pict_imgview sd_setImageWithURL:[NSURL URLWithString:@"http://ifanr-cdn.b0.upaiyun.com/wp-content/uploads/2017/06/ios1193483.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        self.dz_pict_imgview.image = image;
//    }];
    
    [self dz_loadPictWithUrl:@"http://ifanr-cdn.b0.upaiyun.com/wp-content/uploads/2017/06/ios1193483.jpg"];
    
}

-(void)dz_createView
{
    [self.view addSubview:self.dz_pict_imgview];
    UIButton *remo_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    remo_btn.frame = CGRectMake(50, 64, 100, 100);
    [remo_btn setTitle:@"Action" forState:UIControlStateNormal];
    [remo_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [remo_btn setBackgroundColor:[UIColor orangeColor]];
    remo_btn.layer.masksToBounds = YES;
    remo_btn.layer.cornerRadius = 50;
    [remo_btn addTarget:self action:@selector(dz_remoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:remo_btn];
    
}
-(void)dz_remoBtnAction:(UIButton *)sender
{
    [self.dz_cach_mananger removeCach];
}

-(void)dz_loadPictWithUrl:(NSString *)url
{
    kWeakSelf
    [self.dz_cach_mananger dz_loadPictWithUrl:url complete:^(NSData *image_data) {
        dispatch_main_async_safe(^{
            kStrongSelf
            strongSelf.dz_pict_imgview.image = [UIImage decodedImageWithImage:[UIImage sd_imageWithData:image_data]];
           });
        
    }];
}

#pragma mark - lazy load
-(UIImageView *)dz_pict_imgview
{
    if (!_dz_pict_imgview) {
        _dz_pict_imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.width*0.5)];
        _dz_pict_imgview.center = self.view.center;
    }
    return _dz_pict_imgview;
    
}
-(DZCachManager *)dz_cach_mananger
{
    if (!_dz_cach_mananger) {
        _dz_cach_mananger = [[DZCachManager alloc] init];
    }
    return _dz_cach_mananger;
}


@end
