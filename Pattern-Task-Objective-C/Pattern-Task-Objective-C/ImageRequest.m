//
//  ImageRequest.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 07/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "ImageRequest.h"


@interface ImageRequest ()

@property (nonatomic,strong)NSString *url; /**< URL запрос к сервису в строке */
@property (nonatomic,assign)NSInteger number; /**< Номер изображения */

@end


@implementation ImageRequest

/**
 Инициализатор модели запроса
 
 @param url URL запроса
 @param number Номер изображения
 @return Обьект запроса к сервису
 */
+ (instancetype) initRequestWithUrl:(NSString*)url forNumber:(NSInteger)number
{
	ImageRequest *request = [ImageRequest new];
	request.number = number;
	request.url = url;
	return request;
}

/**
 Получение URL строки
 
 @return URL строка
 */
- (NSString *) getURLString
{
	return self.url;
}

/**
 Получение Номера изображения
 
 @return Номер
 */
- (NSInteger) getNumber
{
	return self.number;
}

@end
