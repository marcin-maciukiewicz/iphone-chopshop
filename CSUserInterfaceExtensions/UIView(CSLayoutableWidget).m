//
//  UIView(CSLayoutableWidget).m
//  CSUserInterfaceExtensions
//
//  Created by Marcin Maciukiewicz on 25/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView(CSLayoutableWidget).h"

@implementation UIView(CSLayoutableWidget)

-(CGSize)preferredSize {
	CGSize result=self.frame.size;
	return result;
}

//-(void)setFrame:(CGRect)newFrame {
//	[super setFrame:newFrame];
//}
//
//-(CGRect)frame {
//	return [super frame];
//}

@end
