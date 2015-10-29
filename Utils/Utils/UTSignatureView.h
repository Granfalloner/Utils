//
//  UTSignatureView.h
//  Utils
//
//  Created by Vasyl Myronchuk on 10/29/15.
//  Copyright © 2015 Vasyl Myronchuk. All rights reserved.
//
//  Incorporated simple but appealingly looking solution for user hand-signature
//  ( https://www.altamiracorp.com/blog/employee-posts/capture-a-signature-on-ios )
//

#import <UIKit/UIKit.h>

@interface UTSignatureView : UIView

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) UIColor *signatureColor; // Default is black

@property (nonatomic, readonly) BOOL hasSignature;

@property (nonatomic, readonly) UIBezierPath *signaturePath;
@property (nonatomic, readonly) UIImage *signatureImage;
@property (nonatomic, readonly) NSData *signatureImageData; // Returns PNG representation

- (void)clear;

@end
