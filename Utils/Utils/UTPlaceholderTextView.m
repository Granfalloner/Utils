//
//  UTPlaceholderTextView.m
//  Utils
//
//  Created by granfalloner on 11/26/13.
//  Copyright (c) 2013 granfalloner. All rights reserved.
//

#import "UTPlaceholderTextView.h"

@interface UTPlaceholderTextView ()
{
	UIColor *_placeholderColor;
}

@property (nonatomic, readwrite) BOOL showsPlaceholder;
@property (nonatomic, strong) UIColor *previousTextColor;

@end

@implementation UTPlaceholderTextView

#pragma mark - NSObject

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (nil != self)
	{
		[self initialize];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (nil != self)
	{
		[self initialize];
	}
	
	return self;
}

#pragma mark - UITextView

- (NSString *)text
{
	NSString *result = self.showsPlaceholder ? nil : super.text;
	return result;
}

- (void)setText:(NSString *)text
{
	[self hidePlaceholder];
	super.text = text;
	[self showPlaceholderIfNeeded];
}

- (UIColor *)textColor
{
	UIColor *result = self.showsPlaceholder ? self.previousTextColor : super.textColor;
	return result;
}

- (void)setTextColor:(UIColor *)textColor
{
	if (self.showsPlaceholder)
	{
		self.previousTextColor = textColor;
	}
	else
	{
		super.textColor = textColor;
	}
}

#pragma mark - Public

- (void)setPlaceholder:(NSString *)placeholder
{
	[self hidePlaceholder];
	_placeholder = [placeholder copy];
	[self showPlaceholderIfNeeded];
}

- (UIColor *)placeholderColor
{
	if (nil == _placeholderColor)
	{
		_placeholderColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
	}
	
	return _placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
	_placeholderColor = placeholderColor;
	
	if (self.showsPlaceholder)
	{
		super.textColor = _placeholderColor;
	}
}

#pragma mark - Private

- (void)initialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing) name:UITextViewTextDidBeginEditingNotification object:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing) name:UITextViewTextDidEndEditingNotification object:self];
}

- (void)didBeginEditing
{
	[self hidePlaceholder];
}

- (void)didEndEditing
{
	[self showPlaceholderIfNeeded];
}

- (void)showPlaceholderIfNeeded
{
	if (0 == [self.text length] && [self.placeholder length] > 0 && !self.showsPlaceholder)
	{
		super.text = self.placeholder;
		self.previousTextColor = self.textColor;
		super.textColor = self.placeholderColor;
		self.showsPlaceholder = YES;
	}
}

- (void)hidePlaceholder
{
	if (self.showsPlaceholder)
	{
		super.text = nil;
		super.textColor = self.previousTextColor;
		self.showsPlaceholder = NO;
	}
}

@end
