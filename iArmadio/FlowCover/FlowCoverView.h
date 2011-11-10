#import <UIKit/UIKit.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "DataCache.h"

@protocol FlowCoverViewDelegate;

/*	FlowCoverView
 *
 *		The flow cover view class; this is a drop-in view which calls into
 *	a delegate callback which controls the contents. This emulates the CoverFlow
 *	thingy from Apple.
 */

@interface FlowCoverView : UIView 
{
	// Current state support
	double offset;
	
	NSTimer *timer;
	double startTime;
	double startOff;
	double startPos;
	double startSpeed;
	double runDelta;
	BOOL touchFlag;
	CGPoint startTouch;
	
	double lastPos;
	
	// Delegate
	IBOutlet id<FlowCoverViewDelegate> delegate;
	
	DataCache *cache;
	
	// OpenGL ES support
    GLint backingWidth;
    GLint backingHeight;
    EAGLContext *context;
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
}

@property (assign,nonatomic) IBOutlet id<FlowCoverViewDelegate> delegate;

- (void)draw;					// Draw the FlowCover view with current state
- (void) emptyCache;

@end

/*	FlowCoverViewDelegate
 *
 *		Provides the interface for the delegate used by my flow cover. This
 *	provides a way for me to get the image, to get the total number of images,
 *	and to send a select message
 */

@protocol FlowCoverViewDelegate <NSObject>
- (int)flowCoverNumberImages:(FlowCoverView *)view;
- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)cover;
- (void)flowCover:(FlowCoverView *)view didSelect:(int)cover;

@end
