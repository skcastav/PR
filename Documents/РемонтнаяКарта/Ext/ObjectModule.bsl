﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
ДатаОкончания = Дата(1,1,1);
	Если Не ДокументСписания.Пустая() Тогда
	СписаниеОбъект = ДокументСписания.ПолучитьОбъект();
	СписаниеОбъект.Удалить();
	ДокументСписания = Документы.СписаниеМПЗПрочее.ПустаяСсылка();
	КонецЕсли; 
Записать();
КонецПроцедуры
