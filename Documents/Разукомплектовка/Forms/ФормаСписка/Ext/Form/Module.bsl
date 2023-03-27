﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Список.Параметры.УстановитьЗначениеПараметра("СписокЛинеек",ПараметрыСеанса.Пользователь.ЛинейкиПроизводства.ВыгрузитьКолонку("Линейка"));
КонецПроцедуры

&НаСервере
Процедура ОтменитьПроведениеНаСервере(Док)
ДокОбъект = Док.ПолучитьОбъект();
ДокОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроведение(Команда)
ОтменитьПроведениеНаСервере(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
Элементы.ФормаОтменитьПроведение.Доступность = ОбщийМодульВызовСервера.ДоступностьРоли("Администратор")или ОбщийМодульВызовСервера.ДоступностьРоли("МастерУД");
КонецПроцедуры
