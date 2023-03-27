﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОписаниеОшибки = "";
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   	Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
    ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
    ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , ОписаниеОшибки);
    Сообщить(ТекстСообщения);
   	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзФайлаНаСервере(Наименование,Количество,Цена)
МПЗ = Справочники.Материалы.НайтиПоНаименованию(Наименование,Истина);
	Если Не МПЗ.Пустая() Тогда
	ТЧ = Объект.ТабличнаяЧасть.Добавить(); 
	ТЧ.МПЗ = МПЗ;
 	ТЧ.Количество = Количество;
 	ТЧ.Цена = Цена;
	ТЧ.Пометка = Истина; 
	Иначе
    Сообщить(Наименование+" не найден в справочнике материалов!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	Если Объект.ТабличнаяЧасть.Количество() > 0 Тогда	
		Если Вопрос("Очистить табличную часть перед загрузкой?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		Объект.ТабличнаяЧасть.Очистить();
		КонецЕсли; 
	КонецЕсли; 
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл со списком МПЗ");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка cписка МПЗ из файла..."); 
        ЗагрузитьИзФайлаНаСервере(СокрЛП(ExcelЛист.Cells(к,1).Value),Число(ExcelЛист.Cells(к,2).Value),Число(ExcelЛист.Cells(к,3).Value));
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СозданиеТаблицыНезакрытыхЗаказовПоставщику()
Запрос = Новый Запрос;
СписокМПЗ = Новый СписокЗначений;

	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	СписокМПЗ.Добавить(ТЧ.МПЗ);
	КонецЦикла;
ТаблицаЗаказов.Очистить(); 
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыПоставщикамОстатки.ЗаказПоставщику,
	|	ЗаказыПоставщикамОстатки.МПЗ,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки КАК ЗаказыПоставщикамОстатки
	|ГДЕ
	|	ЗаказыПоставщикамОстатки.Контрагент = &Контрагент
	|	И ЗаказыПоставщикамОстатки.Договор = &Договор
	|	И ЗаказыПоставщикамОстатки.МПЗ В(&СписокМПЗ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Дата";
Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
Запрос.УстановитьПараметр("Договор", Объект.Договор);
Запрос.УстановитьПараметр("СписокМПЗ", СписокМПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаЗаказов.Добавить();
	ТЧ.ЗаказПоставщику = ВыборкаДетальныеЗаписи.ЗаказПоставщику;
	ТЧ.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
	ТЧ.Остаток = ВыборкаДетальныеЗаписи.КоличествоОстаток;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РаспределитьНаСервере()
Объект.РаспределённыеМПЗ.Очистить();
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
		Если ТЧ.Количество = 0 Тогда
		Продолжить;
		КонецЕсли; 
	НераспределённыйОстаток = ТЧ.Количество;
	ВыборкаЗаказов = ТаблицаЗаказов.НайтиСтроки(Новый Структура("МПЗ",ТЧ.МПЗ));
		Если ВыборкаЗаказов.Количество() > 0 Тогда
			Для к = 0 по ВыборкаЗаказов.Количество()-1 Цикл
			Заказ = ВыборкаЗаказов[к];	
				Если Заказ.Остаток >= НераспределённыйОстаток Тогда
				Заказ.Остаток = Заказ.Остаток - НераспределённыйОстаток;
				ТЧ_МПЗ = Объект.РаспределённыеМПЗ.Добавить();
				ТЧ_МПЗ.МПЗ = ТЧ.МПЗ;
				ТЧ_МПЗ.Количество = НераспределённыйОстаток;
				ТЧ_МПЗ.Цена = ТЧ.Цена;
				ТЧ_МПЗ.ЗаказПоставщику = Заказ.ЗаказПоставщику;
				ТЧ.Остаток = 0;
				Прервать;
				ИначеЕсли Заказ.Остаток > 0 Тогда
				КолВЗаказе = Заказ.Остаток;
				НераспределённыйОстаток = НераспределённыйОстаток - КолВЗаказе;			
				Заказ.Остаток = 0;
				ТЧ_МПЗ = Объект.РаспределённыеМПЗ.Добавить();
				ТЧ_МПЗ.МПЗ = ТЧ.МПЗ;
				ТЧ_МПЗ.Количество = КолВЗаказе;
				ТЧ_МПЗ.Цена = ТЧ.Цена;
				ТЧ_МПЗ.ЗаказПоставщику = Заказ.ЗаказПоставщику;
				ТЧ.Остаток = НераспределённыйОстаток;
				КонецЕсли; 
			КонецЦикла;
		Иначе
		ТЧ.Остаток = НераспределённыйОстаток;
		КонецЕсли; 
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура Распределить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Создание таблицы незакрытых заказов поставщику...");
	СозданиеТаблицыНезакрытыхЗаказовПоставщику();
	Состояние("Обработка...",,"Распределение МПЗ по заказам поставщикам...");	
	РаспределитьНаСервере();
		Если Элементы.ТабличнаяЧасть.ТекущаяСтрока <> Неопределено Тогда
		Элементы.РаспределённыеМПЗ.ОтборСтрок = Новый ФиксированнаяСтруктура("МПЗ", Элементы.ТабличнаяЧасть.ТекущиеДанные.МПЗ);
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
	Элементы.РаспределённыеМПЗ.ОтборСтрок = Новый ФиксированнаяСтруктура("МПЗ", Элемент.ТекущиеДанные.МПЗ); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьРаспределённыеМПЗ(МПЗ)
МассивСтрок = Объект.РаспределённыеМПЗ.НайтиСтроки(Новый Структура("МПЗ",МПЗ)); 
	Для каждого Стр Из МассивСтрок Цикл 
	Объект.РаспределённыеМПЗ.Удалить(Стр); 
	КонецЦикла;  
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПередУдалением(Элемент, Отказ)
УдалитьРаспределённыеМПЗ(Элемент.ТекущиеДанные.МПЗ);
КонецПроцедуры

&НаСервере
Функция СоздатьДокумент(ЗаказПоставщику,ТЗ)
	Попытка
	Поступление = Документы.ПоступлениеМПЗ.СоздатьДокумент();
	Поступление.Дата = ТекущаяДата();
	Поступление.Автор = ПараметрыСеанса.Пользователь;
	Поступление.ДокументОснование = ЗаказПоставщику;	
	Поступление.Подразделение = ЗаказПоставщику.Подразделение;
	Поступление.Контрагент = ЗаказПоставщику.Контрагент;
	Поступление.Договор = ЗаказПоставщику.Договор;
	Поступление.УстановитьНовыйНомер(ПрисвоитьПрефикс(ЗаказПоставщику.Подразделение));
	Поступление.МестоХранения = Объект.МестоХранения;
	Поступление.НомерДокВходящий = СокрЛП(Объект.НомерДокВходящий);
	Поступление.ДатаДокВходящий = Объект.ДатаДокВходящий;
	Поступление.Курс = ОбщийМодульВызовСервера.КурсДляВалюты(Объект.Договор.Валюта,ТекущаяДата());
		Если ЗначениеЗаполнено(Объект.НомерДокВходящий) Тогда
		Поступление.Комментарий = СокрЛП(Объект.НомерДокВходящий) + " от "+Объект.ДатаДокВходящий;
		КонецЕсли; 
			Для каждого ТЧ Из ТЗ Цикл
			ТЧПП = Поступление.ТабличнаяЧасть.Добавить();
			ТЧПП.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
			ТЧПП.МПЗ = ТЧ.МПЗ;	
			ТЧПП.ЕдиницаИзмерения = ПолучитьОсновнуюЕдиницуИзмеренияПоБазовой(ТЧ.МПЗ);
			ТЧПП.Количество = ТЧ.Количество;
			ТЧПП.ЦенаВалюта = ТЧ.Цена;
			ТЧПП.СуммаВалюта = ТЧ.Цена*ТЧ.Количество;
			ТЧПП.ВсегоВалюта = ТЧПП.СуммаВалюта;
			ТЧПП.Цена = ТЧ.Цена*Поступление.Курс;
			ТЧПП.Сумма = ТЧ.Цена*ТЧ.Количество;
				Если Не Объект.Договор.БезНДС Тогда
				ТЧПП.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
				ТЧПП.НДС = ТЧПП.Сумма*ТЧПП.СтавкаНДС.Ставка/100;
				ТЧПП.Всего = ТЧПП.Сумма + ТЧПП.НДС;				
				Иначе
				ТЧПП.Всего = ТЧПП.Сумма; 	
				КонецЕсли; 
			КонецЦикла;	
    Поступление.Записать(РежимЗаписиДокумента.Проведение);
	СписокПоступленийМПЗ.Добавить(Поступление.Ссылка);
	Возврат(Поступление.Ссылка);
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Неопределено);
	КонецПопытки;
КонецФункции

&НаСервере
Процедура СоздатьДокументыНаСервере()
ТЗ = Новый ТаблицаЗначений;
СЗ = Новый СписокЗначений;

ТЗ.Колонки.Добавить("Идентификатор");
ТЗ.Колонки.Добавить("МПЗ");
ТЗ.Колонки.Добавить("Количество");
ТЗ.Колонки.Добавить("Цена");

Объект.РаспределённыеМПЗ.Сортировать("ЗаказПоставщику,МПЗ");
ТекЗаказ = Неопределено;
	Для каждого ТЧ Из Объект.РаспределённыеМПЗ Цикл	
		Если ТекЗаказ <> ТЧ.ЗаказПоставщику Тогда
			Если ТекЗаказ <> Неопределено Тогда
			Результат = СоздатьДокумент(ТекЗаказ,ТЗ);
				Если Результат <> Неопределено Тогда
					Для Каждого ТЧ_ТЗ Из ТЗ Цикл	
					Стр = Объект.РаспределённыеМПЗ.НайтиПоИдентификатору(ТЧ_ТЗ.Идентификатор);
					Стр.ПоступлениеМПЗ = Результат;
					КонецЦикла; 			
				КонецЕсли;
			ТЗ.Очистить();
			КонецЕсли;
		ТекЗаказ = ТЧ.ЗаказПоставщику;
		КонецЕсли; 
	ТЧ_МПЗ = ТЗ.Добавить();
	ТЧ_МПЗ.Идентификатор = ТЧ.ПолучитьИдентификатор();
	ТЧ_МПЗ.МПЗ = ТЧ.МПЗ;
	ТЧ_МПЗ.Количество = ТЧ.Количество;
	ТЧ_МПЗ.Цена = ТЧ.Цена;
	КонецЦикла;
		Если ТекЗаказ <> Неопределено Тогда	
		Результат = СоздатьДокумент(ТекЗаказ,ТЗ);
			Если Результат <> Неопределено Тогда
				Для Каждого ТЧ_ТЗ Из ТЗ Цикл	
				Стр = Объект.РаспределённыеМПЗ.НайтиПоИдентификатору(ТЧ_ТЗ.Идентификатор);
				Стр.ПоступлениеМПЗ = Результат;
				КонецЦикла;			
			КонецЕсли;
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументы(Команда)
СписокПоступленийМПЗ.Очистить();
СоздатьДокументыНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоМПЗ(МПЗ)
КоличествоИтого = 0;
	Для каждого ТЧ Из Объект.РаспределённыеМПЗ Цикл
		Если ТЧ.МПЗ = МПЗ Тогда	
		КоличествоИтого = КоличествоИтого + ТЧ.Количество;
		КонецЕсли; 
	КонецЦикла;
Возврат(КоличествоИтого);
КонецФункции

&НаСервере
Функция ПечатьНаСервере()
ТабДок = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблДокумент = Макет.ПолучитьОбласть("Документ");
ОблКонец = Макет.ПолучитьОбласть("Конец");
ТабДок.Вывести(ОблШапка);
	Для каждого ТЧ_МПЗ Из Объект.ТабличнаяЧасть Цикл
	ОблМПЗ.Параметры.Наименование = СокрЛП(ТЧ_МПЗ.МПЗ.Наименование);
	ОблМПЗ.Параметры.МПЗ = ТЧ_МПЗ.МПЗ;
	ОблМПЗ.Параметры.Количество = ПолучитьКоличествоМПЗ(ТЧ_МПЗ.МПЗ);
	ТабДок.Вывести(ОблМПЗ);
		Для каждого ТЧ Из Объект.РаспределённыеМПЗ Цикл
			Если ТЧ_МПЗ.МПЗ = ТЧ.МПЗ Тогда
			ОблДокумент.Параметры.НомерЗаказПоставщику = ТЧ.ЗаказПоставщику.Номер+" от "+ТЧ.ЗаказПоставщику.Дата;	
			ОблДокумент.Параметры.ЗаказПоставщику = ТЧ.ЗаказПоставщику;
			ОблДокумент.Параметры.Количество = ТЧ.Количество;
			ОблДокумент.Параметры.НомерПоступлениеМПЗ = ТЧ.ПоступлениеМПЗ.Номер+" от "+ТЧ.ПоступлениеМПЗ.Дата;
			ОблДокумент.Параметры.ПоступлениеМПЗ = ТЧ.ПоступлениеМПЗ;
			ТабДок.Вывести(ОблДокумент); 
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
ОблКонец.Параметры.Количество = Объект.РаспределённыеМПЗ.Итог("Количество");
ТабДок.Вывести(ОблКонец);
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
ТД = ПечатьНаСервере();
ТД.Показать("Распределение поставок по заказам поставщикам");
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьВБДСбытНаСервере()
БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Константы.БазаДанных1ССбыт.Получить());
	Если БазаСбыта = Неопределено Тогда
	Сообщить("Не открыто соединение с базой сбыта!");
	Возврат;
	КонецЕсли;
ТЗ = Новый ТаблицаЗначений;

ТЗ.Колонки.Добавить("Артикул");
ТЗ.Колонки.Добавить("Количество");
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;	
		Для каждого Док Из СписокПоступленийМПЗ Цикл
			Если Не Док.Значение.Выгружено Тогда
				Для каждого ТЧ Из Док.Значение.ТабличнаяЧасть Цикл
				Выборка = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("МПЗ",ТЧ.МПЗ));
					Если Выборка[0].Пометка Тогда
					ТЧ_ТЗ = ТЗ.Добавить();
					ТЧ_ТЗ.Артикул = ОбщийМодульВызовСервера.ПолучитьАртикулПоКодуТовара(ТЧ.МПЗ.Товар.Код);
					ТЧ_ТЗ.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения);
					КонецЕсли;
				КонецЦикла; 		
			КонецЕсли; 	
		КонецЦикла;
	ТЗ.Свернуть("Артикул","Количество");
	флОшибки = Ложь;
		Если ТЗ.Количество() > 0 Тогда
		бсНовДок = БазаСбыта.Документы.ПриходныйОрдерНаТовары.СоздатьДокумент();
		бсНовДок.ВидОперации = БазаСбыта.Перечисления.ВидыОперацийПриходныйОрдер.ОтПоставщика;
		бсНовДок.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("000000001");
		бсНовДок.Склад = БазаСбыта.Справочники.Склады.НайтиПоКоду("000000001");
		бсНовДок.Контрагент = БазаСбыта.Справочники.Контрагенты.НайтиПоКоду("000000029");
		бсНовДок.Дата = ТекущаяДата();	
			Для каждого ТЧ Из ТЗ Цикл
			бсНомен = БазаСбыта.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",ТЧ.Артикул);
				Если бсНомен.Пустая() Тогда
				флОшибки = Истина;
				Сообщить("Товар с артикулом "+ТЧ.Артикул+" не найден в базе сбыта!");
				Продолжить;
				КонецЕсли;
			ТЧ_Т = бсНовДок.Товары.Добавить();			
			ТЧ_Т.Номенклатура = бсНомен;
			ТЧ_Т.Количество = ТЧ.Количество;
			ТЧ_Т.ЕдиницаИзмерения = бсНомен.ЕдиницаДляОтчетов;
			КонецЦикла;
				Если Не флОшибки Тогда
				бсНовДок.Записать(БазаСбыта.РежимЗаписиДокумента.Запись);
					Для каждого Док Из СписокПоступленийМПЗ Цикл
					Поступление = Док.Значение.ПолучитьОбъект();
					Поступление.Выгружено = Истина;
					Поступление.Записать(РежимЗаписиДокумента.Проведение);
					КонецЦикла;	
				Иначе
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);	
				Возврат;
				КонецЕсли;
		КонецЕсли;   
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Сообщить(ОписаниеОшибки());	
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВБДСбыт(Команда)
ВыгрузитьВБДСбытНаСервере();
КонецПроцедуры

&НаСервере
Процедура НайтиПоКоду(БарКод)	
Товар = ОбщийМодульВызовСервера.ПолучитьТоварПоБарКоду(БарКод);
	Если Не Товар.Пустая() Тогда
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Материалы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Материалы КАК Материалы
		|ГДЕ
		|	Материалы.Товар = &Товар";
	Запрос.УстановитьПараметр("Товар", Товар);
	РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Выборка = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("МПЗ",ВыборкаДетальныеЗаписи.Ссылка));
			Выборка[0].Отсканировано = Выборка[0].Отсканировано + 1;
			КонецЦикла;
		Иначе	
		Сообщить("Материал не найден!");			
		КонецЕсли;
	Иначе	
	Сообщить("Товар не найден!");
	КонецЕсли; 
КонецПроцедуры 

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	НайтиПоКоду(Данные);
	КонецЕсли;
КонецПроцедуры
