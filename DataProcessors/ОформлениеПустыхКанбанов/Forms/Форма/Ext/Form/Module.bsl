﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОписаниеОшибки = "";
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
      ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаСервере
Процедура ОчиститьФорму()
МестоХраненияКанбанов = Справочники.Линейки.ПустаяСсылка();
МПЗ = Неопределено;
Количество = 0;
Элементы.Оформить.Доступность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура Оформить(Команда)
	Если ОбщийМодульВызовСервера.МожноОформитьПустойКанбан(МПЗ) Тогда
	П = Новый Структура("МестоХраненияОтправитель,МестоХраненияКанбанов,МПЗ,НомерЯчейки",МестоХраненияОтправитель,МестоХраненияКанбанов,МПЗ,НомерЯчейки);
		Если ОткрытьФормуМодально("ОбщаяФорма.ОформлениеПустыхКанбанов",П) Тогда
		ОчиститьФорму();
		КонецЕсли;
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция ПолучитьМестоХраненияКанбанов(Линейка)
Возврат(Линейка.МестоХраненияКанбанов);	
КонецФункции
           
&НаСервере
Функция ПолучитьМестоХранения(Код)
Возврат(Справочники.МестаХранения.НайтиПоКоду(Код));	
КонецФункции

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если Массив[0] = "3" Тогда
		ЗначениеПараметра1 = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
			Если ЗначениеПараметра1 = Неопределено Тогда
			Сообщить("Линейка или место хранения не найдена!");
			ОчиститьФорму();
			Возврат;	
			КонецЕсли; 
				Если ТипЗнч(ЗначениеПараметра1) = Тип("СправочникСсылка.Линейки") Тогда
				МестоХраненияКанбанов = ПолучитьМестоХраненияКанбанов(ЗначениеПараметра1);
				Иначе	
				МестоХраненияКанбанов = ЗначениеПараметра1;
				КонецЕсли;
		МПЗ = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
			Если МПЗ = Неопределено Тогда
			Сообщить(Массив[3]+" - МПЗ не найдена!");
			ОчиститьФорму();
			Возврат;	
			КонецЕсли;
		МестоХраненияОтправитель = ПолучитьМестоХранения(Массив[2]);
		Количество = Число(Массив[4]);
		НомерЯчейки = Число(Массив[5]);
		Элементы.Оформить.Доступность = Истина;
		Оформить(Неопределено);
		ИначеЕсли Массив[0] = "7" Тогда
		Линейка = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
		МестоХраненияОтправитель = ОбщийМодульВызовСервера.ПолучитьЗначениеРеквизита(Линейка,"МестоХраненияГП");
		МестоХраненияКанбанов = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[2]);
        МПЗ = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
		Количество = Число(Массив[4]);
        НомерЯчейки = Число(Массив[5]);
        Оформить(Неопределено);
		Иначе
		Сообщить("Неверный формат QR-кода!");	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
