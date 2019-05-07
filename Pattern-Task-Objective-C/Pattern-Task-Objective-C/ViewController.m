//
//  ViewController.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "ViewController.h"
#import "NetworkService.h"
#import "DefinitionTableViewCell.h"
#import "ImageTableViewCell.h"


@interface ViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView; /**< UI для отображения результатов поиска */
@property (nonatomic, strong) UISearchBar *searchBar; /**< UI для поиска определений и изображений  */

@property (nonatomic, strong) WordModel *wordModel; /**< Слово с определениями для отображения */
@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray; /**< Массив данных картинок */
@property (nonatomic, strong) NetworkService *networkService; /**< Сервис для взаимодействия с сетью */

@end


@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self prepareModels];
	[self prepareUI];
	[self.tableView registerClass:DefinitionTableViewCell.class forCellReuseIdentifier:DefinitionTableViewCell.description];
	[self.tableView registerClass:ImageTableViewCell.class forCellReuseIdentifier:ImageTableViewCell.description];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.title = @"Поиск определений слов";
}

- (void)prepareModels
{
	self.imagesArray = [NSMutableArray new];
	self.networkService = [NetworkService initService];
	self.networkService.outputDelegate = self;
}

- (void)prepareUI
{
	self.view.backgroundColor = UIColor.whiteColor;
	//Отступ сверху для навигейшн бара
	CGFloat topInset = CGRectGetMaxY(self.navigationController.navigationBar.frame);
	CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
	CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
	
	//Инициализация серч бара
	CGFloat searchBarHeight = 50;
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, topInset, screenWidth, searchBarHeight)];
	[self.searchBar setPlaceholder:@"Введите слово для поиска (англ.)"];
	self.searchBar.delegate = self;
	[self.view addSubview:self.searchBar];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), screenWidth, screenHeight - searchBarHeight) style:UITableViewStylePlain];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	[self.view addSubview:self.tableView];
}


#pragma UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	//скрыть клавиатуру
	[searchBar resignFirstResponder];
	
	//Удалить все с прошлого поиска
	[self.tableView setContentOffset:CGPointZero animated:YES];
	[self.imagesArray removeAllObjects];
	[self setArraySize:10];
	
	//Вызвать поиск
	[self.networkService searchDefinitionsForString:searchBar.text];
	[self.networkService searchImagesForString:searchBar.text andPage:1];
}


#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.wordModel.definitions.count + self.imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.wordModel.definitions.count)
	{
		DefinitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DefinitionTableViewCell.description forIndexPath:indexPath];
		
		DefinitionModel *model = self.wordModel.definitions[indexPath.row];
		
		cell.definitionLabel.text = [model getDefinition];
		cell.exampleLabel.text = [model getExample];
		cell.authorLabel.text = [model getAuthor];
		cell.dateLabel.text = [model getDate].description;
		
		return cell;
	}
	else
	{
		ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageTableViewCell.description forIndexPath:indexPath];
		
		cell.customImageView.image = self.imagesArray[indexPath.row - self.wordModel.definitions.count];
		return cell;
	}
}


#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.wordModel.definitions.count)
	{
		DefinitionModel *model = self.wordModel.definitions[indexPath.row];
		CGFloat height = [DefinitionTableViewCell
						  calculateHeightWithDefinition:[model getDefinition]
						  example:[model getExample]
						  author:[model getAuthor]
						  date:[model getDate].description];
		return height;
	}
	else
	{
		//Для ячейки с картинкой 250 и по 8 границы
		return 250+16;
	}
}

/**
 Возвращает данные в презентер, когда запрос выполнен
 
 @param word Определения к найденному слову
 */
- (void)searchingFinishedWithWord:(WordModel *)word
{
	self.wordModel = word;
	[self.tableView reloadData];
}

/**
 Задает размер массива с изображениями и количество ячеек в коллекшн вью
 
 @param count размер массива
 */
- (void)prepareArrayForImagesCount:(NSInteger)count
{
	[self setArraySize:count];
}


/**
 Увеличивает размер массива, если необходимо до count

 @param count количество элементов в массиве
 */
- (void)setArraySize:(NSInteger)count
{
	while (self.imagesArray.count < count)
	{
		[self.imagesArray addObject:[UIImage new]];
	}
	[self.tableView reloadData];
}

/**
 Устанавливает картинку в массив
 
 @param imageData Данные изображения
 @param number Индекс в массиве
 */
- (void)loadingImageFinishedWith:(NSData *)imageData atNumber:(NSInteger)number
{
	UIImage *image = [UIImage imageWithData:imageData];
	
	//Проверка, что изображение успешно получено
	if (!image) { return; }
	
	[self.imagesArray setObject:[UIImage imageWithData:imageData] atIndexedSubscript:number];
	[self.tableView reloadData];
}

@end
