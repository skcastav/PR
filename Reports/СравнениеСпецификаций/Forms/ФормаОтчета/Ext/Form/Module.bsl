﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.НаДату = ТекущаяДата();
ВидСпецификации1 = 1;
ВидСпецификации2 = 1;
	Если ЭтаФорма.Параметры.Свойство("Спецификация1") Тогда
		Если Не ЭтаФорма.Параметры.Спецификация1.ЭтоГруппа Тогда
		Отчет.Спецификация1 = ЭтаФорма.Параметры.Спецификация1;
		РаскрытьНаМПЗ(Отчет.Спецификация1,1);
		КонецЕсли;	
	КонецЕсли;
		Если ЭтаФорма.Параметры.Свойство("Спецификация2") Тогда
			Если Не ЭтаФорма.Параметры.Спецификация2.ЭтоГруппа Тогда
			Отчет.Спецификация2 = ЭтаФорма.Параметры.Спецификация2;
			РаскрытьНаМПЗ(Отчет.Спецификация2,2);
			КонецЕсли;	
		КонецЕсли;		 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ВидСпецификации1ПриИзменении(Неопределено);
ВидСпецификации2ПриИзменении(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаСервере(НомерТаблицы,TYPE,NAME,NUM,POSITION,DEFIN,ETAP)
	Если НомерТаблицы = 1 Тогда
	ТЧ = ТаблицаМПЗ1.Добавить();
	Иначе	
	ТЧ = ТаблицаМПЗ2.Добавить();
	КонецЕсли;
ТЧ.Количество = NUM;
ТЧ.Позиция = POSITION;
	Если TYPE = "Материал" Тогда
	Выбор = Справочники.Материалы.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли; 
	ИначеЕсли TYPE = "Деталь" Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	ИначеЕсли TYPE = "Узел" Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	ИначеЕсли TYPE = "Набор" Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	ИначеЕсли TYPE = "Основа" Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	ИначеЕсли TYPE = "ТехОснастка" Тогда
	Выбор = Справочники.ТехОснастка.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	ИначеЕсли TYPE = "Документ" Тогда
	Выбор = Справочники.Документация.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	ИначеЕсли TYPE = "Программа" Тогда		
	Выбор = Справочники.Документация.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.МПЗ = NAME;
		Иначе
        ТЧ.МПЗ = Выбор;
		КонецЕсли;
	КонецЕсли;
ВыборЭтапа = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(ETAP),Истина);
	Если Не ВыборЭтапа.Пустая() Тогда
    ТЧ.ЭтапПроизводства = ВыборЭтапа;
	КонецЕсли; 
КонецПроцедуры 

&НаСервере
Процедура РаскрытьНаМПЗ(ЭтапСпецификации,НомерТаблицы)
НормРасх = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Все(ЭтапСпецификации,Отчет.НаДату);
	Пока НормРасх.Следующий() Цикл
		Если ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
			Если НомерТаблицы = 1 Тогда
			ТЧ = ТаблицаМПЗ1.Добавить();
			Иначе	
			ТЧ = ТаблицаМПЗ2.Добавить();
			КонецЕсли;
		ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
		ТЧ.МПЗ = НормРасх.Элемент;
		ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
		ТЧ.Количество = НормРасх.Норма;
		ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);				 
		ИначеЕсли ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если НормРасх.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
				//Если СравнитьВсюСпецификацию Тогда
				РаскрытьНаМПЗ(НормРасх.Элемент,НомерТаблицы);
				//КонецЕсли;
			ИначеЕсли НормРасх.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
			ТЧ.МПЗ = НормРасх.Элемент;
			ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
			ТЧ.Количество = НормРасх.Норма;
			ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
			Иначе
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
			ТЧ.МПЗ = НормРасх.Элемент;
			ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
			ТЧ.Количество = НормРасх.Норма;
			ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);	
	        КонецЕсли;
		ИначеЕсли ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.Документация") Тогда
			Если НормРасх.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Документ Тогда
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
			ТЧ.МПЗ = НормРасх.Элемент;
			ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
			ТЧ.Количество = НормРасх.Норма;
			ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
			ИначеЕсли НормРасх.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Программа Тогда
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
			ТЧ.МПЗ = НормРасх.Элемент;
			ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
			ТЧ.Количество = НормРасх.Норма;
			ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);		
	        КонецЕсли;
		ИначеЕсли ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.ТехОснастка") Тогда
			Если НомерТаблицы = 1 Тогда
			ТЧ = ТаблицаМПЗ1.Добавить();
			Иначе	
			ТЧ = ТаблицаМПЗ2.Добавить();
			КонецЕсли;
		ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
		ТЧ.МПЗ = НормРасх.Элемент;
		ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
		ТЧ.Количество = НормРасх.Норма;
		ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
		ИначеЕсли ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.ТехОперации") Тогда
			Если НомерТаблицы = 1 Тогда
			ТЧ = ТаблицаМПЗ1.Добавить();
			Иначе	
			ТЧ = ТаблицаМПЗ2.Добавить();
			КонецЕсли;
		ТЧ.ВидМПЗ = НормРасх.ВидЭлемента;
		ТЧ.МПЗ = НормРасх.Элемент;
		ТЧ.Позиция = СокрЛП(НормРасх.Позиция);
		ТЧ.Количество = НормРасх.Норма;
		ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
		КонецЕсли;  
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьЭлементНашейБазы(Наименование,НаименованиеСправочника)
Элемент = Справочники[НаименованиеСправочника].НайтиПоНаименованию(СокрЛП(Наименование),Истина);
	Если Элемент.Пустая() Тогда
	Возврат(Наименование);
	Иначе	
	Возврат(Элемент);
	КонецЕсли; 
КонецФункции 

&НаСервере
Процедура РаскрытьНаМПЗ_ДругаяБД(БД,ЭтапСпецификации,НомерТаблицы)
НормРасх = БД.Справочники.НормыРасходов.Выбрать(,ЭтапСпецификации);
	Пока НормРасх.Следующий() Цикл
		Если НормРасх.ПометкаУдаления Тогда
		Продолжить;	
		КонецЕсли;
	Парам = БД.NewObject("Структура");
	Парам.Вставить("НормаРасходов",НормРасх.Ссылка);
	Нормы = БД.РегистрыСведений.НормыРасходов.ПолучитьПоследнее(Отчет.НаДату,Парам);
		Если Нормы.Норма = 0 Тогда
		Продолжить;	
		КонецЕсли;
			Если СокрЛП(НормРасх.Элемент.Метаданные().Имя) = "Материалы" Тогда
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
			ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"Материалы");
			ТЧ.Позиция = НормРасх.Позиция;
			ТЧ.Количество = Нормы.Норма;
			//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);				 
			ИначеЕсли СокрЛП(НормРасх.Элемент.Метаданные().Имя) = "Номенклатура" Тогда
				Если БД.XMLString(НормРасх.ВидЭлемента) = "Основа" Тогда
				РаскрытьНаМПЗ_ДругаяБД(БД,НормРасх.Элемент,НомерТаблицы);
				ИначеЕсли БД.XMLString(НормРасх.ВидЭлемента) = "Набор" Тогда
					Если НомерТаблицы = 1 Тогда
					ТЧ = ТаблицаМПЗ1.Добавить();
					Иначе	
					ТЧ = ТаблицаМПЗ2.Добавить();
					КонецЕсли;
				ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
				ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"Номенклатура");
				ТЧ.Позиция = НормРасх.Позиция;
				ТЧ.Количество = Нормы.Норма;
				//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
				Иначе
					Если НомерТаблицы = 1 Тогда
					ТЧ = ТаблицаМПЗ1.Добавить();
					Иначе	
					ТЧ = ТаблицаМПЗ2.Добавить();
					КонецЕсли;
				ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
				ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"Номенклатура");
				ТЧ.Позиция = НормРасх.Позиция;
				ТЧ.Количество = Нормы.Норма;
				//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);	
		        КонецЕсли;
			ИначеЕсли СокрЛП(НормРасх.Элемент.Метаданные().Имя) = "Документация" Тогда
				Если БД.XMLString(НормРасх.ВидЭлемента) = "Документ" Тогда
					Если НомерТаблицы = 1 Тогда
					ТЧ = ТаблицаМПЗ1.Добавить();
					Иначе	
					ТЧ = ТаблицаМПЗ2.Добавить();
					КонецЕсли;
				ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
				ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"Документация");
				ТЧ.Позиция = НормРасх.Позиция;
				ТЧ.Количество = Нормы.Норма;
				//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
				ИначеЕсли БД.XMLString(НормРасх.ВидЭлемента) = "Программа" Тогда
					Если НомерТаблицы = 1 Тогда
					ТЧ = ТаблицаМПЗ1.Добавить();
					Иначе	
					ТЧ = ТаблицаМПЗ2.Добавить();
					КонецЕсли;
				ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
				ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"Документация");
				ТЧ.Позиция = НормРасх.Позиция;
				ТЧ.Количество = Нормы.Норма;
				//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);		
		        КонецЕсли;
			ИначеЕсли СокрЛП(НормРасх.Элемент.Метаданные().Имя) = "ТехОснастка" Тогда
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
			ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"ТехОснастка");
			ТЧ.Позиция = НормРасх.Позиция;
			ТЧ.Количество = Нормы.Норма;
			//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
			ИначеЕсли СокрЛП(НормРасх.Элемент.Метаданные().Имя) = "ТехОперации" Тогда
				Если НомерТаблицы = 1 Тогда
				ТЧ = ТаблицаМПЗ1.Добавить();
				Иначе	
				ТЧ = ТаблицаМПЗ2.Добавить();
				КонецЕсли;
			ТЧ.ВидМПЗ = Перечисления.ВидыЭлементовНормРасходов.Получить(БД.Перечисления.ВидыЭлементовНормРасходов.Индекс(НормРасх.ВидЭлемента));
			ТЧ.МПЗ = ПолучитьЭлементНашейБазы(НормРасх.Элемент.Наименование,"ТехОперации");
			ТЧ.Позиция = НормРасх.Позиция;
			ТЧ.Количество = Нормы.Норма;
			//ТЧ.ЭтапПроизводства = ПолучитьГруппуЭтапаПроизводства(ЭтапСпецификации.Родитель);
			КонецЕсли;  
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция РаскрытьСпецификациюДругойБД(Наименование,НомерТаблицы)
БД = ОбщийМодульСинхронизации.УстановитьCOMСоединение(БазаДанных);
	Если БД = Неопределено Тогда
	Сообщить("Не открыто соединение с выбранной базой данных!");
	Возврат(Ложь);
	КонецЕсли;
Спецификация = БД.Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(Наименование),Истина);
	Если Не Спецификация.Пустая() Тогда
	РаскрытьНаМПЗ_ДругаяБД(БД,Спецификация,НомерТаблицы);
	Возврат(Истина);
	Иначе	
	Сообщить("Спецификация не найдена в выбранной базе данных!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции 

&НаСервере
Процедура СравнитьНаСервере()
ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.Элемент1 = Отчет.Спецификация1;
ОблШапка.Параметры.Элемент2 = Отчет.Спецификация2;
ТабДок.Вывести(ОблШапка);

ТаблицаМПЗ1.Сортировать("Позиция,МПЗ");
ТаблицаМПЗ2.Сортировать("Позиция,МПЗ"); 
	Для каждого ТЧ Из ТаблицаМПЗ1 Цикл
	флНесоответствие = Ложь;
	НесоответствуетНаименование = "";
	НесоответствуетКоличество = "";
	НесоответствуетЭтап = "";
		Если СписокВидовМПЗ.Количество() > 0 Тогда
			Если СписокВидовМПЗ.НайтиПоЗначению(ТЧ.ВидМПЗ) = Неопределено Тогда
			Продолжить;		
			КонецЕсли;		
		КонецЕсли;
	Наим1 = ?(ТипЗнч(ТЧ.МПЗ) <> Тип("Строка"),СокрЛП(ТЧ.МПЗ.Наименование),СокрЛП(ТЧ.МПЗ));
	Количество1 = ТЧ.Количество;
	Этап1 = СокрЛП(ТЧ.ЭтапПроизводства.Наименование);
	Наим2 = "";
	Количество2 = "";
	Этап2 = "";
			Если ЗначениеЗаполнено(ТЧ.Позиция) Тогда	
			Выборка = ТаблицаМПЗ2.НайтиСтроки(Новый Структура("Позиция",ТЧ.Позиция));
				Если Выборка.Количество() > 0 Тогда
				Наим2 = ?(ТипЗнч(Выборка[0].МПЗ) <> Тип("Строка"),СокрЛП(Выборка[0].МПЗ.Наименование),СокрЛП(Выборка[0].МПЗ));
				Количество2 = Выборка[0].Количество;
				Этап2 = СокрЛП(Выборка[0].ЭтапПроизводства);
					Если ТЧ.МПЗ <> Выборка[0].МПЗ Тогда
					флНесоответствие = Истина;
					НесоответствуетНаименование = "*";
					КонецЕсли; 
						Если ТЧ.Количество <> Выборка[0].Количество Тогда
						флНесоответствие = Истина;
						НесоответствуетКоличество = "*";
						КонецЕсли;
							Если СравнитьЭтапыПроизводства Тогда
								Если ТЧ.ЭтапПроизводства <> Выборка[0].ЭтапПроизводства Тогда
								флНесоответствие = Истина;
								НесоответствуетЭтап = "*";
								КонецЕсли;						
							КонецЕсли; 
				Иначе
				флНесоответствие = Истина;
				НесоответствуетНаименование = "*";
				КонецЕсли;
			Иначе
			Выборка = ТаблицаМПЗ2.НайтиСтроки(Новый Структура("Позиция,МПЗ",ТЧ.Позиция,ТЧ.МПЗ));
				Если Выборка.Количество() > 0 Тогда
					Если ТЧ.Количество <> Выборка[0].Количество Тогда
					флНесоответствие = Истина;
					Наим2 = ?(ТипЗнч(Выборка[0].МПЗ) <> Тип("Строка"),СокрЛП(Выборка[0].МПЗ.Наименование),СокрЛП(Выборка[0].МПЗ));
					НесоответствуетКоличество = "*";
					КонецЕсли; 
				Иначе
				флНесоответствие = Истина;	
				НесоответствуетНаименование = "*";
				КонецЕсли;		
			КонецЕсли; 
				Если флНесоответствие Тогда
				ОблСтрока.Параметры.ПозОбозн = СокрЛП(ТЧ.Позиция);
				ОблСтрока.Параметры.Наим1 = Наим1;
				ОблСтрока.Параметры.Количество1 = Количество1;
				ОблСтрока.Параметры.Этап1 = Этап1;
				ОблСтрока.Параметры.Наим2 = Наим2;
				ОблСтрока.Параметры.Количество2 = Количество2;
				ОблСтрока.Параметры.Этап2 = Этап2;
				ОблСтрока.Параметры.НесоответствуетНаименование = НесоответствуетНаименование;
				ОблСтрока.Параметры.НесоответствуетКоличество = НесоответствуетКоличество;
				ОблСтрока.Параметры.НесоответствуетЭтап = НесоответствуетЭтап;
				ТабДок.Вывести(ОблСтрока);
				КонецЕсли; 
			//Если ЗначениеЗаполнено(ТЧ.Позиция) Тогда	
			//Выборка = ТаблицаМПЗ2.НайтиСтроки(Новый Структура("Позиция",ТЧ.Позиция));
			//	Если Выборка.Количество() > 0 Тогда
			//		Если ТЧ.МПЗ <> Выборка[0].МПЗ Тогда
			//		ОблНаименование.Параметры.ПозОбозн = ТЧ.Позиция;
			//		ОблНаименование.Параметры.Наим1 = СокрЛП(ТЧ.МПЗ.Наименование);
			//		ОблНаименование.Параметры.Наим2 = СокрЛП(Выборка[0].МПЗ.Наименование);
			//		ТабДок.Вывести(ОблНаименование);
			//		КонецЕсли; 
			//			Если ТЧ.Количество <> Выборка[0].Количество Тогда
			//			ОблКоличество.Параметры.ПозОбозн = ТЧ.Позиция;
			//			ОблКоличество.Параметры.Наим1 = СокрЛП(ТЧ.МПЗ.Наименование);
			//			ОблКоличество.Параметры.Наим2 = СокрЛП(Выборка[0].МПЗ.Наименование);
			//			ОблКоличество.Параметры.Кол1 = ТЧ.Количество;
			//			ОблКоличество.Параметры.Кол2 = Выборка[0].Количество;
			//			ТабДок.Вывести(ОблКоличество);
			//			КонецЕсли; 
			//	Иначе	
			//	ОблОтсутствует.Параметры.ПозОбозн = ТЧ.Позиция;
			//	ОблОтсутствует.Параметры.Наим1 = СокрЛП(ТЧ.МПЗ.Наименование);
			//	ОблОтсутствует.Параметры.Наим2 = "";
			//	ТабДок.Вывести(ОблОтсутствует);
			//	КонецЕсли;
			//Иначе
			//Выборка = ТаблицаМПЗ2.НайтиСтроки(Новый Структура("Позиция,МПЗ",ТЧ.Позиция,ТЧ.МПЗ));
			//	Если Выборка.Количество() > 0 Тогда
			//		Если ТЧ.Количество <> Выборка[0].Количество Тогда
			//		ОблКоличество.Параметры.ПозОбозн = ТЧ.Позиция;
			//		ОблКоличество.Параметры.Наим1 = СокрЛП(ТЧ.МПЗ.Наименование);
			//		ОблКоличество.Параметры.Наим2 = СокрЛП(Выборка[0].МПЗ.Наименование);
			//		ОблКоличество.Параметры.Кол1 = ТЧ.Количество;
			//		ОблКоличество.Параметры.Кол2 = Выборка[0].Количество;
			//		ТабДок.Вывести(ОблКоличество);
			//		КонецЕсли; 
			//	Иначе	
			//	ОблОтсутствует.Параметры.ПозОбозн = ТЧ.Позиция;
			//	ОблОтсутствует.Параметры.Наим1 = СокрЛП(ТЧ.МПЗ.Наименование);
			//	ОблОтсутствует.Параметры.Наим2 = "";
			//	ТабДок.Вывести(ОблОтсутствует);
			//	КонецЕсли;		
			//КонецЕсли; 	
	КонецЦикла; 

	Для каждого ТЧ Из ТаблицаМПЗ2 Цикл
	НесоответствуетНаименование = "";
	НесоответствуетКоличество = "";
	НесоответствуетЭтап = "";
		Если СписокВидовМПЗ.Количество() > 0 Тогда
			Если СписокВидовМПЗ.НайтиПоЗначению(ТЧ.ВидМПЗ) = Неопределено Тогда
			Продолжить;		
			КонецЕсли;		
		КонецЕсли;
	Наим2 = ?(ТипЗнч(ТЧ.МПЗ) <> Тип("Строка"),СокрЛП(ТЧ.МПЗ.Наименование),СокрЛП(ТЧ.МПЗ));
	Количество2 = ТЧ.Количество;
	Этап2 = СокрЛП(ТЧ.ЭтапПроизводства);
			Если ЗначениеЗаполнено(ТЧ.Позиция) Тогда	
			Выборка = ТаблицаМПЗ1.НайтиСтроки(Новый Структура("Позиция",ТЧ.Позиция));
				Если Выборка.Количество() = 0 Тогда
				НесоответствуетНаименование = "*";	
				ОблСтрока.Параметры.ПозОбозн = СокрЛП(ТЧ.Позиция);
				ОблСтрока.Параметры.Наим1 = "";
				ОблСтрока.Параметры.Количество1 = "";
				ОблСтрока.Параметры.Этап1 = "";
				ОблСтрока.Параметры.Наим2 = Наим2;
				ОблСтрока.Параметры.Количество2 = Количество2;
				ОблСтрока.Параметры.Этап2 = Этап2;
				ОблСтрока.Параметры.НесоответствуетНаименование = НесоответствуетНаименование;
				ОблСтрока.Параметры.НесоответствуетКоличество = НесоответствуетКоличество;
				ОблСтрока.Параметры.НесоответствуетЭтап = НесоответствуетЭтап;
				ТабДок.Вывести(ОблСтрока);
				КонецЕсли;
			Иначе
			Выборка = ТаблицаМПЗ1.НайтиСтроки(Новый Структура("Позиция,МПЗ",ТЧ.Позиция,ТЧ.МПЗ));
				Если Выборка.Количество() = 0 Тогда
				НесоответствуетНаименование = "*"; 	
				ОблСтрока.Параметры.ПозОбозн = СокрЛП(ТЧ.Позиция);
				ОблСтрока.Параметры.Наим1 = "";
				ОблСтрока.Параметры.Количество1 = "";
				ОблСтрока.Параметры.Этап1 = "";
				ОблСтрока.Параметры.Наим2 = Наим2;
				ОблСтрока.Параметры.Количество2 = Количество2;
				ОблСтрока.Параметры.Этап2 = Этап2;
				ОблСтрока.Параметры.НесоответствуетНаименование = НесоответствуетНаименование;
				ОблСтрока.Параметры.НесоответствуетКоличество = НесоответствуетКоличество;
				ОблСтрока.Параметры.НесоответствуетЭтап = НесоответствуетЭтап;
				ТабДок.Вывести(ОблСтрока);
				КонецЕсли;		
			КонецЕсли;

			//Если ЗначениеЗаполнено(ТЧ.Позиция) Тогда	
			//Выборка = ТаблицаМПЗ1.НайтиСтроки(Новый Структура("Позиция",ТЧ.Позиция));
			//	Если Выборка.Количество() = 0 Тогда	
			//	ОблОтсутствует.Параметры.ПозОбозн = ТЧ.Позиция;
			//	ОблОтсутствует.Параметры.Наим1 = "";
			//	ОблОтсутствует.Параметры.Наим2 = СокрЛП(ТЧ.МПЗ.Наименование);
			//	ТабДок.Вывести(ОблОтсутствует);
			//	КонецЕсли;
			//Иначе
			//Выборка = ТаблицаМПЗ1.НайтиСтроки(Новый Структура("Позиция,МПЗ",ТЧ.Позиция,ТЧ.МПЗ));
			//	Если Выборка.Количество() = 0 Тогда 	
			//	ОблОтсутствует.Параметры.ПозОбозн = ТЧ.Позиция;
			//	ОблОтсутствует.Параметры.Наим1 = "";
			//	ОблОтсутствует.Параметры.Наим2 = СокрЛП(ТЧ.МПЗ.Наименование);
			//	ТабДок.Вывести(ОблОтсутствует);
			//	КонецЕсли;		
			//КонецЕсли; 	
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 3;
КонецПроцедуры

&НаКлиенте
Процедура Сравнить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
		Если ВидСпецификации1 = 1 Тогда
		Состояние("Обработка...",,"Раскрытие спецификации...");
		ТаблицаМПЗ1.Очистить();
		РаскрытьНаМПЗ(Отчет.Спецификация1,1);
		ИначеЕсли ВидСпецификации1 = 3 Тогда	
		Состояние("Обработка...",,"Раскрытие спецификации из другой базы...");
		ТаблицаМПЗ1.Очистить();
			Если Не РаскрытьСпецификациюДругойБД(Отчет.Спецификация1,1) Тогда
			Возврат;
			КонецЕсли;
		КонецЕсли; 
			Если ВидСпецификации2 = 1 Тогда
			Состояние("Обработка...",,"Раскрытие спецификации...");
			ТаблицаМПЗ2.Очистить();
			РаскрытьНаМПЗ(Отчет.Спецификация2,2);
			ИначеЕсли ВидСпецификации2 = 3 Тогда	
			Состояние("Обработка...",,"Раскрытие спецификации из другой базы...");
			ТаблицаМПЗ2.Очистить();
				Если Не РаскрытьСпецификациюДругойБД(Отчет.Спецификация2,2) Тогда
				Возврат;
				КонецЕсли;
			КонецЕсли;
	Состояние("Обработка...",,"Сравнение спецификаций...");
	СравнитьНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВидСпецификации1ПриИзменении(Элемент)
	Если ВидСпецификации1 = 1 Тогда
	Элементы.Спецификация1.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ИначеЕсли ВидСпецификации1 = 2 Тогда
	Элементы.Спецификация1.ОграничениеТипа = Новый ОписаниеТипов("Строка");
	Элементы.Спецификация1.КнопкаВыбора = Истина;
	Иначе
	Элементы.Спецификация1.ОграничениеТипа = Новый ОписаниеТипов("Строка");
	Элементы.Спецификация1.КнопкаВыбора = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидСпецификации2ПриИзменении(Элемент)
	Если ВидСпецификации2 = 1 Тогда
	Элементы.Спецификация2.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ИначеЕсли ВидСпецификации2 = 2 Тогда
	Элементы.Спецификация2.ОграничениеТипа = Новый ОписаниеТипов("Строка");	
	Элементы.Спецификация2.КнопкаВыбора = Истина;
	Иначе
	Элементы.Спецификация2.ОграничениеТипа = Новый ОписаниеТипов("Строка");	
	Элементы.Спецификация2.КнопкаВыбора = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Спецификация1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ВидСпецификации1 = 2 Тогда
	СтандартнаяОбработка = Ложь;
	Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл с эскизом спецификации");
		Если Результат <> Неопределено Тогда
		Отчет.Спецификация1 = Результат.ПолноеИмяФайла;
		ExcelЛист = Результат.ExcelЛист;
		КолСтрок = Результат.КоличествоСтрок;
		    Для к = 2 по КолСтрок Цикл
			Состояние("Обработка...",к*100/КолСтрок,"Загрузка эскиза спецификации из файла..."); 
			ДобавитьНаСервере(1,ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value,ExcelЛист.Cells(к,1).Value,ExcelЛист.Cells(к,6).Value,ExcelЛист.Cells(к,5).Value);
		    КонецЦикла;
		Результат.Excel.Quit();
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Спецификация2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ВидСпецификации2 = 2 Тогда
	СтандартнаяОбработка = Ложь;
	Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл с эскизом спецификации");
		Если Результат <> Неопределено Тогда
		Отчет.Спецификация2 = Результат.ПолноеИмяФайла;
		ExcelЛист = Результат.ExcelЛист;
		КолСтрок = Результат.КоличествоСтрок;
		    Для к = 2 по КолСтрок Цикл
			Состояние("Обработка...",к*100/КолСтрок,"Загрузка эскиза спецификации из файла..."); 
			ДобавитьНаСервере(2,ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value,ExcelЛист.Cells(к,1).Value,ExcelЛист.Cells(к,6).Value,ExcelЛист.Cells(к,5).Value);
		    КонецЦикла;
		Результат.Excel.Quit();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
