﻿
&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

Запрос = Новый Запрос;

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблПЗ = Макет.ПолучитьОбласть("ПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");
	Для каждого ТЧ Из СписокМТК Цикл
		Если ТЧ.Пометка Тогда
		ОблШапка.Параметры.НомерМТК = ТЧ.Значение.Номер;	
		ТабДок.Вывести(ОблШапка);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПроизводственноеЗадание.Ссылка,
			|	ДрагоценныеМеталлы.ДМ1,
			|	ДрагоценныеМеталлы.ДМ2,
			|	ДрагоценныеМеталлы.ДМУзел
			|ИЗ
			|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
			|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ДрагоценныеМеталлы КАК ДрагоценныеМеталлы
			|		ПО ПроизводственноеЗадание.Ссылка = ДрагоценныеМеталлы.ПЗ
			|ГДЕ
			|	ПроизводственноеЗадание.ДокументОснование = &ДокументОснование";
		Запрос.УстановитьПараметр("ДокументОснование", ТЧ.Значение);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОблПЗ.Параметры.НомерПЗ = ВыборкаДетальныеЗаписи.Ссылка.Номер;
			ОблПЗ.Параметры.ДМ1 = ВыборкаДетальныеЗаписи.ДМ1;
			ОблПЗ.Параметры.ДМ2 = ВыборкаДетальныеЗаписи.ДМ2;
			ОблПЗ.Параметры.ДМУзел = ВыборкаДетальныеЗаписи.ДМУзел;	
			ТабДок.Вывести(ОблПЗ);
			КонецЦикла;
		ТабДок.Вывести(ОблКонец);
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
 
&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЛинейкаПриИзмененииНаСервере()
СписокМТК.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.Статус <> 3
	|	И МаршрутнаяКарта.Линейка = &Линейка";
Запрос.УстановитьПараметр("Линейка", Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокМТК.Добавить(ВыборкаДетальныеЗаписи.Ссылка,,Истина);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
ЛинейкаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из СписокМТК Цикл
	ТЧ.Пометка = Истина;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из СписокМТК Цикл
	ТЧ.Пометка = Ложь;
	КонецЦикла; 
КонецПроцедуры
