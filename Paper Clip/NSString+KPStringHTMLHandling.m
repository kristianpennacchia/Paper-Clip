//
//  NSString+KPStringHTMLHandling.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 11/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "NSString+KPStringHTMLHandling.h"

@implementation NSString (KPStringHTMLHandling)

// Based on code by Dan J from stackoverflow.com
// http://stackoverflow.com/a/12115786
+ (id)stringByStrippingHTML:(NSString *)aString
{
    NSMutableString *outString;
    
    // Check if aString is valid (has been allocated and initialized)
    if (aString) {
        outString = [[NSMutableString alloc] initWithString:aString];
        
        // Make sure aString has data in it. If it doesn't, no point doing anything with it
        if ([aString length] > 0) {
            NSRange r;
            
            // "<[^>]+>" regex means to find '<' and then if the next characters are
            // either '^' or '>', find everything after that first '<' until
            // you find a '>'
            
            // If a <p> (paragraph) tag is detected, replace it with newline (\n)
            while ((r = [outString rangeOfString:@"<p>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString replaceCharactersInRange:r withString:@"\n"];
            }
            
            // TODO: Add support for creating links from the HTML link tags
            // Example: <a target="_blank" href="http://www.nytimes.com/2013/08/11/magazine/the-weather-god-of-oklahoma-city.html?pagewanted=all">
            
            /*
            / TODO: Add support for creating images from the HTML link tags
            while ((r = [outString rangeOfString:@"<[img>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                // Get the url, then create an UIImageView using that URL and place that UIImageView at the location
                // retrieved from rangeOfString: which is now in the 'r' variable.
                [outString replaceCharactersInRange:r withString:@"\n"];
            }
             */
            
            // Remove all other tags
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }      
        }
    }
    
    return outString; 
}

@end
