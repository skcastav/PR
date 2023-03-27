﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
// регистр ЗаказыПоставщикам Приход
Движения.ЗаявкиНаЗакупку.Записывать = Истина;
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
	Движение = Движения.ЗаявкиНаЗакупку.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Подразделение = Подразделение;
	Движение.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
	Движение.Количество = ПолучитьБазовоеКоличество(ТекСтрокаТабличнаяЧасть.Количество,ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения);
	Движение.ЗаявкаНаЗакупку = Ссылка;
	КонецЦикла;
КонецПроцедуры
