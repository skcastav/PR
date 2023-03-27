﻿
&НаСервере
Функция СоздатьЗаявкуОтПокупателя(НомерЗаказа,ДатаДокумента,Дополнение,Комментарий)
	Попытка
	ЗаявкаОтПокупателя = Документы.ЗаявкаОтПокупателя.СоздатьДокумент();
	ЗаявкаОтПокупателя.Номер = НомерЗаказа;
	//ЗаявкаОтПокупателя.Подразделение = Подразделение;
	ЗаявкаОтПокупателя.Автор = ПараметрыСеанса.Пользователь;
	ЗаявкаОтПокупателя.Дата = ДатаДокумента;
	//ЗаявкаОтПокупателя.ДатаИсполнения = ДатаИсполнения;
	ЗаявкаОтПокупателя.Контрагент = Контрагент;
	ЗаявкаОтПокупателя.Договор = Контрагент.ОсновнойДоговор;
	ЗаявкаОтПокупателя.Курс = 1;
	ЗаявкаОтПокупателя.Дополнение = Дополнение;
	ЗаявкаОтПокупателя.Комментарий = Комментарий;
		Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл
		ТЧ = ЗаявкаОтПокупателя.ТабличнаяЧасть.Добавить();
			Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
			Иначе	
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
			КонецЕсли;		
		ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
		ТЧ.Количество = ТЧ_МПЗ.Количество;
		ТЧ.ЕдиницаИзмерения = ТЧ_МПЗ.ЕдиницаИзмерения;
		ТЧ.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(ТЧ_МПЗ.МПЗ,ТекущаяДата())*ТЧ_МПЗ.ЕдиницаИзмерения.Коэффициент;
			Если ТЧ.Цена = 0 Тогда
			ТЧ.Цена = 1;			
			КонецЕсли; 
		ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;
			Если Контрагент.ОсновнойДоговор.БезНДС Тогда
			ТЧ.Всего = ТЧ.Сумма;
			Иначе	
			ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС;
			ТЧ.НДС = ТЧ.Сумма*18/100;				
			ТЧ.Всего = ТЧ.Сумма +  ТЧ.НДС;			
			КонецЕсли; 
		КонецЦикла; 
			Если ЗаявкаОтПокупателя.ТабличнаяЧасть.Количество() > 0 Тогда
			ЗаявкаОтПокупателя.Записать(РежимЗаписиДокумента.Запись);
			Иначе
			Сообщить("Табличная часть документа пустая! Заявка от покупателя "+НомерЗаказа+" не создана!");
			Возврат(Документы.ЗаявкаОтПокупателя.ПустаяСсылка());
			КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Документы.ЗаявкаОтПокупателя.ПустаяСсылка());
	КонецПопытки;
Возврат(ЗаявкаОтПокупателя.Ссылка);
КонецФункции 

&НаСервере
Функция ДокументСуществует(НомерЗаказа,ДатаЗаказа)
Заявка = Документы.ЗаявкаОтПокупателя.НайтиПоНомеру(НомерЗаказа,ДатаЗаказа);
Возврат(Заявка.Ссылка);
КонецФункции

&НаКлиенте
Процедура Соединиться(Команда)
ТаблицаЗаказов.Очистить();
НастройкиОбменаДанными = ОбщийМодульСинхронизации.ПолучитьНастройкиОбменаДанными(Объект.ОбменДанными);
V7 = ОбщийМодульКлиент.ПодключитьсяК1С77(НастройкиОбменаДанными.ПутьКБазеДанных,Объект.ИмяПользователя,Объект.Пароль);
	Если V7 = Неопределено Тогда
	Возврат;	
	КонецЕсли;
Подр = V7.CreateObject("Справочник.Подразделения");
Док = V7.CreateObject("Документ.Заказ");
Запрос = V7.CreateObject("Запрос");
	Для каждого Стр Из СписокПодразделений Цикл	
		Если Подр.НайтиПоНаименованию(Стр.Значение,1) = 0 Тогда
		Сообщить(Стр.Значение + " - подразделение не найдено!");
		Возврат;
		КонецЕсли;	
	КонецЦикла;
ПериодЗапроса = "Период с '"+ Формат(Объект.Период.ДатаНачала,"ДФ=dd.MM.yy")+"' по '"+Формат(Объект.Период.ДатаОкончания,"ДФ=dd.MM.yy")+"';";
	Текст = "//{{ЗАПРОС(Заказ)
	|" + ПериодЗапроса + "
	|
	|ОбрабатыватьДокументы Проведенные;
	|Обрабатывать НеПомеченныеНаУдаление;
	|	
	|Док 	 	 = Документ.Заказ.ТекущийДокумент;
	|Подразделение  = Документ.Заказ.Подразделение;
	|
	|Группировка Подразделение;
	|Группировка Док;                                                                     
	|";
Запрос.Выполнить(Текст);
	Пока Запрос.Группировка(1) = 1 Цикл 
		Если СписокПодразделений.НайтиПоЗначению(СокрЛП(Запрос.Подразделение.Наименование)) <> Неопределено Тогда
			Пока Запрос.Группировка(2) = 1 Цикл 
			Состояние("Обработка...",,"Проверка заказа №"+Запрос.Док.НомерДок+"...");
			ТЧ = ТаблицаЗаказов.Добавить();
			ТЧ.НомерЗаказа = Запрос.Док.НомерДок;
			ТЧ.ДатаЗаказа = Запрос.Док.ДатаДок;
			ТЧ.Дополнение = Запрос.Док.Дополнение; 
			ТЧ.Комментарий = Запрос.Док.Комментарий;
			ТЧ.Ссылка = ДокументСуществует(Запрос.Док.НомерДок,Запрос.Док.ДатаДок); 
		    КонецЦикла;
		Иначе
		Продолжить;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьЕдиницуИзмерения(МПЗ,ЕдиницаИзмерения)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеЕдиницыИзмерений.Ссылка
	|ИЗ
	|	Справочник.ОсновныеЕдиницыИзмерений КАК ОсновныеЕдиницыИзмерений
	|ГДЕ	
	|	ОсновныеЕдиницыИзмерений.Владелец = &Владелец
	|	И ОсновныеЕдиницыИзмерений.ЕдиницаИзмерения.Наименование = &Наименование";
Запрос.УстановитьПараметр("Владелец", МПЗ);
Запрос.УстановитьПараметр("Наименование", СокрЛП(ЕдиницаИзмерения));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(Справочники.ОсновныеЕдиницыИзмерений.ПустаяСсылка());
КонецФункции

&НаСервере
Функция ДобавитьМПЗ(ВидМПЗ,Наименование,Количество,ЕдиницаИзмерения)
	Если ВидМПЗ = 0 Тогда
	МПЗ = Справочники.Материалы.НайтиПоНаименованию(Наименование,Истина);
	Иначе	
	МПЗ = Справочники.Номенклатура.НайтиПоНаименованию(Наименование,Истина);
	КонецЕсли;
		Если Не МПЗ.Пустая() Тогда
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.МПЗ = МПЗ;
		ТЧ.Количество = Количество;	
		ТЧ.ЕдиницаИзмерения = ПолучитьЕдиницуИзмерения(МПЗ,ЕдиницаИзмерения);
		Возврат(Истина);
		Иначе
		Сообщить(Наименование+" - не найден в справочнике!");  
		Возврат(Ложь);
		КонецЕсли;
КонецФункции

&НаКлиенте
Процедура Перенести(Команда)
НастройкиОбменаДанными = ОбщийМодульСинхронизации.ПолучитьНастройкиОбменаДанными(Объект.ОбменДанными);
V7 = ОбщийМодульКлиент.ПодключитьсяК1С77(НастройкиОбменаДанными.ПутьКБазеДанных,Объект.ИмяПользователя,Объект.Пароль);
	Если V7 = Неопределено Тогда
	Возврат;	
	КонецЕсли;
Док = V7.CreateObject("Документ.Заказ");
	Для каждого ТЧ Из ТаблицаЗаказов Цикл
		Если ТЧ.Пометка Тогда
			Если ТЧ.Пометка Тогда
				Если Не ТЧ.Ссылка.Пустая() Тогда
				Продолжить;
				КонецЕсли;  	
			Состояние("Обработка...",,"Перенос заказа №"+ТЧ.НомерЗаказа+"..."); 
				Если Док.НайтиПоНомеру(ТЧ.НомерЗаказа,ТЧ.ДатаЗаказа) = 1 Тогда
				ТаблицаМПЗ.Очистить();
				Док.ВыбратьСтроки();
				флНеНайден = Ложь;
					Пока Док.ПолучитьСтроку() = 1 Цикл
					ВидМПЗ = ?(Док.ВидМПЗ.ПорядковыйНомер() = 1,0,1);
						Если Не ДобавитьМПЗ(ВидМПЗ,СокрЛП(Док.Товар.Наименование),Док.Количество,Док.ЕдиницаИзмерения.Наименование) Тогда	
						флНеНайден = Истина;
						КонецЕсли; 
					КонецЦикла; 
						Если Не флНеНайден Тогда
						ТЧ.Ссылка = СоздатьЗаявкуОтПокупателя(ТЧ.НомерЗаказа,ТЧ.ДатаЗаказа,ТЧ.Дополнение,ТЧ.Комментарий);
						Иначе
						Сообщить(ТЧ.НомерЗаказа+" - документ не перенесён в базу 1С8!");			
						КонецЕсли; 
				Иначе
				Сообщить(ТЧ.НомерЗаказа+" - документ не найден в базе 1С7.7!");
				КонецЕсли;			
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из ТаблицаЗаказов Цикл	
	ТЧ.Пометка = Истина;
	КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из ТаблицаЗаказов Цикл	
	ТЧ.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры
