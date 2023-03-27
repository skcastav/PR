﻿#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция возвращает список подключенного в справочнике ПО
//
Функция ПолучитьСписокОборудования(ТипыПО = Неопределено, Идентификатор = Неопределено, РабочееМесто = Неопределено) Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
	|	ПодключаемоеОборудование.ИдентификаторУстройства КАК ИдентификаторУстройства,
	|	ПодключаемоеОборудование.Наименование КАК Наименование,
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования,
	|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования,      
	|	ПодключаемоеОборудование.ВерсияФорматаОбмена КАК ВерсияФорматаОбмена,
	|	ПодключаемоеОборудование.РабочееМесто КАК РабочееМесто,
	|	ПодключаемоеОборудование.Параметры КАК Параметры,
	|	РабочиеМеста.ИмяКомпьютера КАК ИмяКомпьютера
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РабочиеМеста КАК РабочиеМеста
	|		ПО (РабочиеМеста.Ссылка = ПодключаемоеОборудование.РабочееМесто)
	|ГДЕ
	|	(ПодключаемоеОборудование.УстройствоИспользуется)" +
		// Добавим в текст запроса условия-фильтры переданные в параметрах вызова.
		?(Идентификатор = Неопределено,
			// Добавим в текст запроса фильтр по типам оборудования (если задан).
		?(ТипыПО <> Неопределено,
		    "
		    |	И (ПодключаемоеОборудование.РабочееМесто <> ЗНАЧЕНИЕ(Справочник.РабочиеМеста.ПустаяСсылка))
		    |	И (ПодключаемоеОборудование.ТипОборудования В (&ТипОборудования))
		    |	И (РабочиеМеста.Ссылка = &РабочееМесто)",
		    "
		    |	И РабочиеМеста.Ссылка = &РабочееМесто"),
			// Добавим в текст запроса фильтр по конкретному устройству (имеет приоритет над другими фильтрами).
		  "
		  |	И (ПодключаемоеОборудование.РабочееМесто <> ЗНАЧЕНИЕ(Справочник.РабочиеМеста.ПустаяСсылка))
		  |	И (ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ
		  |	   ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор)") +
	"
	|	И (НЕ ПодключаемоеОборудование.ПометкаУдаления)";
	
	// Добавим полученное условие отбора к тексту запроса.
	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО
	|	ТипОборудования,
	|	Наименование;";

	Запрос = Новый Запрос(ТекстЗапроса);
	
	// Установим параметры запроса (фильтрующие выборку значения).
	Если Идентификатор = Неопределено Тогда
		// То используется фильтр по рабочему месту.
		Если НЕ ЗначениеЗаполнено(РабочееМесто) Тогда
			// Если РМ не задано в параметрах, то всегда текущее из параметров сеанса.
			РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
		КонецЕсли;

		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		// И возможно фильтр по типам оборудования.
		Если ТипыПО <> Неопределено Тогда
			// Подготовка перечислений типов ТО для запроса.
			МассивТиповПО = Новый Массив();
			Если ТипЗнч(ТипыПО) = Тип("Структура") Тогда
				Для Каждого ТипПО Из ТипыПО Цикл
					МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипПО.Ключ]);
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(ТипыПО) = Тип("Массив") Тогда
				Для Каждого ТипПО Из ТипыПО Цикл
					МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипПО]);
				КонецЦикла;
				
			Иначе
				МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипыПО]);
			КонецЕсли;
			
			Запрос.УстановитьПараметр("ТипОборудования", МассивТиповПО);
		КонецЕсли;
	Иначе // Фильтр по конкретному устройству.
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	КонецЕсли;

	Выборка = Запрос.Выполнить().Выбрать();
	
	// Перебирая выборку составляем список устройств.
	СписокОборудования = Новый Массив();
	Пока Выборка.Следующий() Цикл
		// Заполним структуру данных устройства.
		ДанныеУстройства = Новый Структура();
		ДанныеУстройства.Вставить("Ссылка"                    , Выборка.Ссылка);
		
		ДанныеУстройства.Вставить("ИдентификаторУстройства"   , Выборка.ИдентификаторУстройства);
		ДанныеУстройства.Вставить("Наименование"              , Выборка.Наименование);
		ДанныеУстройства.Вставить("ТипОборудования"           , Выборка.ТипОборудования);
		ДанныеУстройства.Вставить("ТипОборудованияИмя"        , МенеджерОборудованияВызовСервера.ПолучитьИмяТипаОборудования(Выборка.ТипОборудования));
		ДанныеУстройства.Вставить("ДрайверОборудования"       , Выборка.ДрайверОборудования);
		ДанныеУстройства.Вставить("ДрайверОборудованияИмя"    , Выборка.ДрайверОборудования.ИмяПредопределенныхДанных);
		ДанныеУстройства.Вставить("ВСоставеКонфигурации"      , Выборка.ДрайверОборудования.Предопределенный);
		ДанныеУстройства.Вставить("ИдентификаторОбъекта"      , Выборка.ДрайверОборудования.ИдентификаторОбъекта);
		ДанныеУстройства.Вставить("ПоставляетсяДистрибутивом" , Выборка.ДрайверОборудования.ПоставляетсяДистрибутивом);
		ДанныеУстройства.Вставить("ИмяМакетаДрайвера"         , Выборка.ДрайверОборудования.ИмяМакетаДрайвера);
		ДанныеУстройства.Вставить("ИмяФайлаДрайвера"          , Выборка.ДрайверОборудования.ИмяФайлаДрайвера);
		ДанныеУстройства.Вставить("Параметры"                 , Выборка.Параметры.Получить());
		ДанныеУстройства.Вставить("РабочееМесто"              , Выборка.РабочееМесто);
		ДанныеУстройства.Вставить("ИмяКомпьютера"             , Выборка.ИмяКомпьютера);
		ОбработчикДрайвера = Выборка.ДрайверОборудования.ОбработчикДрайвера;
		ДанныеУстройства.Вставить("ОбработчикДрайвера"        , ОбработчикДрайвера);
		ДанныеУстройства.Вставить("ОбработчикДрайвераИмя"     , XMLСтрока(ОбработчикДрайвера));
		
		ВерсияФорматаОбмена = ?(Выборка.ВерсияФорматаОбмена > 0, Выборка.ВерсияФорматаОбмена, МенеджерОборудованияВызовСервера.РевизияИнтерфейсаДрайверов()); 
		ДанныеУстройства.Вставить("ВерсияФорматаОбмена", ВерсияФорматаОбмена);
		
		Если ТипЗнч(ДанныеУстройства.Параметры) = Тип("Структура") Тогда
			ДанныеУстройства.Параметры.Вставить("Идентификатор", Выборка.Ссылка); 
		КонецЕсли;
		СписокОборудования.Добавить(ДанныеУстройства);
	КонецЦикла;
	
	// Возвращаем полученный список с данными всех найденных устройств.
	Возврат СписокОборудования;
	
КонецФункции

// Функция возвращает по идентификатору устройства его параметры.
//
Функция ПолучитьПараметрыУстройства(Идентификатор) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Параметры
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Результат = Выборка.Параметры.Получить();
	Возврат Результат;
	
КонецФункции

// Процедура предназначена для сохранения параметров устройства
// в реквизит Параметры типа хранилище значения в элементе справочника.
Функция СохранитьПараметрыУстройства(Идентификатор, Параметры, ВерсияФорматаОбмена) Экспорт

	Попытка
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор");
		
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		ТаблицаРезультатов = Запрос.Выполнить().Выгрузить();
		
		ОбъектСправочника = ТаблицаРезультатов[0].Ссылка.ПолучитьОбъект();
		ОбъектСправочника.Параметры = Новый ХранилищеЗначения(Параметры);
		ОбъектСправочника.ВерсияФорматаОбмена = ВерсияФорматаОбмена;
		ОбъектСправочника.Записать();
		Результат = Истина;
		
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// Функция возвращает структуру с данными устройства
// (со значениями реквизитов элемента справочника).
Функция ПолучитьДанныеУстройства(Идентификатор) Экспорт

	ДанныеУстройства = Новый Структура();

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
	|	ПодключаемоеОборудование.ИдентификаторУстройства КАК ИдентификаторУстройства,
	|	ПодключаемоеОборудование.Наименование КАК Наименование,
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования,
	|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования,      
	|	ПодключаемоеОборудование.ВерсияФорматаОбмена КАК ВерсияФорматаОбмена,
	|	ПодключаемоеОборудование.РабочееМесто КАК РабочееМесто,
	|	ПодключаемоеОборудование.Параметры КАК Параметры,
	|	РабочиеМеста.ИмяКомпьютера КАК ИмяКомпьютера
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РабочиеМеста КАК РабочиеМеста
	|		ПО ПодключаемоеОборудование.РабочееМесто = РабочиеМеста.Ссылка
	|ГДЕ
	|	(ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор
	|			ИЛИ ПодключаемоеОборудование.Ссылка = &Идентификатор)
	|");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	                                                           
	Если Выборка.Следующий() Тогда
		// Заполним структуру данных устройства.
		ДанныеУстройства.Вставить("Ссылка"                    , Выборка.Ссылка);
		ДанныеУстройства.Вставить("ИдентификаторУстройства"   , Выборка.ИдентификаторУстройства);
		ДанныеУстройства.Вставить("Наименование"              , Выборка.Наименование);
		ДанныеУстройства.Вставить("ТипОборудования"           , Выборка.ТипОборудования);
		ДанныеУстройства.Вставить("ТипОборудованияИмя"        , МенеджерОборудованияВызовСервера.ПолучитьИмяТипаОборудования(Выборка.ТипОборудования));
		ДанныеУстройства.Вставить("ДрайверОборудования"       , Выборка.ДрайверОборудования);
		ДанныеУстройства.Вставить("ДрайверОборудованияИмя"    , Выборка.ДрайверОборудования.ИмяПредопределенныхДанных);
		ДанныеУстройства.Вставить("ВСоставеКонфигурации"      , Выборка.ДрайверОборудования.Предопределенный);
		ДанныеУстройства.Вставить("ИдентификаторОбъекта"      , Выборка.ДрайверОборудования.ИдентификаторОбъекта);
		ДанныеУстройства.Вставить("ПоставляетсяДистрибутивом" , Выборка.ДрайверОборудования.ПоставляетсяДистрибутивом);
		ДанныеУстройства.Вставить("ИмяМакетаДрайвера"         , Выборка.ДрайверОборудования.ИмяМакетаДрайвера);
		ДанныеУстройства.Вставить("ИмяФайлаДрайвера"          , Выборка.ДрайверОборудования.ИмяФайлаДрайвера);
		ДанныеУстройства.Вставить("Параметры"                 , Выборка.Параметры.Получить());
		ДанныеУстройства.Вставить("РабочееМесто"              , Выборка.РабочееМесто);
		ДанныеУстройства.Вставить("ИмяКомпьютера"             , Выборка.ИмяКомпьютера);
		ОбработчикДрайвера = Выборка.ДрайверОборудования.ОбработчикДрайвера;
		ДанныеУстройства.Вставить("ОбработчикДрайвера"        , ОбработчикДрайвера);
		ДанныеУстройства.Вставить("ОбработчикДрайвераИмя"     , XMLСтрока(ОбработчикДрайвера));
		
		ВерсияФорматаОбмена = ?(Выборка.ВерсияФорматаОбмена > 0, Выборка.ВерсияФорматаОбмена, МенеджерОборудованияВызовСервера.РевизияИнтерфейсаДрайверов()); 
		ДанныеУстройства.Вставить("ВерсияФорматаОбмена", ВерсияФорматаОбмена);
		
		Если ТипЗнч(ДанныеУстройства.Параметры) = Тип("Структура") Тогда
			ДанныеУстройства.Параметры.Вставить("Идентификатор", Выборка.Ссылка); 
		КонецЕсли;
	КонецЕсли;
		
	Возврат ДанныеУстройства;
	
КонецФункции

#КонецЕсли

#КонецОбласти