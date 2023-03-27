﻿
&НаСервере
Процедура ПроверитьПодчиненнуюЛО(ОблМПЗ,Уровень,Изделие)
УровеньПробелы = Символы.Таб;
	Для к = 1 По Уровень-3 Цикл
	УровеньПробелы = УровеньПробелы + Символы.Таб;
	КонецЦикла;

ТаблицаИзделий = Новый ТаблицаЗначений;
ТаблицаМПЗ = Новый ТаблицаЗначений;

ТаблицаИзделий.Колонки.Добавить("Линейка");
ТаблицаИзделий.Колонки.Добавить("ПЗ");
ТаблицаИзделий.Колонки.Добавить("Изделие");
ТаблицаИзделий.Колонки.Добавить("МПЗ");
ТаблицаИзделий.Колонки.Добавить("Количество");
ТаблицаИзделий.Колонки.Добавить("ДатаПостановки");

ТаблицаМПЗ.Колонки.Добавить("МПЗ");
ТаблицаМПЗ.Колонки.Добавить("Количество");
ТаблицаМПЗ.Колонки.Добавить("КоличествоСклад");

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЛьготнаяОчередь.Период,
	|	ЛьготнаяОчередь.ПЗ,
	|	ЛьготнаяОчередь.Линейка,
	|	ЛьготнаяОчередь.Изделие,
	|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
	|ГДЕ
	|	ЛьготнаяОчередь.Изделие = &Изделие
	|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
Запрос.УстановитьПараметр("Изделие", Изделие);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаИзделий.Добавить();
	ТЧ.Линейка = ВыборкаДетальныеЗаписи.Линейка;
	ТЧ.ПЗ = ВыборкаДетальныеЗаписи.ПЗ;
	ТЧ.Изделие = ВыборкаДетальныеЗаписи.Изделие;	
	ТЧ.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.ПЗ.Количество;
	ТЧ.ДатаПостановки = НачалоДня(ВыборкаДетальныеЗаписи.Период);
	КонецЦикла;
		Если СвернутьПоИзделиям Тогда
		ТаблицаИзделий.Свернуть("Линейка,Изделие,МПЗ","Количество");
		ТаблицаИзделий.Сортировать("Линейка,Изделие,МПЗ");
		Иначе
		ТаблицаИзделий.Свернуть("Линейка,Изделие,ПЗ,МПЗ,ДатаПостановки","Количество");
		ТаблицаИзделий.Сортировать("Линейка,Изделие,ПЗ,МПЗ");
		КонецЕсли;
	Для каждого ТЧ Из ТаблицаИзделий Цикл
	ТаблицаМПЗ.Очистить();
	СписокМестХранения = Новый СписокЗначений;
	СписокМПЗ = Новый СписокЗначений;

    СписокМестХранения.Добавить(ТЧ.Линейка.МестоХраненияКанбанов);
    СписокМестХранения.Добавить(ТЧ.Линейка.Подразделение.МестоХраненияПоУмолчанию);
	ОбщийМодульВызовСервера.ПолучитьТаблицуМПЗиАналогов(ТаблицаМПЗ,ТЧ.Изделие,ТЧ.МПЗ,ТЧ.Количество);
	ТаблицаМПЗ.Свернуть("МПЗ","Количество,КоличествоСклад");
		Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл		
		СписокМПЗ.Добавить(ТЧ_МПЗ.МПЗ); 
		КонецЦикла;
	ОблМПЗ.Параметры.Линейка = ТЧ.Линейка;
	ОблМПЗ.Параметры.Уровень = УровеньПробелы;
	ОблМПЗ.Параметры.НаименованиеМПЗ = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;
	ОблМПЗ.Параметры.Расшифровка = Новый Структура("МПЗ,МестоХранения",СписокМПЗ,СписокМестХранения);
		Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
		ОблМПЗ.Параметры.ВидКанбана = СокрЛП(ТЧ.МПЗ.Канбан.Наименование);
			Если ТаблицаМПЗ.Количество() > 0 Тогда
			ОбщийМодульВызовСервера.ПолучитьОстаткиСпискаМПЗПоМестамХранения(ТЧ.Линейка,ТаблицаМПЗ);
			ОблМПЗ.Параметры.Количество = ТаблицаМПЗ[0].Количество;
			ОблМПЗ.Параметры.КоличествоСклад = ТаблицаМПЗ[0].КоличествоСклад;
			ОблМПЗ.Параметры.ИЛО = "";
			Иначе
			ОблМПЗ.Параметры.Количество = 0;
			ОблМПЗ.Параметры.КоличествоСклад = 0;
			ОблМПЗ.Параметры.ИЛО = "";
			КонецЕсли; 
				Если Не СвернутьПоИзделиям Тогда
				ОблМПЗ.Параметры.ДатаПостановки = ТЧ.ДатаПостановки;
				ОблМПЗ.Параметры.НомерПЗ = ТЧ.ПЗ.Номер;
				ОблМПЗ.Параметры.ПЗ = ТЧ.ПЗ;
				КонецЕсли;
		ТабДок.Вывести(ОблМПЗ,Уровень+1,"Канбаны",Истина);
		ПроверитьПодчиненнуюЛО(ОблМПЗ,Уровень+1,ТЧ.МПЗ);	
		Иначе	
		ОблМПЗ.Параметры.ВидКанбана = "";
			Если ТаблицаМПЗ.Количество() > 0 Тогда
			ОбщийМодульВызовСервера.ПолучитьОстаткиСпискаМПЗПоМестамХранения(ТЧ.Линейка,ТаблицаМПЗ);
			ОблМПЗ.Параметры.Количество = ТаблицаМПЗ[0].Количество;
			ОблМПЗ.Параметры.КоличествоСклад = ТаблицаМПЗ[0].КоличествоСклад;
			флХватает = Ложь;
				Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл		
					Если ТЧ_МПЗ.Количество <= ТЧ_МПЗ.КоличествоСклад Тогда
					флХватает = Истина;
					Прервать;			
					КонецЕсли; 
				КонецЦикла; 
			ОблМПЗ.Параметры.ИЛО = ?(флХватает,"","+");
			Иначе
			ОблМПЗ.Параметры.Количество = 0;
			ОблМПЗ.Параметры.КоличествоСклад = 0;
			ОблМПЗ.Параметры.ИЛО = "";
			КонецЕсли; 
				Если Не СвернутьПоИзделиям Тогда
				ОблМПЗ.Параметры.ДатаПостановки = ТЧ.ДатаПостановки;
				ОблМПЗ.Параметры.НомерПЗ = ТЧ.ПЗ.Номер;
				ОблМПЗ.Параметры.ПЗ = ТЧ.ПЗ;
				КонецЕсли;
		ТабДок.Вывести(ОблМПЗ,Уровень+1,"Канбаны",Истина);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
   
&НаСервере           
Функция ПолучитьКоличествоНезапущенныхПЗВЛО(Изделие)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Изделие КАК Изделие,
	|	ПроизводственноеЗадание.Количество КАК Количество
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.Изделие = &Изделие
	|	И ПроизводственноеЗадание.ДатаЗапуска = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	Изделие";
Запрос.УстановитьПараметр("Изделие", Изделие);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаИзделий = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИзделий.Следующий() Цикл
	Возврат(ВыборкаИзделий.Количество);
	КонецЦикла; 
Возврат(0);
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

Запрос = Новый Запрос;
СписокМестХранения = Новый СписокЗначений;
ТаблицаИзделий = Новый ТаблицаЗначений;
ТаблицаМПЗ = Новый ТаблицаЗначений;

ТаблицаИзделий.Колонки.Добавить("Изделие");
ТаблицаИзделий.Колонки.Добавить("ПЗ");
ТаблицаИзделий.Колонки.Добавить("МПЗ");
ТаблицаИзделий.Колонки.Добавить("Количество");
ТаблицаИзделий.Колонки.Добавить("ДатаПостановки");

ТаблицаМПЗ.Колонки.Добавить("МПЗ");
ТаблицаМПЗ.Колонки.Добавить("Количество");
ТаблицаМПЗ.Колонки.Добавить("КоличествоСклад");

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблПодразделение = Макет.ПолучитьОбласть("Подразделение");
ОблЛинейка = Макет.ПолучитьОбласть("Линейка");
ОблИзделие = Макет.ПолучитьОбласть("Изделие");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);

ТабДок.НачатьАвтогруппировкуСтрок();

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛьготнаяОчередь.Период КАК Период,
	|	ЛьготнаяОчередь.ПЗ КАК ПЗ,
	|	ЛьготнаяОчередь.Линейка КАК Линейка,
	|	ЛьготнаяОчередь.Изделие КАК Изделие,
	|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ,
	|	ЛьготнаяОчередь.Линейка.Подразделение КАК Подразделение,
	|	ЛьготнаяОчередь.ПЗ.Количество КАК Количество
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
	|ГДЕ
	|	ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЛьготнаяОчередь.Линейка.Подразделение В ИЕРАРХИИ(&СписокПодразделений)";
	Если СписокЛинеек.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И ЛьготнаяОчередь.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
	Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
	КонецЕсли; 
		Если Не Изделие.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + " И ЛьготнаяОчередь.Изделие = &Изделие";
		Запрос.УстановитьПараметр("Изделие", Изделие);
		КонецЕсли;
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО
								|	ЛьготнаяОчередь.Линейка.Подразделение.Наименование,
								|	ЛьготнаяОчередь.Линейка.Наименование,
								|	ЛьготнаяОчередь.Изделие.Наименование,
								|	ЛьготнаяОчередь.НормаРасходов.Элемент.Наименование
								|ИТОГИ
								|	СУММА(Количество)
								|ПО
								|	Подразделение,
								|	Линейка,
								|	Изделие"; 
Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаПодразделения = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПодразделения.Следующий() Цикл
	ОблПодразделение.Параметры.Подразделение = ВыборкаПодразделения.Подразделение;
	ТабДок.Вывести(ОблПодразделение,1,"Подразделения",Истина);
	ВыборкаЛинейки = ВыборкаПодразделения.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаЛинейки.Следующий() Цикл
		ТаблицаИзделий.Очистить();
		СписокМестХранения.Очистить();
		СписокМестХранения.Добавить(ВыборкаЛинейки.Линейка.МестоХраненияКанбанов);
		СписокМестХранения.Добавить(ВыборкаЛинейки.Линейка.Подразделение.МестоХраненияПоУмолчанию);
		ОблЛинейка.Параметры.Линейка = ВыборкаЛинейки.Линейка;
		ТабДок.Вывести(ОблЛинейка,2,"Линейки",Истина);
		ВыборкаИзделия = ВыборкаЛинейки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаИзделия.Следующий() Цикл
			ВыборкаДетальныеЗаписи = ВыборкаИзделия.Выбрать();
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ТЧ = ТаблицаИзделий.Добавить();
				ТЧ.Изделие = ВыборкаИзделия.Изделие; 
					Если Не СвернутьПоИзделиям Тогда
					ТЧ.ПЗ = ВыборкаДетальныеЗаписи.ПЗ;	
					ТЧ.ДатаПостановки = НачалоДня(ВыборкаДетальныеЗаписи.Период);
					КонецЕсли;
				ТЧ.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
				ТЧ.Количество = ВыборкаДетальныеЗаписи.ПЗ.Количество;
				КонецЦикла;
			КонецЦикла;
				Если СвернутьПоИзделиям Тогда
				ТаблицаИзделий.Свернуть("Изделие,МПЗ","Количество");
				ТаблицаИзделий.Сортировать("Изделие,МПЗ");
				Иначе
				ТаблицаИзделий.Свернуть("Изделие,ПЗ,МПЗ,ДатаПостановки","Количество");
				ТаблицаИзделий.Сортировать("Изделие,ПЗ,МПЗ");
				КонецЕсли;
		ТекИзделие = Неопределено;
			Для каждого ТЧ Из ТаблицаИзделий Цикл
				Если ТекИзделие <> ТЧ.Изделие Тогда
				флПоказать = Истина;
				ОблИзделие.Параметры.НаименованиеИзделия = СокрЛП(ТЧ.Изделие.Наименование);
				ОблИзделие.Параметры.Изделие = ТЧ.Изделие;
				ОблИзделие.Параметры.Количество = ПолучитьКоличествоНезапущенныхПЗВЛО(ТЧ.Изделие);
					Если Не СвернутьПоИзделиям Тогда
					//ОблИзделие.Параметры.НомерПЗ = ТЧ.ПЗ.Номер;
					//ОблИзделие.Параметры.ПЗ = ТЧ.ПЗ;
					ОблИзделие.Параметры.ИЛО = ?(ОбщийМодульВызовСервера.ИстиннаяЛьготнаяОчередь(ТЧ.ПЗ),"+","");
						Если ТолькоИЛО Тогда
							Если ОблИзделие.Параметры.ИЛО = "" Тогда
							флПоказать = Ложь;
							Иначе
							ТабДок.Вывести(ОблИзделие,3,"Изделия",Истина);
							КонецЕсли;
						Иначе
						ТабДок.Вывести(ОблИзделие,3,"Изделия",Истина);
						КонецЕсли; 
					Иначе
					ОблИзделие.Параметры.ИЛО = "?";				
					ТабДок.Вывести(ОблИзделие,3,"Изделия",Истина);
					КонецЕсли;
				ТекИзделие = ТЧ.Изделие;
				КонецЕсли;
					Если Не флПоказать Тогда
					Продолжить;			
					КонецЕсли;
			ТаблицаМПЗ.Очистить();
			СписокМПЗ = Новый СписокЗначений;
                                                     
			ОбщийМодульВызовСервера.ПолучитьТаблицуМПЗиАналогов(ТаблицаМПЗ,ТЧ.Изделие,ТЧ.МПЗ,?(СвернутьПоИзделиям = Истина,ОблИзделие.Параметры.Количество,ТЧ.ПЗ.Количество));
			ТаблицаМПЗ.Свернуть("МПЗ","Количество,КоличествоСклад");
				Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл		
				СписокМПЗ.Добавить(ТЧ_МПЗ.МПЗ); 
				КонецЦикла;
			ОблМПЗ.Параметры.Уровень = Символы.Таб;
			ОблМПЗ.Параметры.Линейка = ВыборкаЛинейки.Линейка;
			ОблМПЗ.Параметры.НаименованиеМПЗ = СокрЛП(ТЧ.МПЗ);
			ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;
			ОблМПЗ.Параметры.Расшифровка = Новый Структура("МПЗ,МестоХранения",СписокМПЗ,СписокМестХранения);
				Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
				ОблМПЗ.Параметры.ВидКанбана = СокрЛП(ТЧ.МПЗ.Канбан.Наименование);
					Если ТаблицаМПЗ.Количество() > 0 Тогда
					ОбщийМодульВызовСервера.ПолучитьОстаткиСпискаМПЗПоМестамХранения(ВыборкаЛинейки.Линейка,ТаблицаМПЗ);
					ОблМПЗ.Параметры.Количество = ТаблицаМПЗ[0].Количество;
					ОблМПЗ.Параметры.КоличествоСклад = ТаблицаМПЗ[0].КоличествоСклад;
					ОблМПЗ.Параметры.ИЛО = "";
					Иначе
					ОблМПЗ.Параметры.Количество = 0;
					ОблМПЗ.Параметры.КоличествоСклад = 0;
					ОблМПЗ.Параметры.ИЛО = "";
					КонецЕсли;
						Если Не СвернутьПоИзделиям Тогда
						ОблМПЗ.Параметры.ДатаПостановки = ТЧ.ДатаПостановки;
						ОблМПЗ.Параметры.НомерПЗ = ТЧ.ПЗ.Номер;
						ОблМПЗ.Параметры.ПЗ = ТЧ.ПЗ;
						КонецЕсли; 
				ТабДок.Вывести(ОблМПЗ,4,"МПЗ",Истина);
				ПроверитьПодчиненнуюЛО(ОблМПЗ,4,ТЧ.МПЗ);	
				Иначе	
				ОблМПЗ.Параметры.ВидКанбана = "";
					Если ТаблицаМПЗ.Количество() > 0 Тогда
					ОбщийМодульВызовСервера.ПолучитьОстаткиСпискаМПЗПоМестамХранения(ВыборкаЛинейки.Линейка,ТаблицаМПЗ);
					ОблМПЗ.Параметры.Количество = ТаблицаМПЗ[0].Количество;
					ОблМПЗ.Параметры.КоличествоСклад = ТаблицаМПЗ[0].КоличествоСклад;
					флХватает = Ложь;
						Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл		
							Если ТЧ_МПЗ.Количество <= ТЧ_МПЗ.КоличествоСклад Тогда
							флХватает = Истина;
							Прервать;			
							КонецЕсли; 
						КонецЦикла; 
					ОблМПЗ.Параметры.ИЛО = ?(флХватает,"","+");
					Иначе
					ОблМПЗ.Параметры.Количество = 0;
					ОблМПЗ.Параметры.КоличествоСклад = 0;
					ОблМПЗ.Параметры.ИЛО = "";
					КонецЕсли; 
						Если Не СвернутьПоИзделиям Тогда
						ОблМПЗ.Параметры.ДатаПостановки = ТЧ.ДатаПостановки;
						ОблМПЗ.Параметры.НомерПЗ = ТЧ.ПЗ.Номер;
						ОблМПЗ.Параметры.ПЗ = ТЧ.ПЗ;
						КонецЕсли; 
				ТабДок.Вывести(ОблМПЗ,4,"МПЗ",Истина);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
ТабДок.ЗакончитьАвтогруппировкуСтрок();
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Формирование таблицы отчёта...");
	СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
ИмяКолонки = СокрЛП(Сред(Элемент.ТекущаяОбласть.Имя,Найти(Элемент.ТекущаяОбласть.Имя,"C")));
НомерКолонки = Число(Сред(ИмяКолонки,2));
	Если (НомерКолонки = 7)или(НомерКолонки = 8) Тогда
	СтандартнаяОбработка = Ложь;
	ИмяОтчета = "ОтчётПоРегиструМестаХранения";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Расшифровка,"ОстаткиПоСкладам"));
	ПараметрыФормы.Вставить("КлючВарианта","ОстаткиПоСкладам"); 
	ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры
