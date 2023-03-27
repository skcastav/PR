﻿
&НаСервере
Функция ПолучитьМестаХраненияКанбанов()
СписокМестХраненияКанбанов = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Линейки.МестоХраненияКанбанов КАК МестоХраненияКанбанов
	|ИЗ
	|	Справочник.Линейки КАК Линейки
	|ГДЕ
	|	Линейки.Подразделение В(&СписокПодразделений)
	|	И Линейки.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокМестХраненияКанбанов.Добавить(ВыборкаДетальныеЗаписи.МестоХраненияКанбанов);
	КонецЦикла;
Возврат(СписокМестХраненияКанбанов);
КонецФункции 

&НаСервере
Процедура ПолучитьОстаткиПоМестамХранения()	
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МПЗ КАК МПЗ,
	|	МестаХраненияОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	МестаХраненияОстатки.МестоХранения КАК МестоХранения
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки(&НаДату, ) КАК МестаХраненияОстатки
	|ГДЕ
	|	МестаХраненияОстатки.МестоХранения В(&СписокМестХранения)
	|	И МестаХраненияОстатки.МПЗ.Канбан.Подразделение = &Подразделение";
Запрос.УстановитьПараметр("НаДату", Отчет.Период.ДатаОкончания);
Запрос.УстановитьПараметр("Подразделение", ПодразделениеПоставщик);
	Если СписокМестХранения.Количество() > 0 Тогда
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
	Иначе
	Запрос.УстановитьПараметр("СписокМестХранения", ПолучитьМестаХраненияКанбанов());
	КонецЕсли;
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Выборка = ТаблицаИзделий.НайтиСтроки(Новый Структура("МестоХранения,Изделие",ВыборкаДетальныеЗаписи.МестоХранения,ВыборкаДетальныеЗаписи.МПЗ));
		Если Выборка.Количество() = 0 Тогда
		ТЧ = ТаблицаИзделий.Добавить();
		ТЧ.МестоХранения = ВыборкаДетальныеЗаписи.МестоХранения;
		ТЧ.Изделие = ВыборкаДетальныеЗаписи.МПЗ;
		ТЧ.КоличествоОстаток = ВыборкаДетальныеЗаписи.КоличествоОстаток;
		Иначе
		Выборка[0].КоличествоОстаток = ВыборкаДетальныеЗаписи.КоличествоОстаток;  
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры 

&НаСервере
Процедура ПроверитьПередачуВПроизводство(Выпуск)
	Если Выпуск.ДокументОснование.ДокументОснование.Ремонт Тогда	
	Возврат;
	КонецЕсли; 
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПередачаВПроизводствоСпецификация.МПЗ КАК МПЗ,
	|	ПередачаВПроизводствоСпецификация.Количество КАК Количество,
	|	ПередачаВПроизводствоСпецификация.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПередачаВПроизводствоСпецификация.Ссылка.МестоХранения КАК МестоХранения
	|ИЗ
	|	Документ.ПередачаВПроизводство.Спецификация КАК ПередачаВПроизводствоСпецификация
	|ГДЕ
	|	ПередачаВПроизводствоСпецификация.Ссылка.ДокументОснование = &ДокументОснование
	|	И ПередачаВПроизводствоСпецификация.МПЗ.Канбан.Подразделение = &Подразделение";
	Если СписокМестХранения.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И ПередачаВПроизводствоСпецификация.Ссылка.МестоХранения В(&СписокМестХранения)";
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
	КонецЕсли; 
		Если ТипЗнч(Выпуск) = Тип("ДокументСсылка.ВыпускПродукцииКанбан") Тогда
		Запрос.УстановитьПараметр("ДокументОснование", Выпуск.ДокументОснование.ДокументОснование);
		Иначе	
		Запрос.УстановитьПараметр("ДокументОснование", Выпуск.ДокументОснование);
		КонецЕсли; 
Запрос.УстановитьПараметр("Подразделение", ПодразделениеПоставщик);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаИзделий.Добавить();
	ТЧ.МестоХранения = ВыборкаДетальныеЗаписи.МестоХранения;
	ТЧ.Изделие = ВыборкаДетальныеЗаписи.МПЗ;
	ТЧ.Количество = ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Количество,ВыборкаДетальныеЗаписи.ЕдиницаИзмерения);
	КонецЦикла;
КонецПроцедуры 

&НаСервере
Процедура СформироватьНаСервере()
ТаблицаИзделий.Очистить();
ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМестоХранения = Макет.ПолучитьОбласть("МестоХранения");
ОблМестоХраненияИтого = Макет.ПолучитьОбласть("МестоХраненияИтого");
ОблИзделие = Макет.ПолучитьОбласть("Изделие");
ОблКонец = Макет.ПолучитьОбласть("Конец");
 
ОблШапка.Параметры.Период = Формат(Отчет.Период.ДатаОкончания,"ДФ=ММММгггг");
ОблШапка.Параметры.Поставщик = ПодразделениеПоставщик.Наименование;
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОбороты.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.МестаХранения.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК МестаХраненияОбороты
	|ГДЕ
	|	МестаХраненияОбороты.МестоХранения.Подразделение В(&СписокПодразделений)
	|	И МестаХраненияОбороты.КоличествоПриход > 0";
	Если СписокМестХранения.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И МестаХраненияОбороты.Регистратор.ДокументОснование.Линейка.МестоХраненияКанбанов В(&СписокМестХранения)";
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);	
	КонецЕсли; 
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Отчет.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Отчет.Период.ДатаОкончания));
Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ТипЗнч(ВыборкаДетальныеЗаписи.Регистратор) = Тип("ДокументСсылка.ВыпускПродукции")или
			 ТипЗнч(ВыборкаДетальныеЗаписи.Регистратор) = Тип("ДокументСсылка.ВыпускПродукцииКанбан") Тогда	
		ПроверитьПередачуВПроизводство(ВыборкаДетальныеЗаписи.Регистратор);
		КонецЕсли;
 	КонецЦикла;
ПолучитьОстаткиПоМестамХранения();
ТЗ = ТаблицаИзделий.Выгрузить();
ТЗ.Свернуть("МестоХранения,Изделие","Количество,КоличествоОстаток");
ТЗ.Сортировать("МестоХранения,Изделие");
ТекМХ = Неопределено;
КоличествоРасходГПИтого = 0;
КоличествоОстатокИтого = 0;
СебестоимостьРасходИтого = 0;
СебестоимостьОстатокИтого = 0;
КоличествоРасходГПВсего = 0;
КоличествоОстатокВсего = 0;
СебестоимостьРасходВсего = 0;
СебестоимостьОстатокВсего = 0;
	Для каждого ТЧ Из ТЗ Цикл		
		Если ТекМХ <> ТЧ.МестоХранения Тогда
			Если ТекМХ <> Неопределено Тогда
			ТабДок.ЗакончитьГруппуСтрок();
		    ОблМестоХраненияИтого.Параметры.КоличествоРасходГП = КоличествоРасходГПИтого;
			ОблМестоХраненияИтого.Параметры.КоличествоОстаток = КоличествоОстатокИтого;
 			ОблМестоХраненияИтого.Параметры.СебестоимостьРасход = СебестоимостьРасходИтого;
 			ОблМестоХраненияИтого.Параметры.СебестоимостьОстаток = СебестоимостьОстатокИтого;
			ТабДок.Вывести(ОблМестоХраненияИтого);
			КонецЕсли; 
		ОблМестоХранения.Параметры.МестоХранения = ТЧ.МестоХранения;
		ТабДок.Вывести(ОблМестоХранения);		
		ТабДок.НачатьГруппуСтрок("МестоХранения",Ложь);
		ТекМХ = ТЧ.МестоХранения;
		КоличествоРасходГПИтого = 0;
		КоличествоОстатокИтого = 0;
		СебестоимостьРасходИтого = 0;
		СебестоимостьОстатокИтого = 0;
		КонецЕсли;
 	ОблИзделие.Параметры.Изделие = ТЧ.Изделие;
 	ОблИзделие.Параметры.КоличествоРасходГП = ТЧ.Количество;
 	ОблИзделие.Параметры.КоличествоОстаток = ТЧ.КоличествоОстаток;
	Себестоимости = РегистрыСведений.Себестоимость.ПолучитьПоследнее(Отчет.Период.ДатаНачала,Новый Структура("Подразделение,Линейка,Номенклатура",ТЧ.Изделие.Канбан.ПодразделениеДляСебестоимости,Справочники.Линейки.ПустаяСсылка(),ТЧ.Изделие));
	Себестоимость = Себестоимости.СебестоимостьПолная;
	ОблИзделие.Параметры.Себестоимость = Себестоимость;
 	ОблИзделие.Параметры.СебестоимостьРасход = Себестоимость*ТЧ.Количество;
 	ОблИзделие.Параметры.СебестоимостьОстаток = Себестоимость*ТЧ.КоличествоОстаток;
	ТабДок.Вывести(ОблИзделие);
	КоличествоРасходГПИтого = КоличествоРасходГПИтого + ТЧ.Количество;
	КоличествоОстатокИтого = КоличествоОстатокИтого + ТЧ.КоличествоОстаток;
	СебестоимостьРасходИтого = СебестоимостьРасходИтого + ОблИзделие.Параметры.СебестоимостьРасход;
	СебестоимостьОстатокИтого = СебестоимостьОстатокИтого + ОблИзделие.Параметры.СебестоимостьОстаток;
	КоличествоРасходГПВсего = КоличествоРасходГПВсего + ТЧ.Количество;
	КоличествоОстатокВсего = КоличествоОстатокВсего + ТЧ.КоличествоОстаток;
	СебестоимостьРасходВсего = СебестоимостьРасходВсего + ОблИзделие.Параметры.СебестоимостьРасход;
	СебестоимостьОстатокВсего = СебестоимостьОстатокВсего + ОблИзделие.Параметры.СебестоимостьОстаток;
	КонецЦикла;
		Если ТекМХ <> Неопределено Тогда
		ТабДок.ЗакончитьГруппуСтрок();
		ОблМестоХраненияИтого.Параметры.КоличествоРасходГП = КоличествоРасходГПИтого;
		ОблМестоХраненияИтого.Параметры.КоличествоОстаток = КоличествоОстатокИтого;
 		ОблМестоХраненияИтого.Параметры.СебестоимостьРасход = СебестоимостьРасходИтого;
 		ОблМестоХраненияИтого.Параметры.СебестоимостьОстаток = СебестоимостьОстатокИтого;
		ТабДок.Вывести(ОблМестоХраненияИтого);
		КонецЕсли;
ОблКонец.Параметры.КоличествоРасходГП = КоличествоРасходГПВсего;
ОблКонец.Параметры.КоличествоОстаток = КоличествоОстатокВсего;
ОблКонец.Параметры.СебестоимостьРасход = СебестоимостьРасходВсего;
ОблКонец.Параметры.СебестоимостьОстаток = СебестоимостьОстатокВсего; 
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 3;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
