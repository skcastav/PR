﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
РемонтнаяКарта = Параметры.Ссылка;
Линейка = РемонтнаяКарта.Линейка;
ДокументРемонта = РемонтнаяКарта.ДокументОснование;
РабочееМесто = РемонтнаяКарта.РабочееМесто;
НормаРасходов = Параметры.НормаРасхода;
Количество = Параметры.Количество;
	Если ТипЗнч(НормаРасходов.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
	Элементы.ТипБрака.Доступность = Ложь;	
	КонецЕсли; 
		Если ТипЗнч(НормаРасходов) = Тип("СправочникСсылка.АналогиНормРасходов") Тогда
		НР = НормаРасходов.Владелец;
		Иначе
		НР = НормаРасходов;
		КонецЕсли; 
			Если ТипЗнч(ДокументРемонта) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
			ДатаЗапуска = ДокументРемонта.ДатаЗапуска;
			Подразделение = Линейка.Подразделение;
			СписокМестХранения.Добавить(Линейка.МестоХраненияКанбанов);
			ИначеЕсли ТипЗнч(ДокументРемонта) = Тип("ДокументСсылка.ВыпускПродукцииКанбан") Тогда
			ДатаЗапуска = ТекущаяДата();
			Подразделение = Линейка.Подразделение;
			СписокМестХранения.Добавить(Линейка.МестоХраненияКанбанов);
			Иначе	
			ДатаЗапуска = ТекущаяДата();
			Подразделение = Параметры.Ссылка.Изделие.Канбан.Подразделение;
			КонецЕсли;
СписокМестХраненияДляМониторинга = ОбщийМодульВызовСервера.ПолучитьСписокМестХраненияДляМониторинга(Подразделение);
	Для каждого МестоХранения Из СписокМестХраненияДляМониторинга Цикл
		Если СписокМестХранения.НайтиПоЗначению(МестоХранения.Значение) = Неопределено Тогда
		СписокМестХранения.Добавить(МестоХранения.Значение);
		КонецЕсли;
	КонецЦикла;			
СписокМестХранения.Добавить(Подразделение.МестоХраненияПоУмолчанию);				
	Для каждого МестоХранения Из СписокМестХранения Цикл
	КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(МестоХранения.Значение,НР.Элемент);
		Если КоличествоСклад > 0 Тогда
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.НР = НР;
		ТЧ.МПЗ = НР.Элемент;
		ТЧ.ЕдиницаИзмерения = НР.Элемент.ЕдиницаИзмерения;
		ТЧ.Статус = ПолучитьСтатус(НР.Элемент);
		ТЧ.КоличествоТребуется = ПолучитьБазовоеКоличество(Количество,НР.Элемент.ОсновнаяЕдиницаИзмерения);
		ТЧ.КоличествоСклад = КоличествоСклад;
		ТЧ.МестоХранения = МестоХранения.Значение;
		КонецЕсли;
	КонецЦикла;
ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(НР);
	Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл
		Для каждого МестоХранения Из СписокМестХранения Цикл
		КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(МестоХранения.Значение,ТЧ_ТА.Ссылка.Элемент);
			Если КоличествоСклад > 0 Тогда
			ТЧ = ТаблицаМПЗ.Добавить();
			ТЧ.НР = ТЧ_ТА.Ссылка;
			ТЧ.МПЗ = ТЧ_ТА.Ссылка.Элемент;
			ТЧ.ЕдиницаИзмерения = ТЧ_ТА.Ссылка.Элемент.ЕдиницаИзмерения;
			ТЧ.Статус = ПолучитьСтатус(ТЧ_ТА.Ссылка.Элемент);
			ТЧ.КоличествоТребуется = ПолучитьБазовоеКоличество(Количество,ТЧ_ТА.Ссылка.Элемент.ОсновнаяЕдиницаИзмерения);
			ТЧ.КоличествоСклад = КоличествоСклад;
			ТЧ.МестоХранения = МестоХранения.Значение;
			ТЧ.Аналог = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
		Для каждого ТЧ Из ТаблицаМПЗ Цикл
			Если ТЧ.КоличествоТребуется <= ТЧ.КоличествоСклад Тогда	
			Элементы.ТаблицаМПЗ.ТекущаяСтрока = ТЧ.ПолучитьИдентификатор();
			Прервать;
			КонецЕсли;		
		КонецЦикла; 
КонецПроцедуры

&НаСервере
Функция ПолучитьНормуРасходов(Стр)
ТЧ = ТаблицаМПЗ.НайтиПоИдентификатору(Стр);
Возврат(ТЧ.НР);
КонецФункции

&НаСервере
Функция ОформитьСписаниеБракаНаСервере(МестоХранения,СтатьяСписания,Стр)
ТЧ = ТаблицаМПЗ.НайтиПоИдентификатору(Стр);
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	Списание = Документы.СписаниеМПЗПрочее.СоздатьДокумент();
	Списание.Дата = ТекущаяДата();
	Списание.УстановитьНовыйНомер(ПрисвоитьПрефикс(МестоХранения.Подразделение));
	Списание.Автор = ПараметрыСеанса.Пользователь;
	Списание.ДокументОснование = РемонтнаяКарта;
	Списание.Подразделение = МестоХранения.Подразделение;
	Списание.МестоХранения = МестоХранения;
	Списание.Статья = СтатьяСписания;
	//Списание.ВидНеисправности = ВидНеисправности;
	Списание.Утвердил = МестоХранения.Подразделение.Руководитель;
	Списание.Комментарий = Комментарий;  
	ТЧ_С = Списание.ТабличнаяЧасть.Добавить();
	ТЧ_С.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
	ТЧ_С.МПЗ = ТЧ.МПЗ;
	ТЧ_С.Количество = ТЧ.КоличествоТребуется/ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
	ТЧ_С.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения;
	Списание.Записать(РежимЗаписиДокумента.Проведение);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(Списание.Ссылка);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Неопределено);
	КонецПопытки;
КонецФункции

&НаСервере
Функция ОформитьПеремещениеБракаНаСервере(СтатьяСписания,Стр)
ТЧ = ТаблицаМПЗ.НайтиПоИдентификатору(Стр);
ПаспортЛинейки = РегистрыСведений.ПаспортЛинейки.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("Линейка",Линейка));
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	Перемещение = Документы.ДвижениеМПЗ.СоздатьДокумент();
	Перемещение.Дата = ТекущаяДата();
	Перемещение.УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение));
	Перемещение.Автор = ПараметрыСеанса.Пользователь;
	Перемещение.ДокументОснование = РемонтнаяКарта;
	Перемещение.Подразделение = Подразделение;
	Перемещение.Сотрудник = ПаспортЛинейки.Мастер;
	Перемещение.МестоХранения = ТЧ.МестоХранения;
		Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
			Если ТЧ.МПЗ.Возвратный Тогда
			Перемещение.МестоХраненияВ = Справочники.МестаХранения.НайтиПоКоду("100");	
			Иначе	
				Если ТипБрака = 1 Тогда
				Перемещение.МестоХраненияВ = ТЧ.МПЗ.Канбан.Подразделение.МестоХраненияБрака; 
				Иначе
				Перемещение.МестоХраненияВ = Подразделение.МестоХраненияБрака;
				КонецЕсли;			
			КонецЕсли;
		Иначе
			Если ТипБрака = 1 Тогда
			Перемещение.МестоХраненияВ = ТЧ.МПЗ.Канбан.Подразделение.МестоХраненияБрака; 
			Иначе
			Перемещение.МестоХраненияВ = Подразделение.МестоХраненияБрака;
			КонецЕсли;
		КонецЕсли;
	Перемещение.РабочееМесто = РабочееМесто;
	Перемещение.Комментарий = СокрЛП(СтатьяСписания.Наименование);
	ТЧ_П = Перемещение.ТабличнаяЧасть.Добавить();
	ТЧ_П.ВидМПЗ = ?(ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы"),Перечисления.ВидыМПЗ.Материалы,Перечисления.ВидыМПЗ.Полуфабрикаты);
	ТЧ_П.МПЗ = ТЧ.МПЗ;
	ТЧ_П.Количество = ТЧ.КоличествоТребуется/ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
	ТЧ_П.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения;	
	Перемещение.Записать(РежимЗаписиДокумента.Проведение);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(Перемещение.Ссылка);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Неопределено);
	КонецПопытки;
КонецФункции

&НаСервере
Функция ПолучитьСтатьюСписания(Наименование)
Возврат(Справочники.СтатьиПоступленийСписанийПрочих.НайтиПоНаименованию(Наименование,Истина));
КонецФункции

&НаКлиенте
Процедура ЗаменитьНаВыбранный(Команда)
	Если Элементы.ТаблицаМПЗ.ТекущаяСтрока <> Неопределено Тогда
		Если (ТипБрака = 0)и(Элементы.ТипБрака.Доступность) Тогда
			Если Вопрос("Вы уверены, что это собственный брак?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;				
			КонецЕсли;
		КонецЕсли;
			Если ТипЗнч(Элементы.ТаблицаМПЗ.ТекущиеДанные.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
				Если ТипБрака = 1 Тогда
			    СтатьяСписания = ПолучитьСтатьюСписания("Брак материалов от поставщика");
				Иначе				
				СтатьяСписания = ПолучитьСтатьюСписания("Брак материалов, полученный в процессе производства");
				КонецЕсли;
					Если ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Элементы.ТаблицаМПЗ.ТекущиеДанные.МПЗ,"Возвратный") Тогда
					Док = ОформитьПеремещениеБракаНаСервере(СтатьяСписания,Элементы.ТаблицаМПЗ.ТекущаяСтрока);					
					Иначе	
					Док = ОформитьСписаниеБракаНаСервере(Элементы.ТаблицаМПЗ.ТекущиеДанные.МестоХранения,СтатьяСписания,Элементы.ТаблицаМПЗ.ТекущаяСтрока);					
					КонецЕсли; 
			Иначе	
				Если ТипБрака = 1 Тогда
			    СтатьяСписания = ПолучитьСтатьюСписания("Внешний брак продукции участков");
				Иначе				
				СтатьяСписания = ПолучитьСтатьюСписания("Брак полуфабрикатов, полученный в процессе производства");
				КонецЕсли;
			Док = ОформитьПеремещениеБракаНаСервере(СтатьяСписания,Элементы.ТаблицаМПЗ.ТекущаяСтрока);
			КонецЕсли;
				Если Док <> Неопределено Тогда
				ЭтаФорма.Закрыть(Новый Структура("НормаРасхода,МПЗ,Документ",Элементы.ТаблицаМПЗ.ТекущиеДанные.НР,Элементы.ТаблицаМПЗ.ТекущиеДанные.МПЗ,Док));		
				КонецЕсли; 
	Иначе
	Сообщить("Выберите МПЗ для замены!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
ЭтаФорма.Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьЗамену(Команда)
ЭтаФорма.Закрыть(Неопределено);
КонецПроцедуры
