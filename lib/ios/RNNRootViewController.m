
#import "RNNRootViewController.h"
#import <React/RCTConvert.h>

@interface RNNRootViewController ()

@property (nonatomic, copy) NSString* containerId;
@property (nonatomic, copy) NSString* containerName;
@property (nonatomic, strong) RNNEventEmitter *eventEmitter;

@property (nonatomic, strong) NSDictionary* nodeData;
@property (nonatomic, strong) id<RNNRootViewCreator> creator;

@end

@implementation RNNRootViewController

-(instancetype)initWithNode:(RNNLayoutNode*)node rootViewCreator:(id<RNNRootViewCreator>)creator eventEmitter:(RNNEventEmitter*)eventEmitter {
	self = [super init];
	self.containerId = node.nodeId;
	self.containerName = node.data[@"name"];
	self.nodeData = node.data;
	self.eventEmitter = eventEmitter;
	self.creator = creator;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onJsReload)
												 name:RCTJavaScriptWillStartLoadingNotification
											   object:nil];
	
	self.navigationItem.title = node.data[@"navigationOptions"][@"title"];
	
	
	return self;
}

- (void)loadView
{
	self.view = [self.creator createRootView:self.containerName rootViewId:self.containerId];
	self.creator = nil;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	NSDictionary* options = self.nodeData[@"navigationOptions"];
	// topBarTextColor and topBarTextFontFamily
	if ([options objectForKey:@"topBarTextColor"]) {
		UIColor* titleColor = [RCTConvert UIColor:options[@"topBarTextColor"]];
		NSMutableDictionary* navigationBarTitleTextAttributes = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName: titleColor}];
		if ([options objectForKey:@"topBarTextFontFamily"]) {
			[navigationBarTitleTextAttributes addEntriesFromDictionary:@{NSFontAttributeName: [UIFont fontWithName:options[@"topBarTextFontFamily"] size:20]}];
		}
		self.navigationController.navigationBar.titleTextAttributes = navigationBarTitleTextAttributes;
	} else if ([options objectForKey:@"topBarTextFontFamily"]) {
		self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:options[@"topBarTextFontFamily"] size:20]};
	}
	// topBarBackgroundColor
	if ([options objectForKey:@"topBarBackgroundColor"]) {
		UIColor* backgroundColor =[RCTConvert UIColor:options[@"topBarBackgroundColor"]];
		self.navigationController.navigationBar.barTintColor = backgroundColor;
	}
	// topBarButtonColor
	if ([options objectForKey:@"topBarButtonColor"]) {
		UIColor* buttonColor = [RCTConvert UIColor:options[@"topBarButtonColor"]];
		self.navigationController.navigationBar.tintColor = buttonColor;
	}
	// topBarHidden
	if ([options objectForKey:@"topBarHidden"]) {
		if ([options[@"topBarHidden"] boolValue]) {
			[self.navigationController setNavigationBarHidden:YES animated:YES];
		} else {
			[self.navigationController setNavigationBarHidden:NO animated:YES];
		}
	};
	// topBarTranslucent
	if ([options objectForKey:@"topBarTranslucent"]) {
		if ([options[@"topBarTranslucent"] boolValue]) {
			[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
													  forBarMetrics:UIBarMetricsDefault];
			self.navigationController.navigationBar.shadowImage = [UIImage new];
			self.navigationController.navigationBar.translucent = YES;
			self.navigationController.view.backgroundColor = [UIColor clearColor];
		} else {
			self.navigationController.navigationBar.translucent = NO;
		}
	}
	// screenBackgroundColor
	if ([options objectForKey:@"screenBackgroundColor"]) {
		UIColor* screenColor = [RCTConvert UIColor:options[@"screenBackgroundColor"]];
		self.view.backgroundColor = screenColor;
	}
	// topBarHideOnScroll
	if ([options objectForKey:@"topBarHideOnScroll"]){
		NSNumber *topBarHideOnScroll = options[@"topBarHideOnScroll"];
		BOOL topBarHideOnScrollBool = topBarHideOnScroll ? [topBarHideOnScroll boolValue] : NO;
		if (topBarHideOnScrollBool) {
			self.navigationController.hidesBarsOnSwipe = YES;
		} else {
		self.navigationController.hidesBarsOnSwipe = NO;
		}
	}
}

- (BOOL)prefersStatusBarHidden {
	NSNumber* statusBarHidden = self.nodeData[@"navigationOptions"][@"statusBarHidden"];
	BOOL statusBarHiddenBool = statusBarHidden ? [statusBarHidden boolValue] : NO;
	return statusBarHiddenBool;
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.eventEmitter sendContainerStart:self.containerId];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.eventEmitter sendContainerStop:self.containerId];
}

/**
 *	fix for #877, #878
 */
-(void)onJsReload {
	[self cleanReactLeftovers];
}

/**
 * fix for #880
 */
-(void)dealloc {
	[self cleanReactLeftovers];
}

-(void)cleanReactLeftovers {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self.view];
	self.view = nil;
}

@end
