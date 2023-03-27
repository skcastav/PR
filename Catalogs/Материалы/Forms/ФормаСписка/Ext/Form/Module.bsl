﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Элементы.Операции.Видимость = РольДоступна("Администратор") или РольДоступна("ВводДанных"); 
КонецПроцедуры

&НаКлиенте
Процедура Применение(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,ТекущаяДата(),Ложь));
	Если Результат <> Неопределено Тогда
	ТекФорма = ПолучитьФорму("Справочник.Номенклатура.ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		Если Элементы.Список.ТекущиеДанные.Свойство("ИмяФайла") Тогда
		Элементы.ОбщаяКомандаОткрытьФайл.Доступность = Не Элементы.Список.ТекущиеДанные.ИмяФайла.Пустая();
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзмененияПараметров(Команда)
ОткрытьФорму("Обработка.ЗагрузкаПараметровМатериалов.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзмененияПараметровСклад(Команда)
ОткрытьФорму("Обработка.ЗагрузкаПараметровМатериаловСклад.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКратностьЗаготовок(Команда)
ОткрытьФорму("Обработка.ЗагрузкаКратностиЗаготовок.Форма");
КонецПроцедуры

&НаСервере
Процедура УдалитьИзАналоговНаСервере(ВыбМПЗ) 
ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиМПЗ(ВыбМПЗ);
	Для каждого ТЧ Из ТаблицаАналогов Цикл
	РАНР = РегистрыСведений.АналогиНормРасходов.СоздатьМенеджерЗаписи();
	РАНР.Период = ТекущаяДата();
	РАНР.Владелец = ТЧ.Ссылка.Владелец;
	РАНР.АналогНормыРасходов = ТЧ.Ссылка;
	РАНР.Норма = 0;
	РАНР.Записать();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзАналогов(Команда)
УдалитьИзАналоговНаСервере(Элементы.Список.ТекущаяСтрока);
Предупреждение("Операция завершена!",10);
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоМестамХранения(Команда)
ИмяОтчета = "ОтчётПоРегиструМестаХранения";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("МПЗ",Элементы.Список.ТекущаяСтрока),"ОстаткиПоСкладам"));
ПараметрыФормы.Вставить("КлючВарианта","ОстаткиПоСкладам"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзмененияСтатусов(Команда)
ИмяОтчета = "ОтчетПоРегиструСтатусыМПЗ";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,НачалоГода(ТекущаяДата()),ТекущаяДата(),Новый Структура("МПЗ",Элементы.Список.ТекущаяСтрока),"Основной"));
ПараметрыФормы.Вставить("КлючВарианта","Основной"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура РасположениеНаСкладе(Команда)
ИмяОтчета = "ОтчетПоРегиструЯчейкиХранения";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("МПЗ",Элементы.Список.ТекущаяСтрока),"ПоМПЗ"));
ПараметрыФормы.Вставить("КлючВарианта","ПоМПЗ"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппуМатериалов(Мат)
	Если Мат.ЭтоГруппа Тогда
	Возврат(Мат);	
	Иначе	
	Возврат(Мат.Родитель);
	КонецЕсли; 	
КонецФункции

&НаКлиенте
Процедура ОценкаПоКритериям(Команда)
ОткрытьФорму("Обработка.ОценкаПоКритериям.Форма",Новый Структура("ГруппаМатериалов",ПолучитьГруппуМатериалов(Элементы.Список.ТекущаяСтрока)));
КонецПроцедуры

&НаКлиенте
Процедура РасширенныйПоискМатериалов(Команда)
ОткрытьФорму("Обработка.РасширенныйПоискМатериалов.Форма");
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаСервере(Владелец,TYPE,NAME,NUM,POSITION,DEFIN)
ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов[СокрЛП(TYPE)];
	Если ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Материал Тогда
	Выбор = Справочники.Материалы.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике материалов!");
		Возврат;
		КонецЕсли; 
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Деталь Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике номенклатуры!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Узел Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике номенклатуры!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике номенклатуры!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике номенклатуры!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация Тогда
	Выбор = Справочники.ТехОперации.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике тех. операций!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОснастка Тогда
	Выбор = Справочники.ТехОснастка.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике тех. оснастки!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Документ Тогда
	Выбор = Справочники.Документация.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике документации!");
		Возврат;
		КонецЕсли;
	ИначеЕсли ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Программа Тогда		
	Выбор = Справочники.Документация.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        Сообщить(NAME + " - не найден в справочнике документации!");
		Возврат;
		КонецЕсли;
	Иначе
	Возврат;
	КонецЕсли;
ТЧ = Справочники.НормыРасходов.СоздатьЭлемент();
ТЧ.Владелец = Владелец;
ТЧ.ВидЭлемента = ВидЭлемента;
ТЧ.Элемент = Выбор;
ТЧ.Наименование = ""+ВидЭлемента+", "+СокрЛП(Выбор.Наименование);
ТЧ.Позиция = POSITION;
ТЧ.Примечание = DEFIN;
ТЧ.Записать();
РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
РНР.Период = ТекущаяДата();
РНР.Владелец = ТЧ.Владелец;
РНР.Элемент = ТЧ.Элемент;
РНР.НормаРасходов = ТЧ.Ссылка;
РНР.Норма = NUM;       
РНР.Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСпецификациюИзФайла(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл с эскизом спецификации");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка норм расходов из файла..."); 
		ДобавитьНаСервере(Элементы.Список.ТекущаяСтрока,ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value,ExcelЛист.Cells(к,1).Value,ExcelЛист.Cells(к,6).Value);
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрИзвещений(Команда)
ОткрытьФорму("Отчет.ПросмотрИзвещений.Форма.ФормаОтчета",Новый Структура("Элемент",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаСервере
Процедура ДобавитьИзвещениеНаСервере(Материал,ВыбИзвещение)
Извещение = РегистрыСведений.ИзвещенияОбИзменениях.СоздатьМенеджерЗаписи();
Извещение.Период = ТекущаяДата();
Извещение.Элемент = Материал;
Извещение.Извещение = ВыбИзвещение;
Извещение.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзвещение(Команда)
ФормаИзвещения = ПолучитьФорму("Справочник.ИзвещенияОбИзменениях.ФормаВыбора");
Результат = ФормаИзвещения.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
	ДобавитьИзвещениеНаСервере(Элементы.Список.ТекущаяСтрока,Результат);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьТовар(Наименование)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Товары КАК Товары
	|ГДЕ
	|	Товары.ЭтоГруппа = ЛОЖЬ
	|	И Товары.ПометкаУдаления = ЛОЖЬ
	|	И Товары.Наименование = &Наименование";	
Запрос.УстановитьПараметр("Наименование", Наименование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(Справочники.Товары.ПустаяСсылка());
КонецФункции 

&НаСервере
Процедура ПрисвоитьТоварыНаСервере(ГруппаМатериалов)
Выборка = Справочники.Материалы.ВыбратьИерархически(ГруппаМатериалов);
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.ЭтоГруппа Тогда	
			Если Выборка.Товар.Пустая() Тогда
			Товар = ПолучитьТовар(СокрЛП(Выборка.Наименование));
				Если Не Товар.Пустая() Тогда
				Мат = Выборка.ПолучитьОбъект();
				Мат.Товар = Товар;
				Мат.Записать();             
					Если Найти(ПолучитьВерхнегоРодителя(Выборка.Ссылка).Наименование,"Товары для перепродажи") = 0 Тогда
					Продолжить;
					КонецЕсли;
			    СтатусМПЗ = ПолучитьСтатус(Выборка.Ссылка);
					Если Товар.Статус = Перечисления.СтатусыТоваров.НеПроизводимый Тогда
						Если СтатусМПЗ <> Перечисления.СтатусыМПЗ.Запрещённая Тогда
						СтатусыМПЗ = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
						СтатусыМПЗ.Период = ТекущаяДата();
						СтатусыМПЗ.МПЗ = Выборка.Ссылка;
						СтатусыМПЗ.Статус = Перечисления.СтатусыМПЗ.Запрещённая;
						СтатусыМПЗ.Записать(Истина);  					
						КонецЕсли;
					ИначеЕсли Товар.Статус = Перечисления.СтатусыТоваров.СнимаемыйСПроизводства Тогда
						Если СтатусМПЗ <> Перечисления.СтатусыМПЗ.ДоИсчерпанияЗапасов Тогда
						СтатусыМПЗ = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
						СтатусыМПЗ.Период = ТекущаяДата();
						СтатусыМПЗ.МПЗ = Выборка.Ссылка;
						СтатусыМПЗ.Статус = Перечисления.СтатусыМПЗ.ДоИсчерпанияЗапасов;
						СтатусыМПЗ.Записать(Истина);			
						КонецЕсли;
					ИначеЕсли Товар.Статус = Перечисления.СтатусыТоваров.Производимый Тогда
						Если СтатусМПЗ <> Перечисления.СтатусыМПЗ.Основная Тогда
						СтатусыМПЗ = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
						СтатусыМПЗ.Период = ТекущаяДата();
						СтатусыМПЗ.МПЗ = Выборка.Ссылка;
						СтатусыМПЗ.Статус = Перечисления.СтатусыМПЗ.Основная;
						СтатусыМПЗ.Записать(Истина);			
						КонецЕсли;
					ИначеЕсли Товар.Статус = Перечисления.СтатусыТоваров.Опытный Тогда
						Если СтатусМПЗ <> Перечисления.СтатусыМПЗ.ОНР Тогда
						СтатусыМПЗ = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
						СтатусыМПЗ.Период = ТекущаяДата();
						СтатусыМПЗ.МПЗ = Выборка.Ссылка;
						СтатусыМПЗ.Статус = Перечисления.СтатусыМПЗ.ОНР;
						СтатусыМПЗ.Записать(Истина);			
						КонецЕсли;
					ИначеЕсли Товар.Статус = Перечисления.СтатусыТоваров.Проектный Тогда
						Если СтатусМПЗ <> Перечисления.СтатусыМПЗ.ОНР Тогда
						СтатусыМПЗ = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
						СтатусыМПЗ.Период = ТекущаяДата();
						СтатусыМПЗ.МПЗ = Выборка.Ссылка;
						СтатусыМПЗ.Статус = Перечисления.СтатусыМПЗ.ОНР;
						СтатусыМПЗ.Записать(Истина);			
						КонецЕсли;	
					КонецЕсли;	
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПрисвоитьТовары(Команда)
ПрисвоитьТоварыНаСервере(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКорневыеХарактеристики(Команда)
ОткрытьФорму("Обработка.ЗагрузкаКорневыхХарактеристикМатериала.Форма",Новый Структура("Материал",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатусыМатериалов(Команда)
ОткрытьФорму("Обработка.ИзменениеСтатусовМатериалов.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияЦенПоследнихЗакупок(Команда)
ИмяОтчета = "ДетализацияЦенПоследнихЗакупок";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,НачалоМесяца(ТекущаяДата()),КонецМесяца(ТекущаяДата()),Новый Структура("МПЗ",Элементы.Список.ТекущаяСтрока),"Основной"));
ПараметрыФормы.Вставить("КлючВарианта","Основной"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);		
КонецПроцедуры
