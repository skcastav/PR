﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(СокрЛП(ДокументОснование.Номер)+"-");
	КонецЕсли;			   
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.Заказ Цикл
		ТЧ = ТабличнаяЧасть.Добавить();
		ТЧ.Товар = ТекСтрокаТабличнаяЧасть.Товар;
		ТЧ.Продукция = ТекСтрокаТабличнаяЧасть.Продукция;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
// регистр РезервированиеГП Расход
Движения.РезервированиеГП.Записывать = Истина;
Движения.Долги.Записывать = Истина;
Движения.ЗаказыНаПроизводство.Записывать = Истина;
КоличествоВсего = 0; 
	Для каждого ТЧ Из ТабличнаяЧасть Цикл
		Если ТЧ.Продукция <> Неопределено Тогда
		КоличествоВсего = КоличествоВсего + ТЧ.Количество;
			Если ТипЗнч(ТЧ.Продукция) = Тип("СправочникСсылка.Номенклатура") Тогда
			МестоХранения = ТЧ.Продукция.Линейка.МестоХраненияГП;
			Иначе	
			МестоХранения = Константы.МестоХраненияТНП.Получить();
			КонецЕсли;
		// регистр ЗаказыНаПроизводство Расход
		КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоЗаказуНаПроизводство(ДокументОснование,ТЧ.Продукция,Дата);
			Если КолОстаток >= ТЧ.Количество Тогда
			Движение = Движения.ЗаказыНаПроизводство.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Документ = ДокументОснование;
			Движение.Продукция = ТЧ.Продукция;
			Движение.Количество = ТЧ.Количество;
			Иначе
			Движение = Движения.ЗаказыНаПроизводство.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Документ = ДокументОснование;
			Движение.Продукция = ТЧ.Продукция;
			Движение.Количество = КолОстаток;			
			КонецЕсли;
		// регистр Долги Расход
		КолОстатокДолг = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоДолгам(ДокументОснование,ТЧ.Продукция,Дата);
			Если КолОстатокДолг >= ТЧ.Количество Тогда
			Движение = Движения.Долги.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Документ = ДокументОснование;
			Движение.Продукция = ТЧ.Продукция;
			Движение.Количество = ТЧ.Количество;
			Иначе
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Текст = "Продукция: "+СокрЛП(ТЧ.Продукция.Наименование)+" требуется списать: "+ТЧ.Количество+" недостаёт в регистре долгов: "+Строка(ТЧ.Количество-КолОстатокДолг);
			Сообщение.Сообщить();
			КонецЕсли;
        // регистр Резервирование ГП Расход
		КолОстатокРезерв = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокВРезерве(МестоХранения,ТЧ.Продукция,ДокументОснование,Дата);
		КолСписанияСРезерва = КолОстатокРезерв+ТЧ.Количество-КолОстатокДолг;
			Если КолСписанияСРезерва > 0 Тогда
			Движение = Движения.РезервированиеГП.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.МестоХранения = МестоХранения;
			Движение.Продукция = ТЧ.Продукция;
			Движение.Количество = КолСписанияСРезерва;
			Движение.Документ = ДокументОснование;
			КонецЕсли;
		КонецЕсли; 		
	КонецЦикла;
		Если Не Отказ Тогда
		ОбщийМодульВызовСервера.ПроверитьЗаказНаПроизводство(ДокументОснование,КоличествоВсего,Дата);
		КонецЕсли; 
КонецПроцедуры
