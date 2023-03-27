﻿
&НаСервере 
Перем ТаблицаСклада,ТаблицаСкладаКопия;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь; 
Показать = 0;
СортироватьПо = 1;
ОтобратьПо = 0;
Период.ДатаНачала = ТекущаяДата();
Период.ДатаОкончания = ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не Объект.Линейка.Пустая() Тогда
	ЛинейкаПриИзменении(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьТаблицуСклада()
ТаблицаСкладаКопия = ТаблицаСклада.Скопировать(); 
КонецПроцедуры 

&НаСервере
Процедура ВосстановитьТаблицуСклада()
ТаблицаСклада = ТаблицаСкладаКопия.Скопировать(); 
КонецПроцедуры 

&НаКлиенте
Процедура ПоказатьПриИзменении(Элемент)
ПолучитьДанныеПоЗаданиямНаСервере();
ПроверитьТаблицуЗаданий();
	Если Показать = 0 Тогда
	Элементы.ПоказатьЗаПериод.Доступность = Ложь;
	Элементы.Период.Доступность = Ложь;
	Иначе	
	Элементы.ПоказатьЗаПериод.Доступность = Истина;
	Элементы.Период.Доступность = Истина;	
	КонецЕсли; 
		Если Показать = 0 и СписокОборудования.Количество() = 0 и СортироватьПо = 1 и ОтобратьПо = 0 Тогда
		Элементы.ПолучитьЗадания.Доступность = Истина;
		Иначе
		Элементы.ПолучитьЗадания.Доступность = Ложь; 
		КонецЕсли;
КонецПроцедуры

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(Объект.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	Объект.Линейка = Справочники.Линейки.ПустаяСсылка();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
	Если Не МожноРаботатьВАРМ() Тогда
	Возврат;
	КонецЕсли;
ПолучитьЗадания(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьПоПриИзменении(Элемент)
ПолучитьДанныеПоЗаданиямНаСервере();
ПроверитьТаблицуЗаданий();
	Если Показать = 0 и СписокОборудования.Количество() = 0 и СортироватьПо = 1 и ОтобратьПо = 0 Тогда
	Элементы.ПолучитьЗадания.Доступность = Истина;
	Иначе
	Элементы.ПолучитьЗадания.Доступность = Ложь; 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьМТКДатчика(МТК)
Список = Новый СписокЗначений;

ВыбМТК = МТК;
	Пока ТипЗнч(ВыбМТК.ДокументОснование) = Тип("ДокументСсылка.МаршрутнаяКарта") Цикл
		Если ЗначениеЗаполнено(ВыбМТК.ДокументОснование) Тогда
		ВыбМТК = ВыбМТК.ДокументОснование;
			Если Список.НайтиПоЗначению(ВыбМТК) = Неопределено Тогда
			Список.Добавить(ВыбМТК);
			Иначе
			Возврат(Документы.МаршрутнаяКарта.ПустаяСсылка());
			КонецЕсли; 
		Иначе
		Возврат(Документы.МаршрутнаяКарта.ПустаяСсылка());		
		КонецЕсли;	
	КонецЦикла; 
Возврат(ВыбМТК);
КонецФункции

&НаСервере
Функция ПолучитьКоличествоИзготовленных(ПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыполнениеЭтаповПроизводства.Количество
	|ИЗ
	|	РегистрСведений.ВыполнениеЭтаповПроизводства КАК ВыполнениеЭтаповПроизводства
	|ГДЕ
	|	ВыполнениеЭтаповПроизводства.МТК = &МТК";
Запрос.УстановитьПараметр("МТК", ПЗ.ДокументОснование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Количество = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Возврат(Количество);
КонецФункции 

&НаСервере
Процедура ПолучитьДанныеПоЗаданиямНаСервере()
ТаблицаЗаданий.Очистить();
Запрос = Новый Запрос;
ЗапросЛО = Новый Запрос;
СписокМестХранения = Новый СписокЗначений;

СписокМестХранения.Добавить(Объект.Линейка.Подразделение.МестоХраненияПоУмолчанию);
СписокМестХранения.Добавить(Объект.Линейка.МестоХраненияКанбанов);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПервых.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПервых.Изделие,
	|	ЭтапыПроизводственныхЗаданийСрезПервых.ДатаНачала
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПервых КАК ЭтапыПроизводственныхЗаданийСрезПервых
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПервых.Линейка = &Линейка
	|	И ЭтапыПроизводственныхЗаданийСрезПервых.ПЗ.ДокументОснование.Статус <> 3
	|	И ЭтапыПроизводственныхЗаданийСрезПервых.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	Если Показать > 0 и ПоказатьЗаПериод Тогда	
	Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПервых.ПЗ.Дата МЕЖДУ &ДатаНач И &ДатаКон";
	Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Период.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон",КонецДня(Период.ДатаОкончания));
	КонецЕсли;  
		Если ОтобратьПо = 1 Тогда
		Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПервых.Изделие.Канбан.Служебный = ЛОЖЬ";		
		ИначеЕсли ОтобратьПо = 2 Тогда
		Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПервых.Изделие.Канбан.Служебный = ИСТИНА";	
		КонецЕсли;
Запрос.УстановитьПараметр("Линейка",Объект.Линейка);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл   
    ТЧ = ТаблицаЗаданий.Добавить();
	ТЧ.Спецификация = ВыборкаДетальныеЗаписи.Изделие;
	ТЧ.Статус = ПолучитьСтатус(ВыборкаДетальныеЗаписи.Изделие);
	ТЧ.СтатусМТК = ВыборкаДетальныеЗаписи.ПЗ.ДокументОснование.Статус;
	ТЧ.ПЗ = ВыборкаДетальныеЗаписи.ПЗ;
	ТЧ.ДатаПЗ = ВыборкаДетальныеЗаписи.ПЗ.Дата;
	ТЧ.ДатаЗапуска = ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска;
	ТЧ.Приоритет = ?(ВыборкаДетальныеЗаписи.ПЗ.НомерОчереди > 0,Истина,Ложь);
	ТЧ.НомерОчереди = ВыборкаДетальныеЗаписи.ПЗ.НомерОчереди;
	ТЧ.МестоХраненияПотребитель = ВыборкаДетальныеЗаписи.ПЗ.ДокументОснование.МестоХраненияПотребитель;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.ПЗ.Количество;
	ТЧ.КоличествоВыпущено = ПолучитьКоличествоИзготовленных(ВыборкаДетальныеЗаписи.ПЗ);
	ТЧ.ОборудованиеНазначено = ?(ВыборкаДетальныеЗаписи.ПЗ.Оборудование.Количество() > 0, Истина, Ложь);
	ТЧ.ДатаНачала = ВыборкаДетальныеЗаписи.ДатаНачала;
		Если ВыборкаДетальныеЗаписи.Изделие.Канбан.Служебный Тогда
		ТЧ.МТКДатчика = ПолучитьМТКДатчика(ВыборкаДетальныеЗаписи.ПЗ.ДокументОснование);
		ТЧ.МТКРодителя = ВыборкаДетальныеЗаписи.ПЗ.ДокументОснование.ДокументОснование;
		КонецЕсли; 
	ЗапросЛО.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЛьготнаяОчередь.Период КАК Период
		|ИЗ
		|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
		|ГДЕ
		|	ЛьготнаяОчередь.НормаРасходов.Элемент = &МПЗ
		|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период";
	ЗапросЛО.УстановитьПараметр("МПЗ",ВыборкаДетальныеЗаписи.Изделие);
	РезультатЗапросаЛО = ЗапросЛО.Выполнить();
	ВыборкаЛО = РезультатЗапросаЛО.Выбрать();
		Пока ВыборкаЛО.Следующий() Цикл
		ТЧ.ЛОДатчиков = Истина;
		ТЧ.ДатаЛО = ВыборкаЛО.Период;
		КонецЦикла;
	ЗапросЛО.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ
		|ИЗ
		|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
		|ГДЕ
		|	ЛьготнаяОчередь.ПЗ = &ПЗ
		|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	ЗапросЛО.УстановитьПараметр("ПЗ",ВыборкаДетальныеЗаписи.ПЗ);
	РезультатЗапросаЛО = ЗапросЛО.Выполнить();
	ТЧ.ЛО = Не РезультатЗапросаЛО.Пустой();		    
	КонецЦикла;
		Если СортироватьПо = 1 Тогда
		ТаблицаЗаданий.Сортировать("НомерОчереди");		
		ИначеЕсли СортироватьПо = 2 Тогда
		ТаблицаЗаданий.Сортировать("Спецификация,ЛОДатчиков Убыв,ДатаЛО,ДатаПЗ");			
		КонецЕсли; 
ПроверитьТаблицуЗаданий();
ТаблицаСклада = ОбщийМодульВызовСервера.СоздатьТаблицуОстатковВиртуальныхСкладов(СписокМестХранения,ТекущаяДата());
	Если ТаблицаСклада.Количество() > 0 Тогда
		Для каждого ТЧ Из ТаблицаЗаданий Цикл
			Если Не ЗначениеЗаполнено(ТЧ.ДатаЗапуска) Тогда
			СохранитьТаблицуСклада();
			ТЧ.ЛО = ПроверитьНаЛОНаСервере(ТЧ.ПЗ,ТЧ.Спецификация,ТЧ.Количество);
				Если ТЧ.ЛО Тогда
				ВосстановитьТаблицуСклада();
				КонецЕсли; 
			КонецЕсли; 	
		КонецЦикла;
	Иначе
	Сообщить("Таблица остатков по местам хранения пустая!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗадания(Команда)
Состояние("Обработка...",,"Получение и проверка заданий...");
ПолучитьДанныеПоЗаданиямНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатусМТК(ПЗ)
Возврат(ПЗ.ДокументОснование.Статус);
КонецФункции

&НаСервере
Функция ВнесеныТО(ПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НормыРасходовСрезПоследних.Элемент КАК Элемент
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(
	|			&НаДату,
	|			Владелец = &Владелец
	|				И Элемент ССЫЛКА Справочник.ТехОперации) КАК НормыРасходовСрезПоследних
	|ГДЕ
	|	НормыРасходовСрезПоследних.Норма > 0
	|	И НормыРасходовСрезПоследних.НормаРасходов.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("НаДату", ПЗ.Дата);
Запрос.УстановитьПараметр("Владелец", ПЗ.Изделие);
Возврат(Не Запрос.Выполнить().Пустой());
КонецФункции

&НаКлиенте
Процедура НазначитьОборудование(Команда)
СписокПЗ = Новый СписокЗначений;

	Для каждого ТЧ Из ТаблицаЗаданий Цикл
		Если ТЧ.Пометка Тогда
			Если Не ТЧ.ЛО Тогда
				Если Не ТЧ.ОборудованиеНазначено Тогда
				СписокПЗ.Добавить(ТЧ.ПЗ,""+ТЧ.ПЗ+" ("+СокрЛП(ТЧ.Спецификация)+")");
				Продолжить;
				КонецЕсли;		
			КонецЕсли;
		ТЧ.Пометка = Ложь;
		КонецЕсли; 
	КонецЦикла;
		Если СписокПЗ.Количество() > 0 Тогда
		Результат = ОткрытьФормуМодально("Обработка.РабочееМестоКанбанУД_Мастер.Форма.ДобавлениеТО",Новый Структура("СписокПЗ",СписокПЗ)); 
			Если Результат Тогда
				Для каждого ТЧ Из ТаблицаЗаданий Цикл
					Если ТЧ.Пометка Тогда
					ТЧ.ОборудованиеНазначено = Истина;
					ТЧ.Пометка = Ложь;
					КонецЕсли; 
				КонецЦикла;	
			КонецЕсли;
		Иначе
		Сообщить("Список выбранных заданий пустой!");
		КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УстановитьНомерОчередиПЗ(ПЗ,НО)
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	МТКОбъект = ПЗ.ДокументОснование.ПолучитьОбъект();
	МТКОбъект.НомерОчереди = НО;
	МТКОбъект.Записать();
	//ОбщийМодульРаботаСРегистрами.ИзменитьНомерОчереди(МТКОбъект.Ссылка,НО);
	ПЗОбъект = ПЗ.ПолучитьОбъект();
	ПЗОбъект.НомерОчереди = НО;
	ПЗОбъект.Записать();
	//ОбщийМодульРаботаСРегистрами.ИзменитьНомерОчереди(ПЗОбъект.Ссылка,НО);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Ложь);
	КонецПопытки;
Возврат(Истина);
КонецФункции

&НаСервере
Процедура ОтменитьОборудованиеНаСервере()
	Для каждого ТЧ Из ТаблицаЗаданий Цикл
		Если ТЧ.Пометка Тогда
			Если ТЧ.ПЗ.ДокументОснование.Статус = 0 Тогда
			ПЗОбъект = ТЧ.ПЗ.ПолучитьОбъект();
			ПЗОбъект.Оборудование.Очистить();
			ПЗОбъект.Записать();
			ТЧ.ОборудованиеНазначено = Ложь;
			ТЧ.Пометка = Ложь;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;			
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьОборудование(Команда)
ОтменитьОборудованиеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПроверитьТаблицуЗаданий()
	Если СортироватьПо = 1 Тогда
	ТаблицаЗаданий.Сортировать("НомерОчереди");		
	ИначеЕсли СортироватьПо = 2 Тогда
	ТаблицаЗаданий.Сортировать("Спецификация,ЛОДатчиков Убыв,ДатаЛО,ДатаПЗ");			
	КонецЕсли;	
		Для каждого ТЧ Из ТаблицаЗаданий Цикл
		ТЧ.Показать = Ложь;
			Если Показать = 0 Тогда
			ТЧ.Показать = Истина;
			ИначеЕсли Показать = 1 Тогда
 				Если Не ТЧ.ОборудованиеНазначено Тогда
				ТЧ.Показать = Истина; 	
				КонецЕсли;
			ИначеЕсли Показать = 2 Тогда
				Если ТЧ.ОборудованиеНазначено Тогда
				ТЧ.Показать = Истина;	
				КонецЕсли;
			ИначеЕсли Показать = 3 Тогда
				Если ЗначениеЗаполнено(ТЧ.ДатаНачала) Тогда
				ТЧ.Показать = Истина;	
				КонецЕсли; 
			Иначе
				Если ТЧ.ЛО = Истина Тогда
				ТЧ.Показать = Истина;
				КонецЕсли;
			КонецЕсли;	
		КонецЦикла;
Отбор = Новый Структура("Показать", Истина);
Элементы.ТаблицаЗаданий.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);	
КонецПроцедуры

&НаСервере
Функция ПроверитьНаСкладеНаСервере(МПЗ,Количество)
Выборка = ТаблицаСклада.НайтиСтроки(Новый Структура("МПЗ",МПЗ));
	Если Выборка.Количество() > 0 Тогда
		Если Выборка[0].Количество >= Количество Тогда
		Выборка[0].Количество = Выборка[0].Количество - Количество;
		Возврат(Истина);
		КонецЕсли;
	КонецЕсли;
Возврат(Ложь);
КонецФункции

&НаСервере
Процедура РаскрытьНаМПЗиПроверить(Узел,ЭтапСпецификации,КолУзла)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ЭтапСпецификации,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Номенклатура")Тогда
			Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
			РаскрытьНаМПЗиПроверить(Узел,ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
			Продолжить;
			ИначеЕсли Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда
				Если Не ВыборкаНР.Элемент.Канбан.РезервироватьВПроизводстве Тогда		
				Продолжить;
				КонецЕсли;			
			КонецЕсли;
		Выборка = Этапы.НайтиСтроки(Новый Структура("ЭтапСпецификации",ВыборкаНР.Элемент));
        	Если Выборка.Количество() > 0 Тогда
			Продолжить;
			КонецЕсли;
		КонецЕсли;
	ТаблицаМПЗ.Очистить();	
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = ВыборкаНР.Элемент;
	ТЧ.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
	ТЧ.Приоритет = 1;
	ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(ВыборкаНР.Ссылка,ТекущаяДата(),Истина);
		Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.МПЗ = ТЧ_ТА.Элемент;
		ТЧ.Количество = ПолучитьБазовоеКоличество(ТЧ_ТА.Норма,ТЧ_ТА.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
		Статус = ПолучитьСтатус(ТЧ_ТА.Элемент);
			Если Статус = Перечисления.СтатусыМПЗ.ДоИсчерпанияЗапасов Тогда
			ТЧ.Приоритет = 0;
			ИначеЕсли Статус = Перечисления.СтатусыМПЗ.ПроблеммыЛогистики Тогда
			ТЧ.Приоритет = 0;			
			Иначе	
			ТЧ.Приоритет = ТЧ_ТА.Ссылка.Приоритет + 1;
			КонецЕсли; 
		КонецЦикла;
	ТаблицаМПЗ.Сортировать("Приоритет");
	флЗарезервирован = Ложь;
		Для каждого ТЧ Из ТаблицаМПЗ Цикл
			Если ПроверитьНаСкладеНаСервере(ТЧ.МПЗ,ТЧ.Количество) Тогда 
			флЗарезервирован = Истина;
			Прервать;				
			КонецЕсли; 
		КонецЦикла;
			Если Не флЗарезервирован Тогда
			СписокЛО.Добавить(ВыборкаНР.Ссылка);
			КонецЕсли;  		
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ПроверитьНаЛОНаСервере(ПЗ,Спецификация,Количество)
СписокЛО.Очистить();
Этапы.Очистить();
ЭтапыАРМ.Очистить();	
РезультатПроверки = ОбщийМодульСозданиеДокументов.ПроверитьЭтапыСпецификации(Объект.Линейка,Спецификация);
	Если РезультатПроверки.Пустая() Тогда
	ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповСпецификации(Этапы,Спецификация,Количество,Ложь,ТекущаяДата());
		Для каждого ТЧ_Этап Из Этапы Цикл
		РаскрытьНаМПЗиПроверить(ТЧ_Этап.ЭтапСпецификации,ТЧ_Этап.ЭтапСпецификации,ТЧ_Этап.Количество);
		КонецЦикла;
	ОбщийМодульРаботаСРегистрами.ОбработкаЛьготнойОчереди(ПЗ,СписокЛО);
		Если СписокЛО.Количество() > 0 Тогда 
		Возврат(Истина);
		КонецЕсли; 
	Иначе
	Сообщить("Не найдено рабочее место для "+РезультатПроверки);
	КонецЕсли;
Возврат(Ложь);
КонецФункции 

&НаСервере
Процедура ВыбратьПЗПоИзделиюНаСервере(Спецификация)
	Для каждого ТЧ Из ТаблицаЗаданий Цикл
	ТЧ.Пометка = Ложь;
		Если ТЧ.ПЗ.ДокументОснование.Статус = 0 Тогда
			Если Не ТЧ.ЛО Тогда
				Если Не ТЧ.ОборудованиеНазначено Тогда
					Если ТЧ.Спецификация = Спецификация Тогда
					ТЧ.Пометка = Истина;
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПЗПоИзделию(Команда)
ВыбратьПЗПоИзделиюНаСервере(Элементы.ТаблицаЗаданий.ТекущиеДанные.Спецификация);
КонецПроцедуры

&НаСервере
Процедура ВыбратьПЗПоТОНаСервере()
ТЗЭталон = ТаблицаТО.Выгрузить();
ТЗЭталон.Свернуть("ТехОперация","Количество");
	Для каждого ТЧ Из ТаблицаЗаданий Цикл
	ТЧ.Пометка = Ложь;
		Если ТЧ.ПЗ.ДокументОснование.Статус = 0 Тогда
			Если Не ТЧ.ЛО Тогда
				Если Не ТЧ.ОборудованиеНазначено Тогда
				ТаблицаТО.Очистить();
				ПолучитьТаблицуТО(ТЧ.Спецификация,1);
				ТЗ = ТаблицаТО.Выгрузить();
				ТЗ.Свернуть("ТехОперация","Количество");
				флСовпадают = Истина;
					Для каждого ТЧ_ТО Из ТЗ Цикл
					Выборка = ТЗЭталон.Найти(ТЧ_ТО.ТехОперация,"ТехОперация");	
						Если Выборка = Неопределено Тогда	
						флСовпадают = Ложь;
						Прервать;
						Иначе
							Если ТЧ_ТО.Количество <> Выборка.Количество Тогда
							флСовпадают = Ложь;
							Прервать;
							КонецЕсли; 
						КонецЕсли; 
					КонецЦикла;
						Если флСовпадают Тогда
							Для каждого ТЧ_ТО_Эталон Из ТЗЭталон Цикл
							Выборка	= ТЗ.Найти(ТЧ_ТО_Эталон.ТехОперация,"ТехОперация");
								Если Выборка = Неопределено Тогда	
								флСовпадают = Ложь;
								Прервать;
								Иначе
									Если ТЧ_ТО_Эталон.Количество <> Выборка.Количество Тогда
									флСовпадают = Ложь;
									Прервать;
									КонецЕсли; 
								КонецЕсли; 
							КонецЦикла;
						КонецЕсли;  	
							Если флСовпадают Тогда
							ТЧ.Пометка = Истина;
							КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьТаблицуТО(ЭтапСпецификации,Количество)
ВыборкаДетальныеЗаписи = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_ТО(ЭтапСпецификации,ТекущаяДата());
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
		ПолучитьТаблицуТО(ВыборкаДетальныеЗаписи.Элемент,ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения)*Количество);
		ИначеЕсли ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация Тогда
		ТЧ = ТаблицаТО.Добавить();
		ТЧ.ТехОперация = ВыборкаДетальныеЗаписи.Элемент;
			Если ВыборкаДетальныеЗаписи.Элемент.Оборудование.Количество() > 0 Тогда
			ТЧ.Количество = ВыборкаДетальныеЗаписи.Норма*Количество;	
			КонецЕсли;
		ИначеЕсли (ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Деталь)или
				  (ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Узел) Тогда	
			Если Не ВыборкаДетальныеЗаписи.Элемент.Канбан.Пустая() Тогда	
			Продолжить;
			КонецЕсли; 
		ПолучитьТаблицуТО(ВыборкаДетальныеЗаписи.Элемент,ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения)*Количество);
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПЗПоТО(Команда)
Состояние("Обработка...",,"Сравнение тех. операций...");
ТаблицаТО.Очистить();
ПолучитьТаблицуТО(Элементы.ТаблицаЗаданий.ТекущиеДанные.Спецификация,1);
ВыбратьПЗПоТОНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПЗ(Команда)
ТаблицаТО.Очистить();
ПолучитьТаблицуТО(Элементы.ТаблицаЗаданий.ТекущиеДанные.Спецификация,1);
	Если ТаблицаТО.Количество() > 0 Тогда	
	Элементы.ТаблицаЗаданий.ТекущиеДанные.Пометка = Истина;
	Иначе
	Сообщить("Не найдено тех. операций по выбранной спецификации!");	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВОжиданииПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРаспределенныеПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВРаботеПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура СписокОборудованияПриИзменении(Элемент)
	Если Показать = 0 и СписокОборудования.Количество() = 0 и СортироватьПо = 1 и ОтобратьПо = 0 Тогда
	Элементы.ПолучитьЗадания.Доступность = Истина;
	Иначе
	Элементы.ПолучитьЗадания.Доступность = Ложь; 
	КонецЕсли;
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНомерОчереди(Команда)
НО = Элементы.ТаблицаЗаданий.ТекущиеДанные.НомерОчереди;
	Если ВвестиЧисло(НО,"Введите номер очереди",6,0) Тогда
		Если УстановитьНомерОчередиПЗ(Элементы.ТаблицаЗаданий.ТекущиеДанные.ПЗ,НО) Тогда
		Элементы.ТаблицаЗаданий.ТекущиеДанные.НомерОчереди = НО;
		Элементы.ТаблицаЗаданий.ТекущиеДанные.Приоритет = ?(НО > 0,Истина,Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоПриИзменении(Элемент)
	Если СортироватьПо = 1 Тогда
	ТаблицаЗаданий.Сортировать("НомерОчереди");
	ИначеЕсли СортироватьПо = 2 Тогда
	ТаблицаЗаданий.Сортировать("Спецификация,ЛОДатчиков Убыв,ДатаЛО,ДатаПЗ");			
	КонецЕсли;
		Если Показать = 0 и СписокОборудования.Количество() = 0 и СортироватьПо = 1 и ОтобратьПо = 0 Тогда
		Элементы.ПолучитьЗадания.Доступность = Истина;
		Иначе
		Элементы.ПолучитьЗадания.Доступность = Ложь; 
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Подразделение) Тогда
	Ф = ПолучитьФорму("Справочник.Линейки.Форма.ФормаВыбора");
	ЭлементОтбора = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение = Подразделение;

	ЭлементОформления = Ф.Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	УслОформ = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УслОформ.Использование = Истина;
	УслОформ.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
	УслОформ.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	УслОформ.ПравоеЗначение = Подразделение;
	Результат = Ф.ОткрытьМодально();
		Если Результат <> Неопределено Тогда
		Объект.Линейка = Результат;
		КонецЕсли;  
	Иначе
	Сообщить("Выберите подразделение!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЗаПериодПриИзменении(Элемент)
ПолучитьДанныеПоЗаданиямНаСервере();
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
ПолучитьДанныеПоЗаданиямНаСервере();
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ВнестиТОВСпецификацию(Команда)
ОткрытьФорму("Обработка.ГрупповоеВнесениеТехОпераций.Форма",Новый Структура("Спецификация",Элементы.ТаблицаЗаданий.ТекущиеДанные.Спецификация));
КонецПроцедуры
