﻿
&НаСервере
Процедура ПроверитьНаСервере()
ТаблицаМПЗ.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Товары КАК Товары
	|ГДЕ
	|	Товары.ЭтоГруппа = ЛОЖЬ";
	Если СписокГруппТоваров.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И Товары.Ссылка В ИЕРАРХИИ(&СписокГруппТоваров)";
	Запрос.УстановитьПараметр("СписокГруппТоваров",СписокГруппТоваров);
	КонецЕсли; 
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО	Товары.Родитель.Наименование, Товары.Наименование";
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл	
	флНайден = Ложь;
	Выборка = Справочники.Материалы.Выбрать(,,Новый Структура("Товар",ВыборкаДетальныеЗаписи.Ссылка));
		Пока Выборка.Следующий() Цикл
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.Товар = ВыборкаДетальныеЗаписи.Ссылка;
		ТЧ.МПЗ = Выборка.Ссылка;
		ТЧ.Статус = ПолучитьСтатус(Выборка.Ссылка);
		ТЧ.ТНП = Истина;
		флНайден = Истина;
		КонецЦикла;
	Выборка = Справочники.Номенклатура.Выбрать(,,Новый Структура("Товар",ВыборкаДетальныеЗаписи.Ссылка));
		Пока Выборка.Следующий() Цикл
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.Товар = ВыборкаДетальныеЗаписи.Ссылка;
		ТЧ.МПЗ = Выборка.Ссылка;
		ТЧ.Статус = ПолучитьСтатус(Выборка.Ссылка);
		флНайден = Истина;
		КонецЦикла;
			Если Не флНайден Тогда
			ТЧ = ТаблицаМПЗ.Добавить();
			ТЧ.Товар = ВыборкаДетальныеЗаписи.Ссылка;	
			КонецЕсли;
	КонецЦикла;
 КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
ПроверитьНаСервере();
КонецПроцедуры
