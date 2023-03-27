﻿
Функция ВнесёнВДоговорныеПозиции(МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДоговорныеПозиции.Ссылка
	|ИЗ
	|	Справочник.ДоговорныеПозиции КАК ДоговорныеПозиции
	|ГДЕ
	|	ДоговорныеПозиции.Владелец = &Владелец
	|	И ДоговорныеПозиции.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("Владелец", Договор);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
	Возврат(Истина);
	Иначе
	Возврат(Ложь);
	КонецЕсли; 			
КонецФункции 

Функция ПолучитьЦену(МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорныеПозицииСрезПоследних.Цена,
	|	ДоговорныеПозицииСрезПоследних.Валюта
	|ИЗ
	|	РегистрСведений.ДоговорныеПозиции.СрезПоследних(&НаДату, ) КАК ДоговорныеПозицииСрезПоследних
	|ГДЕ
	|	ДоговорныеПозицииСрезПоследних.ДоговорнаяПозиция.Владелец = &Владелец
	|	И ДоговорныеПозицииСрезПоследних.ДоговорнаяПозиция.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("Владелец", Договор);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Цена = ВыборкаДетальныеЗаписи.Цена;
		Если Договор.Валюта <> ВыборкаДетальныеЗаписи.Валюта Тогда
		КурсВалютыМПЗ = ОбщийМодульВызовСервера.КурсДляВалюты(ВыборкаДетальныеЗаписи.Валюта,ТекущаяДата());		
		ЦенаВРублях = Цена*КурсВалютыМПЗ;
		Цена = ЦенаВРублях/Курс;
		КонецЕсли; 
			Если Не Договор.БезНДС Тогда	
			СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();	
			Цена = Цена/(100+СтавкаНДС.Ставка)*100;
			КонецЕсли; 
	Возврат(Цена);
	КонецЦикла;
Возврат(0);
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаЗакупку") Тогда
	Подразделение = ДанныеЗаполнения.Подразделение;
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Запрос = Новый Запрос;

	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкиНаЗакупкуОстатки.МПЗ КАК МПЗ,
		|	ЗаявкиНаЗакупкуОстатки.КоличествоОстаток КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ЗаявкиНаЗакупку.Остатки(&НаДату, ) КАК ЗаявкиНаЗакупкуОстатки
		|ГДЕ
		|	ЗаявкиНаЗакупкуОстатки.ЗаявкаНаЗакупку = &ЗаявкаНаЗакупку";
	Запрос.УстановитьПараметр("ЗаявкаНаЗакупку", ДанныеЗаполнения.Ссылка);
	Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТЧ = ТабличнаяЧасть.Добавить();
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
		ТЧ.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
		ТЧ.Количество = ВыборкаДетальныеЗаписи.КоличествоОстаток/ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент; 
		ТЧ.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения; 	
		КонецЦикла;
	ТабличнаяЧасть.Сортировать("МПЗ");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаОтПокупателя") Тогда
	Подразделение = ДанныеЗаполнения.Подразделение;
	Контрагент = ДанныеЗаполнения.Контрагент;
	Договор = ДанныеЗаполнения.Договор;
	Курс = ДанныеЗаполнения.Курс;
	ДокументОснование = ДанныеЗаполнения.Ссылка;
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
		ТЧ = ТабличнаяЧасть.Добавить();
		ТЧ.ВидМПЗ = ТекСтрокаТабличнаяЧасть.ВидМПЗ;
		ТЧ.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
		ТЧ.Количество = ТекСтрокаТабличнаяЧасть.Количество;
		ТЧ.ЕдиницаИзмерения = ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения;
			Если Не ОбщийМодульРаботаСРегистрами.ВнесёнВДоговорныеПозиции(Договор,ТекСтрокаТабличнаяЧасть.МПЗ,Дата) Тогда
			ТЧ.НЦ = Истина;
			Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",ТекСтрокаТабличнаяЧасть.МПЗ));
			ТЧ.Цена = Цены.Цена*ТЧ.ЕдиницаИзмерения.Коэффициент;
				Если Договор.Валюта <> Константы.ОсновнаяВалюта.Получить() Тогда
				ТЧ.ЦенаВалюта = ТЧ.Цена/Курс;
				КонецЕсли;
			Иначе
				Если Договор.Валюта <> Константы.ОсновнаяВалюта.Получить() Тогда
					Если  Не Договор.ДоговорСНефиксированнымиЦенами Тогда
					ТЧ.ЦенаВалюта = ПолучитьЦену(ТЧ.МПЗ);
					//ТЧ.ЦенаВалюта = ОбщийМодульРаботаСРегистрами.ПолучитьЦенуПоДоговору(Договор,ТЧ.МПЗ);
						Если ТЧ.ЦенаВалюта > 0 Тогда
						ТЧ.НЦ = Ложь;			
						КонецЕсли; 
					ТЧ.Цена = ТЧ.ЦенаВалюта*Курс;
					КонецЕсли;
				Иначе
					Если Договор.ДоговорСНефиксированнымиЦенами Тогда
					Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",ТекСтрокаТабличнаяЧасть.МПЗ));
					ТЧ.Цена = Цены.Цена*ТЧ.ЕдиницаИзмерения.Коэффициент;			
					Иначе
					ТЧ.Цена = ПолучитьЦену(ТЧ.МПЗ);
					//ТЧ.Цена = ОбщийМодульРаботаСРегистрами.ПолучитьЦенуПоДоговору(Договор,ТЧ.МПЗ);
						Если ТЧ.Цена > 0 Тогда
						ТЧ.НЦ = Ложь;			
						КонецЕсли; 
					КонецЕсли;  
				КонецЕсли;		
			КонецЕсли; 
		ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;	
			Если Договор.БезНДС Тогда
			ТЧ.СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
			ТЧ.НДС = 0;
			ТЧ.Всего = ТЧ.Сумма;
			Иначе
			ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
			ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
			ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;		
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка; 
	ТЧ = ТабличнаяЧасть.Добавить();
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
	ТЧ.МПЗ = ДанныеЗаполнения.ВнешняяПродукция;
	ТЧ.Количество = ДанныеЗаполнения.КоличествоВнешнейПродукции;
	ТЧ.ЕдиницаИзмерения = ДанныеЗаполнения.ВнешняяПродукция.ОсновнаяЕдиницаИзмерения;		
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;
		Если ЗначениеЗаполнено(ДатаИсполнения) Тогда
			Для каждого ТЧ Из ТабличнаяЧасть Цикл
				Если Не ЗначениеЗаполнено(ТЧ.ДатаПоставки) Тогда
				ТЧ.ДатаПоставки = ДатаИсполнения;				
				КонецЕсли; 		
			КонецЦикла;
		КонецЕсли; 
КонецПроцедуры

Функция ПолучитьСпецификациюКДоговору(МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СпецификацияКДоговоруСПоставщиком.ТабличнаяЧасть КАК СпецификацияКДоговоруСПоставщикомТабличнаяЧасть
	|ГДЕ
	|	СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Ссылка.Договор = &Договор
	|	И СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	|	И НАЧАЛОПЕРИОДА(СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Ссылка.Дата, ДЕНЬ) <= &ДатаЗаказа
	|	И СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Ссылка.ДействуетДо >= &ДатаЗаказа
	|	И СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.МПЗ = &МПЗ
	|	И СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Количество > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпецификацияКДоговоруСПоставщикомТабличнаяЧасть.Ссылка.Дата";
Запрос.УстановитьПараметр("Договор", Договор);
Запрос.УстановитьПараметр("ДатаЗаказа", НачалоДня(Дата));
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	КоличествоОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоДоговоруСПоставщиком(Контрагент,Договор,ВыборкаДетальныеЗаписи.Ссылка,МПЗ,Дата);
		Если КоличествоОстаток > 0 Тогда
		Возврат(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЕсли;
	КонецЦикла;
Возврат(Неопределено);
КонецФункции

Функция ИзменитьДвижениеРасходПоМПЗ(ЗаказПоставщику,МПЗ,ДатаПоставки)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыПоставщикам.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
	|ГДЕ                                                     
	|	ЗаказыПоставщикам.ЗаказПоставщику = &ЗаказПоставщику
	|	И ЗаказыПоставщикам.МПЗ = &МПЗ                      
	|	И ЗаказыПоставщикам.ВидДвижения = &ВидДвижения
	|	И ЗаказыПоставщикам.ДатаИсполнения <> &ДатаИсполнения";
Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
Запрос.УстановитьПараметр("ЗаказПоставщику", ЗаказПоставщику);
Запрос.УстановитьПараметр("МПЗ", МПЗ);                        
Запрос.УстановитьПараметр("ДатаИсполнения", ДатаПоставки);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
 	НаборЗаписей = РегистрыНакопления.ЗаказыПоставщикам.СоздатьНаборЗаписей();
    НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДетальныеЗаписи.Регистратор);
    НаборЗаписей.Прочитать();
    	Для каждого Запись из НаборЗаписей Цикл
			Если Запись.МПЗ = МПЗ Тогда
				Если Запись.ДатаИсполнения <> ДатаПоставки Тогда
				Запись.ДатаИсполнения = ДатаПоставки;
				КонецЕсли;		
			КонецЕсли;
        КонецЦикла;
    НаборЗаписей.Записать();	
	КонецЦикла;
КонецФункции

Процедура ОбработкаПроведения(Отказ, Режим)
// регистр ЗаказыПоставщикам Приход
Движения.ЗаказыПоставщикам.Записывать = Истина;
	Для Каждого ТЧ Из ТабличнаяЧасть Цикл
		//Если Не Договор.ДоговорСНефиксированнымиЦенами Тогда
		//	Если Не ТЧ.НЦ Тогда
		//		Если Не ОбщийМодульРаботаСРегистрами.ВнесёнВДоговорныеПозиции(Договор,ТЧ.МПЗ,Дата) Тогда
		//		Сообщить(СокрЛП(ТЧ.МПЗ.Наименование+" - не внесён в договорные позиции!"));
		//		Отказ = Истина;
		//		КонецЕсли;	
		//	КонецЕсли;	
		//КонецЕсли; 
	Движение = Движения.ЗаказыПоставщикам.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.ДатаИсполнения = ТЧ.ДатаПоставки;
	Движение.МПЗ = ТЧ.МПЗ;
	Движение.Контрагент = Контрагент;
	Движение.Договор = Договор;
	Движение.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
	Движение.ЗаказПоставщику = Ссылка; 
	ИзменитьДвижениеРасходПоМПЗ(Ссылка,ТЧ.МПЗ,ТЧ.ДатаПоставки);
	КонецЦикла;
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаЗакупку") Тогда
		// регистр ЗаявкаНаЗакупку Расход
		Движения.ЗаявкиНаЗакупку.Записывать = Истина;
			Для Каждого ТЧ Из ТабличнаяЧасть Цикл
			Движение = Движения.ЗаявкиНаЗакупку.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Подразделение = Подразделение;
			Движение.МПЗ = ТЧ.МПЗ;
			Движение.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
			Движение.ЗаявкаНаЗакупку = ДокументОснование;
			КонецЦикла;		
		КонецЕсли; 
			Если Договор.УчётКоличества Тогда
			// регистр ДоговорыСПоставщиками Расход
			Движения.ДоговорыСПоставщиками.Записывать = Истина;			
				Для Каждого ТЧ Из ТабличнаяЧасть Цикл
					Если Не ТЧ.НЦ Тогда
					СпецификацияКДоговору = ПолучитьСпецификациюКДоговору(ТЧ.МПЗ);
						Если СпецификацияКДоговору <> Неопределено Тогда
						БазовоеКоличество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
						КоличествоОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоДоговоруСПоставщиком(Контрагент,Договор,СпецификацияКДоговору,ТЧ.МПЗ,Дата);
							Если КоличествоОстаток < БазовоеКоличество Тогда
							Отказ = Истина;
							Сообщить("МПЗ "+ТЧ.МПЗ+" заказано: "+БазовоеКоличество+" остаток по спецификации к договору: "+КоличествоОстаток);
							Продолжить;
							КонецЕсли;
						Движение = Движения.ДоговорыСПоставщиками.Добавить();
						Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
						Движение.Период = Дата;
						Движение.Контрагент = Контрагент;
						Движение.Договор = Договор;
						Движение.МПЗ = ТЧ.МПЗ;
						Движение.СпецификацияКДоговору = СпецификацияКДоговору;
						Движение.Количество = БазовоеКоличество;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;			
			КонецЕсли;
КонецПроцедуры
