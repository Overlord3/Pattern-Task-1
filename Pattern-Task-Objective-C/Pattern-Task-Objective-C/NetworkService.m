//
//  NetworkService.m
//  Pattern-Task-Objective-C
//
//  Created by Александр Плесовских on 06/05/2019.
//  Copyright © 2019 Alex. All rights reserved.
//


#import "NetworkService.h"
#import "DefinitionModel.h"
#import "ImageRequest.h"
#import "NetworkHelper.h"


const NSInteger imagesPerPage = 10;


@interface NetworkService ()

@property (nonatomic, strong) NSURLSession *urlSession; /**< Сессия */
@property (nonatomic, strong) NSMutableArray<NSURLSessionDownloadTask *> *downloadTasksArray; /**< Массив для заданий подгрузки картинок, нужен для отмены заданий */

@end


@implementation NetworkService


#pragma Initialization

/**
 Инициализатор сервиса
 Проинициализирует все необходимые свойства и настроит сессию
 
 @return экземпляр класса NetworkService
 */
+ (instancetype)initService
{
	NetworkService *service = [NetworkService new];
	[service configureUrlSession];
	service.downloadTasksArray = [NSMutableArray new];
	return service;
}


/**
 Настраивает URL сессию.
 */
- (void)configureUrlSession
{
	NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
	
	// Настраиваем Session Configuration
	[sessionConfiguration setAllowsCellularAccess:YES];
	[sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
	
	// Создаем сессию
	self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}


#pragma Find Definitions

/**
 Поиск определений слов в сервисе
 
 @param searchString Строка поиска, на английском обязательно
 */
- (void)searchDefinitionsForString:(NSString *)searchString;
{
	NSString *urlString = [NSString stringWithFormat: @"http://api.urbandictionary.com/v0/define?term=%@", searchString];
	//http://api.urbandictionary.com/v0/define?term={word}
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setTimeoutInterval:15];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	
	NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		//Получим список
		NSArray<NSDictionary *> *definitions = dict[@"list"];
		//Создадим модель для слова
		WordModel *wordModel = [WordModel new];
		wordModel.word = searchString;
		
		for(NSDictionary *dict in definitions)
		{
			NSString *definitionString = dict[@"definition"];
			definitionString = [self replaceBracketsInString:definitionString];
			
			NSString *authorString = dict[@"author"];
			authorString = [self replaceBracketsInString:authorString];
			
			NSString *exampleString = dict[@"example"];
			exampleString = [self replaceBracketsInString:exampleString];
			
			//Получаем дату, используем форматтер
			//"written_on": "2012-07-19T00:00:00.000Z",
			NSString *dateString = dict[@"written_on"];
			NSDateFormatter *dateFormatter = [NSDateFormatter new];
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
			NSDate *date = [dateFormatter dateFromString:dateString];
			
			
			//Инициализация определения с параметрами
			DefinitionModel *definition = [DefinitionModel
										   initWithDefinition:definitionString
										   author:authorString
										   date:date
										   example:exampleString];
			
			//Добавим определение в слово
			[wordModel.definitions addObject:definition];
		}
		// Отправим сообщение с данными на главный поток, для обновления UI
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.outputDelegate searchingFinishedWithWord:wordModel];
		});
	}];
	[sessionDataTask resume];
}

/**
 Вспомогательная функция для удаления квадратных скобок из строки.
 
 @param string Входная строка со скобками
 @return Строка без скобок
 */
- (NSString *) replaceBracketsInString:(NSString *)string
{
	string = [string stringByReplacingOccurrencesOfString:@"[" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"]" withString:@""];
	return string;
}


#pragma Find Images

/**
 Загружает изображение по запросу
 
 @param request Модель запроса
 @param number Номер изображения, для View потом нужен
 */
- (void)loadImageFromRequest:(ImageRequest*) request atNumber:(NSInteger)number;
{
	if (!self.urlSession)
	{
		NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
		self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
	}
	
	NSURL *url = [NSURL URLWithString:[request getURLString]];
	NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
	   {
		   //Получили данные
		   NSData *data = [NSData dataWithContentsOfURL:location];
		   
		   dispatch_async(dispatch_get_main_queue(), ^{
			   // Отсюда отправим сообщение на обновление UI с главного потока
			   [self.outputDelegate loadingImageFinishedWith:data atNumber:number];
		   });
	   }];
	
	[self.downloadTasksArray addObject:downloadTask];
	
	[downloadTask resume];
}

- (void)cancelCurrentDownloadTasks
{
	for (NSURLSessionDownloadTask *task in self.downloadTasksArray)
	{
		if (task.state == NSURLSessionTaskStateRunning)
		{
			[task cancel];
		}
	}
	[self.downloadTasksArray removeAllObjects];
}

- (void)searchImagesForString:(NSString *)searchSrting andPage:(NSInteger)page
{
	if (page == 1)
	{
		//Отменим все текущие загрузки, если они есть
		[self cancelCurrentDownloadTasks];
	}
	
	NSString *urlString = [NetworkHelper URLForSearchString:searchSrting andPage:page];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setTimeoutInterval:15];
	
	NSURLSession *session;
	session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	
	NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	   {
		   NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		   //Проверяем статус
		   if ([temp[@"stat"] isEqual: @"ok"])
		   {
			   NSInteger counter = (page - 1) * imagesPerPage;
			   NSArray<NSDictionary *> *photos = temp[@"photos"][@"photo"];
			   
			   // Отсюда отправим сообщение на обновление UI с главного потока
			   dispatch_async(dispatch_get_main_queue(), ^{
				   [self.outputDelegate prepareArrayForImagesCount: counter + photos.count];
			   });
			   
			   for (NSDictionary *dict in photos)
			   {
				   // Получение фото
				   // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
				   // example https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
				   NSNumber *farm = dict[@"farm"];
				   NSNumber *server = dict[@"server"];
				   NSNumber *photo_id = dict[@"id"];
				   NSNumber *secret = dict[@"secret"];
				   
				   NSString *url = [NSString stringWithFormat:
									@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, photo_id, secret];
				   ImageRequest *request = [ImageRequest initRequestWithUrl:url forNumber:counter];
				   [self loadImageFromRequest:request atNumber:counter];
				   counter += 1;
			   }
		   }
	   }];
	[sessionDataTask resume];
}

@end
