//
//  RNNStyles.m
//  ReactNativeNavigation
//
//  Created by Elad Bogomolny on 24/07/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "RNNStyles.h"
#import <React/RCTConvert.h>

@implementation RNNStyles : NSObject

+(void)topBarStyles:(NSDictionary *)options andRNNRootViewController:(UIViewController*)vc{
	if ([options objectForKey:@"topBarTextColor"]) {
		UIColor* titleColor = [RCTConvert UIColor:options[@"topBarTextColor"]];
		NSLog(@"-------titlecolor:--------- %@", titleColor);
		NSMutableDictionary* navigationBarTitleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName: titleColor}];
		if ([options objectForKey:@"topBarTextFontFamily"]) {
			[navigationBarTitleTextAttributes addEntriesFromDictionary:@{NSFontAttributeName: [UIFont fontWithName:options[@"topBarTextFontFamily"] size:20]}];
		}
		vc.navigationController.navigationBar.titleTextAttributes = navigationBarTitleTextAttributes;
	} else if ([options objectForKey:@"topBarTextFontFamily"]) {
		vc.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:options[@"topBarTextFontFamily"] size:20]};
	}
	
	if ([options objectForKey:@"topBarBackgroundColor"]) {
		UIColor* backgroundColor =[RCTConvert UIColor:options[@"topBarBackgroundColor"]];
		vc.navigationController.navigationBar.barTintColor = backgroundColor;
	}
	
	if ([options objectForKey:@"topBarButtonColor"]) {
		UIColor* buttonColor = [RCTConvert UIColor:options[@"topBarButtonColor"]];
		vc.navigationController.navigationBar.tintColor = buttonColor;
	}
	
	if ([options objectForKey:@"topBarHidden"]) {
		if ([options[@"topBarHidden"] boolValue]) {
			[vc.navigationController setNavigationBarHidden:YES animated:YES];
		} else {
			[vc.navigationController setNavigationBarHidden:NO animated:YES];
		}
	};
	
	if ([options objectForKey:@"topBarTranslucent"]) {
		if ([options[@"topBarTranslucent"] boolValue]) {
			[vc.navigationController.navigationBar setBackgroundImage:[UIImage new]
														  forBarMetrics:UIBarMetricsDefault];
			vc.navigationController.navigationBar.shadowImage = [UIImage new];
			vc.navigationController.navigationBar.translucent = YES;
			vc.navigationController.view.backgroundColor = [UIColor clearColor];
		} else {
			vc.navigationController.navigationBar.translucent = NO;
		}
	}
	
	if ([options objectForKey:@"topBarHideOnScroll"]){
		NSNumber *topBarHideOnScroll = options[@"topBarHideOnScroll"];
		BOOL topBarHideOnScrollBool = topBarHideOnScroll ? [topBarHideOnScroll boolValue] : NO;
		if (topBarHideOnScrollBool) {
			vc.navigationController.hidesBarsOnSwipe = YES;
		} else {
			vc.navigationController.hidesBarsOnSwipe = NO;
		}
	}
}

@end
