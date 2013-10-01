//
//  KPArticleRepository.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KPTableViewController;
@class KPArticle;

@interface KPArticleRepository : NSObject
{
    KPTableViewController *viewController;
}

- (void)fetchArticlesWithParent:(UIViewController *)controller fromURL:(NSString *)url;
- (void)fetchArticleContentWithParent:(UIViewController *)controller forArticle:(KPArticle *)article atIndex:(NSInteger)index;
- (BOOL)validateRSS:(NSString *)feed;

@end