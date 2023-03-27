﻿
&НаСервере
Процедура ПолучитьДанныеПоЗаданиямНаСервере()
Объект.ТаблицаЗаданий.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Ссылка
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.Линейка = &Линейка
	|	И ПроизводственноеЗадание.Остановлено = ИСТИНА";
Запрос.УстановитьПараметр("Линейка",Объект.Линейка);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
    ТЧ = Объект.ТаблицаЗаданий.Добавить();
	ТЧ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
Объект.ТаблицаЗаданий.Сортировать("ПроизводственноеЗадание");
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
ПолучитьДанныеПоЗаданиямНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не Объект.Линейка.Пустая() Тогда
	ПолучитьДанныеПоЗаданиямНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗапуститьВРаботуНаСервере(Стр)
ТЧ = Объект.ТаблицаЗаданий.НайтиПоИдентификатору(Стр);
	Попытка
	ПЗ = ТЧ.ПроизводственноеЗадание.ПолучитьОбъект();	
	ПЗ.Остановлено = Ложь;
	ПЗ.Записать();
	Объект.ТаблицаЗаданий.Удалить(ТЧ);
	Исключение
	Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры 

&НаКлиенте
Процедура ЗапуститьВРаботу(Команда)
ЗапуститьВРаботуНаСервере(Элементы.ТаблицаЗаданий.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура УдалитьПЗНаСервере(Стр)	
ТЧ = Объект.ТаблицаЗаданий.НайтиПоИдентификатору(Стр);
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	ПЗ = ТЧ.ПроизводственноеЗадание.ПолучитьОбъект();
	МТК = ПЗ.ДокументОснование.ПолучитьОбъект();
	МТК.Количество = МТК.Количество - ПЗ.Количество;
	МТК.Записать(РежимЗаписиДокумента.Проведение);
	ПП = Документы.ПередачаВПроизводство.НайтиПоНомеру(МТК.Номер,ПЗ.ДатаЗапуска).ПолучитьОбъект();
	КоличествоСтарое = ПП.Количество;
	ПП.Количество = МТК.Количество;
		Для каждого ТЧ_ПП Из ПП.Спецификация Цикл
		ТЧ_ПП.Количество = ТЧ_ПП.Количество/КоличествоСтарое*ПП.Количество;
		КонецЦикла; 
	ПП.Записать(РежимЗаписиДокумента.Проведение);	
	ПЗ.Удалить();
	Объект.ТаблицаЗаданий.Удалить(ТЧ);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;
КонецПроцедуры 

&НаКлиенте
Процедура УдалитьПЗ(Команда)
УдалитьПЗНаСервере(Элементы.ТаблицаЗаданий.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
ПолучитьДанныеПоЗаданиямНаСервере();
КонецПроцедуры
