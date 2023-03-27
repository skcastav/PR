﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ПолучитьСписокАктивныхПользователей();
РазмерностьОтсрочки = 1;
КонецПроцедуры 

&НаСервере
Процедура ПолучитьСписокАктивныхПользователей()
ТаблицаАктивныхПользователей.Очистить();
СоединенияИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();    
    Для Каждого Соединение Из СоединенияИнформационнойБазы Цикл 
		Если ПредставлениеПриложения(Соединение.ИмяПриложения) = "Конфигуратор" Тогда
		Продолжить;
		КонецЕсли; 
	Сотр = Справочники.Сотрудники.НайтиПоНаименованию(Соединение.Пользователь.Имя,Истина);
		Если Не Сотр.Пустая() Тогда
	    ТЗ = ТаблицаАктивныхПользователей.Добавить();          
	    ТЗ.Пользователь = Сотр.Ссылка;                                                                       
	    ТЗ.Компьютер = Соединение.ИмяКомпьютера;
		Роли = ПользователиИнформационнойБазы.НайтиПоИмени(Соединение.Пользователь.Имя).Роли;
			Для каждого ТЧ Из Роли Цикл
	    	ТЗ.СписокРолей.Добавить(ТЧ.Имя);
			КонецЦикла;                                         		
		КонецЕсли; 	                              
	КонецЦикла;
ТаблицаАктивныхПользователей.Сортировать("Пользователь");
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из ТаблицаАктивныхПользователей Цикл
	ТЧ.Пометка = Истина;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из ТаблицаАктивныхПользователей Цикл
	ТЧ.Пометка = Ложь;	
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ВыбратьСРольюНаСервере(Роль)
	Для каждого ТЧ Из ТаблицаАктивныхПользователей Цикл
	ТЧ.Пометка = Ложь;
		Для каждого ТЧ_Р Из ТЧ.СписокРолей Цикл
			Если ТЧ_Р.Значение = Роль Тогда
			ТЧ.Пометка = Истина;
			КонецЕсли;		
		КонецЦикла;	
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокРолей()
СписокРолей = Новый СписокЗначений;

	Для каждого Роль Из Метаданные.Роли Цикл
	СписокРолей.Добавить(Роль.Имя);
	КонецЦикла;
Возврат(СписокРолей);
КонецФункции

&НаКлиенте
Процедура ВыбратьСРолью(Команда)
СписокРолей = ПолучитьСписокРолей();
Роль = СписокРолей.ВыбратьЭлемент("Выберите роль");
ВыбратьСРольюНаСервере(Роль.Значение);
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСервере()
	Если Объект.ВремяОтсрочки > 0 Тогда
		Если РазмерностьОтсрочки = 1 Тогда
		ВремяОтсрочки = ТекущаяДата()+Объект.ВремяОтсрочки*60;
		Иначе
		ВремяОтсрочки = ТекущаяДата()+Объект.ВремяОтсрочки*3600;
		КонецЕсли; 
	Иначе
	ВремяОтсрочки = ТекущаяДата();
	КонецЕсли; 
		Если ДляВсех Тогда
			Если Объект.Срок = 0 Тогда
			Сообщить("Установите срок действия сообщения!");
			Возврат;
			КонецЕсли; 	
		Сообщение = РегистрыСведений.СообщенияПользователям.СоздатьМенеджерЗаписи();
		Сообщение.Период = ТекущаяДата();
		Сообщение.Отправитель = ПараметрыСеанса.Пользователь;
		Сообщение.Получатель = Справочники.Сотрудники.ПустаяСсылка();
		Сообщение.Сообщение = Объект.Сообщение;
		Сообщение.ТекстСообщения = Объект.ТекстСообщения;
		Сообщение.Время = ВремяОтсрочки;
		Сообщение.Срок = Объект.Срок;
		Сообщение.Важное = Важное;
		Сообщение.Записать(Истина);
		Иначе
			Для каждого ТЧ Из ТаблицаАктивныхПользователей Цикл
				Если ТЧ.Пометка Тогда
				Сообщение = РегистрыСведений.СообщенияПользователям.СоздатьМенеджерЗаписи();
				Сообщение.Период = ТекущаяДата();
				Сообщение.Отправитель = ПараметрыСеанса.Пользователь;
				Сообщение.Получатель = ТЧ.Пользователь;
				Сообщение.Сообщение = Объект.Сообщение;
				Сообщение.ТекстСообщения = Объект.ТекстСообщения;
				Сообщение.Время = ВремяОтсрочки;
				Сообщение.Срок = Объект.Срок;
				Сообщение.Важное = Важное;
				Сообщение.Записать(Истина);			
				КонецЕсли; 	
			КонецЦикла; 
		КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
		Если ДляВсех Тогда
			Если Объект.Срок = 0 Тогда
			Сообщить("Укажите срок действия сообщения!");
			Возврат;
			КонецЕсли; 
		КонецЕсли; 
	ОтправитьНаСервере();
	ЭтаФорма.Закрыть();
	КонецЕсли; 
КонецПроцедуры 

&НаКлиенте
Процедура Обновить(Команда)
ПолучитьСписокАктивныхПользователей();
КонецПроцедуры

&НаСервере
Функция НастройкиНаСервере()
Настройки = Новый Структура;
Настройки.Вставить("Сообщение",Объект.Сообщение);
Настройки.Вставить("ТекстСообщения",Объект.ТекстСообщения);
Настройки.Вставить("Срок",Объект.Срок);
Настройки.Вставить("ВремяОтсрочки",Объект.ВремяОтсрочки);
Настройки.Вставить("ДляВсех",ДляВсех);
Настройки.Вставить("Важное",Важное);
Возврат(Новый Структура("КлючНазначенияИспользования,Настройки","СообщениеПользователям",Настройки));
КонецФункции

&НаКлиенте
Процедура Настройки(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.НастройкиФорм",НастройкиНаСервере());
	Если Результат <> Неопределено Тогда	
	Объект.Сообщение = Результат.Сообщение;
	Объект.ТекстСообщения = Результат.ТекстСообщения;
	Объект.Срок = Результат.Срок;
	Объект.ВремяОтсрочки = Результат.ВремяОтсрочки;
	ДляВсех = Результат.ДляВсех;
	Важное = Результат.Важное;
	КонецЕсли;
КонецПроцедуры


