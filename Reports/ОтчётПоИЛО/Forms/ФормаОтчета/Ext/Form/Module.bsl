﻿
&НаСервере
Функция ПолучитьДатуПриходаМПЗ(ДатаНач,МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОбороты.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.МестаХранения.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК МестаХраненияОбороты
	|ГДЕ
	|	МестаХраненияОбороты.МестоХранения В ИЕРАРХИИ(&СписокМестХранения)
	|	И МестаХраненияОбороты.МПЗ = &МПЗ
	|	И МестаХраненияОбороты.КоличествоПриход > 0";
Запрос.УстановитьПараметр("ДатаНач",ДатаНач);
Запрос.УстановитьПараметр("ДатаКон", ТекущаяДата());
Запрос.УстановитьПараметр("МПЗ", МПЗ);
Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.Регистратор);
	КонецЦикла;
Возврат(Неопределено);
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
Запрос = Новый Запрос;

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблГруппа = Макет.ПолучитьОбласть("Группа");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy");
ОблШапка.Параметры.ДатаКон = Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛьготнаяОчередь.НормаРасходов.Элемент.Родитель КАК Родитель,
	|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК Элемент,
	|	ЛьготнаяОчередь.Период КАК Период,
	|	ЛьготнаяОчередь.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
	|ГДЕ
	|	ЛьготнаяОчередь.Период МЕЖДУ &ДатаНач И &ДатаКон
	|	И ЛьготнаяОчередь.НормаРасходов.Элемент В ИЕРАРХИИ(&СписокМПЗ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЛьготнаяОчередь.НормаРасходов.Элемент.Наименование,
	|	Период
	|ИТОГИ ПО
	|	Родитель";
Запрос.УстановитьПараметр("ДатаНач", Отчет.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон", Отчет.Период.ДатаОкончания);
Запрос.УстановитьПараметр("СписокМПЗ", СписокМПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаГруппа = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаГруппа.Следующий() Цикл
	ОблГруппа.Параметры.ГруппаМПЗ = СокрЛП(ВыборкаГруппа.Родитель.Наименование);
	ОблГруппа.Параметры.Менеджер = СокрЛП(ВыборкаГруппа.Родитель.МенеджерПоЗакупкам.Наименование);
	ТабДок.Вывести(ОблГруппа);
	ВыборкаДетальныеЗаписи = ВыборкаГруппа.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,ВыборкаДетальныеЗаписи.Элемент,ВыборкаДетальныеЗаписи.Период) = 0 Тогда	
			ОблМПЗ.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.Элемент.Наименование);
			ОблМПЗ.Параметры.МПЗ = ВыборкаДетальныеЗаписи.Элемент;
				Если ТипЗнч(ВыборкаДетальныеЗаписи.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
				ОблМПЗ.Параметры.ГруппаПоЗакупкам = ВыборкаДетальныеЗаписи.Элемент.ГруппаПоЗакупкам;
				Иначе	
				ОблМПЗ.Параметры.ГруппаПоЗакупкам = "";
				КонецЕсли;
			ОблМПЗ.Параметры.ДатаПостановки = ВыборкаДетальныеЗаписи.Период;
			//ОблМПЗ.Параметры.ДатаСнятия = ВыборкаДетальныеЗаписи.ДатаОкончания;
			Результат = ПолучитьДатуПриходаМПЗ(ВыборкаДетальныеЗаписи.Период,ВыборкаДетальныеЗаписи.Элемент);
				Если Результат <> Неопределено Тогда
				ОблМПЗ.Параметры.ДатаСнятия = Результат.Дата;
				ОблМПЗ.Параметры.Документ = Результат;
				Иначе	
				ОблМПЗ.Параметры.ДатаСнятия = "";
				ОблМПЗ.Параметры.Документ = "";
				КонецЕсли;
			ТабДок.Вывести(ОблМПЗ);
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
