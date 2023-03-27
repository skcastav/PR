﻿
&НаСервере
Процедура СформироватьНаСервере(СписокКодов)
ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ТабДок.Вывести(ОблШапка);
Запрос = Новый Запрос;

	Для каждого КодDanfoss Из СписокКодов Цикл
	Код = Формат(КодDanfoss.Значение,"ЧЦ=8; ЧВН=; ЧГ=0");
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	БарКоды.ПЗ КАК ПЗ,
		|	БарКоды.Товар КАК Товар,
		|	БарКоды.БарКод КАК БарКод
		|ИЗ
		|	РегистрСведений.БарКоды КАК БарКоды
		|ГДЕ
		|	БарКоды.КодDanfoss = &КодDanfoss";
	Запрос.УстановитьПараметр("КодDanfoss", Код);	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОблМПЗ.Параметры.КодDanfoss = Код;
			ОблМПЗ.Параметры.Наименование = ВыборкаДетальныеЗаписи.Товар.Наименование;
			ОблМПЗ.Параметры.Товар = ВыборкаДетальныеЗаписи.Товар;
			ОблМПЗ.Параметры.БарКод = ВыборкаДетальныеЗаписи.БарКод;		
			Запрос.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ВыпускПродукции.Дата КАК Дата
				|ИЗ
				|	Документ.ВыпускПродукции КАК ВыпускПродукции
				|ГДЕ
				|	ВыпускПродукции.НаСклад = ИСТИНА
				|	И ВыпускПродукции.ДокументОснование = &ПЗ";
			Запрос.УстановитьПараметр("ПЗ", ВыборкаДетальныеЗаписи.ПЗ);	
			РезультатЗапроса = Запрос.Выполнить();	
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ОблМПЗ.Параметры.ДатаВыпуска = Формат(ВыборкаДетальныеЗаписи.Дата,"ДФ=dd.MM.yyyy");
				КонецЦикла;
			ТабДок.Вывести(ОблМПЗ);
			КонецЦикла;
		Иначе
		ОблМПЗ.Параметры.КодDanfoss = Код;
		ОблМПЗ.Параметры.Наименование = "";
		ОблМПЗ.Параметры.Товар = "";
		ОблМПЗ.Параметры.БарКод = "";
		ОблМПЗ.Параметры.ДатаВыпуска = "";
		ТабДок.Вывести(ОблМПЗ);
		КонецЕсли;
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c кодами Danfoss");
	Если Результат <> Неопределено Тогда
	СписокКодов = Новый СписокЗначений;

	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Обработка кодов Danfoss...");
		СписокКодов.Добавить(Число(ExcelЛист.Cells(к,3).Value));
	    КонецЦикла;
	Результат.Excel.Quit();
    СформироватьНаСервере(СписокКодов);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьДанные(КодDanfoss)
Данные = Новый Структура("БарКод,Товар,ДатаВыпуска","","","");
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	БарКоды.ПЗ КАК ПЗ,
	|	БарКоды.Товар КАК Товар,
	|	БарКоды.БарКод КАК БарКод
	|ИЗ
	|	РегистрСведений.БарКоды КАК БарКоды
	|ГДЕ
	|	БарКоды.КодDanfoss = &КодDanfoss";
Запрос.УстановитьПараметр("КодDanfoss", Формат(КодDanfoss,"ЧЦ=8; ЧВН=; ЧГ=0"));	
РезультатЗапроса = Запрос.Выполнить();	
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Данные.Товар = СокрЛП(ВыборкаДетальныеЗаписи.Товар.Наименование);
		Данные.БарКод = ВыборкаДетальныеЗаписи.БарКод;		
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВыпускПродукции.Дата КАК Дата
			|ИЗ
			|	Документ.ВыпускПродукции КАК ВыпускПродукции
			|ГДЕ
			|	ВыпускПродукции.НаСклад = ИСТИНА
			|	И ВыпускПродукции.ДокументОснование = &ПЗ";
		Запрос.УстановитьПараметр("ПЗ", ВыборкаДетальныеЗаписи.ПЗ);	
		РезультатЗапроса = Запрос.Выполнить();	
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Данные.ДатаВыпуска = Формат(ВыборкаДетальныеЗаписи.Дата,"ДФ=dd.MM.yyyy");
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
Возврат(Данные);
КонецФункции

&НаКлиенте
Процедура ОбработатьФайл(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c кодами Danfoss");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Обработка кодов Danfoss...");
		Данные = ПолучитьДанные(Число(ExcelЛист.Cells(к,3).Value));
			Если ЗначениеЗаполнено(Данные.БарКод) Тогда
			ExcelЛист.Cells(к,6).Value = Данные.БарКод;	
			ExcelЛист.Cells(к,7).Value = Данные.Товар;	
			ExcelЛист.Cells(к,8).Value = Данные.ДатаВыпуска;			
			КонецЕсли; 
	    КонецЦикла;
	Результат.ExcelКнига.SaveAs(Результат.ПолноеИмяФайла);
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры
