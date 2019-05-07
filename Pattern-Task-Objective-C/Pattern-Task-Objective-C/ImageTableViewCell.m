//
//  ImageTableViewCell.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 07/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "ImageTableViewCell.h"


@implementation ImageTableViewCell

/**
 Инициализатор ячейки
 
 @param style стиль
 @param reuseIdentifier идентификатор
 @return экземпляр класса ячейки
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	_customImageView = [UIImageView new];
	return self;
}

/**
 Расстановка элементов UI в ячейке
 */
- (void)layoutSubviews
{
	//Всего высота - 250
	[super layoutSubviews];
	//Допустим такое расположение:
	//Определение, ниже пример, ниже автор и дата помельче
	CGFloat height = 250+16;
	CGFloat width = self.bounds.size.width;
	CGFloat leftRightBorder = (width - 250)/2;
	CGFloat border = 8;
	
	self.customImageView.frame = CGRectMake(leftRightBorder, border, width - leftRightBorder*2, height - border*2);
	self.customImageView.backgroundColor = UIColor.redColor;
	[self.contentView addSubview:self.customImageView];
}

@end
