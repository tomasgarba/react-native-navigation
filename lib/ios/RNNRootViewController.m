
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
	// TODO: make sure styles were provided
	if ([self.nodeData[@"navigationOptions"] objectForKey:@"topBarTextColor"]){
		UIColor *topBarTextColor = [RCTConvert UIColor:self.nodeData[@"navigationOptions"][@"topBarTextColor"]];
		[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: topBarTextColor}];
	}
	if ([self.nodeData[@"navigationOptions"] objectForKey:@"topBarBackgroundColor"]){
		UIColor *backgroundColor = [RCTConvert UIColor:self.nodeData[@"navigationOptions"][@"topBarBackgroundColor"]];
		self.navigationController.navigationBar.barTintColor = backgroundColor;
	}
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
