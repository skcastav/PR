﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
	Если Объект.Исполнитель.Пустая() Тогда
	Элементы.РабочееМесто.Доступность = Ложь;
	Сообщить("Вы не внесены в справочник Сотрудников! Работа невозможна!");
	КонецЕсли; 
КонецПроцедуры

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
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры 

&НаКлиенте
Процедура РабочееМестоПриИзменении(Элемент)
	Если Не МожноРаботатьВАРМ() Тогда
	Возврат;
	КонецЕсли;
Элементы.ПростойЛинейки.Видимость = ?(ПолучитьКодРабочегоМеста() = 1,Истина,Ложь);
ОчиститьСсылкуНаПЗ();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево(ЭтапСпецификации)
Объект.Спецификация.Сортировать("ТипСправочника Убыв,ВидМПЗ,Позиция,МПЗ");
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ТипСпр = "";
	Для каждого ТЧ Из Объект.Спецификация Цикл
		Если ТЧ.ЭтапСпецификации <> ЭтапСпецификации Тогда
		Продолжить;		
		КонецЕсли; 
			Если ТипСпр <> ТЧ.ТипСправочника Тогда
			Стр = тДерево.Строки.Добавить();
			Стр.ТипСправочника = ТЧ.ТипСправочника;
			ТипСпр = ТЧ.ТипСправочника;
			КонецЕсли; 
	СтрЗнч = Стр.Строки.Добавить();
	СтрЗнч.Позиция = ТЧ.Позиция;
	СтрЗнч.ВидЭлемента = ТЧ.ВидМПЗ;
	СтрЗнч.МПЗ = ТЧ.МПЗ;
	СтрЗнч.Количество = ТЧ.Количество;
	СтрЗнч.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения;
	СтрЗнч.Аналог = ТЧ.Аналог;
	СтрЗнч.Примечание = ТЧ.Примечание;
		Если ТЧ.Владелец <> Неопределено Тогда
		СтрЗнч.Владелец = ТЧ.Владелец.Элемент;
		КонецЕсли; 		 
	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоСпецификации");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомплектацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
ЗаполнитьДерево(Элемент.ТекущиеДанные.ЭтапСпецификации);
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаСервере
Функция ПолучитьЗаданиеНаСервере()
Результат = ОбщийМодульАРМ.ПолучитьНезавершенноеЗадание(Этапы,ЭтапыАРМ,Объект.РабочееМесто,Объект.Исполнитель);
	Если Результат <> Неопределено Тогда 
	Объект.ПроизводственноеЗадание = Результат.ПЗ;
	КодDanfoss = ОбщийМодульВызовСервера.ПолучитьКодDanfoss(Объект.ПроизводственноеЗадание.БарКод);
	Возврат(1);
	КонецЕсли;
НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
КолПЗ = 0;

СписокИзделийЛО = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала КАК ДатаНачала,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних(, РабочееМесто = &РабочееМесто) КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = &ДатаОкончания
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.НомерОчереди,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.ДатаОтгрузки,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер
	|ИТОГИ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование";	
Запрос.УстановитьПараметр("РабочееМесто",Объект.РабочееМесто); 
Запрос.УстановитьПараметр("ДатаОкончания",Дата(1,1,1));
Результат = Запрос.Выполнить();

ВыборкаМТК = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМТК.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаМТК.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолПЗ = КолПЗ + 1;
			Если СписокИзделийЛО.НайтиПоЗначению(ВыборкаДетальныеЗаписи.ПЗ.Изделие) <> Неопределено Тогда
			Прервать; //Переходим к следующей МТК
			КонецЕсли;
				Если Не ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,Объект.РабочееМесто,Объект.Исполнитель) Тогда	
				Прервать; //Переходим к следующей МТК			
				КонецЕсли;
					Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска) Тогда
					Результат = ОбщийМодульВызовСервера.ЗапуститьВПроизводство(ВыборкаДетальныеЗаписи.ПЗ,Объект.РабочееМесто,Этапы);
						Если Результат = 0 Тогда
						СписокИзделийЛО.Добавить(ВыборкаДетальныеЗаписи.ПЗ.Изделие);
						Прервать; //Переходим к следующей МТК
						ИначеЕсли Результат = -1 Тогда
						Возврат(-1);
						КонецЕсли;
					КонецЕсли;   
		Объект.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		КодDanfoss = ОбщийМодульВызовСервера.ПолучитьКодDanfoss(Объект.ПроизводственноеЗадание.БарКод);
		ОкончаниеЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ОбщийМодульРаботаСРегистрами.СборИнформацииПоАРМ(1,Объект.РабочееМесто,Объект.ПроизводственноеЗадание.Изделие,КолПЗ,(ОкончаниеЗамера - НачалоЗамера)/1000);
		Возврат(1);
		КонецЦикла;
	КонецЦикла;
ОкончаниеЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбщийМодульРаботаСРегистрами.СборИнформацииПоАРМ(1,Объект.РабочееМесто,Справочники.Номенклатура.ПустаяСсылка(),КолПЗ,(ОкончаниеЗамера - НачалоЗамера)/1000);
Возврат(0);
КонецФункции

&НаСервере
Функция ПолучитьСпецификациюЭтапов()
Возврат(ОбщийМодульАРМ.ПолучитьСпецификациюЭтапов(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Этапы,Объект.Спецификация,ТаблицаКомплектации)); 
КонецФункции
 
&НаСервере
Функция ПолучитьКодРабочегоМеста()
Возврат(Объект.РабочееМесто.Код);
КонецФункции 

&НаКлиенте
Процедура ПолучитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ОстановкаЛинейки(Объект.РабочееМесто) Тогда
		Если ПолучитьКодРабочегоМеста() = 1 Тогда
			Если Вопрос("Линейка остановлена! Снять остановку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				Если Не ОбщийМодульРаботаСРегистрами.СнятьОстановкуЛинейки(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда	
				Возврат;
				КонецЕсли;
			Иначе
			Возврат;			
			КонецЕсли;
		Иначе
		Возврат; 
		КонецЕсли;
	КонецЕсли;
Состояние("Обработка...",,"Получение задания...");
Результат = ПолучитьЗаданиеНаСервере(); 
	Если Результат = 1 Тогда
	ПолучитьСпецификациюЭтапов();
		Если ТипЗнч(ТаблицаКомплектации[0].Комплектация) = Тип("СправочникСсылка.Номенклатура") Тогда
		Элементы.ТаблицаКомплектации.ТекущаяСтрока = ТаблицаКомплектации[0].ПолучитьИдентификатор();
		ТаблицаКомплектацииВыборЗначения(Элементы.ТаблицаКомплектации,Элементы.ТаблицаКомплектации.ТекущаяСтрока,Истина);
		КонецЕсли;
	ОткрытьФорму("Обработка.СозданныеБарКоды.Форма.Форма",Новый Структура("ПЗ,РабочееМесто",Объект.ПроизводственноеЗадание,Объект.РабочееМесто));
	Элементы.Завершить.КнопкаПоУмолчанию = Истина;
	Элементы.ПолучитьЗадание.Доступность = Ложь;
	Элементы.ПростойЛинейки.Доступность = Ложь;
	Элементы.ПечатьДокументов.Доступность = Истина;
	Элементы.Завершить.Доступность = Истина;
	Элементы.ВвестиКодDanfoss.Доступность = ОбщийМодульВызовСервера.ТребуетсяКодDanfoss(Объект.ПроизводственноеЗадание);
	Элементы.ВвестиIDКлюча.Доступность = ОбщийМодульВызовСервера.ТребуетсяIDКлюча(Объект.ПроизводственноеЗадание);
	Элементы.КодDanfoss.Видимость = ОбщийМодульВызовСервера.ТребуетсяКодDanfoss(Объект.ПроизводственноеЗадание);
	ИначеЕсли Результат = 0 Тогда
	Сообщить("Нет производственных заданий!");
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ОчиститьСсылкуНаПЗ()
Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
КодDanfoss = "";
Этапы.Очистить();
ЭтапыАРМ.Очистить();
ТаблицаКомплектации.Очистить();
Объект.Спецификация.Очистить();
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ЗначениеВРеквизитФормы(тДерево,"ДеревоСпецификации");
Элементы.ПолучитьЗадание.КнопкаПоУмолчанию = Истина;
Элементы.ПолучитьЗадание.Доступность = Истина;
Элементы.ПростойЛинейки.Доступность = Истина;
Элементы.ПечатьДокументов.Доступность = Ложь;
Элементы.Завершить.Доступность = Ложь;
Элементы.ВвестиКодDanfoss.Доступность = Ложь;
Элементы.ВвестиIDКлюча.Доступность = Ложь;
флПечать = Ложь;
КонецПроцедуры  

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(Объект.РабочееМесто.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции 

&НаСервере
Функция ЗавершитьЗаданиеНаСервере()
	Попытка
	ДатаЗавершения = ТекущаяДата();
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	НаборЗаписей = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
	    	Если Запись.РабочееМесто = Объект.РабочееМесто Тогда
			Запись.ДатаОкончания = ДатаЗавершения;
			Прервать;
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать();
		Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Объект.Спецификация,Этапы,ДатаЗавершения) Тогда
		Сообщить("Документ выпуска не создан!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат("");
		КонецЕсли;
			Если СокрЛП(Объект.РабочееМесто.ГруппаРабочихМест.Префикс) = "УП" Тогда
				Если Объект.ПроизводственноеЗадание.ДокументОснование.МестоХраненияПотребитель.Пустая() Тогда
				МестоПередачи = "на склад линейки";
				Иначе	
				МестоПередачи = "на склад "+СокрЛП(Объект.ПроизводственноеЗадание.ДокументОснование.МестоХраненияПотребитель.Наименование);
				КонецЕсли;
			Иначе
			МестоПередачи = "на следующий этап производства";			
			КонецЕсли;		
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(МестоПередачи);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат("");
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура ЗавершитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ЛинейкаОстановлена(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда
	Возврат;
	КонецЕсли;
		Если ОбщийМодульВызовСервера.ТребуетсяКодDanfoss(Объект.ПроизводственноеЗадание) Тогда
			Если Не ЗначениеЗаполнено(ОбщийМодульВызовСервера.ПолучитьКодDanfoss(ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ПроизводственноеЗадание,"БарКод"))) Тогда
			Сообщить("Введите код Danfoss!");
			Возврат;
			КонецЕсли; 
		КонецЕсли; 
			Если ОбщийМодульВызовСервера.ТребуетсяIDКлюча(Объект.ПроизводственноеЗадание) Тогда
				Если Не ЗначениеЗаполнено(ОбщийМодульВызовСервера.ПолучитьIDКлюча(ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ПроизводственноеЗадание,"БарКод"))) Тогда
				Сообщить("Введите ID ключа!");
				Возврат;
				КонецЕсли; 
			КонецЕсли;	
МестоПередачи = ЗавершитьЗаданиеНаСервере();
	Если МестоПередачи <> "" Тогда
	Испытания = ОбщийМодульВызовСервера.ПолучитьIDКлюча(ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ПроизводственноеЗадание,"Испытания"));
		Если Испытания = 1 Тогда
		Предупреждение("Отложите изделие для ПСИ!",,"Внимание!");
		ИначеЕсли Испытания = 2 Тогда
		Предупреждение("Отложите изделие для поверки!",,"Внимание!");
		Иначе
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"Передайте изделие "+МестоПередачи,БиблиотекаКартинок.Пользователь);
		КонецЕсли;
	ОчиститьСсылкуНаПЗ();
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция ЭтоПереупаковка(РабочееМесто)
	Если РабочееМесто.Линейка.ВидЛинейки = Перечисления.ВидыЛинеек.Переупаковка Тогда
	Возврат(Истина);
	Иначе	
	Возврат(Ложь);
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура РабочееМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ЭтоПереупаковка(ВыбранноеЗначение) Тогда
	Сообщить("Выберите рабочее место из основной или проектной линейки!");
	СтандартнаяОбработка = Ложь;
	Возврат;
	КонецЕсли; 
		Если Не Объект.ПроизводственноеЗадание.Пустая() Тогда
			Если Вопрос("Задание не завершено. Вы действительно хотите авторизоваться?",РежимДиалогаВопрос.ДаНет,,,"ВНИМАНИЕ!") = КодВозвратаДиалога.Нет Тогда
			СтандартнаяОбработка = Ложь;
			КонецЕсли; 
		КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЭтапов()
СписокЭтапов = Новый СписокЗначений;
	Для каждого ТЧ Из ТаблицаКомплектации Цикл
		Если СписокЭтапов.НайтиПоЗначению(ТЧ.ЭтапСпецификации) = Неопределено Тогда
		СписокЭтапов.Добавить(ТЧ.ЭтапСпецификации);
		КонецЕсли; 
	КонецЦикла;
Возврат(СписокЭтапов);
КонецФункции 

&НаКлиенте
Процедура ПечатьДокументов(Команда)
	Если флПечать Тогда
		Если Вопрос("Распечатать повторно?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОткрытьФорму("Обработка.СозданныеБарКоды.Форма.Форма",Новый Структура("ПЗ,РабочееМесто",Объект.ПроизводственноеЗадание,Объект.РабочееМесто)); 
флПечать = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   	Элементы.ДеревоСпецификации.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоСпецификации.Свернуть(тСтр.ПолучитьИдентификатор());
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	Если ТипЗнч(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ) = Тип("СправочникСсылка.Документация") Тогда
	ОбщийМодульКлиент.ОткрытьФайлДокумента(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСпецификацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ) = Тип("СправочникСсылка.Документация") Тогда
	ОбщийМодульКлиент.ОткрытьФайлДокумента(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомплектацииВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
ЗаполнитьДерево(Элемент.ТекущиеДанные.ЭтапСпецификации);
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ВвестиКодDanfossНаСервере(БарКод)
	Попытка				
	НаборЗаписей = РегистрыСведений.БарКоды.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл
			Если Не ЗначениеЗаполнено(Запись.КодDanfoss) Тогда
			Запись.КодDanfoss = БарКод;
			Иначе
			Сообщить("Код Danfoss уже присвоен данному изделию.");
			Возврат;
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать(Истина);
	КодDanfoss = БарКод;
	Элементы.КодDanfoss.Видимость = Истина;
	Исключение
	Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКодDanfoss(Команда,БарКод = "")
	Если Не Объект.ПроизводственноеЗадание.Пустая() Тогда
		Если Не ЗначениеЗаполнено(БарКод) Тогда
			Если Не ВвестиСтроку(БарКод,"Введите код Danfoss",20) Тогда
			Возврат;	
			КонецЕсли; 
		КонецЕсли;
	ВвестиКодDanfossНаСервере(БарКод);
	Иначе
	Сообщить("Сначала получите производственное задание!");	
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ВвестиIDКлючаНаСервере(ID)
	Попытка				
	НаборЗаписей = РегистрыСведений.БарКоды.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл
			Если Не ЗначениеЗаполнено(Запись.IDКлюча) Тогда
			Запись.IDКлюча = ID;
			Иначе
			Сообщить("ID ключа уже присвоен данному изделию.");
			Возврат;
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать(Истина);
	IDКлюча = ID;
	Элементы.IDКлюча.Видимость = Истина;
	Исключение
	Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ВвестиIDКлюча(Команда)
	Если Не Объект.ПроизводственноеЗадание.Пустая() Тогда
	ID = "";
		Если Не ВвестиСтроку(ID,"Введите ID ключа",8) Тогда
		Возврат;	
		КонецЕсли; 
	ВвестиIDКлючаНаСервере(ID);
	Иначе
	Сообщить("Сначала получите производственное задание!");	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если Массив[0] = "3" Тогда
		ЗначениеПараметра1 = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
			Если ЗначениеПараметра1 = Неопределено Тогда
			Сообщить("Линейка или место хранения не найдена!");
			Возврат;	
			КонецЕсли; 
		МПЗ = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
			Если МПЗ = Неопределено Тогда
			Сообщить(Массив[3]+" - МПЗ не найдена!");
			Возврат;	
			КонецЕсли;
				Если ТипЗнч(ЗначениеПараметра1) = Тип("СправочникСсылка.Линейки") Тогда
				МестоХранения = ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(ЗначениеПараметра1,"МестоХраненияКанбанов");
				Иначе
				МестоХранения = ЗначениеПараметра1;			
				КонецЕсли;
		МестоХраненияОтправитель = ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоКоду(Массив[2]);
		П = Новый Структура("МестоХраненияОтправитель,МестоХраненияКанбанов,МПЗ,НомерЯчейки,Сотрудник",МестоХраненияОтправитель,МестоХранения,МПЗ,Массив[5],Объект.Исполнитель);
		ОткрытьФорму("ОбщаяФорма.ОформлениеПустыхКанбанов",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе 
		ВвестиКодDanfoss(Неопределено,СокрЛП(Данные));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостачу(Команда)
	Если ОбщийМодульАРМКлиент.ОформитьНедостачу(ЭтаФорма,Объект.РабочееМесто,Объект.ПроизводственноеЗадание) Тогда
	ОчиститьСсылкуНаПЗ();
	КонецЕсли;  
КонецПроцедуры
