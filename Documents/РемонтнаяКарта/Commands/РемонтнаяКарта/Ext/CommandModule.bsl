﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
ТекФорма = ПолучитьФорму("Документ.РемонтнаяКарта.Форма.ФормаОтбораПоПЗ",, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
ТекФорма.Открыть();
ЭлементОтбора = ТекФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокументОснование");
ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
ЭлементОтбора.Использование = Истина;
ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
ЭлементОтбора.ПравоеЗначение = ПараметрКоманды;
КонецПроцедуры
