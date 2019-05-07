//
//  NetworkServiceProtocol.h
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WordModel.h"
#import "DefinitionModel.h"


/**
 Протокол для вывода результатов работы сервиса
 */
@protocol NetworkServiceOutputProtocol <NSObject>

/**
 Возвращает данные в презентер, когда запрос выполнен
 
 @param word Определения к найденному слову
 */
- (void)searchingFinishedWithWord:(WordModel *)word;

/**
 Уведомляет View, когда загрузка завершена
 
 @param imageData Данные изображения
 @param number Номер этого изображения (ячейка)
 */
- (void)loadingImageFinishedWith:(NSData*)imageData atNumber:(NSInteger)number;

/**
 Сообщает сколько всего изображений будет, чтобы подготовить массив (так как изображения могут прийти в любом порядке)
 
 @param count Количество изображений
 */
- (void)prepareArrayForImagesCount:(NSInteger)count;

@end


/**
 Протокол для функций сервиса
 */
@protocol NetworkServiceInputProtocol <NSObject>

/**
 Поиск определений слов в сервисе
 
 @param searchString Строка поиска, на английском обязательно
 */
- (void)searchDefinitionsForString:(NSString *)searchString;

/**
 Поиск изображений в сервисе
 
 @param searchSrting Строка поиска, на английском обязательно
 @param page Номер страницы, с 1
 */
- (void)searchImagesForString:(NSString *)searchSrting andPage:(NSInteger)page;

@end
