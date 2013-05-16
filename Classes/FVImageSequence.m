//
//  FVImageSequence.m
//  Untitled
//
//  Created by Fernando Valente on 12/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FVImageSequence.h"

@implementation FVImageSequence
{
    CGFloat _currentSpeed;
    NSTimer *_timer;
    CGFloat _speed;
    NSTimeInterval _interval;
    NSTimeInterval _dInterval;
}
@synthesize prefix, numberOfImages, extension, increment;



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_timer invalidate]; [_timer release]; _timer = nil;
    NSLog(@"timer invalidated %d", current);
	if(increment == 0)
		increment = 1;
	[super touchesBegan:touches withEvent:event];
	
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
	
	previous = touchLocation.y;
}

- (void)update {
    NSString *path = [NSString stringWithFormat:@"%@%d", prefix, current];
	NSLog(@"%@", path);
	
	path = [[NSBundle mainBundle] pathForResource:path ofType:extension];
	
	
	UIImage *img =  [[UIImage alloc] initWithContentsOfFile:path];
	
	[self setImage:img];
	
	[img release];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
	
	int location = touchLocation.y;
    CGFloat diff = location - previous;
    _speed = diff / (event.timestamp - previousTimestamp);

    
	if(location < previous)
		current += increment;
	else
		current -= increment;
	
	previous = location;
	previousTimestamp = event.timestamp;
    
	if(current >= numberOfImages)
		current = 0;
	if(current < 0)
		current = numberOfImages - 1;
	
	[self update];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    _interval = 0.01;
    _dInterval = 0.0002;
    _timer =  [[NSTimer scheduledTimerWithTimeInterval:_interval
                                                target:self
                                              selector:@selector(onTimer:)
                                              userInfo:nil
                                               repeats:NO] retain];
    [_timer fire];
}

- (void)onTimer:(NSTimer *)timer
{
    if (_speed > 0) { current -= 1; } else { current += 1; }
    
    if(current >= numberOfImages)
		current = 0;
	if(current < 0)
		current = numberOfImages - 1;
    NSLog(@"onTimer: set current to: %d", current);
    [self update];
    
    _interval += _dInterval;
    _dInterval *= 1.01;
    if (_interval < 0.2) {
        [_timer release];
        _timer =  [[NSTimer scheduledTimerWithTimeInterval:_interval
                                                    target:self
                                                  selector:@selector(onTimer:)
                                                  userInfo:nil
                                                   repeats:NO] retain];
    }
}

-(void)dealloc{
	[extension release];
	[prefix release];
	[super dealloc];
}

@end
