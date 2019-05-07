//
//  NetworkHelper.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 07/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "NetworkHelper.h"


@implementation NetworkHelper

/**
 Получение URL с запросом к сервису с текстом поиска
 
 @param searchString текст поиска
 @param page страница, с 1
 @return URL в строке
 */
+ (NSString *)URLForSearchString:(NSString *)searchString andPage:(NSInteger)page
{
	//Ключ работает, проверено
	NSString *APIKey = @"5553e0626e5d3a905df9a76df1383d98";
	return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=20&format=json&nojsoncallback=1&page=%lu", APIKey, searchString, page];
}

@end
