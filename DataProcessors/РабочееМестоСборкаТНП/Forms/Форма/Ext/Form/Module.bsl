﻿
&НаСервере
Процедура ПолучитьЗНПНаСервере()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыНаПроизводствоОстатки.Документ КАК Документ,
	|	ЗаказыНаПроизводствоОстатки.Продукция КАК Продукция,
	|	ЗаказыНаПроизводствоОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыНаПроизводство.Остатки КАК ЗаказыНаПроизводствоОстатки
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ЗаказыНаПроизводствоОстатки.Продукция) = ТИП(Справочник.Материалы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказыНаПроизводствоОстатки.Документ.Дата
	|ИТОГИ ПО
	|	Документ";	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЗНП = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЗНП.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаЗНП.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Продукция = ВыборкаДетальныеЗаписи.Продукция;
		КоличествоНаСкладе = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(Объект.Линейка.МестоХраненияКанбанов,Продукция);
			Если КоличествоНаСкладе > 0 Тогда
			Объект.ЗаказНаПроизводство = ВыборкаЗНП.Документ;
				Для каждого ТЧ_Заказ Из ВыборкаДетальныеЗаписи.Документ.Заказ Цикл	
					Если ТЧ_Заказ.Продукция = Продукция Тогда
				    ТЧ = Объект.ТабличнаяЧасть.Добавить();
					ТЧ.Продукция = Продукция;
					ТЧ.КоличествоТребуется = ВыборкаДетальныеЗаписи.КоличествоОстаток;
					ТЧ.КоличествоНаСкладе = КоличествоНаСкладе;
						Если КоличествоНаСкладе >= ТЧ.КоличествоТребуется Тогда
						ТЧ.Количество = ТЧ.КоличествоТребуется;
						Иначе	
						ТЧ.Количество = КоличествоНаСкладе;
						КонецЕсли;  	
					КонецЕсли; 
				КонецЦикла;
			Возврат;
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
Сообщить("Нет заказов, готовых к сборке!");
КонецПроцедуры

&НаСервере
Функция ПолучитьОстаткиЗНП(Продукция)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыНаПроизводствоОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыНаПроизводство.Остатки КАК ЗаказыНаПроизводствоОстатки
	|ГДЕ
	|	ЗаказыНаПроизводствоОстатки.Документ = &Документ
	|	И ЗаказыНаПроизводствоОстатки.Продукция = &Продукция";	
Запрос.УстановитьПараметр("Документ",Объект.ЗаказНаПроизводство);
Запрос.УстановитьПараметр("Продукция",Продукция);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.КоличествоОстаток);
	КонецЦикла; 
Возврат(0);
КонецФункции 

&НаСервере
Процедура ЗаказНаПроизводствоПриИзмененииНаСервере()
	Для каждого ТЧ_Заказ Из Объект.ЗаказНаПроизводство.Заказ Цикл	
		Если ТЧ_Заказ.Продукция.Линейка = Объект.Линейка Тогда
	    ТЧ = Объект.ТабличнаяЧасть.Добавить();
		ТЧ.Продукция = ТЧ_Заказ.Продукция;
		ТЧ.КоличествоТребуется = ПолучитьОстаткиЗНП(ТЧ_Заказ.Продукция);
		ТЧ.КоличествоНаСкладе = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(Объект.Линейка.МестоХраненияКанбанов,ТЧ.Продукция);
			Если ТЧ.КоличествоНаСкладе >= ТЧ.КоличествоТребуется Тогда
			ТЧ.Количество = ТЧ.КоличествоТребуется;
			Иначе	
			ТЧ.Количество = ТЧ.КоличествоНаСкладе;
			КонецЕсли;  	
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказНаПроизводствоПриИзменении(Элемент)
Объект.ТабличнаяЧасть.Очистить();
ЗаказНаПроизводствоПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьДвижениеНаСборке()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДвижениеМПЗ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ДвижениеМПЗ КАК ДвижениеМПЗ
	|ГДЕ
	|	ДвижениеМПЗ.Автор = &Исполнитель
	|	И ДвижениеМПЗ.НаСборке = ИСТИНА";
Запрос.УстановитьПараметр("Исполнитель", ПараметрыСеанса.Пользователь);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Объект.ЗаказНаПроизводство = ВыборкаДетальныеЗаписи.Ссылка.ДокументОснование;
	Объект.ДвижениеМПЗ = ВыборкаДетальныеЗаписи.Ссылка;
		Для каждого ТЧ Из Объект.ДвижениеМПЗ.ТабличнаяЧасть Цикл	
	    ТЧ_ТЧ = Объект.ТабличнаяЧасть.Добавить();
		ТЧ_ТЧ.Продукция = ТЧ.МПЗ;
		ТЧ_ТЧ.Количество = ТЧ.Количество;		
		КонецЦикла; 
	Возврат(Истина); 
	КонецЦикла;
Возврат(Ложь);
КонецФункции

&НаКлиенте
Процедура ПолучитьЗНП(Команда)
	Если Объект.ЗаказНаПроизводство.Пустая() Тогда
		Если ЭтаФорма.ПроверитьЗаполнение() Тогда
			Если Не ПолучитьДвижениеНаСборке() Тогда
			ПолучитьЗНПНаСервере();
				Если Не Объект.ЗаказНаПроизводство.Пустая() Тогда
				СоздатьПеремещениеНаГПНаСервере();
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура СоздатьПеремещениеНаГПНаСервере()
	Попытка
	Перемещение = Документы.ДвижениеМПЗ.СоздатьДокумент();
	Перемещение.ДокументОснование = Объект.ЗаказНаПроизводство;
	Перемещение.НаСборке = Истина;
	Перемещение.Автор = ПараметрыСеанса.Пользователь;
	Перемещение.Дата = ТекущаяДата();
	Перемещение.Подразделение = Объект.Линейка.Подразделение;
	Перемещение.УстановитьНовыйНомер(ПрисвоитьПрефикс(Объект.Линейка.Подразделение)); 
	Перемещение.МестоХранения = Объект.Линейка.МестоХраненияКанбанов;
	Перемещение.МестоХраненияВ = Объект.Линейка.МестоХраненияГП;
	Перемещение.Сотрудник = Перемещение.МестоХранения.МОЛ;
		Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
		ТЧ_Р = Перемещение.ТабличнаяЧасть.Добавить();
		ТЧ_Р.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
		ТЧ_Р.МПЗ = ТЧ.Продукция;
		ТЧ_Р.Количество = ТЧ.Количество;
		ТЧ_Р.ЕдиницаИзмерения = ТЧ.Продукция.ОсновнаяЕдиницаИзмерения;
        КонецЦикла;
	Перемещение.Записать(РежимЗаписиДокумента.Проведение);
	Объект.ДвижениеМПЗ = Перемещение.Ссылка;
	Исключение
	Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ЗавершитьЗаданиеНаСервере()
	Попытка
	Перемещение = Объект.ДвижениеМПЗ.ПолучитьОбъект();
	Перемещение.НаСборке = Ложь;
	Перемещение.Записать(РежимЗаписиДокумента.Проведение);
	Объект.ЗаказНаПроизводство = Документы.ЗаказНаПроизводство.ПустаяСсылка();
	Объект.ДвижениеМПЗ = Документы.ДвижениеМПЗ.ПустаяСсылка();
	Объект.ТабличнаяЧасть.Очистить();
	Исключение
	Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры
 
&НаКлиенте
Процедура ЗавершитьЗадание(Команда)
	Если Не Объект.ЗаказНаПроизводство.Пустая() Тогда
	ЗавершитьЗаданиеНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПечатьБиркиНаСервере()
ТабДок = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Бирка");

ОблБирка = Макет.ПолучитьОбласть("Бирка");
ОблБирка.Параметры.НомерЗНП = Объект.ЗаказНаПроизводство.Номер;
QRCode = "";
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	QRCode = QRCode + Формат(ТЧ.Продукция.Товар.EAN,"ЧЦ=13; ЧВН=; ЧГ=0") + ";" + ТЧ.Количество + ";" 
	КонецЦикла;
ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRCode, 0, 100);	
	Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
	КартинкаQRКода = Новый Картинка(ДанныеQRКода);
	ОблБирка.Рисунки.QRCode.Картинка = КартинкаQRКода;
	Иначе
	Сообщить("Не удалось сформировать QR-код!");
	КонецЕсли;
ТабДок.Вывести(ОблБирка);
ТабДок.РазмерСтраницы = "Custom";
ТабДок.ВысотаСтраницы = 101;
ТабДок.ШиринаСтраницы = 57;
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;	
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьБирки(Команда)
ТД = ПечатьБиркиНаСервере();
ТД.Показать("Бирка ТНП");
КонецПроцедуры

&НаСервере
Функция ПечатьЗаказаНаСервере()
ТабДок = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл	
	ОблМПЗ.Параметры.Наименование = СокрЛП(ТЧ.Продукция.Наименование);
	ОблМПЗ.Параметры.МПЗ = ТЧ.Продукция;
	ОблМПЗ.Параметры.Количество = ТЧ.Количество;
	ОблМПЗ.Параметры.НомерДок = Объект.ЗаказНаПроизводство.Номер;
	ОблМПЗ.Параметры.Документ = Объект.ЗаказНаПроизводство;
	ТабДок.Вывести(ОблМПЗ); 
	КонецЦикла; 
ТабДок.Вывести(ОблКонец);	
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьЗаказа(Команда)
ТД = ПечатьЗаказаНаСервере();
ТД.Показать("Заказ ТНП");
КонецПроцедуры

&НаСервере
Функция ПечатьБиркиА4НаСервере()
ТабДок = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Бирка_А4");

ОблБирка = Макет.ПолучитьОбласть("Бирка");

ОблБирка.Параметры.НомерЗНП = Объект.ЗаказНаПроизводство.Номер;
ОблБирка.Параметры.Клиент = СокрЛП(Объект.ЗаказНаПроизводство.Контрагент.Наименование);
ТабДок.Вывести(ОблБирка);	
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьНаименованияКлиента(Команда)
ТД = ПечатьБиркиА4НаСервере();
ТД.Показать("Бирка А4");
КонецПроцедуры
