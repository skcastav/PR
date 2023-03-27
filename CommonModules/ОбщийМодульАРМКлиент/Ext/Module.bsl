﻿
Процедура ОформитьПустойКанбан(ЭтаФорма,РабочееМесто) Экспорт
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = ЭтаФорма.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = ЭтаФорма.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ОбщийМодульВызовСервера.МожноОформитьПустойКанбан(МПЗ) Тогда
		П = Новый Структура("МестоХраненияКанбанов,МПЗ",ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(РабочееМесто),МПЗ);
		ОткрытьФорму("ОбщаяФорма.ОформлениеПустыхКанбанов",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		КонецЕсли;
КонецПроцедуры

Функция ОформитьНедостачу(ЭтаФорма,РабочееМесто,ПроизводственноеЗадание) Экспорт
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Этаформа.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(МПЗ,"Канбан").Пустая() Тогда	
			Сообщить("Выберите МПЗ ячейки канбана!");
			Возврат(Ложь);
			КонецЕсли;
		ИначеЕсли ТипЗнч(МПЗ) <> Тип("СправочникСсылка.Материалы")Тогда	
		Сообщить("Выберите МПЗ ячейки канбана!");
		Возврат(Ложь);
		КонецЕсли; 
П = Новый Структура("ВидОперации,МестоХраненияКанбанов,ПЗ,МПЗ",1,ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(РабочееМесто),ПроизводственноеЗадание,МПЗ);
	Если ОткрытьФормуМодально("ОбщаяФорма.ОформлениеНедостачиИзлишков",П) Тогда
		Если ОбщийМодульВызовСервера.МТКОстановлена(ПроизводственноеЗадание) Тогда
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"МТК остановлена по причине недостачи комплектации. Отложите изготавливаемый полуфабрикат!",БиблиотекаКартинок.Пользователь);
		Возврат(Истина);
		КонецЕсли;     
	КонецЕсли; 
Возврат(Ложь);
КонецФункции

Процедура ОформитьИзлишки(ЭтаФорма,РабочееМесто,ПроизводственноеЗадание) Экспорт
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Этаформа.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли; 
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(МПЗ,"Канбан").Пустая() Тогда	
			Сообщить("Выберите МПЗ ячейки канбана!");
			Возврат;
			КонецЕсли;
		ИначеЕсли ТипЗнч(МПЗ) <> Тип("СправочникСсылка.Материалы")Тогда	
		Сообщить("Выберите МПЗ ячейки канбана!");
		Возврат;
		КонецЕсли; 
П = Новый Структура("ВидОперации,МестоХраненияКанбанов,ПЗ,МПЗ",2,ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(РабочееМесто),ПроизводственноеЗадание,МПЗ);
ОткрытьФорму("ОбщаяФорма.ОформлениеНедостачиИзлишков",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

Процедура ОформитьБрак(ЭтаФорма,РабочееМесто,ПроизводственноеЗадание) Экспорт
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Этаформа.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Количество = Этаформа.Элементы.ДеревоСпецификации.ТекущиеДанные.Количество;
	Иначе
	МПЗ = Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	Количество = Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.Количество;
	КонецЕсли;
		Если ОбщийМодульВызовСервера.МожноПеремещатьВБрак(МПЗ) Тогда
		П = Новый Структура("РабочееМесто,ПЗ,ЭтапСпецификации,МПЗ,Количество",РабочееМесто,ПроизводственноеЗадание,Этаформа.Элементы.ТаблицаКомплектации.ТекущиеДанные.ЭтапСпецификации,МПЗ,Количество);
		ОткрытьФорму("ОбщаяФорма.ОформлениеБракаНовый",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		Иначе
		Сообщить("Выбранную МПЗ запрещено перемещать в брак!");
		КонецЕсли;
КонецПроцедуры

Процедура ОстановкаЛинейки(ЭтаФорма,РабочееМесто) Экспорт
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = ЭтаФорма.Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = ЭтаФорма.Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ОбщийМодульВызовСервера.ЭтоКанбанБезРезервирования(МПЗ) Тогда
				Если Вопрос("Вы уверены, что хотите остановить линейку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				ОбщийМодульРаботаСРегистрами.ОстановитьЛинейку(ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(РабочееМесто,"Линейка"),МПЗ);
				КонецЕсли;
			Иначе
			Сообщить("Выберите МПЗ ячейки канбана без резервирования!");
			КонецЕсли;
		Иначе	
		Сообщить("Выберите МПЗ ячейки канбана без резервирования!");
		КонецЕсли; 
КонецПроцедуры
              
Процедура ПечатьДокументовА4(СписокФайлов) Экспорт
	Если СписокФайлов.Количество() = 1 Тогда
	ЗапуститьПриложение("C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe /t "+""""+СписокФайлов[0].Значение+"""");
	//ОткрытьФорму("ОбщаяФорма.ДокументPDF",Новый Структура("ИмяФайла",СписокФайлов[0].Значение));
	ИначеЕсли СписокФайлов.Количество() > 0 Тогда
	ВыбФайл = СписокФайлов.ВыбратьЭлемент("Выберите файл для печати");	
		Если ВыбФайл <> Неопределено Тогда                                                  
		ЗапуститьПриложение("C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe /t "+""""+ВыбФайл.Значение+"""");
		//ОткрытьФорму("ОбщаяФорма.ДокументPDF",Новый Структура("ИмяФайла",ВыбФайл.Значение));
		КонецЕсли; 		
	Иначе
	Сообщить("Документы КР(РЭ) формата А4 не найдены!");
	КонецЕсли;
КонецПроцедуры
