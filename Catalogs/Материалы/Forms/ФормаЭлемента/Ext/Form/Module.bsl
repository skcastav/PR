﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ВыбСтатус = РегистрыСведений.СтатусыМПЗ.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",Объект.Ссылка));
Статус = ВыбСтатус.Статус;
Элементы.ЦенаСНДС.Заголовок = "С НДС: "+Строка(Объект.ЦенаНачГода*(1+Константы.ОсновнаяСтавкаНДС.Получить().Ставка/100));
Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",Объект.Ссылка));
ЦенаПоследнейЗакупки = Цены.Цена;
ЦеныДопустимые = РегистрыСведений.ЦеныДопустимые.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",Объект.Ссылка));
ЦенаДопустимая = ЦеныДопустимые.Цена;
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ДоговорыСПоставщиками.Параметры.УстановитьЗначениеПараметра("МПЗ",Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
ВыбСтатус = РегистрыСведений.СтатусыМПЗ.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",Объект.Ссылка));
	Если Статус <> ВыбСтатус.Статус Тогда
	НовыйСтатус = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
	НовыйСтатус.Период = ТекущаяДата();
	НовыйСтатус.МПЗ = Объект.Ссылка;
	НовыйСтатус.Статус = Статус;
	НовыйСтатус.Записать();	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяЕдиницаИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;    
Результат = ОткрытьФормуМодально("Справочник.ОсновныеЕдиницыИзмерений.ФормаВыбора",Новый Структура("Владелец", Объект.Ссылка));
	Если Результат <> Неопределено Тогда
	Объект.ОсновнаяЕдиницаИзмерения = Результат;
	КонецЕсли; 
КонецПроцедуры 

&НаСервере
Процедура НайтиТоварНаСервере()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Ссылка
	|ИЗ
	|	Справочник.Товары КАК Товары
	|ГДЕ
	|	Товары.ЭтоГруппа = ЛОЖЬ
	|	И Товары.Наименование = &Наименование";
Запрос.УстановитьПараметр("Наименование", СокрЛП(Объект.Наименование));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Объект.Товар = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НайтиТовар(Команда)
НайтиТоварНаСервере();
	Если ЗначениеЗаполнено(Объект.Товар) Тогда
	ТоварПриИзмененииНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
НаименованиеSMD = СокрЛП(Объект.Наименование);
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мкОм","_uOhm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мОм","_mOhm"); 
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"кОм","_kOhm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"МОм","_MOhm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Ом","Ohm");	 
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"кOм","_kOhm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Oм","Ohm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"пФ","pF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"пф","pF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"нФ","nF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"нф","nF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мкФ","uF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мкф","uF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мФ","mF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мф","mF");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Ф","F");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"ф","F");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"кГц","kHz");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"МГц","MHz");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Мгц","MHz");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"ГГц","GHz");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Гц","Hz");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"нГн","nH");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мкГн","uH");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мГн","mH");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"кГн","kH");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"МГн","MH");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Гн","H");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Вт","W");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"В","V"); 
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мкА","uA");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мА","mA");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"А","A"); 
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"мм","mm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"см","cm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"дм","dm");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"м","m");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"с","c");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"С","C");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"М","M");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"х","x");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Х","X");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Е","E");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"Т","T");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"К","K");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"З","3");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD," ,",", ");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"  "," ");

Наимен = НаименованиеSMD;
ЧислоВхождений = СтрЧислоВхождений(НаименованиеSMD,",");
	Для к = 1 По ЧислоВхождений Цикл	
	Поз = СтрНайти(НаименованиеSMD,",",НаправлениеПоиска.СНачала,1,к);
		Если Поз > 1 Тогда	
		Код = КодСимвола(НаименованиеSMD,Поз-1);
			Если (Код >= 48)и(Код <= 57) Тогда
			Код = КодСимвола(НаименованиеSMD,Поз+1);
				Если (Код >= 48)и(Код <= 57) Тогда			
				Наимен = Лев(Наимен,Поз-1)+"."+Сред(Наимен,Поз+1);
				КонецЕсли;			
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
НаименованиеSMD = Наимен;

Наимен = НаименованиеSMD;
ЧислоВхождений = СтрЧислоВхождений(НаименованиеSMD,"Ohm");
	Для к = 1 По ЧислоВхождений Цикл	
	Поз = СтрНайти(НаименованиеSMD,"Ohm",НаправлениеПоиска.СНачала,1,к);
		Если Поз > 1 Тогда	
		Код = КодСимвола(НаименованиеSMD,Поз-1);
			Если (Код >= 48)и(Код <= 57) Тогда
			Наимен = Лев(Наимен,Поз-1)+"_Ohm"+Сред(Наимен,Поз+3);		
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
НаименованиеSMD = Наимен; 

НаименованиеSMD = СтрЗаменить(НаименованиеSMD,",","_");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD," ","_");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"__","_");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"±","+/-");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"—","--");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"NPO","NP0");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"ATMEGA","ATmega");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"ATTINY","ATtiny");
НаименованиеSMD = СтрЗаменить(НаименованиеSMD,"ADUM","ADuM");

Объект.НаименованиеSMD = НаименованиеSMD;
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЦенПоследнихЗакупок(Команда)
ИмяОтчета = "ДетализацияЦенПоследнихЗакупок";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ДобавитьМесяц(ТекущаяДата(),-12),ТекущаяДата(),Новый Структура("МПЗ",Объект.Ссылка),"Основной"));
ПараметрыФормы.Вставить("КлючВарианта","Основной"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.Ссылка.ПрослеживаемыйТовар <> Объект.ПрослеживаемыйТовар Тогда
		Попытка
		РИД = РегистрыСведений.ИзменениеДанных.СоздатьМенеджерЗаписи();
		РИД.ИзменённыйОбъект = Объект.Ссылка;
		РИД.ИмяРеквизита = "ПрослеживаемыйТовар";
		РИД.Записать();
		Исключение     
		Сообщить(ОписаниеОшибки());
		Отказ = Истина;
		КонецПопытки;		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ТоварПриИзмененииНаСервере()
	Если Не Объект.Товар.Пустая() Тогда
		Если Найти(ПолучитьВерхнегоРодителя(Объект.Родитель).Наименование,"Товары для перепродажи") = 0 Тогда
		Возврат;
		КонецЕсли;
			Если Объект.Товар.Статус = Перечисления.СтатусыТоваров.НеПроизводимый Тогда
			Статус = Перечисления.СтатусыМПЗ.Запрещённая;			
			ИначеЕсли Объект.Товар.Статус = Перечисления.СтатусыТоваров.СнимаемыйСПроизводства Тогда
			Статус = Перечисления.СтатусыМПЗ.ДоИсчерпанияЗапасов;
			ИначеЕсли Объект.Товар.Статус = Перечисления.СтатусыТоваров.Производимый Тогда
			Статус = Перечисления.СтатусыМПЗ.Основная;
			ИначеЕсли Объект.Товар.Статус = Перечисления.СтатусыТоваров.Опытный Тогда
			Статус = Перечисления.СтатусыМПЗ.ОНР;
			ИначеЕсли Объект.Товар.Статус = Перечисления.СтатусыТоваров.Проектный Тогда
			Статус = Перечисления.СтатусыМПЗ.ОНР;	
			КонецЕсли;			
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТоварПриИзменении(Элемент)
ТоварПриИзмененииНаСервере();
КонецПроцедуры
