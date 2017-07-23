//
//  RNNNavigationController.m
//  ReactNativeNavigation
//
//  Created by Elad Bogomolny on 20/07/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "RNNNavigationController.h"

@interface RNNNavigationController ()


@end

@implementation RNNNavigationController


-(UIStatusBarStyle)preferredStatusBarStyle {
	if([self.statusBarStyle  isEqual: @"light"]) {
		return UIStatusBarStyleLightContent;
	} else {
		return UIStatusBarStyleDefault;
	}
}

@end
