﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОбновитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
ТаблицаЗаданий.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостояниеРегламентныхЗаданий.Ссылка КАК Ссылка,
	|	СостояниеРегламентныхЗаданий.ДатаВыполнения КАК ДатаВыполнения,
	|	СостояниеРегламентныхЗаданий.Комментарий КАК Комментарий,
	|	СостояниеРегламентныхЗаданий.Наименование КАК Наименование
	|ИЗ
	|	Справочник.СостояниеРегламентныхЗаданий КАК СостояниеРегламентныхЗаданий";	
РезультатЗапроса = Запрос.Выполнить();	
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаЗаданий.Добавить();
	ТЧ.Наименование = ВыборкаДетальныеЗаписи.Наименование;
	ТЧ.ДатаВыполнения = ВыборкаДетальныеЗаписи.ДатаВыполнения;
	ТЧ.Комментарий = ВыборкаДетальныеЗаписи.Комментарий;
	КонецЦикла;
Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Неопределено);
	Для Каждого Регламентное из Регламентные Цикл
	Выборка = ТаблицаЗаданий.НайтиСтроки(Новый Структура("Наименование",СокрЛП(Регламентное.Наименование)));
		Если Выборка.Количество() > 0 Тогда
		Выборка[0].Расписание = Регламентное.Расписание;		
			Попытка
			ПоследнееЗадание = Регламентное.ПоследнееЗадание;
			Исключение
			ПоследнееЗадание = Неопределено;
			КонецПопытки;
				Если ПоследнееЗадание <> Неопределено Тогда
				Выборка[0].Выполнялось = ПоследнееЗадание.Начало;
				Выборка[0].Состояние = ПоследнееЗадание.Состояние;
					Если ЗначениеЗаполнено(Выборка[0].ДатаВыполнения) Тогда
						Если Выборка[0].ДатаВыполнения >= ПоследнееЗадание.Начало Тогда
						Выборка[0].ВремяВыполнения = (Выборка[0].ДатаВыполнения-ПоследнееЗадание.Начало)/60;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
		КонецЕсли;
	КонецЦикла;   
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
ОбновитьНаСервере();
КонецПроцедуры
