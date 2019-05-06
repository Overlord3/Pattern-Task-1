//
//  DefinitionTableViewCell.h
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 07/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface DefinitionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *definitionLabel;
@property (nonatomic, strong) UILabel *exampleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *dateLabel;


/**
 Функция для вычисления высоты ячейки, на основе параметров
 
 @param definition Текст определения
 @param example Текст примера
 @param author Текст автора
 @param date Текст даты
 @return Высота ячейки
 */
+ (CGFloat)calculateHeightWithDefinition:(NSString *)definition example:(NSString *)example author:(NSString *)author date:(NSString *)date;

@end

NS_ASSUME_NONNULL_END
