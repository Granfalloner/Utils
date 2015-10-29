//
//  UTSignatureView.m
//  Utils
//
//  Created by Vasyl Myronchuk on 10/29/15.
//  Copyright © 2015 Vasyl Myronchuk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UTSignatureView.h"


static CGPoint middlePoint(CGPoint p0, CGPoint p1)
{
    return CGPointMake(0.5 * (p0.x + p1.x), 0.5 * (p0.y + p1.y));
}


@interface UTSignatureView ()
{
    UIBezierPath *path;
    CGPoint previousPoint;
    UILabel *placeholderLabel;
}

@end


@implementation UTSignatureView

#pragma mark - Init -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (void)commonInit
{
    self.placeholderLabel.frame = self.bounds;
    [self addSubview:self.placeholderLabel];
    
    self.signatureColor = [UIColor blackColor];
    path = [UIBezierPath bezierPath];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clear)];
    [self addGestureRecognizer:longPressRecognizer];
}

#pragma mark - Accessors -

- (UILabel *)placeholderLabel
{
    if (!placeholderLabel)
    {
        placeholderLabel = [UILabel new];
        placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    return placeholderLabel;
}

- (BOOL)hasSignature {
    return !path.empty;
}

- (UIBezierPath *)signaturePath
{
    return [path copy];
}

- (UIImage *)signatureImage
{
    // Scale bounds to create bigger image
    CGRect bounds = self.bounds;
    bounds.size.width *= 3;
    bounds.size.height *= 3;
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, bounds);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextScaleCTM(context, 3, 3);
    [path stroke];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return signatureImage;
}

- (NSData *)signatureImageData
{
    return UIImagePNGRepresentation(self.signatureImage);
}

#pragma mark - Actions -

- (void)clear
{
    path = [UIBezierPath bezierPath];
    self.placeholderLabel.hidden = NO;
    [self setNeedsDisplay];
}

#pragma mark - Private -

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint currentPoint = [panGestureRecognizer locationInView:self];
    CGPoint midPoint = middlePoint(previousPoint, currentPoint);
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [path moveToPoint:currentPoint];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    }
    
    self.placeholderLabel.hidden = !path.empty;
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.signatureColor setStroke];
    [path stroke];
}

@end
