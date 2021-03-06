//
// CHProgressHUD.m

#import "CHProgressHUD.h"
#import <tgmath.h>


#if __has_feature(objc_arc)
	#define CH_AUTORELEASE(exp) exp
	#define CH_RELEASE(exp) exp
	#define CH_RETAIN(exp) exp
#else
	#define CH_AUTORELEASE(exp) [exp autorelease]
	#define CH_RELEASE(exp) [exp release]
	#define CH_RETAIN(exp) [exp retain]
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
    #define CHLabelAlignmentCenter NSTextAlignmentCenter
#else
    #define CHLabelAlignmentCenter UITextAlignmentCenter
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
	#define CH_TEXTSIZE(text, font) [text length] > 0 ? [text \
		sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
	#define CH_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
	#define CH_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
		boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
		attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
	#define CH_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
		sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
    #define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
    #define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif


static const CGFloat kPadding = 4.f;
static const CGFloat kLabelFontSize = 14.f; //16.f;
static const CGFloat kDetailsLabelFontSize = 12.f;


@interface CHProgressHUD () {
	BOOL useAnimation;
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	UILabel *label;
	UILabel *detailsLabel;
	//BOOL isFinished;
	CGAffineTransform rotationTransform;
}

@property (atomic, CH_STRONG) UIView *indicator;
@property (atomic, CH_STRONG) NSTimer *graceTimer;
@property (atomic, CH_STRONG) NSTimer *minShowTimer;
@property (atomic, CH_STRONG) NSDate *showStarted;

@end


@implementation CHProgressHUD

#pragma mark - Properties

@synthesize animationType;
@synthesize delegate;
@synthesize opacity;
@synthesize color;
@synthesize labelFont;
@synthesize labelColor;
@synthesize detailsLabelFont;
@synthesize detailsLabelColor;
@synthesize indicator;
@synthesize xOffset;
@synthesize yOffset;
@synthesize minSize;
@synthesize square;
@synthesize margin;
@synthesize dimBackground;
@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;
@synthesize taskInProgress;
@synthesize removeFromSuperViewOnHide;
@synthesize customView;
@synthesize showStarted;
@synthesize mode;
@synthesize labelText;
@synthesize detailsLabelText;
@synthesize progress;
@synthesize size;
@synthesize activityIndicatorColor;
#if NS_BLOCKS_AVAILABLE
@synthesize completionBlock;
#endif

#pragma mark - Class methods

+ (CH_INSTANCETYPE)ch_showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
	CHProgressHUD *hud = [[self alloc] initWithView:view];
	hud.removeFromSuperViewOnHide = YES;
	[view addSubview:hud];
	[hud oldmb_showAnimated:animated];
	return CH_AUTORELEASE(hud);
}

// add by DJ
+ (CH_INSTANCETYPE)ch_showHUDAddedTo:(UIView *)view animated:(BOOL)animated withText:(NSString *)text
{
    return [CHProgressHUD ch_showHUDAddedTo:view animated:animated withText:text delay:0];
}

+ (instancetype)ch_showHUDAddedTo:(UIView *)view animated:(BOOL)animated withText:(NSString *)text delay:(NSTimeInterval)delay
{
    CHProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud setLabelText:text];
    hud.color = nil;
    hud.mode = CHProgressHUDModeText;
    [hud oldmb_showAnimated:animated];
    if (delay > 0)
    {
        hud.removeFromSuperViewOnHide = YES;
        [hud ch_hideAnimated:animated afterDelay:delay];
    }
    return CH_AUTORELEASE(hud);
}

+ (CH_INSTANCETYPE)ch_showHUDAddedTo:(UIView *)view animated:(BOOL)animated withDetailText:(NSString *)text
{
    return [CHProgressHUD ch_showHUDAddedTo:view animated:animated withDetailText:text delay:0];
}

+ (instancetype)ch_showHUDAddedTo:(UIView *)view animated:(BOOL)animated withDetailText:(NSString *)text delay:(NSTimeInterval)delay
{
    CHProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud setDetailsLabelText:text];
    hud.color = nil;
    hud.mode = CHProgressHUDModeText;
    [hud oldmb_showAnimated:animated];
    if (delay > 0)
    {
        hud.removeFromSuperViewOnHide = YES;
        [hud ch_hideAnimated:animated afterDelay:delay];
    }
    
    return CH_AUTORELEASE(hud);
}

+ (BOOL)ch_hideHUDForView:(UIView *)view animated:(BOOL)animated {
    CHProgressHUD *hud = [self ch_HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud ch_hideAnimated:animated];
        return YES;
    }
    
    return NO;
}

// add by DJ
+ (instancetype)ch_showHUDAddedTo:(UIView *)view animated:(BOOL)animated withText:(NSString *)text detailText:(NSString *)detailText images:(NSArray *)images duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    // hud_network_poor
    CHProgressHUD *hud = [[self alloc] initWithView:view];
    hud.mode = CHProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    
    [hud setLabelText:text];
    [hud setDetailsLabelText:detailText];
    
    UIImageView *imageView = [UIImageView ch_imageViewWithImageArray:images duration:duration];
    if (images.count > 1)
    {
        [imageView startAnimating];
    }
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 120.0f)];
    bgview.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.6 alpha:0.6];
    [bgview ch_roundedRect:8.0f];
    [bgview addSubview:imageView];
    [imageView ch_centerInSuperView];
    hud.customView = bgview;
    
    hud.color = [UIColor colorWithWhite:0.3f alpha:0.6f];//[UIColor clearColor];
    [hud oldmb_showAnimated:animated];
    if (delay > 0)
    {
        hud.removeFromSuperViewOnHide = YES;
        [hud ch_hideAnimated:animated afterDelay:delay];
    }
    return CH_AUTORELEASE(hud);
}


+ (BOOL)ch_hideHUDForView:(UIView *)view animated:(BOOL)animated delay:(NSTimeInterval)delay
{
    CHProgressHUD *hud = [self ch_HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud ch_hideAnimated:animated afterDelay:delay];
        
        return YES;
    }
    
    return NO;
}

+ (NSUInteger)ch_hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [CHProgressHUD ch_allHUDsForView:view];
	for (CHProgressHUD *hud in huds) {
		hud.removeFromSuperViewOnHide = YES;
		[hud ch_hideAnimated:animated];
	}
    
	return [huds count];
}

+ (CH_INSTANCETYPE)ch_HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (CHProgressHUD *)subview;
        }
    }
    
    return nil;
}

+ (NSArray *)ch_allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:self]) {
			[huds addObject:aView];
		}
	}
    
	return [NSArray arrayWithArray:huds];
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Set default values for properties
		self.animationType = CHProgressHUDAnimationFade;
		self.mode = CHProgressHUDModeIndeterminate;
		self.labelText = nil;
		self.detailsLabelText = nil;
		self.opacity = 0.8f;
		self.color = nil;
		self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
		self.labelColor = [UIColor whiteColor];
		self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
		self.detailsLabelColor = [UIColor whiteColor];
		self.activityIndicatorColor = [UIColor whiteColor];
		self.xOffset = 0.0f;
		self.yOffset = 0.0f;
		self.dimBackground = NO;
		self.margin = 20.0f;
		self.cornerRadius = 10.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.removeFromSuperViewOnHide = NO;
		self.minSize = CGSizeZero;
		self.square = NO;
		self.contentMode = UIViewContentModeCenter;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
		
		[self setupLabels];
		[self updateIndicators];
		[self registerForKVO];
		[self registerForNotifications];
	}
    
	return self;
}

- (instancetype)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithWindow:(UIWindow *)window {
	return [self initWithView:window];
}

- (void)dealloc {
    [self unregisterFromNotifications];
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[color release];
	[indicator release];
	[label release];
	[detailsLabel release];
	[labelText release];
	[detailsLabelText release];
	[graceTimer release];
	[minShowTimer release];
	[showStarted release];
	[customView release];
	[labelFont release];
	[labelColor release];
	[detailsLabelFont release];
	[detailsLabelColor release];
#if NS_BLOCKS_AVAILABLE
	[completionBlock release];
#endif
	[super dealloc];
#endif
}

#pragma mark - Show & hide

- (void)oldmb_showAnimated:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"CHProgressHUD needs to be accessed on the main thread.");
	useAnimation = animated;
    // If the grace time is set postpone the HUD display
    if (self.graceTime > 0.0) {
        NSTimer *newGraceTimer = [NSTimer timerWithTimeInterval:self.graceTime target:self selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:newGraceTimer forMode:NSRunLoopCommonModes];
        self.graceTimer = newGraceTimer;
    } 
    // ... otherwise show the HUD imediately 
    else {
        [self showUsingAnimation:useAnimation];
    }
}

// add by DJ
// ????????????  ?????????????????? ?????????????????????
- (void)ch_showAnimated:(BOOL)animated
{
    [self ch_showAnimated:animated showBackground:YES];
}

- (void)ch_showAnimated:(BOOL)animated showBackground:(BOOL)bShow
{
    if (bShow)
    {
        [self ch_showAnimated:animated showBackground:bShow activityIndicatorColor:nil];
    }
    else
    {
        [self ch_showAnimated:animated showBackground:bShow activityIndicatorColor:[UIColor colorWithWhite:0.5 alpha:0.6]];
    }
}

- (void)ch_showAnimated:(BOOL)animated showBackground:(BOOL)bShow useGray:(BOOL)useGray
{
    if (useGray)
    {
        [self ch_showAnimated:animated showBackground:bShow activityIndicatorColor:[UIColor grayColor]];
    }
    else
    {
        [self ch_showAnimated:animated showBackground:bShow activityIndicatorColor:[UIColor whiteColor]];
    }
}

- (void)ch_showAnimated:(BOOL)animated showBackground:(BOOL)bShow activityIndicatorColor:(nullable UIColor *)acolor
{
    if (bShow)
    {
        [self ch_showAnimated:animated backgroundColor:nil activityIndicatorColor:acolor];
    }
    else
    {
        [self ch_showAnimated:animated backgroundColor:[UIColor clearColor] activityIndicatorColor:acolor];
    }
}

- (void)ch_showAnimated:(BOOL)animated backgroundColor:(nullable UIColor *)bcolor activityIndicatorColor:(nullable UIColor *)acolor
{
    self.mode = CHProgressHUDModeIndeterminate;
    self.labelText = nil;
    self.detailsLabelText = nil;
    
    if (bcolor != nil)
    {
        self.color = bcolor;
    }
    else
    {
        self.color = nil;
    }
    
    if (acolor)
    {
        self.activityIndicatorColor = acolor;
    }
    else
    {
        self.activityIndicatorColor = [UIColor whiteColor];
    }
    
    [self oldmb_showAnimated:animated];
}

// ????????????????????????
- (void)ch_showAnimated:(BOOL)animated withText:(nullable NSString *)text;
{
    [self ch_showAnimated:animated withText:text delay:0];
}

- (void)ch_showAnimated:(BOOL)animated withText:(nullable NSString *)text delay:(NSTimeInterval)delay;
{
    [self ch_showAnimated:animated withText:text detailText:nil backgroudColor:nil delay:delay];
}

- (void)ch_showAnimated:(BOOL)animated withDetailText:(nullable NSString *)detailText
{
    [self ch_showAnimated:animated withDetailText:detailText delay:0];
}

- (void)ch_showAnimated:(BOOL)animated withDetailText:(nullable NSString *)detailText delay:(NSTimeInterval)delay
{
    [self ch_showAnimated:animated withText:nil detailText:detailText backgroudColor:nil delay:delay];
}

- (void)ch_showAnimated:(BOOL)animated withText:(nullable NSString *)text detailText:(nullable NSString *)detailText delay:(NSTimeInterval)delay
{
    [self ch_showAnimated:animated withText:text detailText:detailText backgroudColor:nil delay:delay];
}

- (void)ch_showAnimated:(BOOL)animated withText:(nullable NSString *)text detailText:(nullable NSString *)detailText backgroudColor:(nullable UIColor *)acolor delay:(NSTimeInterval)delay
{
    self.mode = CHProgressHUDModeText;
    self.labelText = text;  
    self.detailsLabelText = detailText;
    self.color = acolor;
    
    [self oldmb_showAnimated:animated];
    
    if (delay > 0)
    {
        [self ch_hideAnimated:animated afterDelay:delay];
    }
}

- (void)ch_hideAnimated:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"CHProgressHUD needs to be accessed on the main thread.");
	useAnimation = animated;
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self 
								selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
			return;
		} 
	}
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:useAnimation];
}

- (void)ch_hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self ch_hideAnimated:[animated boolValue]];
}

#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
    // Show the HUD only if the task is still running
	if (taskInProgress) {
		[self showUsingAnimation:useAnimation];
    }
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - View Hierrarchy

- (void)didMoveToSuperview {
    [self updateForCurrentOrientationAnimated:NO];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
    // Cancel any scheduled hideDelayed: calls
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setNeedsDisplay];

	if (animated && animationType == CHProgressHUDAnimationZoomIn) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
	} else if (animated && animationType == CHProgressHUDAnimationZoomOut) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
	}
	self.showStarted = [NSDate date];
	// Fade in
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		self.alpha = 1.0f;
		if (animationType == CHProgressHUDAnimationZoomIn || animationType == CHProgressHUDAnimationZoomOut) {
			self.transform = rotationTransform;
		}
		[UIView commitAnimations];
	}
	else {
		self.alpha = 1.0f;
	}
}

- (void)hideUsingAnimation:(BOOL)animated {
	// Fade out
	if (animated && showStarted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		// 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
		// in the done method
		if (animationType == CHProgressHUDAnimationZoomIn) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
		} else if (animationType == CHProgressHUDAnimationZoomOut) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
		}

		self.alpha = 0.02f;
		[UIView commitAnimations];
	}
	else {
		self.alpha = 0.0f;
		[self done];
	}
	self.showStarted = nil;
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
	[self done];
}

- (void)done {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	//isFinished = YES;
	self.alpha = 0.0f;
	if (removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
#if NS_BLOCKS_AVAILABLE
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = NULL;
	}
#endif
	if ([delegate respondsToSelector:@selector(ch_hudWasHidden:)]) {
		[delegate performSelector:@selector(ch_hudWasHidden:) withObject:self];
	}

    // ?????????????????????
    [self reset];
}

// ?????????????????????
- (void)reset
{
    self.color = nil;
    self.labelFont = [UIFont boldSystemFontOfSize:kLabelFontSize];
    self.labelColor = [UIColor whiteColor];
    self.detailsLabelFont = [UIFont boldSystemFontOfSize:kDetailsLabelFontSize];
    self.detailsLabelColor = [UIColor whiteColor];
    self.activityIndicatorColor = [UIColor whiteColor];
}

#pragma mark - Threading

- (void)ch_showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	methodForExecution = method;
	targetForExecution = CH_RETAIN(target);
	objectForExecution = CH_RETAIN(object);
	// Launch execution in new thread
	self.taskInProgress = YES;
	[NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	// Show HUD view
	[self oldmb_showAnimated:animated];
}

#if NS_BLOCKS_AVAILABLE

- (void)ch_showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self ch_showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:NULL];
}

- (void)ch_showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)(void))completion {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self ch_showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
}

- (void)ch_showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
	[self ch_showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
}

- (void)ch_showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
	 completionBlock:(CHProgressHUDCompletionBlock)completion {
	self.taskInProgress = YES;
	self.completionBlock = completion;
	dispatch_async(queue, ^(void) {
		block();
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self cleanUp];
		});
	});
	[self oldmb_showAnimated:animated];
}

#endif

- (void)launchExecution {
	@autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		// Start executing the requested task
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
#pragma clang diagnostic pop
		// Task completed, update view in main thread (note: view operations should
		// be done only in the main thread)
		[self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp {
	taskInProgress = NO;
#if !__has_feature(objc_arc)
	[targetForExecution release];
	[objectForExecution release];
#else
	targetForExecution = nil;
	objectForExecution = nil;
#endif
	[self ch_hideAnimated:useAnimation];
}

#pragma mark - UI

- (void)setupLabels {
	label = [[UILabel alloc] initWithFrame:self.bounds];
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = CHLabelAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = self.labelColor;
	label.font = self.labelFont;
	label.text = self.labelText;
	[self addSubview:label];
	
	detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.adjustsFontSizeToFitWidth = NO;
	detailsLabel.textAlignment = CHLabelAlignmentCenter;
	detailsLabel.opaque = NO;
	detailsLabel.backgroundColor = [UIColor clearColor];
	detailsLabel.textColor = self.detailsLabelColor;
	detailsLabel.numberOfLines = 0;
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.text = self.detailsLabelText;
	[self addSubview:detailsLabel];
}

- (void)updateIndicators {
	
	BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
	BOOL isRoundIndicator = [indicator isKindOfClass:[CHRoundProgressView class]];
	
	if (mode == CHProgressHUDModeIndeterminate) {
		if (!isActivityIndicator) {
			// Update to indeterminate indicator
			[indicator removeFromSuperview];
			self.indicator = CH_AUTORELEASE([[UIActivityIndicatorView alloc]
											 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
			[(UIActivityIndicatorView *)indicator startAnimating];
			[self addSubview:indicator];
		}
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
		[(UIActivityIndicatorView *)indicator setColor:self.activityIndicatorColor];
#endif
	}
	else if (mode == CHProgressHUDModeDeterminateHorizontalBar) {
		// Update to bar determinate indicator
		[indicator removeFromSuperview];
		self.indicator = CH_AUTORELEASE([[CHBarProgressView alloc] init]);
		[self addSubview:indicator];
	}
	else if (mode == CHProgressHUDModeDeterminate || mode == CHProgressHUDModeAnnularDeterminate) {
		if (!isRoundIndicator) {
			// Update to determinante indicator
			[indicator removeFromSuperview];
			self.indicator = CH_AUTORELEASE([[CHRoundProgressView alloc] init]);
			[self addSubview:indicator];
		}
		if (mode == CHProgressHUDModeAnnularDeterminate) {
			[(CHRoundProgressView *)indicator setAnnular:YES];
		}
		[(CHRoundProgressView *)indicator setProgressTintColor:self.activityIndicatorColor];
		[(CHRoundProgressView *)indicator setBackgroundTintColor:[self.activityIndicatorColor colorWithAlphaComponent:0.1f]];
	} 
	else if (mode == CHProgressHUDModeCustomView && customView != indicator) {
		// Update custom view indicator
		[indicator removeFromSuperview];
		self.indicator = customView;
		[self addSubview:indicator];
        // LM
        //[indicator centerInSuperView];
	} else if (mode == CHProgressHUDModeText) {
		[indicator removeFromSuperview];
		self.indicator = nil;
	}
}

#pragma mark - Layout

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// Entirely cover the parent view
	UIView *parent = self.superview;
	if (parent) {
		self.frame = parent.bounds;
	}
	CGRect bounds = self.bounds;
	
	// Determine the total width and height needed
	CGFloat maxWidth = bounds.size.width - 4 * margin;
	CGSize totalSize = CGSizeZero;
	
	CGRect indicatorF = indicator.bounds;
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, indicatorF.size.width);
	totalSize.height += indicatorF.size.height;
	
	CGSize labelSize = CH_TEXTSIZE(label.text, label.font);
	labelSize.width = MIN(labelSize.width, maxWidth);
	totalSize.width = MAX(totalSize.width, labelSize.width);
	totalSize.height += labelSize.height;
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		totalSize.height += kPadding;
	}

	CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * margin; 
	CGSize maxSize = CGSizeMake(maxWidth, remainingHeight);
	CGSize detailsLabelSize = CH_MULTILINE_TEXTSIZE(detailsLabel.text, detailsLabel.font, maxSize, detailsLabel.lineBreakMode);
	totalSize.width = MAX(totalSize.width, detailsLabelSize.width);
	totalSize.height += detailsLabelSize.height;
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		totalSize.height += kPadding;
	}
	
	totalSize.width += 2 * margin;
	totalSize.height += 2 * margin;
	
	// Position elements
	CGFloat yPos = round(((bounds.size.height - totalSize.height) / 2)) + margin + yOffset;
	CGFloat xPos = xOffset;
	indicatorF.origin.y = yPos;
	indicatorF.origin.x = round((bounds.size.width - indicatorF.size.width) / 2) + xPos;
	indicator.frame = indicatorF;
	yPos += indicatorF.size.height;
	
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		yPos += kPadding;
	}
	CGRect labelF;
	labelF.origin.y = yPos;
	labelF.origin.x = round((bounds.size.width - labelSize.width) / 2) + xPos;
	labelF.size = labelSize;
	label.frame = labelF;
	yPos += labelF.size.height;
	
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		yPos += kPadding;
	}
	CGRect detailsLabelF;
	detailsLabelF.origin.y = yPos;
	detailsLabelF.origin.x = round((bounds.size.width - detailsLabelSize.width) / 2) + xPos;
	detailsLabelF.size = detailsLabelSize;
	detailsLabel.frame = detailsLabelF;
	
	// Enforce minsize and quare rules
	if (square) {
		CGFloat max = MAX(totalSize.width, totalSize.height);
		if (max <= bounds.size.width - 2 * margin) {
			totalSize.width = max;
		}
		if (max <= bounds.size.height - 2 * margin) {
			totalSize.height = max;
		}
	}
	if (totalSize.width < minSize.width) {
		totalSize.width = minSize.width;
	} 
	if (totalSize.height < minSize.height) {
		totalSize.height = minSize.height;
	}
	
	size = totalSize;
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);

	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}

	// Set background rect color
	if (self.color) {
		CGContextSetFillColorWithColor(context, self.color.CGColor);
	} else {
		CGContextSetGrayFillColor(context, 0.0f, self.opacity);
	}

	
	// Center HUD
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(round((allRect.size.width - size.width) / 2) + self.xOffset,
								round((allRect.size.height - size.height) / 2) + self.yOffset, size.width, size.height);
	float radius = self.cornerRadius;
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);

	UIGraphicsPopContext();
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"mode", @"customView", @"labelText", @"labelFont", @"labelColor",
			@"detailsLabelText", @"detailsLabelFont", @"detailsLabelColor", @"progress", @"activityIndicatorColor", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"] ||
		[keyPath isEqualToString:@"activityIndicatorColor"]) {
		[self updateIndicators];
	} else if ([keyPath isEqualToString:@"labelText"]) {
		label.text = self.labelText;
	} else if ([keyPath isEqualToString:@"labelFont"]) {
		label.font = self.labelFont;
	} else if ([keyPath isEqualToString:@"labelColor"]) {
		label.textColor = self.labelColor;
	} else if ([keyPath isEqualToString:@"detailsLabelText"]) {
		detailsLabel.text = self.detailsLabelText;
	} else if ([keyPath isEqualToString:@"detailsLabelFont"]) {
		detailsLabel.font = self.detailsLabelFont;
	} else if ([keyPath isEqualToString:@"detailsLabelColor"]) {
		detailsLabel.textColor = self.detailsLabelColor;
	} else if ([keyPath isEqualToString:@"progress"]) {
		if ([indicator respondsToSelector:@selector(setProgress:)]) {
			[(id)indicator setValue:@(progress) forKey:@"progress"];
		}
        
		return;
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)registerForNotifications {
#if !TARGET_OS_TV
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	[nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
			   name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
}

- (void)unregisterFromNotifications {
#if !TARGET_OS_TV
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
}

#if !TARGET_OS_TV
- (void)statusBarOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else {
		[self updateForCurrentOrientationAnimated:YES];
	}
}
#endif

- (void)updateForCurrentOrientationAnimated:(BOOL)animated {
    // Stay in sync with the superview in any case
    if (self.superview) {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }

    // Not needed on iOS 8+, compile out when the deployment target allows,
    // to avoid sharedApplication problems on extension targets
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    // Only needed pre iOS 7 when added to a window
    BOOL iOS8OrLater = kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0;
    if (iOS8OrLater || ![self.superview isKindOfClass:[UIWindow class]]) return;

	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; } 
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; } 
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
#endif
}

@end


@implementation CHRoundProgressView

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		_progress = 0.f;
		_annular = NO;
		_progressTintColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
		_backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
		[self registerForKVO];
	}
	return self;
}

- (void)dealloc {
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[_progressTintColor release];
	[_backgroundTintColor release];
	[super dealloc];
#endif
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
	CGRect allRect = self.bounds;
	CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_annular) {
		// Draw background
		BOOL isPreiOS7 = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;
		CGFloat lineWidth = isPreiOS7 ? 5.f : 2.f;
		UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
		processBackgroundPath.lineWidth = lineWidth;
		processBackgroundPath.lineCapStyle = kCGLineCapButt;
		CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		CGFloat radius = (self.bounds.size.width - lineWidth)/2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (2 * (float)M_PI) + startAngle;
		[processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[_backgroundTintColor set];
		[processBackgroundPath stroke];
		// Draw progress
		UIBezierPath *processPath = [UIBezierPath bezierPath];
		processPath.lineCapStyle = isPreiOS7 ? kCGLineCapRound : kCGLineCapSquare;
		processPath.lineWidth = lineWidth;
		endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		[processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[_progressTintColor set];
		[processPath stroke];
	} else {
		// Draw background
		[_progressTintColor setStroke];
		[_backgroundTintColor setFill];
		CGContextSetLineWidth(context, 2.0f);
		CGContextFillEllipseInRect(context, circleRect);
		CGContextStrokeEllipseInRect(context, circleRect);
		// Draw progress
		CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
		CGFloat radius = (allRect.size.width - 4) / 2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		[_progressTintColor setFill];
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"progressTintColor", @"backgroundTintColor", @"progress", @"annular", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end


@implementation CHBarProgressView

#pragma mark - Lifecycle

- (id)init {
	return [self initWithFrame:CGRectMake(.0f, .0f, 120.0f, 20.0f)];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_progress = 0.f;
		_lineColor = [UIColor whiteColor];
		_progressColor = [UIColor whiteColor];
		_progressRemainingColor = [UIColor clearColor];
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		[self registerForKVO];
	}
	return self;
}

- (void)dealloc {
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[_lineColor release];
	[_progressColor release];
	[_progressRemainingColor release];
	[super dealloc];
#endif
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 2);
	CGContextSetStrokeColorWithColor(context,[_lineColor CGColor]);
	CGContextSetFillColorWithColor(context, [_progressRemainingColor CGColor]);
	
	// Draw background
	float radius = (rect.size.height / 2) - 2;
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextFillPath(context);
	
	// Draw border
	CGContextMoveToPoint(context, 2, rect.size.height/2);
	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
	CGContextStrokePath(context);
	
	CGContextSetFillColorWithColor(context, [_progressColor CGColor]);
	radius = radius - 2;
	float amount = self.progress * rect.size.width;
	
	// Progress in the middle area
	if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, amount, 4);
		CGContextAddLineToPoint(context, amount, radius + 4);
		
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, amount, rect.size.height - 4);
		CGContextAddLineToPoint(context, amount, radius + 4);
		
		CGContextFillPath(context);
	}
	
	// Progress in the right arc
	else if (amount > radius + 4) {
		float x = amount - (rect.size.width - radius - 4);

		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
		float angle = -acos(x/radius);
		if (isnan(angle)) angle = 0;
		CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, M_PI, angle, 0);
		CGContextAddLineToPoint(context, amount, rect.size.height/2);

		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
		angle = acos(x/radius);
		if (isnan(angle)) angle = 0;
		CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, -M_PI, angle, 1);
		CGContextAddLineToPoint(context, amount, rect.size.height/2);
		
		CGContextFillPath(context);
	}
	
	// Progress is in the left arc
	else if (amount < radius + 4 && amount > 0) {
		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);

		CGContextMoveToPoint(context, 4, rect.size.height/2);
		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
		
		CGContextFillPath(context);
	}
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"lineColor", @"progressRemainingColor", @"progressColor", @"progress", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end
