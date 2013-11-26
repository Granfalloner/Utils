//
//  UTPlaceholderTextView.h
//  Utils
//
//  Created by granfalloner on 11/26/13.
//  Copyright (c) 2013 granfalloner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTPlaceholderTextView : UITextView

@property (nonatomic, readonly) BOOL showsPlaceholder;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor; // Default color is the same as in UITextField

@end
