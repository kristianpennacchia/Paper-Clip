//
//  NSString+KPStringHTMLHandling.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 11/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KPStringHTMLHandling)

+ (NSString *)stringByStrippingHTML:(NSString *)aString;

@end
