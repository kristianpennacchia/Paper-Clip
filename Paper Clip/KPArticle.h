//
//  KPArticle.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPArticle : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dict;   // Contains the data for article from RSS (except complete article text)
@property (nonatomic, strong) NSString *title;  // Title of the article
@property (nonatomic, strong) NSString *previewText;    // Called contentSnippet in API responseData
@property (nonatomic, strong) NSString *content;    // A larger preview of the article
@property (nonatomic, strong) NSString *completeText;   // Have to fetch the whole article manually
@property (nonatomic, strong) NSString *author; // Author of the article
@property (nonatomic, strong) NSString *date;   // Called publishedDate in API responseData
@property (nonatomic, strong) NSString *time;   // The time the article was published
@property (nonatomic, strong) NSString *timezone;   // The timezone the date and time are displayed in
@property (nonatomic, strong) NSString *link;   // Link to the full article on the website
@property (nonatomic) BOOL isArticleLoaded;   // Specifies whether the article has already been downloaded or not

- (id)initWithDictionary:(NSDictionary *)dict;

@end
