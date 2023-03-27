﻿
&НаСервере
Функция СортироватьПоПорядку(ТекЗнач)
Перем ТемпНач,ТемпКон;

	Если (ТекЗнач = "")или(Найти(ТекЗнач,"-") > 0) Тогда
	Возврат(ТекЗнач);		
	КонецЕсли;
		Для к = 1 по 3 Цикл
			Если (КодСимвола(Сред(ТекЗнач,к,1)) > 47)и(КодСимвола(Сред(ТекЗнач,к,1)) < 58) Тогда
			ТемпНач = Лев(ТекЗнач,к-1);
			ТекЗнач = СтрЗаменить(ТекЗнач,ТемпНач,"");
				Если Найти(ТекЗнач,".") > 0 Тогда
				ТемпКон = Сред(ТекЗнач,Найти(ТекЗнач,"."));
				ТекЗнач = СтрЗаменить(ТекЗнач,ТемпКон,"");
				КонецЕсли;	                            
			    	Пока СтрДлина(ТекЗнач) < 5 Цикл
			    	ТекЗнач = "#"+ТекЗнач;	
					КонецЦикла;
			ТекЗнач = ТемпНач+ТекЗнач+ТемпКон;		
			Прервать;		
			КонецЕсли;
		КонецЦикла;
Возврат(СокрЛП(ТекЗнач));	
КонецФункции

&НаСервере
Процедура ПолучитьСписокЭлементовСпецификации(ЭтапСпецификации,КолУзла,СтрЭтап,НаДату)
ТаблицаМПЗ = Новый ТаблицаЗначений;

ТаблицаМПЗ.Колонки.Добавить("НР",Новый ОписаниеТипов("СправочникСсылка.НормыРасходов"));
ТаблицаМПЗ.Колонки.Добавить("Норма");
ТаблицаМПЗ.Колонки.Добавить("ПозицияСортировка",Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(100)));

Основа = Справочники.НормыРасходов.ПустаяСсылка();
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ЭтапСпецификации,НаДату);
	Пока ВыборкаНР.Следующий() Цикл	
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
			Основа = ВыборкаНР.Ссылка;
			Иначе
			Стр = СтрЭтап.Строки.Добавить();
			ВыбАналог = Параметры.ПроизводственноеЗадание.Аналоги.НайтиСтроки(Новый Структура("Спецификация,НормаРасходов",ЭтапСпецификации,ВыборкаНР.Ссылка));
				Если ВыбАналог.Количество() > 0 Тогда
				АналогНР = ВыбАналог[0].АналогНормыРасходов;
				Стр.НормаРасходов = АналогНР;
				Стр.ВидМПЗ = АналогНР.ВидЭлемента;
				Стр.МПЗ = АналогНР.Элемент;
				Стр.Количество = ВыборкаНР.Норма*КолУзла;
					Если АналогНР.ВидЭлемента <> Перечисления.ВидыЭлементовНормРасходов.Материал Тогда
					Стр.Канбан = АналогНР.Элемент.Канбан;
					КонецЕсли; 
				Стр.Аналог = Истина;
				Иначе
				Стр.НормаРасходов = ВыборкаНР.Ссылка;
				Стр.ВидМПЗ = ВыборкаНР.ВидЭлемента;
				Стр.МПЗ = ВыборкаНР.Элемент;
				Стр.Количество = ВыборкаНР.Норма*КолУзла;
				Стр.Канбан = ВыборкаНР.Элемент.Канбан;
				КонецЕсли;
			Стр.Позиция = ВыборкаНР.Позиция;
			Стр.ЭтапСпецификации = ЭтапСпецификации;
				Если Не ЗначениеЗаполнено(ВыборкаНР.Элемент.Канбан) Тогда
				ПолучитьСписокЭлементовСпецификации(ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения),Стр,НаДату);
				КонецЕсли; 
			КонецЕсли;
		ИначеЕсли ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.НР = ВыборкаНР.Ссылка;
		ТЧ.Норма = ВыборкаНР.Норма;			
		ТЧ.ПозицияСортировка = СортироватьПоПорядку(СокрЛП(ВыборкаНР.Позиция));
		КонецЕсли;
	КонецЦикла;	
		Если Не Основа.Пустая() Тогда
		Стр = СтрЭтап.Строки.Добавить();
		Стр.НормаРасходов = Основа;
		Стр.ВидМПЗ = Основа.ВидЭлемента;
		Стр.МПЗ = Основа.Элемент;
		Стр.Количество = ВыборкаНР.Норма*КолУзла;
		Стр.Канбан = Основа.Элемент.Канбан;
		Стр.ЭтапСпецификации = ЭтапСпецификации;
		ПолучитьСписокЭлементовСпецификации(Основа.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,Основа.Элемент.ОсновнаяЕдиницаИзмерения),Стр,НаДату);
		КонецЕсли;
ТаблицаМПЗ.Сортировать("ПозицияСортировка");
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	Стр = СтрЭтап.Строки.Добавить();
	ВыбАналог = Параметры.ПроизводственноеЗадание.Аналоги.НайтиСтроки(Новый Структура("Спецификация,НормаРасходов",ЭтапСпецификации,ТЧ.НР));
		Если ВыбАналог.Количество() > 0 Тогда
		АналогНР = ВыбАналог[0].АналогНормыРасходов;
		Стр.НормаРасходов = АналогНР;
		Стр.ВидМПЗ = АналогНР.ВидЭлемента;
		Стр.МПЗ = АналогНР.Элемент;
		Стр.Количество = ТЧ.Норма*КолУзла;
		Стр.Аналог = Истина;
		Иначе
		Стр.НормаРасходов = ТЧ.НР;
		Стр.ВидМПЗ = ТЧ.НР.ВидЭлемента;
		Стр.МПЗ = ТЧ.НР.Элемент;
		Стр.Количество = ТЧ.Норма*КолУзла;
		КонецЕсли;
	Стр.Позиция = ТЧ.НР.Позиция;
	Стр.ЭтапСпецификации = ЭтапСпецификации;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
тДеревоСпецификации = РеквизитФормыВЗначение("ДеревоСпецификации");
СтрСпец = тДеревоСпецификации.Строки.Добавить();
СтрСпец.МПЗ = Параметры.Изделие;
СтрСпец.Количество = Параметры.Количество;
СтрСпец.Канбан = Параметры.Изделие.Канбан;
СтрСпец.ЭтапСпецификации = Параметры.Изделие;
	Если ТипЗнч(Параметры.ПроизводственноеЗадание) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
	НаДату = Параметры.ПроизводственноеЗадание.ДатаЗапуска;
	Иначе
	НаДату = ТекущаяДата();
	КонецЕсли;
ПолучитьСписокЭлементовСпецификации(Параметры.Изделие,Параметры.Количество,СтрСпец,НаДату);
ЗначениеВРеквизитФормы(тДеревоСпецификации, "ДеревоСпецификации");
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл 
   Элементы.ДеревоСпецификации.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево()
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
СвернутьРекурсия(тЭлементы);
КонецПроцедуры
 
&НаКлиенте
Процедура СвернутьРекурсия(тЭлементы)
	Для Каждого тСтр Из тЭлементы Цикл
   	тСтрЭлементы = тСтр.ПолучитьЭлементы();
   	СвернутьРекурсия(тСтрЭлементы);
		Если тЭлементы.Количество() > 1 Тогда
		Элементы.ДеревоСпецификации.Свернуть(тСтр.ПолучитьИдентификатор());		
		КонецЕсли; 
   	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура Развернуть(Команда)
РазвернутьДерево();
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
СвернутьДерево();
КонецПроцедуры

&НаСервере
Процедура ОбходДереваДетально(ПереданноеДер)
	Для Каждого Стр Из ПереданноеДер.Строки Цикл 
		Если Стр.Списать Тогда	
		СписокСписания.Добавить(Стр.МПЗ,Строка(Стр.Количество));		
		КонецЕсли; 	 
			Если Стр.Строки.Количество() > 0 Тогда 
			ОбходДереваДетально(Стр);
			КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьПараметры()
ДеревоЗнач = РеквизитФормыВЗначение("ДеревоСпецификации"); 
ОбходДереваДетально(ДеревоЗнач);
КонецПроцедуры

&НаКлиенте
Процедура Завершить(Команда)
ПолучитьПараметры();
ЭтаФорма.Закрыть(Новый Структура("СписокСписания",СписокСписания));
КонецПроцедуры
