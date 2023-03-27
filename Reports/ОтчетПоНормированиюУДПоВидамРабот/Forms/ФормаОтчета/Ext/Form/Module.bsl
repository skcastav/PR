﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.НаДату = ТекущаяДата();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокТОИзделия(ТаблицаТО,Изделие,КолУзла)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Элемент,
	|	НормыРасходовСрезПоследних.Норма,
	|	НормыРасходов.ВидЭлемента
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, ) КАК НормыРасходовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
	|ГДЕ
	|	НормыРасходов.ПометкаУдаления = ЛОЖЬ
	|	И НормыРасходов.Владелец = &Владелец
	|	И (ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.ТехОперации)
    |      ИЛИ ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.Номенклатура))
	|	И НормыРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("НаДату", Отчет.НаДату);
Запрос.УстановитьПараметр("Владелец", Изделие);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация Тогда
		ТЧ = ТаблицаТО.Добавить();
		ТЧ.ТО = ВыборкаДетальныеЗаписи.Элемент;
		ТЧ.ВидРабот = ВыборкаДетальныеЗаписи.Элемент.ВидРабот;
		НормыТО = РегистрыСведений.НормыТО.ПолучитьПоследнее(Отчет.НаДату,Новый Структура("ТехОперация",ВыборкаДетальныеЗаписи.Элемент));
		ТЧ.МВ = НормыТО.МашинноеВремя;		
		ТЧ.НВ = НормыТО.Норма*ВыборкаДетальныеЗаписи.Норма*КолУзла;
		ТЧ.Стоимость = НормыТО.Стоимость;
		Иначе
		ПолучитьСписокТОИзделия(ТаблицаТО,ВыборкаДетальныеЗаписи.Элемент,КолУзла*ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения));
		КонецЕсли; 		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
Запрос = Новый Запрос;
СписокВР = Новый СписокЗначений;
ТаблицаТО = Новый ТаблицаЗначений;

ТаблицаТО.Колонки.Добавить("ТО",Новый ОписаниеТипов("СправочникСсылка.ТехОперации"));
ТаблицаТО.Колонки.Добавить("ВидРабот",Новый ОписаниеТипов("СправочникСсылка.ВидыРабот"));
ТаблицаТО.Колонки.Добавить("МВ",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(5,2)));
ТаблицаТО.Колонки.Добавить("НВ",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(8,4)));
ТаблицаТО.Колонки.Добавить("Стоимость",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(8,4)));

Выборка = Справочники.ВидыРабот.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если СписокВидовРабот.Количество() > 0 Тогда
			Если СписокВидовРабот.НайтиПоЗначению(Выборка.Ссылка) <> Неопределено Тогда
			СписокВР.Добавить(Выборка.Ссылка,Выборка.Код);
			КонецЕсли;
		Иначе
        СписокВР.Добавить(Выборка.Ссылка,Выборка.Код);
		КонецЕсли;
	КонецЦикла;
СписокВР.СортироватьПоПредставлению(); 

ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапкаОбщая = Макет.ПолучитьОбласть("Шапка|Общая");
ОблШапкаВидРабот = Макет.ПолучитьОбласть("Шапка|ВидРабот");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблИзделиеОбщая = Макет.ПолучитьОбласть("Изделие|Общая");
ОблИзделиеВидРабот = Макет.ПолучитьОбласть("Изделие|ВидРабот");
ОблИзделиеИтого = Макет.ПолучитьОбласть("Изделие|Итого");
ОблКонецОбщая = Макет.ПолучитьОбласть("Конец|Общая");
ОблКонецВидРабот = Макет.ПолучитьОбласть("Конец|ВидРабот");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");
ОблТО = Макет.ПолучитьОбласть("ТО");

ОблШапкаОбщая.Параметры.НаДату = Формат(Отчет.НаДату,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапкаОбщая);
	Для каждого ВидРабот Из СписокВР Цикл
	ОблШапкаВидРабот.Параметры.ВидРабот = ВидРабот.Значение;	
	ТабДок.Присоединить(ОблШапкаВидРабот);				
	КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Линейка КАК Линейка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
	Если СписокНоменклатуры.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И Номенклатура.Ссылка В ИЕРАРХИИ(&СписокНоменклатуры)";
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	КонецЕсли; 
Запрос.Текст = Запрос.Текст + "	УПОРЯДОЧИТЬ ПО
								|	Номенклатура.Линейка.Наименование,
								|	Номенклатура.Наименование
								|ИТОГИ ПО
								|	Линейка";
Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЛинейки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейки.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаЛинейки.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТаблицаТО.Очистить();
		ПолучитьСписокТОИзделия(ТаблицаТО,ВыборкаДетальныеЗаписи.Ссылка,1);
		ТаблицаТО.Сортировать("ВидРабот");
		ОблИзделиеОбщая.Параметры.Линейка = ВыборкаЛинейки.Линейка;
		ОблИзделиеОбщая.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.Ссылка.Наименование);
		ОблИзделиеОбщая.Параметры.Изделие = ВыборкаДетальныеЗаписи.Ссылка;
		ТабДок.Вывести(ОблИзделиеОбщая);
		МашинноеВремяИтого = 0;
		НВИтого = 0;	
		СтоимостьИтого = 0;
			Для каждого ВидРабот Из СписокВР Цикл
			МашинноеВремя = 0;
			НВ = 0;	
			Стоимость = 0;
			Выборка = ТаблицаТО.НайтиСтроки(Новый Структура("ВидРабот",ВидРабот.Значение));
				Для к = 0 По Выборка.ВГраница() Цикл
				НормыТО = РегистрыСведений.НормыТО.ПолучитьПоследнее(Отчет.НаДату,Новый Структура("ТехОперация",Выборка[к].ТО));	
				МашинноеВремя = МашинноеВремя + Выборка[к].МВ;
				НВ = НВ + Выборка[к].НВ;
				Стоимость = Стоимость + Выборка[к].НВ/60*Выборка[к].Стоимость;
				КонецЦикла;
			МашинноеВремяИтого = МашинноеВремяИтого + МашинноеВремя;
			НВИтого = НВИтого + НВ;	
			СтоимостьИтого = СтоимостьИтого + Стоимость;
			ОблИзделиеВидРабот.Параметры.МашинноеВремя = МашинноеВремя;
			ОблИзделиеВидРабот.Параметры.НВ = НВ;
 			ОблИзделиеВидРабот.Параметры.Стоимость = Стоимость;  
			ТабДок.Присоединить(ОблИзделиеВидРабот);				
			КонецЦикла;
		ОблИзделиеИтого.Параметры.МашинноеВремяИтого = МашинноеВремяИтого;
		ОблИзделиеИтого.Параметры.НВИтого = НВИтого;
 		ОблИзделиеИтого.Параметры.СтоимостьИтого = СтоимостьИтого;
		ТабДок.Присоединить(ОблИзделиеИтого);
			Если РасшифроватьТО Тогда
			ТабДок.НачатьГруппуСтрок("ТО",Ложь);
				Для каждого ТЧ Из ТаблицаТО Цикл	
				ОблТО.Параметры.ТО = ТЧ.ТО;
				ОблТО.Параметры.ВидРабот = ТЧ.ВидРабот;
				ОблТО.Параметры.МашинноеВремя = ТЧ.МВ;
				ОблТО.Параметры.НВ = ТЧ.НВ;
	 			ОблТО.Параметры.Стоимость = ТЧ.НВ/60*ТЧ.Стоимость;
				ТабДок.Вывести(ОблТО);
				КонецЦикла; 
			ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщая);
	Для каждого ВидРабот Из СписокВР Цикл	
	ТабДок.Присоединить(ОблКонецВидРабот);				
	КонецЦикла;
ТабДок.Присоединить(ОблКонецИтого);
ТабДок.ФиксацияСверху = 3;
ТабДок.ФиксацияСлева = 1;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли; 
КонецПроцедуры
