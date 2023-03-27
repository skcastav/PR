﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
ЭлементОтбора.Использование = Истина;
ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
ЭлементОтбора.ПравоеЗначение = ОбщийМодульВызовСервера.ПолучитьСписокДоступныхПодразделений();
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда
		Если Не ОбщийМодульВызовСервера.РазрешитьКопированиеДокумента(Элемент.ТекущаяСтрока) Тогда
		Отказ = Истина; 
		Сообщить("У Вас нет прав на копирование чужёго документа!");
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры
