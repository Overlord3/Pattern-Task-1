//
//  ImageRequest.h
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 07/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface ImageRequest : NSObject

/**
 Инициализатор модели запроса
 
 @param url URL запроса
 @param number Номер изображения
 @return Обьект запроса к сервису
 */
+ (instancetype) initRequestWithUrl:(NSString*)url forNumber:(NSInteger)number;

/**
 Получение URL строки
 
 @return URL строка
 */
- (NSString *) getURLString;

/**
 Получение Номера изображения
 
 @return Номер
 */
- (NSInteger) getNumber;

@end

NS_ASSUME_NONNULL_END
