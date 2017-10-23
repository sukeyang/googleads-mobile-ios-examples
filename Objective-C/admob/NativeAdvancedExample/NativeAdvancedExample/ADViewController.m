//
//  ADViewController.m
//  NativeAdvancedExample
//
//  Created by yangshuo on 2017/10/23.
//  Copyright © 2017年 Google. All rights reserved.
//

#import "ADViewController.h"
#import "ADHeader.h"

@import GoogleMobileAds;

// Native Advanced ad unit ID for testing.
//static NSString *const TestAdUnit = KGoogleAdUnit;

@interface ADViewController ()<GADNativeContentAdLoaderDelegate>
/// You must keep a strong reference to the GADAdLoader during the ad loading process.
@property(nonatomic, strong) GADAdLoader *adLoader;
/// The native ad view that is being presented.
@property(nonatomic, strong) UIView *nativeAdView;

@end

@implementation ADViewController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
 
    UIView *btnView=  [[self.nativeAdView subviews] objectAtIndex:5];
     btnView .hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = NO;
    
    NSMutableArray *adTypes = [[NSMutableArray alloc] init];
    [adTypes addObject:kGADAdLoaderAdTypeNativeContent];
    
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:KGoogleAdUnit
                                       rootViewController:self
                                                  adTypes:adTypes
                                                  options:@[ videoOptions ]];
    self.adLoader.delegate = self;
    
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ kGADSimulatorID];
     request.testDevices = @[ kGADSimulatorID,@"25464f41f7c187772b0f96eb93f8704e"];
//    request.testDevices = @[ kGADSimulatorID,                       // All simulators
//                             @"dfd727394d70f8ec74e894143c29c80ad1509f29" ]; // Sample device ID
    [self.adLoader loadRequest:request];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
//    self.refreshButton.enabled = YES;
}

- (void)setAdView:(UIView *)view {
    // Remove previous ad view.
    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = view;
    self.nativeAdView.backgroundColor = [UIColor whiteColor];
    self.nativeAdView.frame = CGRectMake(0, 0, 320, 400);
    // Add new ad view and set constraints to fill its container.
    [self.view addSubview:view];
//    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:viewDictionary]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:viewDictionary]];
}

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    NSLog(@"Received native content ad: %@", nativeContentAd);
//    self.videoStatusLabel.text = @"Ad does not contain a video.";
//    self.refreshButton.enabled = YES;
    
    // Create and place ad in view hierarchy.
    GADNativeContentAdView *contentAdView =
    [[NSBundle mainBundle] loadNibNamed:@"NativeContentAdView" owner:nil options:nil].firstObject;
    [self setAdView:contentAdView];
   
    
    // Associate the content ad view with the content ad object. This is required to make the ad
    // clickable.
    contentAdView.nativeContentAd = nativeContentAd;
    
    // Populate the content ad view with the content ad assets.
    // Some assets are guaranteed to be present in every content ad.
    ((UILabel *)contentAdView.headlineView).text = nativeContentAd.headline;
    ((UILabel *)contentAdView.bodyView).text = nativeContentAd.body;
    ((UIImageView *)contentAdView.imageView).image =
    ((GADNativeAdImage *)nativeContentAd.images.firstObject).image;
    ((UILabel *)contentAdView.advertiserView).text = nativeContentAd.advertiser;
    [((UIButton *)contentAdView.callToActionView)setTitle:nativeContentAd.callToAction
                                                 forState:UIControlStateNormal];
    
    // Other assets are not, however, and should be checked first.
    if (nativeContentAd.logo && nativeContentAd.logo.image) {
        ((UIImageView *)contentAdView.logoView).image = nativeContentAd.logo.image;
        contentAdView.logoView.hidden = NO;
    } else {
        contentAdView.logoView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    contentAdView.callToActionView.userInteractionEnabled = NO;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [self.nativeAdView addSubview:label];
    label.backgroundColor = [UIColor greenColor];
}

//- (void)coverView {}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
//    self.videoStatusLabel.text = @"Video playback has ended.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
