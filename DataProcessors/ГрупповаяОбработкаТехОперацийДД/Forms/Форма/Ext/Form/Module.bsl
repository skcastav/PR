﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.ВноситьНаДату = НачалоМесяца(ТекущаяДата())
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СписокЛинеек.Количество() > 0 Тогда
	СписокЛинеекПриИзмененииНаСервере();
	КонецЕсли; 
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("МПЗ",Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из ТаблицаТехОпераций Цикл
		Если Не ТЧ.ТехОперация.Пустая() Тогда
		ТЧ.Пометка = Истина; 
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из ТаблицаТехОпераций Цикл
	ТЧ.Пометка = Ложь;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе1(Команда)
	Для каждого ТЧ Из ТаблицаТехОперацийСпецификации Цикл
	ТЧ.Пометка = Истина;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе1(Команда)
	Для каждого ТЧ Из ТаблицаТехОперацийСпецификации Цикл
	ТЧ.Пометка = Ложь;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура СписокЛинеекПриИзмененииНаСервере()
ТаблицаТехОпераций.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеекТехОперации.ТехОперация,
	|	РабочиеМестаЛинеекТехОперации.Ссылка
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек.ТехОперации КАК РабочиеМестаЛинеекТехОперации
	|ГДЕ
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Линейка В ИЕРАРХИИ(&СписокЛинеек)
	|
	|УПОРЯДОЧИТЬ ПО
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Код";
Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ_ТО = ТаблицаТехОпераций.Добавить();
	ТЧ_ТО.Линейка = ВыборкаДетальныеЗаписи.Ссылка.Линейка;
	ТЧ_ТО.РабочееМесто = ВыборкаДетальныеЗаписи.Ссылка;
		Если ВыборкаДетальныеЗаписи.ТехОперация.ЭтоГруппа Тогда
		ТЧ_ТО.ГруппаТО = ВыборкаДетальныеЗаписи.ТехОперация;
		Иначе
		ТЧ_ТО.ТехОперация = ВыборкаДетальныеЗаписи.ТехОперация;
		ТЧ_ТО.НормаВремени = ПолучитьНормуВремени(ВыборкаДетальныеЗаписи.ТехОперация);
		КонецЕсли;
	КонецЦикла;
ТаблицаТехОпераций.Сортировать("Линейка");
СписокВидовКанбанов.Очистить();
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛинейкиВидыКанбанов.ВидКанбана
	|ИЗ
	|	Справочник.Линейки.ВидыКанбанов КАК ЛинейкиВидыКанбанов
	|ГДЕ
	|	ЛинейкиВидыКанбанов.Ссылка В ИЕРАРХИИ(&СписокЛинеек)";
Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокВидовКанбанов.Добавить(ВыборкаДетальныеЗаписи.ВидКанбана);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокЛинеекПриИзменении(Элемент)
СписокЛинеекПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьВидЭлементаТО()
Возврат(Перечисления.ВидыЭлементовНормРасходов.ТехОперация);
КонецФункции

&НаСервере
Процедура РаскрытьНаМПЗ(ЭтапСпецификации)
ВыборкаНР =  ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(ЭтапСпецификации,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаНР.Элемент.Канбан) Тогда
			Если СписокВидовКанбанов.НайтиПоЗначению(ВыборкаНР.Элемент.Канбан) <> Неопределено Тогда
			СписокМПЗ.Добавить(ВыборкаНР.Элемент);
			КонецЕсли;
		КонецЕсли;
	РаскрытьНаМПЗ(ВыборкаНР.Элемент);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокПФ(Изделие)
СписокМПЗ.Очистить();
СписокМПЗ.Добавить(Изделие);	
РаскрытьНаМПЗ(Изделие);
КонецПроцедуры 

&НаСервере
Функция ТОСуществует(Спецификация,ТО)
Запрос = Новый Запрос;
Результат = Новый Структура("НормРасх,Норма",Неопределено,0); 

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Ссылка КАК Ссылка,
	|	НормыРасходовСрезПоследних.Норма КАК Норма
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних КАК НормыРасходовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
	|ГДЕ
	|	НормыРасходов.Владелец = &Владелец
	|	И НормыРасходов.Элемент = &Элемент
	|	И НормыРасходов.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("Владелец", Спецификация);
Запрос.УстановитьПараметр("Элемент", ТО);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Результат.НормРасх = ВыборкаДетальныеЗаписи.Ссылка;
	Результат.Норма = ВыборкаДетальныеЗаписи.Норма;
	КонецЦикла;
Возврат(Результат);
КонецФункции

&НаСервере
Процедура ДобавитьТО(Спецификация,ТО)
Результат = ТОСуществует(Спецификация,ТО);	
	Если Результат.НормРасх = Неопределено Тогда
	НР = Справочники.НормыРасходов.СоздатьЭлемент();
	НР.Владелец = Спецификация;
	НР.Наименование = "Тех. операции, "+СокрЛП(ТО.Наименование);
	НР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация;
	НР.Элемент = ТО;
	НР.Записать();
	РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
	РНР.Период = НачалоМесяца(Объект.ВноситьНаДату);
	РНР.Владелец = НР.Владелец;
	РНР.Элемент = НР.Элемент;
	РНР.НормаРасходов = НР.Ссылка;
	РНР.Норма = 1;
	РНР.Записать(Истина);
	ИначеЕсли Результат.Норма = 0 Тогда
	РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
	РНР.Период = НачалоМесяца(Объект.ВноситьНаДату);
	РНР.Владелец = Результат.НормРасх.Владелец;
	РНР.Элемент = Результат.НормРасх.Элемент;
	РНР.НормаРасходов = Результат.НормРасх;
	РНР.Норма = 1;
	РНР.Записать(Истина);
	КонецЕсли;
КонецПроцедуры 

&НаСервере
Процедура ДобавитьВСпецификацииНаСервере(Спецификация)
	Для каждого ТЧ Из ТаблицаТехОпераций Цикл
		Если ТЧ.Пометка Тогда
		ДобавитьТО(Спецификация,ТЧ.ТехОперация);
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСпецификации(Команда)
ДобавитьВСпецификацииНаСервере(Элементы.СписокМПЗ.ТекущиеДанные.Значение);
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
ПолучитьСписокПФ(Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);
КонецПроцедуры

&НаСервере
Процедура ДобавитьНоменклатуру(НаименованиеТовара)
Товар = Справочники.Товары.НайтиПоНаименованию(НаименованиеТовара,Истина);
	Если Не Товар.Пустая() Тогда
	флНайдена = Ложь;
	Запрос = Новый Запрос;

	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Товар = &Товар";
	Запрос.УстановитьПараметр("Товар", Товар);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокНоменклатуры.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		флНайдена = Истина;
		Прервать;
		КонецЦикла;
			Если Не флНайдена Тогда
			Сообщить(НаименованиеТовара +" - спецификация не найдена!");	
			КонецЕсли; 
	Иначе
	Сообщить(НаименованиеТовара +" - товар не найден!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
СписокНоменклатуры.Очистить();
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c номенклатурой");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка номенклатуры из файла..."); 
		ДобавитьНоменклатуру(СокрЛП(ExcelЛист.Cells(к,1).Value));
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокТО(ГруппаТО)
СписокТО = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТехОперации.Ссылка
	|ИЗ
	|	Справочник.ТехОперации КАК ТехОперации
	|ГДЕ
	|	ТехОперации.Родитель = &Родитель";
Запрос.УстановитьПараметр("Родитель", ГруппаТО);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокТО.Добавить(ВыборкаДетальныеЗаписи.Ссылка,ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(СписокТО);
КонецФункции 

&НаКлиенте
Процедура Обновить(Команда)
СписокЛинеекПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьНормуВремени(ТО)
Возврат(РегистрыСведений.НормыТО.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("ТехОперация",ТО)).Норма);
КонецФункции 

&НаКлиенте
Процедура ТаблицаТехОперацийТехОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
	Если Не Элементы.ТаблицаТехОпераций.ТекущиеДанные.ГруппаТО.Пустая() Тогда
	СписокТО = ПолучитьСписокТО(Элементы.ТаблицаТехОпераций.ТекущиеДанные.ГруппаТО);
		Если СписокТО.Количество() > 0 Тогда
		ТО = Неопределено;
		ТО = СписокТО.ВыбратьЭлемент("Выберите тех. операцию",ТО);
			Если ТО <> Неопределено Тогда
			Элементы.ТаблицаТехОпераций.ТекущиеДанные.Пометка = Истина;
			Элементы.ТаблицаТехОпераций.ТекущиеДанные.ТехОперация = ТО.Значение;
			Элементы.ТаблицаТехОпераций.ТекущиеДанные.НормаВремени = ПолучитьНормуВремени(ТО.Значение);
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриИзменении(Элемент)
	Если СписокНоменклатуры.Количество() > 0 Тогда
		Если Не Элементы.СписокНоменклатуры.ТекущиеДанные.Значение.Пустая() Тогда
		ПолучитьСписокПФ(Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);
		Элементы.СписокМПЗ.ТекущаяСтрока = СписокМПЗ[0].ПолучитьИдентификатор();
		СписокМПЗВыборЗначения(Элементы.СписокМПЗ.ТекущаяСтрока,,Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Если Не Элементы.СписокНоменклатуры.ТекущиеДанные.Значение.Пустая() Тогда
	ПолучитьСписокПФ(Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);
	Элементы.СписокМПЗ.ТекущаяСтрока = СписокМПЗ[0].ПолучитьИдентификатор();
	СписокМПЗВыборЗначения(Элементы.СписокМПЗ.ТекущаяСтрока,,Истина);
	СписокЛинеекПриИзмененииНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокМПЗВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("МПЗ",Элементы.СписокМПЗ.ТекущиеДанные.Значение);
СписокЛинеекПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТехОперацийПометкаПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Элементы.ТаблицаТехОпераций.ТекущиеДанные.ТехОперация) Тогда
	Элементы.ТаблицаТехОпераций.ТекущиеДанные.Пометка = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТехОперацийТехОперацияПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Элементы.ТаблицаТехОпераций.ТекущиеДанные.ТехОперация) Тогда
	Элементы.ТаблицаТехОпераций.ТекущиеДанные.Пометка = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ИзменитьНормуРасхода(НР,Количество)
РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
РНР.Период = Объект.ВноситьНаДату;
РНР.Владелец = НР.Владелец;
РНР.Элемент = НР.Элемент;
РНР.НормаРасходов = НР;
РНР.Норма = Количество;
РНР.Записать(Истина);
КонецПроцедуры  

&НаКлиенте
Процедура ТаблицаТехОперацийСпецификацииПередНачаломИзменения(Элемент, Отказ)
Отказ = Истина;
ВыбКоличество = 0;
	Если ВвестиЧисло(ВыбКоличество,"Введите кол-во тех. операции",7,3) Тогда	
	ИзменитьНормуРасхода(Элемент.ТекущаяСтрока,ВыбКоличество);
	Элементы.ТаблицаТехОперацийСпецификации.Обновить();
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Процедура ОбнулитьКоличествоНаСервере(НР,НаДату)
РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
РНР.Период = НаДату;   
РНР.Владелец = НР.Владелец;
РНР.Элемент = НР.Элемент;
РНР.НормаРасходов = НР;
РНР.Норма = 0;
РНР.Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбнулитьКоличество(Команда)
НаДату = ТекущаяДата();
	Если ВвестиДату(НаДату,"Обнулить на дату",ЧастиДаты.Дата) Тогда
	ОбнулитьКоличествоНаСервере(Элементы.ТаблицаТехОперацийСпецификации.ТекущаяСтрока,НаДату);
	Элементы.ТаблицаТехОперацийСпецификации.Обновить();
	КонецЕсли; 
КонецПроцедуры
