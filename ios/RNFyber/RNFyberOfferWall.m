//
//  RNFyberOfferWall.m
//  RNFyberOfferWall
//
//  Created by Ben Yee <benyee@gmail.com> on 5/20/16.
//
#import "RNFyberOfferWall.h"

// Failed is not actually used, but it's an event the JS listens to, so...

NSString *const kFyberOfferWallInitializeFailed = @"fyberOfferWallInitializeFailed";
NSString *const kFyberOfferWallInitializeSucceeded = @"fyberOfferWallInitializeSucceeded";
NSString *const kFyberOfferWallShowOfferWallSucceeded = @"fyberOfferWallShowOfferWallSucceeded";

@implementation RNFyberOfferWall {
}

RCT_EXPORT_MODULE();

// Run on the main thread

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kFyberOfferWallInitializeFailed,
        kFyberOfferWallInitializeSucceeded,
        kFyberOfferWallShowOfferWallSucceeded
    ];
}

#pragma mark exported methods

RCT_EXPORT_METHOD(initializeOfferWall: (NSString *)appId securityToken: (NSString *)securityToken userId: (NSString *)userId) {
  FYBSDKOptions *options = [FYBSDKOptions optionsWithAppId: appId
                                                    userId: userId
                                             securityToken: securityToken];

  [FyberSDK startWithOptions: options];

  [self sendEventWithName: kFyberOfferWallInitializeSucceeded body: nil];
}

//
// Show the Offer Wall
//
RCT_EXPORT_METHOD(showOfferWall) {
    FYBOfferWallViewController *offerWallViewController = [FyberSDK offerWallViewController];

    [offerWallViewController presentFromViewController: [UIApplication sharedApplication].delegate.window.rootViewController
                                              animated: YES
                                            completion: ^{
                                                          NSLog(@"Offer Wall presented");

                                                          [self sendEventWithName: kFyberOfferWallShowOfferWallSucceeded body: nil];
                                                        }

                                               dismiss: ^(NSError *error) {
                                                          if (error) {
                                                            NSLog(@"Offer Wall error");
                                                          }
                                                        }];
}

@end
