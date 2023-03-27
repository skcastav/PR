﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
СписокРазрешенныхРолей = Новый СписокЗначений;

СписокРазрешенныхРолей.Добавить("Администратор");
СписокРазрешенныхРолей.Добавить("Мастер");
СписокРазрешенныхРолей.Добавить("ГлавныйДиспетчер");
ЭтотОбъект.ТолькоПросмотр = ОбщийМодульСозданиеДокументов.ЗапретРедактирования(Объект.Ссылка,Истина,Истина,СписокРазрешенныхРолей);
ОписаниеОшибки = "";
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
      ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаСервере
Процедура ПодборМПЗНаСервере(ТаблицаМПЗ)
	Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;		
		Иначе
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
		КонецЕсли; 
	ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
	ТЧ.Количество = ТЧ_МПЗ.Количество;
	ТЧ.ЕдиницаИзмерения = ТЧ_МПЗ.ЕдиницаИзмерения;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПодборМПЗ(Команда)
ТаблицаМПЗ = ОткрытьФормуМодально("ОбщаяФорма.ПодборМПЗ", Новый Структура("МестоХранения",Объект.МестоХранения));
	Если ТаблицаМПЗ <> Неопределено Тогда
		Если ТаблицаМПЗ.Количество() > 0 Тогда
			Если Объект.ТабличнаяЧасть.Количество() > 0 Тогда
				Если Вопрос("Очистить таблицу?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				Объект.ТабличнаяЧасть.Очистить();		
				КонецЕсли; 			
			КонецЕсли; 
		ПодборМПЗНаСервере(ТаблицаМПЗ);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
ДокументОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
	Возврат;
	КонецЕсли; 
Объект.ТабличнаяЧасть.Очистить();
Об = РеквизитФормыВЗначение("Объект");
Об.ОбработкаЗаполнения(Объект.ДокументОснование,Истина);
ВыгрузкаТЧ = Об.ТабличнаяЧасть.Выгрузить();
Объект.ТабличнаяЧасть.Загрузить(ВыгрузкаТЧ); 
КонецПроцедуры

&НаСервере
Функция ПеремещениеРазрешено(МестоХранения)
	Если СокрЛП(МестоХранения.Наименование) = "Склад Основной" Тогда
		Если ПараметрыСеанса.Пользователь.Ответственный <> МестоХранения.МОЛ Тогда
		Сообщить("Перемещение с основного склада разрешено только сотрудникам, подчиненным ответственному за этот склад!");
		Возврат(Ложь);
		КонецЕсли;
	КонецЕсли;
Возврат(Истина); 
КонецФункции

&НаСервере
Функция СовпадаетСПодразделенимДокумента(МестоХранения)
Возврат(?(МестоХранения.Подразделение = Объект.Подразделение,Истина,Ложь));
КонецФункции 

&НаКлиенте
Процедура МестоХраненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если СовпадаетСПодразделенимДокумента(ВыбранноеЗначение) Тогда	
	СтандартнаяОбработка = ПеремещениеРазрешено(ВыбранноеЗначение);
	Иначе
	СтандартнаяОбработка = Ложь;
	Сообщить("Выбранное место хранения принадлежит другому подразделению!");	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьМПЗПриИзменении(Элемент)
ТабличнаяЧастьМПЗПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьМПЗПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения;
	Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;	
	Иначе
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ДобавитьМПЗ(Данные)
Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
	Если Массив[0] = "4" Тогда	
	ПЗ = ЗначениеИзСтрокиВнутр(Массив[1]);
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
	ТЧ.МПЗ = ПЗ.Изделие;
	ТЧ.Количество = ПЗ.Количество;
	ТЧ.ЕдиницаИзмерения = ПЗ.Изделие.ОсновнаяЕдиницаИзмерения;		
	Иначе
	Сообщить("Неверный QRCode!");	
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
ДобавитьМПЗ(Данные);
КонецПроцедуры
