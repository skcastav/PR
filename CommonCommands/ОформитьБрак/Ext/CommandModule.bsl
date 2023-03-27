﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
ЭтаФорма = ПараметрыВыполненияКоманды.Источник; 
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Этаформа.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Количество = Этаформа.Элементы.ДеревоСпецификации.ТекущиеДанные.Количество;
	Иначе
	МПЗ = Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	Количество = Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.Количество;
	КонецЕсли;
		Если ОбщийМодульВызовСервера.МожноПеремещатьВБрак(МПЗ) Тогда
		П = Новый Структура("РабочееМесто,ПЗ,ЭтапСпецификации,МПЗ,Количество",ПараметрКоманды,ЭтаФорма.Объект.ПроизводственноеЗадание,Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.ЭтапСпецификации,МПЗ,Количество);
		ОткрытьФорму("ОбщаяФорма.ОформлениеБракаНовый",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		Иначе
		Сообщить("Выбранную МПЗ запрещено перемещать в брак!");
		КонецЕсли;
КонецПроцедуры
