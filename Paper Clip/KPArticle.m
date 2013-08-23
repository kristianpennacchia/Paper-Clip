//
//  KPArticle.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPArticle.h"

@interface KPArticle ()
@property (nonatomic, strong, readwrite) NSDictionary *dict;
@end

@implementation KPArticle

// When saving data to a file, you should just save the dictionary.
// Then when you recreate/load the data you would just call initWithDictionary:
// on each KPArticle (there will be an array of KPArticle) and feed it the
// dictionary data that was saved. You would give it the dictionary that
// corresponds with the index number of the NSArray that the KPArticle is in.
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.dict = dict;
        
        self.title = [self.dict valueForKey:@"title"];
        self.author = [self.dict valueForKey:@"author"];
        self.link = [self.dict valueForKey:@"link"];
        
        // Need to strip the '\n's that are at the start of contentSnippet
        NSString *string = [self.dict valueForKey:@"contentSnippet"];
        self.previewText =  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.content = [self.dict valueForKey:@"content"];
        self.completeText = @"";
        
        // Seperate date, time and timezone
        // Date example: Sat, 10 Aug 2013 04:03:04 -0700
        // The first 4 components (0-3) of the string are the date
        // The next 1 component (4) is the time
        // The last component (5) is the timezone
        NSString *fullDate = [self.dict valueForKey:@"publishedDate"];
        NSArray *dateComponents = [fullDate componentsSeparatedByString:@" "];
        NSMutableString *date = [[NSMutableString alloc] init];
        int i;
        for (i = 0; i < 4; ++i) {
            [date appendFormat:@"%@ ", [dateComponents objectAtIndex:i ]];
        }
        
        // TODO: Localise date and time (use the timezone to accomplish this)
        self.date = date;
        self.time = [dateComponents objectAtIndex:i];
        self.timezone = [dateComponents lastObject];
    }
    return self;
}

@end
