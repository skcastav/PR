﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)  
ЭтаФорма = ПараметрыВыполненияКоманды.Источник;
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = ЭтаФорма.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = ЭтаФорма.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ОбщийМодульВызовСервера.МожноОформитьПустойКанбан(МПЗ) Тогда
		П = Новый Структура("МестоХраненияКанбанов,МПЗ",ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(ПараметрКоманды),МПЗ);
		ОткрытьФорму("ОбщаяФорма.ОформлениеПустыхКанбанов",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		КонецЕсли;
КонецПроцедуры
