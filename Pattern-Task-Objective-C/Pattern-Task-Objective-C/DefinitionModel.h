//
//  DefinitionModel.h
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface DefinitionModel : NSObject

/**
 Инициализатор модели определения
 
 @param definition Текст определения
 @param author Имя автора
 @param date Дата
 @param example Пример использования
 @return Модель определения
 */
+ (instancetype) initWithDefinition:(NSString *)definition author:(NSString *)author date:(NSDate *)date example:(NSString *)example;


/**
 Метод, для получения текста определения
 
 @return текст определения
 */
- (NSString *)getDefinition;

/**
 Метод, для получения имени автора
 
 @return имя автора
 */
- (NSString *)getAuthor;

/**
 Метод, для получения даты
 
 @return дата
 */
- (NSDate *)getDate;

/**
 Метод, для получения текста даты
 
 @return текст даты, отформатированный
 */
- (NSString *)getDateText;

/**
 Метод, для получения текста использования
 
 @return текст примера использования
 */
- (NSString *)getExample;

@end

NS_ASSUME_NONNULL_END
