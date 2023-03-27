﻿
&НаСервере
Функция ПолучитьСтатусСпецификацииНаСервере(Спецификация)
Отбор = Новый Структура("МПЗ",Спецификация);
Статусы = РегистрыСведений.СтатусыМПЗ.ПолучитьПоследнее(ТекущаяДата(),Отбор);
Возврат(Статусы.Статус);
КонецФункции 

&НаСервере
Функция ПолучитьГоловнуюМТК(МТК)
ГоловнаяМТК = МТК;
	Пока ЗначениеЗаполнено(ГоловнаяМТК.ДокументОснование) Цикл
		Если ТипЗнч(ГоловнаяМТК.ДокументОснование) = Тип("ДокументСсылка.МаршрутнаяКарта") Тогда	
		ГоловнаяМТК = ГоловнаяМТК.ДокументОснование;
		Иначе
		Прервать;
		КонецЕсли;
	КонецЦикла;
		Если ГоловнаяМТК = МТК Тогда
		Возврат(Документы.МаршрутнаяКарта.ПустаяСсылка());		
		Иначе	
		Возврат(ГоловнаяМТК);		
		КонецЕсли; 
КонецФункции

&НаСервере
Процедура НайтиНезавершённыхМТКНаСервере()
Объект.МаршрутныеКарты.Очистить();
СписокСтатусов = Новый СписокЗначений;

	Если СтатусМТК = 1 Тогда
	Элементы.Обработать.Заголовок = "Остановить";
	СписокСтатусов.Добавить(0);
	СписокСтатусов.Добавить(1);
	СписокСтатусов.Добавить(4);
	ИначеЕсли СтатусМТК = 2 Тогда
	Элементы.Обработать.Заголовок = "Снять остановку";
	СписокСтатусов.Добавить(2);
	КонецЕсли; 
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка КАК Ссылка,
	|	МаршрутнаяКарта.НомерОчереди КАК НомерОчереди,
	|	МаршрутнаяКарта.Номенклатура КАК Номенклатура,
	|	МаршрутнаяКарта.Количество КАК Количество,
	|	МаршрутнаяКарта.Счёт КАК Счёт,
	|	МаршрутнаяКарта.СтандартныйКомментарий КАК СтандартныйКомментарий,
	|	МаршрутнаяКарта.Статус КАК Статус
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.Линейка = &Линейка
	|	И МаршрутнаяКарта.Статус В(&Статусы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерОчереди,
	|	МаршрутнаяКарта.Номер";
Запрос.УстановитьПараметр("Линейка",Объект.Линейка);
Запрос.УстановитьПараметр("Статусы",СписокСтатусов);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = Объект.МаршрутныеКарты.Добавить();
	ТЧ.СтатусМТК = ВыборкаДетальныеЗаписи.Статус;
	ТЧ.МТК = ВыборкаДетальныеЗаписи.Ссылка;
	ТЧ.ГоловнаяМТК = ПолучитьГоловнуюМТК(ВыборкаДетальныеЗаписи.Ссылка);
	ТЧ.Спецификация = ВыборкаДетальныеЗаписи.Номенклатура;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.Количество;
	ТЧ.Счёт = ВыборкаДетальныеЗаписи.Счёт;
	ТЧ.НомерОчереди = ВыборкаДетальныеЗаписи.НомерОчереди;
	ТЧ.СтандартныйКомментарий = ВыборкаДетальныеЗаписи.СтандартныйКомментарий;
		Если СтатусМТК = 2 Тогда
		Остановка = ВыборкаДетальныеЗаписи.Ссылка.Остановки[ВыборкаДетальныеЗаписи.Ссылка.Остановки.Количество()-1];
		ТЧ.ИнициаторОстановки = Остановка.Инициатор;
		ТЧ.МПЗОстановки = Остановка.МПЗ;
		ТЧ.ПричинаОстановки = Остановка.Причина;
		ТЧ.ДатаНачалаОстановки = Остановка.ДатаНачала;
		ТЧ.ДатаПредполагаемогоОкончанияОстановки = Остановка.ДатаОкончанияПредполагаемая;
		//МТК = ВыборкаДетальныеЗаписи.Ссылка;
		//ТЧ.ИнициаторОстановки = МТК.ИнициаторОстановки;
		//ТЧ.МПЗОстановки = МТК.МПЗОстановки;
		//ТЧ.ПричинаОстановки = МТК.ПричинаОстановки;
		//ТЧ.ДатаНачалаОстановки = МТК.ДатаНачалаОстановки;
		//ТЧ.ДатаПредполагаемогоОкончанияОстановки = МТК.ДатаПредполагаемогоОкончанияОстановки;
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
Состояние("Обработка...",,"Загрузка незавершённых маршрутных карт...");
НайтиНезавершённыхМТКНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОстановитьНаСервере()
	Если Не ЗначениеЗаполнено(ПричинаОстановки) Тогда
	Сообщить("Укажите причину остановки!");
	Возврат;
	КонецЕсли; 
		Для каждого ТЧ Из Объект.МаршрутныеКарты Цикл
			Если ТЧ.Пометка Тогда
				Если (ТЧ.МТК.Статус <> 2) и (ТЧ.МТК.Статус <> 3) Тогда
				ДПО = ДатаПредполагаемогоОкончанияОстановки + (ТекущаяДата()-НачалоДня(ТекущаяДата()));
					Если ОбщийМодульВызовСервера.ОстановитьМТК(ТЧ.МТК,ПараметрыСеанса.Пользователь,ПричинаОстановки,Неопределено,ДПО,Неопределено,Комментарий) Тогда
					ТЧ.СтатусМТК = 2;	
					ТЧ.ПричинаОстановки = ПричинаОстановки;	
					КонецЕсли;		
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
НайтиНезавершённыхМТКНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьРабочееМесто(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", МТК);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.РабочееМесто);
	КонецЦикла;
Возврат(Справочники.РабочиеМестаЛинеек.ПустаяСсылка());
КонецФункции 

&НаСервере
Процедура ОтправитьВРаботуНаСервере()
	Для каждого ТЧ Из Объект.МаршрутныеКарты Цикл
		Если ТЧ.Пометка Тогда
			Если ТЧ.МТК.Статус = 2 Тогда
				Попытка
				НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
				Статус = 0;
				ВыборкаПЗ = Документы.ПроизводственноеЗадание.Выбрать(,,Новый Структура("ДокументОснование",ТЧ.МТК));	
					Пока ВыборкаПЗ.Следующий() Цикл
						Если ЗначениеЗаполнено(ВыборкаПЗ.ДатаЗапуска) Тогда
				//			Если Найти(ТЧ.МТК.Подразделение.Наименование,"SMD") > 0 Тогда
				//				Если Константы.КодБазы.Получить() = "БГР" Тогда
				//				РМ = ПолучитьРабочееМесто(ТЧ.МТК);
				//					Если РМ.Код = 2 Тогда
				//						Если Не ОбщийМодульВызовСервера.ОтменаЗапускаМТК(ТЧ.МТК) Тогда
				//						Сообщить(""+ТЧ.МТК+" - не удалось отменить запуск МТК!");
				//						ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				//						Возврат;
				//						КонецЕсли; 
				//					Статус = 0;
				//					ИначеЕсли РМ.Код = 1 Тогда
				//					Статус = 0;
				//					Иначе
				//					Статус = 1;
				//					КонецЕсли; 
				//				Иначе	
				//				Статус = 4;	
				//				КонецЕсли;
				//			Иначе
				//			Статус = 1;										
				//			КонецЕсли; 
						Статус = 1;
						КонецЕсли;
					Прервать;			
					КонецЦикла;
				МТК = ТЧ.МТК.ПолучитьОбъект();
				МТК.Статус = Статус;
				МТК.Остановки[МТК.Остановки.Количество()-1].ДатаОкончания = ТекущаяДата();
				МТК.Записать();
				ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
				Исключение
				Сообщить(ОписаниеОшибки());
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат;
				КонецПопытки;
			ТЧ.СтатусМТК = МТК.Статус;
			ТЧ.ПричинаОстановки = "";			
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
НайтиНезавершённыхМТКНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтатусМТКПриИзменении(Элемент)
НайтиНезавершённыхМТКНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Обработать(Команда)
	Если СтатусМТК = 1 Тогда
		Если ЭтаФорма.ПроверитьЗаполнение() Тогда
		ОстановитьНаСервере();
		КонецЕсли;
	ИначеЕсли СтатусМТК = 2 Тогда
	ОтправитьВРаботуНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
СтатусМТК = 1;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПометкаПриИзменении(Элемент)
НоменклатураПометкаПриИзмененииНаСервере(Элементы.Номенклатура.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура НоменклатураПометкаПриИзмененииНаСервере(Стр)
ТЧ = Объект.МаршрутныеКарты.НайтиПоИдентификатору(Стр);
	Если ТЧ.Пометка Тогда
		Если ТипЗнч(ТЧ.МТК.ИнициаторОстановки) = Тип("СправочникСсылка.Подразделения") Тогда
		ТЧ.Пометка = Ложь;		
		Сообщить("Нельзя выбирать МТК, остановленные другим подразделением!");
		КонецЕсли;	
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьНомерМТК(МТК)
Возврат(МТК.Номер);
КонецФункции

&НаКлиенте
Процедура НайтиМТК(Команда)
ПодстрокаПоиска = "";
	Если ВвестиСтроку(ПодстрокаПоиска,"Введите строку поиска",10,Ложь) Тогда
		Для Каждого ТЧ Из Объект.МаршрутныеКарты Цикл
			Если Найти(ПолучитьНомерМТК(ТЧ.МТК),СокрЛП(ПодстрокаПоиска)) > 0 Тогда
			Элементы.Номенклатура.ТекущаяСтрока = ТЧ.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли; 
КонецПроцедуры
