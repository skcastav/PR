﻿
&НаСервере
Функция ЕстьЛО(МТК)	
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛьготнаяОчередьСрезПоследних.ПЗ
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь.СрезПоследних КАК ЛьготнаяОчередьСрезПоследних
	|ГДЕ
	|	ЛьготнаяОчередьСрезПоследних.ПЗ.ДокументОснование = &ДокументОснование
	|	И ЛьготнаяОчередьСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
Запрос.УстановитьПараметр("ДокументОснование", МТК);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(Истина);
	КонецЦикла;
Возврат(Ложь);
КонецФункции 

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");


ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблЛинейка = Макет.ПолучитьОбласть("Линейка");
ОблМТК = Макет.ПолучитьОбласть("МТК");
ОблШапка2 = Макет.ПолучитьОбласть("Шапка2");
ОблТовар = Макет.ПолучитьОбласть("Товар");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка,
	|	МаршрутнаяКарта.Статус,
	|	МаршрутнаяКарта.Линейка КАК Линейка,
	|	МаршрутнаяКарта.Номенклатура,
	|	МаршрутнаяКарта.Количество,
	|	МаршрутнаяКарта.НомерОчереди КАК НомерОчереди,
	|	МаршрутнаяКарта.ДатаОтгрузки
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.Статус <> 3
	|	И МаршрутнаяКарта.Номенклатура.Товар.КодДанфосс ПОДОБНО &КодДанфосс
	|
	|УПОРЯДОЧИТЬ ПО
	|	Линейка,
	|	НомерОчереди
	|ИТОГИ ПО
	|	Линейка";
Запрос.УстановитьПараметр("КодДанфосс", "187F%");
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЛинейки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейки.Следующий() Цикл
	ОблЛинейка.Параметры.Линейка = ВыборкаЛинейки.Линейка;
	ТабДок.Вывести(ОблЛинейка);	
	ВыборкаДетальныеЗаписи = ВыборкаЛинейки.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОблМТК.Параметры.НомерМТК = ВыборкаДетальныеЗаписи.Ссылка.Номер;
		ОблМТК.Параметры.ДатаМТК = ВыборкаДетальныеЗаписи.Ссылка.Дата;
		ОблМТК.Параметры.Товар = ВыборкаДетальныеЗаписи.Номенклатура.Товар;
		ОблМТК.Параметры.КодDanfoss = ВыборкаДетальныеЗаписи.Номенклатура.Товар.КодДанфосс;
		ОблМТК.Параметры.Количество = ОбщийМодульВызовСервера.ПолучитьНезавершённоеКоличество(ТекущаяДата(),ВыборкаДетальныеЗаписи.Ссылка);
		ОблМТК.Параметры.ДатаОтгрузки = Формат(ВыборкаДетальныеЗаписи.ДатаОтгрузки,"ДФ=dd.MM.yyyy");
		Ст = ВыборкаДетальныеЗаписи.Ссылка.Статус;
			Если Ст = 0 Тогда
			ОблМТК.Параметры.Статус = "в ожидании";
			ИначеЕсли (Ст = 1)или(Ст = 4) Тогда
			ОблМТК.Параметры.Статус = "в работе";				
			ИначеЕсли Ст = 2 Тогда
			ОблМТК.Параметры.Статус = "остановлена";			
			КонецЕсли;
				Если ЕстьЛО(ВыборкаДетальныеЗаписи.Ссылка) Тогда				
				ОблМТК.Параметры.Статус = "в льготной очереди";
				КонецЕсли;  
		ТабДок.Вывести(ОблМТК);
		КонецЦикла;
	КонецЦикла;
ТабДок.Вывести(ОблШапка2);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МПЗ,
	|	МестаХраненияОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки КАК МестаХраненияОстатки
	|ГДЕ
	|	МестаХраненияОстатки.МПЗ.Товар.КодДанфосс ПОДОБНО &КодДанфосс
	|
	|УПОРЯДОЧИТЬ ПО
	|	МестаХраненияОстатки.МПЗ.Наименование";
Запрос.УстановитьПараметр("КодДанфосс", "187F%");
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ОблТовар.Параметры.Товар = ВыборкаДетальныеЗаписи.МПЗ.Товар;
	ОблТовар.Параметры.Количество = ВыборкаДетальныеЗаписи.КоличествоОстаток;
	ТабДок.Вывести(ОблТовар);
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 2;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерСтраницы = "A4";
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
СформироватьНаСервере();
КонецПроцедуры
