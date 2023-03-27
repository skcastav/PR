﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЭтотОбъект.ТолькоПросмотр = ОбщийМодульСозданиеДокументов.ЗапретРедактирования(Объект.Ссылка,Истина,Ложь);
Элементы.ВыгрузитьВБазуСбыта.Доступность = Не Объект.Выгружено;
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
Процедура ПриЗакрытии(ЗавершениеРаботы)
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры 
        
&НаСервере
Процедура ДобавитьМПЗ(МПЗ)
ТЧ = Объект.ТабличнаяЧасть.Добавить();
	Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;	
	Иначе	
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;		
	КонецЕсли; 
ТЧ.МПЗ = МПЗ;
ТЧ.ЕдиницаИзмерения = МПЗ.ОсновнаяЕдиницаИзмерения;		
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если (Массив[0] = "3")или(Массив[0] = "7") Тогда
		ДобавитьМПЗ(ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]));
		Иначе
		Сообщить("Неверный QRCode!");
		КонецЕсли;		
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюНаСервере()
Объект.ТабличнаяЧасть.Очистить();
Об = РеквизитФормыВЗначение("Объект");
Об.ОбработкаЗаполнения(Объект.ДокументОснование,Истина);
ВыгрузкаТЧ = Об.ТабличнаяЧасть.Выгрузить();
Объект.ТабличнаяЧасть.Загрузить(ВыгрузкаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
ЗаполнитьПоОснованиюНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодборМПЗНаСервере(ТаблицаМПЗ)
	Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;		
		Иначе
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
		КонецЕсли; 
	ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
	ТЧ.Количество = ТЧ_МПЗ.Количество;
	ТЧ.ЕдиницаИзмерения = ТЧ_МПЗ.ЕдиницаИзмерения;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПодборМПЗ(Команда)
ТаблицаМПЗ = ОткрытьФормуМодально("ОбщаяФорма.ПодборМПЗ", Новый Структура("МестоХранения",Объект.МестоХранения));
	Если ТаблицаМПЗ <> Неопределено Тогда
		Если ТаблицаМПЗ.Количество() > 0 Тогда
			Если Объект.ТабличнаяЧасть.Количество() > 0 Тогда
				Если Вопрос("Очистить таблицу?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				Объект.ТабличнаяЧасть.Очистить();		
				КонецЕсли; 			
			КонецЕсли; 
		ПодборМПЗНаСервере(ТаблицаМПЗ);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере(ТабДок)
Макет = Документы.СписаниеМПЗПрочее.ПолучитьМакет("АктОБракеНаПроизводстве");
ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблПодвал = Макет.ПолучитьОбласть("Подвал");
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ДвижениеМПЗ") Тогда	
		Если ТипЗнч(Объект.ДокументОснование.ДокументОснование) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
		Линейка = СокрЛП(Объект.ДокументОснование.ДокументОснование.Линейка);
		ПаспортЛинейки = РегистрыСведений.ПаспортЛинейки.ПолучитьПоследнее(Объект.Дата,Новый Структура("Линейка",Линейка));
		Мастер = ПаспортЛинейки.Мастер;
		Иначе
		Линейка = "";
		Мастер = "";
		КонецЕсли;		
	КонецЕсли; 
ОблШапка.Параметры.НазваниеОрганизации = Константы.НазваниеОрганизации.Получить();
ОблШапка.Параметры.ИННАдрес = СокрЛП(Константы.ИННОрганизации.Получить())+", "+СокрЛП(Константы.АдресОрганизации.Получить());
ОблШапка.Параметры.ЗаместительДиректораПоПроизводству = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Заместитель директора по производству");
ОблШапка.Параметры.РуководительПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Наименование);
ОблШапка.Параметры.ДолжностьРуководителяПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Должность.Наименование);
ОблШапка.Параметры.Мастер = Мастер;
ОблШапка.Параметры.НачальникСТК = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Начальник СТК");
ОблШапка.Параметры.Номер = Объект.Номер;
ТабДок.Вывести(ОблШапка);
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	ОблСтрока.Параметры.Код = ?(ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы,ТЧ.МПЗ.Код,""); 	
	ОблСтрока.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблСтрока.Параметры.ЕдиницаИзмерения = СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование);
	ОблСтрока.Параметры.Количество = ТЧ.Количество;
	ОблСтрока.Параметры.Сумма = ОбщийМодульВызовСервера.ПолучитьСтоимостьМПЗ(ТЧ.МПЗ,1,Объект.Дата,0)*ТЧ.ЕдиницаИзмерения.Коэффициент*ТЧ.Количество;	
	ТабДок.Вывести(ОблСтрока);
	КонецЦикла;
ОблПодвал.Параметры.Линейка = Линейка; 
ОблПодвал.Параметры.РуководительПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Наименование);
ОблПодвал.Параметры.ДолжностьРуководителяПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Должность.Наименование);
ОблПодвал.Параметры.Мастер = Мастер;
ОблПодвал.Параметры.НачальникСТК = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Начальник СТК");
ТабДок.Вывести(ОблПодвал);
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьНаСервере(ТабДок);
ТабДок.Показать("Печать акта о браке на производстве");
КонецПроцедуры

&НаСервере
Процедура ПечатьАктаОСписанииПоСтатьеЗатратНаСервере(ТабДок)
Макет = Документы.СписаниеМПЗПрочее.ПолучитьМакет("АктОСписанииПоСтатьеЗатрат");
ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблПодвал = Макет.ПолучитьОбласть("Подвал");
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ДвижениеМПЗ") Тогда	
		Если ТипЗнч(Объект.ДокументОснование.ДокументОснование) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
		Линейка = СокрЛП(Объект.ДокументОснование.ДокументОснование.Линейка);
		ПаспортЛинейки = РегистрыСведений.ПаспортЛинейки.ПолучитьПоследнее(Объект.Дата,Новый Структура("Линейка",Линейка));
		Мастер = ПаспортЛинейки.Мастер;
		Иначе
		Линейка = "";
		Мастер = "";
		КонецЕсли;		
	КонецЕсли; 
ОблШапка.Параметры.НазваниеОрганизации = Константы.НазваниеОрганизации.Получить();
ОблШапка.Параметры.ИННАдрес = СокрЛП(Константы.ИННОрганизации.Получить())+", "+СокрЛП(Константы.АдресОрганизации.Получить());
ОблШапка.Параметры.ЗаместительДиректораПоПроизводству = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Заместитель директора по производству");
ОблШапка.Параметры.РуководительПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Наименование);
ОблШапка.Параметры.ДолжностьРуководителяПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Должность.Наименование); 
ОблШапка.Параметры.Мастер = Мастер;
ОблШапка.Параметры.НачальникСТК = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Начальник СТК");
ОблШапка.Параметры.Номер = Объект.Номер;
ТабДок.Вывести(ОблШапка);
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
		Если ТЧ.МПЗ.Товар.Пустая() Тогда
			Если ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы Тогда
			ОблСтрока.Параметры.Код = ТЧ.МПЗ.Код;
			Иначе	
			ОблСтрока.Параметры.Код = ""; 
			КонецЕсли;		
		Иначе	
		ОблСтрока.Параметры.Код = ТЧ.МПЗ.Товар.Код;
		КонецЕсли; 
	ОблСтрока.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблСтрока.Параметры.ЕдиницаИзмерения = СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование);
	ОблСтрока.Параметры.Количество = ТЧ.Количество;
	ОблСтрока.Параметры.Сумма = ОбщийМодульВызовСервера.ПолучитьСтоимостьМПЗ(ТЧ.МПЗ,1,Объект.Дата,0)*ТЧ.ЕдиницаИзмерения.Коэффициент*ТЧ.Количество;	
	ТабДок.Вывести(ОблСтрока);
	КонецЦикла;
ОблПодвал.Параметры.СтатьяСписания = СокрЛП(Объект.Статья.Наименование);
ОблПодвал.Параметры.АвторДокумента = СокрЛП(Объект.Автор.Наименование); 
ОблПодвал.Параметры.РуководительПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Наименование);
ОблПодвал.Параметры.ДолжностьРуководителяПодразделения = СокрЛП(Объект.Подразделение.Руководитель.Должность.Наименование); 
ОблПодвал.Параметры.Мастер = Мастер;
ОблПодвал.Параметры.НачальникСТК = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Начальник СТК");
ТабДок.Вывести(ОблПодвал);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктаОСписанииПоСтатьеЗатрат(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьАктаОСписанииПоСтатьеЗатратНаСервере(ТабДок);
ТабДок.Показать("Печать акта о списании по статье затрат");
КонецПроцедуры

&НаСервере
Процедура ПечатьРасходнаяНакладнаяНаСервере(ТабДок)
Макет = Документы.СписаниеМПЗПрочее.ПолучитьМакет("РасходнаяНакладная");
ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.Документ = Объект.Ссылка;
ОблШапка.Параметры.Подразделение = Объект.Подразделение;
ОблШапка.Параметры.МестоХранения = Объект.МестоХранения;
ОблШапка.Параметры.Статья = Объект.Статья;
ОблШапка.Параметры.ДатаВывода = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);
НомСтр = 0;
СуммаИтого = 0;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	НомСтр = НомСтр + 1;
	ОблСтрока.Параметры.НомСтр = НомСтр;
	ОблСтрока.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблСтрока.Параметры.ЕдиницаИзмерения = СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование);
	ОблСтрока.Параметры.Количество = ТЧ.Количество;
	Цена = ОбщийМодульВызовСервера.ПолучитьСтоимостьМПЗ(ТЧ.МПЗ,1,Объект.Дата,0)*ТЧ.ЕдиницаИзмерения.Коэффициент;
	ОблСтрока.Параметры.Цена = Цена;
	ОблСтрока.Параметры.Сумма = Цена*ТЧ.Количество;	
	ТабДок.Вывести(ОблСтрока);
	СуммаИтого = СуммаИтого+Цена*ТЧ.Количество;	
	КонецЦикла;
ОблКонец.Параметры.СуммаИтого = СуммаИтого;
ОблКонец.Параметры.ДолжностьОтпустил = СокрЛП(Объект.Автор.Должность.Наименование); 
ОблКонец.Параметры.Отпустил = СокрЛП(Объект.Автор.Наименование); 
ОблКонец.Параметры.ДолжностьУтвердил = СокрЛП(Объект.Утвердил.Должность.Наименование);
ОблКонец.Параметры.Утвердил = СокрЛП(Объект.Утвердил.Наименование); 
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьРасходнаяНакладная(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьРасходнаяНакладнаяНаСервере(ТабДок);
ТабДок.Показать("Расходная накладная");
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьМПЗПриИзменении(Элемент)
ТабличнаяЧастьМПЗПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьМПЗПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения;
	Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
	Иначе
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьВидМПЗПриИзменении(Элемент)
Элементы.ТабличнаяЧасть.ТекущиеДанные.МПЗ = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
Отказ = Не ЭтаФорма.ПроверитьЗаполнение();
КонецПроцедуры

&НаСервере
Функция ДобавитьНаСервере(TYPE,NAME,NUM,POSITION,DEFIN,ETAP,КоличествоИзделий)
ТЧ = Объект.ТабличнаяЧасть.Добавить();
	Если СокрЛП(ВРег(TYPE)) <> "МАТЕРИАЛ" Тогда
	Сообщить(NAME+" - не является материалом!");
	Возврат(Истина);
	КонецЕсли; 
ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
Выбор = Справочники.Материалы.НайтиПоНаименованию(СокрЛП(NAME),Истина);
	Если Не Выбор.Пустая() Тогда
    ТЧ.МПЗ = Выбор;
	ТЧ.ЕдиницаИзмерения = Выбор.ОсновнаяЕдиницаИзмерения;
	ТЧ.Количество = NUM*КоличествоИзделий;
	Возврат(Истина);
	Иначе
    Сообщить(NAME+" - не найден в справочнике материалов!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
Объект.ТабличнаяЧасть.Очистить();
КоличествоИзделий = 1;
	Если ВвестиЧисло(КоличествоИзделий,"Введите кол-во изделий",9,3) Тогда
	Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл с эскизом спецификации");
		Если Результат <> Неопределено Тогда
		ExcelЛист = Результат.ExcelЛист;
		КолСтрок = Результат.КоличествоСтрок;
		флНеНайден = Ложь;
		    Для к = 2 по КолСтрок Цикл
			Состояние("Обработка...",к*100/КолСтрок,"Загрузка эскиза спецификации из файла..."); 
				Если Не ДобавитьНаСервере(ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value,ExcelЛист.Cells(к,1).Value,ExcelЛист.Cells(к,6).Value,ExcelЛист.Cells(к,5).Value,КоличествоИзделий) Тогда
				флНеНайден = Истина;		
				КонецЕсли;
		    КонецЦикла;
		Результат.Excel.Quit();
			Если флНеНайден Тогда	
			Объект.ТабличнаяЧасть.Очистить();
			Сообщить("Загрузка отменена, т.к. некоторые материалы не были найдены в справочнике материалов!");
			Иначе
			ТЗ = Объект.ТабличнаяЧасть.Выгрузить();
			ТЗ.Свернуть("ВидМПЗ,МПЗ,ЕдиницаИзмерения","Количество");
			Объект.ТабличнаяЧасть.Загрузить(ТЗ);
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция СовпадаетСПодразделенимДокумента(МестоХранения)
Возврат(?(МестоХранения.Подразделение = Объект.Подразделение,Истина,Ложь));
КонецФункции 

&НаКлиенте
Процедура МестоХраненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не СовпадаетСПодразделенимДокумента(ВыбранноеЗначение) Тогда	
	СтандартнаяОбработка = Ложь;
	Сообщить("Выбранное место хранения принадлежит другому подразделению!");	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВыгруженоПриИзменении(Элемент)
Элементы.ВыгрузитьВБазуСбыта.Доступность = Не Объект.Выгружено;
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьВБазуСбытаНаСервере()
БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Константы.БазаДанных1ССбыт.Получить());
	Если БазаСбыта = Неопределено Тогда
	Сообщить("Не открыто соединение с базой сбыта!");
	Возврат;
	КонецЕсли;
флОшибки = Ложь;
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	бсСклад = БазаСбыта.Справочники.Склады.НайтиПоНаименованию("ТНП",Истина);
	бсНовДок = БазаСбыта.Документы.СписаниеНедостачТоваров.СоздатьДокумент();
	бсНовДок.Дата = Объект.Дата;
	бсНовДок.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("02");
	бсНовДок.Подразделение = БазаСбыта.Справочники.СтруктураПредприятия.НайтиПоКоду("00-000002");
	бсНовДок.Склад = бсСклад;
	бсНовДок.Руководитель = БазаСбыта.Справочники.ОтветственныеЛицаОрганизаций.НайтиПоНаименованию("Яров Н.И.",Истина);
	бсНовДок.ГлавныйБухгалтер = БазаСбыта.Справочники.ОтветственныеЛицаОрганизаций.НайтиПоНаименованию("Авезова Е.А.",Истина);
	бсНовДок.ИМСтарыйНомер = Объект.Номер;
	//бсНовДок.БанковскийСчетОрганизации = БазаСбыта.ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(бсНовДок.Организация);
	//бсНовДок.Валюта = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
	//бсНовДок.ВалютаВзаиморасчетов = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
		Для каждого ТЧ_МПЗ Из Объект.ТабличнаяЧасть Цикл
			Если ТЧ_МПЗ.МПЗ.Товар.Пустая() Тогда
			флОшибки = Истина;
			Сообщить(СокрЛП(ТЧ_МПЗ.МПЗ.Наименование)+" - не заполнен реквизит соответствия с товаром!");
			Продолжить;				
			КонецЕсли; 
		Артикул = ОбщийМодульВызовСервера.ПолучитьАртикулПоКодуТовара(ТЧ_МПЗ.МПЗ.Товар.Код);
		бсНомен = БазаСбыта.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
			Если бсНомен.Пустая() Тогда
			флОшибки = Истина;
			Сообщить(СокрЛП(ТЧ_МПЗ.МПЗ.Наименование)+" - товар с артикулом "+Артикул+" не найден в торговой базе!");
			Продолжить;
			КонецЕсли;
		ТЧ = бсНовДок.Товары.Добавить(); 
		ТЧ.Номенклатура = бсНомен;
		ТЧ.Количество = ПолучитьБазовоеКоличество(ТЧ_МПЗ.Количество,ТЧ_МПЗ.ЕдиницаИзмерения);
		КонецЦикла;
			Если (бсНовДок.Товары.Количество() > 0)и(Не флОшибки) Тогда
			бсНовДок.Комментарий = "&ТОВ Выгрузка списания ТНП из производственной базы от "+ТекущаяДата();
			бсНовДок.Записать();
			Объект.Выгружено = Истина;
			Элементы.ВыгрузитьВБазуСбыта.Доступность = Ложь;
			ЭтаФорма.Записать();
			Сообщить("Создан документ "+бсНовДок.Номер);
			КонецЕсли;   
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВБазуСбыта(Команда)
	Если Не ЭтаФорма.Модифицированность Тогда
		Если Найти(Объект.МестоХранения,"Склад ТНП") > 0 Тогда
		Состояние("Обработка...",,"Выгрузка в базу сбыта...");
		ВыгрузитьВБазуСбытаНаСервере();
		Иначе
		Сообщить("Место хранения не является складом ТНП!");	
		КонецЕсли;
	Иначе
	Сообщить("Сначала запишите изменения!");
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамНаСервере()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МПЗ КАК МПЗ,
	|	МестаХраненияОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки КАК МестаХраненияОстатки
	|ГДЕ
	|	МестаХраненияОстатки.МестоХранения = &МестоХранения
	|	И МестаХраненияОстатки.ВидМПЗ = &ВидМПЗ";
Запрос.УстановитьПараметр("МестоХранения", Объект.МестоХранения);
Запрос.УстановитьПараметр("ВидМПЗ", Перечисления.ВидыМПЗ.Материалы);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
	ТЧ.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
	ТЧ.ЕдиницаИзмерения = ВыборкаДетальныеЗаписи.МПЗ.ОсновнаяЕдиницаИзмерения;	
	ТЧ.Количество = ВыборкаДетальныеЗаписи.КоличествоОстаток/ТЧ.ЕдиницаИзмерения.Коэффициент;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
ЗаполнитьПоОстаткамНаСервере();
КонецПроцедуры
                
&НаСервере
Процедура ПечатьАктаОСписанииНаСервере(ТабДок,ВидАкта)
Макет = Документы.СписаниеМПЗПрочее.ПолучитьМакет("АктОСписании");
ОблШапка1 = Макет.ПолучитьОбласть("Шапка1");
ОблШапка2 = Макет.ПолучитьОбласть("Шапка2");
ОблАкт1 = Макет.ПолучитьОбласть("Акт1");
ОблАкт2 = Макет.ПолучитьОбласть("Акт2");
ОблАкт3 = Макет.ПолучитьОбласть("Акт3");
ОблАкт4 = Макет.ПолучитьОбласть("Акт4");	
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблИтого = Макет.ПолучитьОбласть("Итого");
ОблПодвал1 = Макет.ПолучитьОбласть("Подвал1"); 
ОблПодвал2 = Макет.ПолучитьОбласть("Подвал2");
ОблПодвал3 = Макет.ПолучитьОбласть("Подвал3");
ОблПодвал4 = Макет.ПолучитьОбласть("Подвал4");
 
ОблШапка1.Параметры.НомерДок = Объект.Номер;
ОблШапка1.Параметры.ДатаДок = Объект.Дата;
ТабДок.Вывести(ОблШапка1);
	Если ВидАкта = 1 Тогда
	ТабДок.Вывести(ОблАкт1);
	ИначеЕсли ВидАкта = 2 Тогда
	ТабДок.Вывести(ОблАкт2);
	ИначеЕсли ВидАкта = 3 Тогда
	ТабДок.Вывести(ОблАкт3);
	ИначеЕсли ВидАкта = 4 Тогда
	ТабДок.Вывести(ОблАкт4);
	КонецЕсли;
ТабДок.Вывести(ОблШапка2);
КоличествоВсего = 0;
СуммаВсего = 0;
НомСтр = 0;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	НомСтр = НомСтр + 1;
		Если ТЧ.МПЗ.Товар.Пустая() Тогда
			Если ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы Тогда
			ОблСтрока.Параметры.Код = СтрЗаменить(ТЧ.МПЗ.ПолныйКод(),"/","-");
			Иначе	
			ОблСтрока.Параметры.Код = ""; 
			КонецЕсли;		
		Иначе	
		ОблСтрока.Параметры.Код = ТЧ.МПЗ.Товар.Код;
		КонецЕсли;
	ОблСтрока.Параметры.НомСтр = НомСтр; 
	ОблСтрока.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблСтрока.Параметры.ЕдиницаИзмерения = СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование);
	ОблСтрока.Параметры.Количество = ТЧ.Количество;
	ОблСтрока.Параметры.Цена = ОбщийМодульВызовСервера.ПолучитьСтоимостьМПЗ(ТЧ.МПЗ,1,Объект.Дата,0)*ТЧ.ЕдиницаИзмерения.Коэффициент;
	ОблСтрока.Параметры.Сумма = ОблСтрока.Параметры.Цена*ТЧ.Количество;
	ОблСтрока.Параметры.Причина = СокрЛП(Объект.Статья.Наименование);	
	ТабДок.Вывести(ОблСтрока);
	КоличествоВсего = КоличествоВсего + ТЧ.Количество;
	СуммаВсего = СуммаВсего + ОблСтрока.Параметры.Сумма;
	КонецЦикла;
ОблИтого.Параметры.Количество = КоличествоВсего;
ОблИтого.Параметры.Сумма = СуммаВсего;
ОблИтого.Параметры.СуммаПрописью = ""+Цел(СуммаВсего)+" руб. "+Цел((СуммаВсего-Цел(СуммаВсего))*100)+" коп.";
ТабДок.Вывести(ОблИтого); 
	Если ВидАкта = 1 Тогда
	ТабДок.Вывести(ОблПодвал1);
	ИначеЕсли ВидАкта = 2 Тогда
	ТабДок.Вывести(ОблПодвал2);
	ИначеЕсли ВидАкта = 3 Тогда
	ТабДок.Вывести(ОблПодвал3);
	ИначеЕсли ВидАкта = 4 Тогда
	ТабДок.Вывести(ОблПодвал4);
	КонецЕсли;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСлева = 5;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктОСписанииЗапасовГП(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьАктаОСписанииНаСервере(ТабДок,1);
ТабДок.Показать("Печать акта о списании запасов материалов СМТС");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктОСписанииЗапасовМатериалов(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьАктаОСписанииНаСервере(ТабДок,2);
ТабДок.Показать("Печать акта о списании материалов");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктОСписанииЗапасовПФ(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьАктаОСписанииНаСервере(ТабДок,3);
ТабДок.Показать("Печать акта о списании п.ф.");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАктОСписанииЗапасовТНП(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьАктаОСписанииНаСервере(ТабДок,4);
ТабДок.Показать("Печать акта о списании ТНП");
КонецПроцедуры
