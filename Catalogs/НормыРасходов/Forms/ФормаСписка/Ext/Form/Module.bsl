﻿
&НаСервере
Функция ПолучитьВладельцаФормы()
КоллекцияПолейОтбора=ЭтаФорма.Список.Отбор.Элементы;
ТекущийВладелецФормы=Неопределено;
	Для каждого ПолеОтбора Из КоллекцияПолейОтбора Цикл
		Если Строка(ПолеОтбора.ЛевоеЗначение)="Владелец" Тогда
		ТекущийВладелецФормы=ПолеОтбора.ПравоеЗначение;
   		Прервать;
		КонецЕсли; 
	КонецЦикла; 
Возврат ТекущийВладелецФормы;
КонецФункции

&НаКлиенте
Процедура СкрытьНеАктуальныеПриИзменении(Элемент)
Владелец = ПолучитьВладельцаФормы();
Список.Отбор.Элементы.Очистить();
ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
ЭлементОтбора.Использование = Истина;
ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
ЭлементОтбора.ПравоеЗначение = Владелец;
	Если СкрытьНеАктуальные Тогда
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Норма");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение = 0;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьЭлементНормыРасходов(НР)
Возврат(НР.Элемент);
КонецФункции

&НаСервере
Функция ПолучитьМетаданные(ВыбТип)
Возврат(Метаданные.НайтиПоТипу(ВыбТип).ПолноеИмя());
КонецФункции

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущийЭлемент.Имя = "Статус" Тогда 
	Отказ = Истина;
	ЭлементНР = ПолучитьЭлементНормыРасходов(Элементы.Список.ТекущаяСтрока);
	ТекФорма = ПолучитьФорму(ПолучитьМетаданные(ТипЗнч(ЭлементНР))+".ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = ЭлементНР;	
	КонецЕсли;
КонецПроцедуры
