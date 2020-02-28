//  RNFyberOfferWall.m
//  RNFyberOfferWall
//
//  Created by Ben Yee <benyee@gmail.com> on 5/20/16.

#import "RNFyberOfferWall.h"

@implementation RNFyberOfferWall {
}

RCT_EXPORT_MODULE();

// Run on the main thread

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

#pragma mark exported methods

RCT_EXPORT_METHOD(initializeOfferWall: (NSString *)appId
                        securityToken: (NSString *)securityToken
                               userId: (NSString *)userId
                              resolve: (RCTPromiseResolveBlock)resolve
                               reject: (RCTPromiseRejectBlock)reject) {
  FYBSDKOptions *options = [FYBSDKOptions optionsWithAppId: appId
                                                    userId: userId
                                             securityToken: securityToken];

  [FyberSDK startWithOptions: options];

  resolve(@"Initialize Succeeded");
}

//
// Show the Offer Wall
//
RCT_EXPORT_METHOD(showOfferWall: (RCTPromiseResolveBlock)resolve
                         reject: (RCTPromiseRejectBlock)reject) {
    FYBOfferWallViewController *offerWallViewController = [FyberSDK offerWallViewController];

    [offerWallViewController presentFromViewController: [UIApplication sharedApplication].delegate.window.rootViewController
                                              animated: YES
                                            completion: ^{
                                                          NSLog(@"Offer Wall presented");

                                                          resolve(@"Offer Wall presented");
                                                        }

                                               dismiss: ^(NSError *error) {
                                                          if (error) {
                                                            NSLog(@"Offer Wall error");
                                                          }
                                                        }];
}

@end
