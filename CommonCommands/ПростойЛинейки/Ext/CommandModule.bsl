﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.РабочиеМестаЛинеек") Тогда
	Линейка = ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(ПараметрКоманды);
	Иначе	
	Линейка = ПараметрКоманды;
	КонецЕсли;
		Если Не ОбщийМодульВызовСервера.ЛинейкаОстановлена(Линейка) Тогда
		ОткрытьФормуМодально("ОбщаяФорма.ОформлениеПростояЛинейки",Новый Структура("Линейка",Линейка));
		КонецЕсли;
КонецПроцедуры
