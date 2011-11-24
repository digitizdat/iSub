//
//  EqualizerView.m
//  iSub
//
//  Created by Ben Baron on 11/19/11.
//  Copyright (c) 2011 Ben Baron. All rights reserved.
//

#import "EqualizerView.h"
#import "BassParamEqValue.h"

@implementation EqualizerView
@synthesize parentSize;
@synthesize position, handle;

- (id)initWithCGPoint:(CGPoint)point parentSize:(CGSize)size
{	
	self = [super initWithFrame:CGRectMake(0, 0, myWidth, myHeight)];
    if (self) 
	{
		parentSize = size;
		self.center = point;
		
		position.x = point.x / parentSize.width;
		position.y = point.y / parentSize.height;
		handle = 0;
		
		self.image = [UIImage imageNamed:@"eqView.png"];
		
		self.userInteractionEnabled = YES;
		
		BASS_DX8_PARAMEQ p = BASS_DX8_PARAMEQMake(self.frequency, self.gain, DEFAULT_BANDWIDTH);
		eqValue = [[BassParamEqValue alloc] initWithParameters:p];
    }
    return self;
}

- (CGFloat)percentXFromFrequency:(NSUInteger)frequency
{
	return (log2(frequency) - 5) / 9;
}

- (CGFloat)percentYFromGain:(CGFloat)gain
{
	return .5 - (gain / (CGFloat)(MAX_GAIN * 2));
}

- (id)initWithEqValue:(BassParamEqValue *)value parentSize:(CGSize)size
{
	self = [super initWithFrame:CGRectMake(0, 0, myWidth, myHeight)];
    if (self)
	{		
		parentSize = size;
		
		CGFloat x = parentSize.width * [self percentXFromFrequency:value.parameters.fCenter];
		CGFloat y = parentSize.height * [self percentYFromGain:value.parameters.fGain];
		self.center = CGPointMake(x, y);
		
        position.x = [self percentXFromFrequency:value.parameters.fCenter];
		position.y = [self percentYFromGain:value.parameters.fGain];
		
		self.image = [UIImage imageNamed:@"eqView.png"];
		
		self.userInteractionEnabled = YES;
		
		eqValue = [value retain];
    }
    return self;
}

- (void)setCenter:(CGPoint)center
{
	[super setCenter:center];
	
	position.x = self.center.x / parentSize.width;
	position.y = self.center.y / parentSize.height;
}

- (NSUInteger)frequency
{
	return exp2f((position.x * RANGE_OF_EXPONENTS) + 5);
}

- (CGFloat)gain
{
	return (.5 - position.y) * (CGFloat)(MAX_GAIN * 2);
}

- (HFX)handle
{
	return eqValue.handle;
}

- (void)setEqValue:(BassParamEqValue *)value
{
	[eqValue release]; 
	eqValue = [value retain];
}

- (BassParamEqValue *)eqValue
{
	eqValue.gain = self.gain;
	eqValue.frequency = self.frequency;
	eqValue.bandwidth = DEFAULT_BANDWIDTH;
	
	return eqValue;
}

- (void)dealloc
{
	[eqValue release]; eqValue = nil;
	[super dealloc];
}

/*CGFloat percentXFromFrequency(NSUInteger frequency)
{
	return (log2(frequency) - 5) / 9;
}

CGFloat percentYFromGain(CGFloat gain)
{
	return .5 - (gain / (CGFloat)(MAX_GAIN * 2));
}
 
CGPoint CGPointMakeFromEqValues(NSUInteger frequency, CGFloat gain)
{
	return CGPointMake(percentXFromFrequency(frequency), percentYFromGain(gain));
}*/

@end