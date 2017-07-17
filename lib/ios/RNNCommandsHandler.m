
#import "RNNCommandsHandler.h"
#import <React/RCTConvert.h>
#import "RNNModalManager.h"
#import "RNNNavigationStackManager.h"

@implementation RNNCommandsHandler {
	RNNControllerFactory *_controllerFactory;
	RNNStore *_store;
	RNNNavigationStackManager* _navigationStackManager;
	RNNModalManager* _modalManager;
}

-(instancetype) initWithStore:(RNNStore*)store controllerFactory:(RNNControllerFactory*)controllerFactory {
	self = [super init];
	_store = store;
	_controllerFactory = controllerFactory;
	_navigationStackManager = [[RNNNavigationStackManager alloc] initWithStore:_store];
	_modalManager = [[RNNModalManager alloc] initWithStore:_store];
	return self;
}

#pragma mark - public

-(void) setRoot:(NSDictionary*)layout {
	[self assertReady];

	[_modalManager dismissAllModals];
	
	UIViewController *vc = [_controllerFactory createLayoutAndSaveToStore:layout];
	
	UIApplication.sharedApplication.delegate.window.rootViewController = vc;
	[UIApplication.sharedApplication.delegate.window makeKeyAndVisible];
}

-(void) setOptions:(NSString*)containerId options:(NSDictionary*)options {
	[self assertReady];
	UIViewController* vc = [_store findContainerForId:containerId];
	
	NSString* title = options[@"title"];
	[vc setTitle:title];
	// topBarTextColor and topBarTextFontFamily
	if ([options objectForKey:@"topBarTextColor"]) {
		UIColor* titleColor = [RCTConvert UIColor:options[@"topBarTextColor"]];
		NSMutableDictionary* navigationBarTitleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName: titleColor}];
		if ([options objectForKey:@"topBarTextFontFamily"]) {
			[navigationBarTitleTextAttributes addEntriesFromDictionary:@{NSFontAttributeName: [UIFont fontWithName:options[@"topBarTextFontFamily"] size:20]}];
		}
		vc.navigationController.navigationBar.titleTextAttributes = navigationBarTitleTextAttributes;
	} else if ([options objectForKey:@"topBarTextFontFamily"]) {
		vc.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:options[@"topBarTextFontFamily"] size:20]};
	}
	// topBarBackgroundColor
	if ([options objectForKey:@"topBarBackgroundColor"]) {
		UIColor* backgroundColor =[RCTConvert UIColor:options[@"topBarBackgroundColor"]];
		vc.navigationController.navigationBar.barTintColor = backgroundColor;
	}
	// topBarButtonColor
	if ([options objectForKey:@"topBarButtonColor"]) {
		UIColor* buttonColor = [RCTConvert UIColor:options[@"topBarButtonColor"]];
		vc.navigationController.navigationBar.tintColor = buttonColor;
	}
	// topBarHidden
	if ([options objectForKey:@"topBarHidden"]) {
		if ([options[@"topBarHidden"] boolValue]) {
			[vc.navigationController setNavigationBarHidden:YES animated:YES];
		} else {
			[vc.navigationController setNavigationBarHidden:NO animated:YES];
		}
	};
	// topBarTranslucent
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
	
	
}

-(void) push:(NSString*)containerId layout:(NSDictionary*)layout {
	[self assertReady];
	UIViewController *newVc = [_controllerFactory createLayoutAndSaveToStore:layout];
	[_navigationStackManager push:newVc onTop:containerId];
}

-(void) pop:(NSString*)containerId {
	[self assertReady];
	[_navigationStackManager pop:containerId];
}

-(void) popTo:(NSString*)containerId {
	[self assertReady];
	[_navigationStackManager popTo:containerId];
}

-(void) popToRoot:(NSString*)containerId {
	[self assertReady];
	[_navigationStackManager popToRoot:containerId];
}

-(void) showModal:(NSDictionary*)layout {
	[self assertReady];
	UIViewController *newVc = [_controllerFactory createLayoutAndSaveToStore:layout];
	[_modalManager showModal:newVc];
}

-(void) dismissModal:(NSString*)containerId {
	[self assertReady];
	[_modalManager dismissModal:containerId];
}

-(void) dismissAllModals {
	[self assertReady];
	[_modalManager dismissAllModals];
}

#pragma mark - private

-(void) assertReady {
	if (!_store.isReadyToReceiveCommands) {
		@throw [NSException exceptionWithName:@"BridgeNotLoadedError" reason:@"Bridge not yet loaded! Send commands after Navigation.events().onAppLaunched() has been called." userInfo:nil];
	}
}

@end
