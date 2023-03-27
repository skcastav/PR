﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	ПолучитьТаблицуЗаданийНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
ПриОткрытии(Ложь);
КонецПроцедуры

&НаСервере
Функция ПолучитьРемонт(Документ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РемонтнаяКарта.Ссылка
	|ИЗ
	|	Документ.РемонтнаяКарта КАК РемонтнаяКарта
	|ГДЕ
	|	РемонтнаяКарта.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование",Документ);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(Документы.РемонтнаяКарта.ПустаяСсылка());
КонецФункции 

&НаСервере
Процедура ПолучитьТаблицуЗаданийНаСервере()
Объект.ТаблицаЗаданий.Очистить();	
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	БракПроизводстваОстатки.Линейка,
	|	БракПроизводстваОстатки.Документ,
	|	БракПроизводстваОстатки.Изделие,
	|	БракПроизводстваОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.БракПроизводства.Остатки(&НаДату, МестоХранения = &МестоХраненияБрака) КАК БракПроизводстваОстатки
	|ГДЕ
	|	БракПроизводстваОстатки.КоличествоОстаток > 0";
Запрос.УстановитьПараметр("НаДату",ТекущаяДата());
Запрос.УстановитьПараметр("МестоХраненияБрака",Объект.Подразделение.МестоХраненияБрака);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = Объект.ТаблицаЗаданий.Добавить();
	ТЧ.Линейка = ВыборкаДетальныеЗаписи.Линейка;
	ТЧ.Изделие = ВыборкаДетальныеЗаписи.Изделие;
	ТЧ.Документ = ВыборкаДетальныеЗаписи.Документ;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.КоличествоОстаток; 
	ТЧ.ДатаОтправкиВБрак = ВыборкаДетальныеЗаписи.Документ.Дата;
	ТЧ.РабочееМесто = ВыборкаДетальныеЗаписи.Документ.РабочееМесто;
	ТЧ.ВидБрака = ВыборкаДетальныеЗаписи.Документ.ВидБрака;
	ТЧ.Ремонт = ПолучитьРемонт(ВыборкаДетальныеЗаписи.Документ);
	КонецЦикла;
Объект.ТаблицаЗаданий.Сортировать("ДатаОтправкиВБрак");
КонецПроцедуры
 
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
ПолучитьТаблицуЗаданийНаСервере();
КонецПроцедуры

&НаСервере
Функция ПереданоВРемонт(Стр)
Результат = Новый Структура("ВРемонте,Количество,КоличествоНеремонтопригодных",Ложь,0,0);
ТЧ = Объект.ТаблицаЗаданий.НайтиПоИдентификатору(Стр);
	Если Не ТЧ.Ремонт.Пустая() Тогда
		Если ТЧ.Ремонт.Проведен Тогда
		Результат.Количество = ТЧ.Ремонт.Количество;	
		Результат.КоличествоНеремонтопригодных = ТЧ.Ремонт.КоличествоНеремонтопригодных;
		Иначе
		Результат.ВРемонте = Истина;
		Результат.Количество = ТЧ.Ремонт.Количество;
		КонецЕсли;
	КонецЕсли;
Возврат(Результат); 
КонецФункции

&НаСервере
Функция ПередатьВРемонтНаСервере(Стр,ПричиныРемонта,Количество)
	Если Не Объект.Подразделение.РабочееМестоОценкиБрака.Пустая() Тогда	
	ТЧ = Объект.ТаблицаЗаданий.НайтиПоИдентификатору(Стр);
		Попытка
		НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		РемонтнаяКарта = Документы.РемонтнаяКарта.СоздатьДокумент();
			Если ТипЗнч(ТЧ.Документ) = Тип("ДокументСсылка.ВыпускПродукцииКанбан") Тогда
			РемонтнаяКарта.Номер = ТЧ.Документ.Номер+"-"+ОбщийМодульСозданиеДокументов.ПолучитьНомерРемонтнойКарты(ТЧ.Документ.ДокументОснование);
			Иначе	
			РемонтнаяКарта.Номер = ТЧ.Документ.Номер+"-"+ОбщийМодульСозданиеДокументов.ПолучитьНомерРемонтнойКарты(ТЧ.Документ);
			КонецЕсли;
		РемонтнаяКарта.Дата = ТекущаяДата();
		РемонтнаяКарта.ДокументОснование = ТЧ.Документ;
		РемонтнаяКарта.ВидРемонта = Перечисления.ВидыРемонта.БракКанбан;
		РемонтнаяКарта.Линейка = Объект.Подразделение.РабочееМестоОценкиБрака.Линейка;
		РемонтнаяКарта.Подразделение = Объект.Подразделение.РабочееМестоОценкиБрака.Линейка.Подразделение;
	 	РемонтнаяКарта.РабочееМесто = Объект.Подразделение.РабочееМестоОценкиБрака;
		РемонтнаяКарта.Изделие = ТЧ.Изделие;
	    РемонтнаяКарта.Количество = Количество;
		РемонтнаяКарта.ПричинаРемонта = ПричиныРемонта.ПричинаРемонта;
		РемонтнаяКарта.Комментарий = ПричиныРемонта.Комментарий;
		РемонтнаяКарта.Записать(РежимЗаписиДокумента.Запись);
		ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Исключение
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(Неопределено);
		КонецПопытки;
	Возврат(РемонтнаяКарта.Ссылка);
	Иначе
	Сообщить("Для подразделения не указано рабочее место оценки брака!");
	Возврат(Неопределено);
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьРабочееМестоОценкиБрака()
Возврат(Объект.Подразделение.РабочееМестоОценкиБрака); 
КонецФункции

&НаКлиенте
Процедура ПередатьВРемонт(Команда)
	Если Элементы.ТаблицаЗаданий.ТекущаяСтрока <> Неопределено Тогда
	Результат = ПереданоВРемонт(Элементы.ТаблицаЗаданий.ТекущаяСтрока);
		Если Не Результат.ВРемонте Тогда
		ВыбКоличество = Элементы.ТаблицаЗаданий.ТекущиеДанные.Количество;
			Если ВвестиЧисло(ВыбКоличество,"Введите кол-во",9,3) Тогда
				Если ВыбКоличество <= Элементы.ТаблицаЗаданий.ТекущиеДанные.Количество Тогда
					Если Элементы.ТаблицаЗаданий.ТекущиеДанные.Ремонт.Пустая() Тогда
					Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",ПолучитьРабочееМестоОценкиБрака()));
						Если Результат <> Неопределено Тогда
						РК = ПередатьВРемонтНаСервере(Элементы.ТаблицаЗаданий.ТекущаяСтрока,Результат,ВыбКоличество);
							Если РК <> Неопределено Тогда
							Элементы.ТаблицаЗаданий.ТекущиеДанные.Ремонт = РК;
							КонецЕсли; 
						КонецЕсли;			
					Иначе	
					Сообщить("Изделие уже прошло ремонт!");
					КонецЕсли;
				Иначе
				Сообщить("Введённое количество больше чем передано в брак!");	
				КонецЕсли;
			КонецЕсли;		
		Иначе			
		Сообщить("Изделие находится в ремонте!");
		КонецЕсли;
	Иначе
	Сообщить("Выберите строку в табличной части!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОформитьСписаниеПеремещение(Команда)
	Если Элементы.ТаблицаЗаданий.ТекущаяСтрока <> Неопределено Тогда
	КоличествоПеремещение = Элементы.ТаблицаЗаданий.ТекущиеДанные.Количество;
	КоличествоСписание = 0;
	Результат = ПереданоВРемонт(Элементы.ТаблицаЗаданий.ТекущаяСтрока);
		Если Результат.ВРемонте Тогда
		КоличествоПеремещение = КоличествоПеремещение - Результат.Количество;
		Иначе	
		КоличествоПеремещение = КоличествоПеремещение - Результат.КоличествоНеремонтопригодных;
		КонецЕсли;	
	КоличествоСписание = Результат.КоличествоНеремонтопригодных;
	Результат = ОткрытьФормуМодально("ОбщаяФорма.ОформлениеСписанияПеремещенияБрака",Новый Структура("Подразделение,ДокументПрихода,Изделие,КоличествоСписание,КоличествоПеремещение",Объект.Подразделение,Элементы.ТаблицаЗаданий.ТекущиеДанные.Документ,Элементы.ТаблицаЗаданий.ТекущиеДанные.Изделие,КоличествоСписание,КоличествоПеремещение));
		Если Результат <> Неопределено Тогда
			Если Результат.Списание <> Неопределено Тогда
			ОткрытьФорму("Документ.СписаниеМПЗПрочее.ФормаОбъекта",Новый Структура("Ключ",Результат.Списание));
			КонецЕсли; 	
				Если Результат.Перемещение <> Неопределено Тогда
				ОткрытьФорму("Документ.ДвижениеМПЗ.ФормаОбъекта",Новый Структура("Ключ",Результат.Перемещение));
				КонецЕсли;
		ПолучитьТаблицуЗаданийНаСервере();	
		КонецЕсли;
	Иначе
	Сообщить("Выберите строку в табличной части!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоздатьМТКНаСервере(Линейка,Изделие,Количество)
СтдКомментарий = Справочники.СтандартныеКомментарии.НайтиПоНаименованию("Полуфабрикаты, созданные по заказу ремонтника",Истина);				
МТК = ОбщийМодульСозданиеДокументов.СоздатьМТК(Линейка,Изделие,Количество,СтдКомментарий,Справочники.Проекты.ПустаяСсылка(),Истина,Ложь,,,,,,,,,"Создано из АРМ Оценки брака");
	Если Не МТК.Пустая() Тогда
	Сообщить("Создана "+МТК);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СоздатьМТК(Команда)
ВыбЛинейка = Неопределено;
	Если ВвестиЗначение(ВыбЛинейка,"Введите линейку",Тип("СправочникСсылка.Линейки")) Тогда
	Количество = Элементы.ТаблицаЗаданий.ТекущиеДанные.Количество;	
		Если ВвестиЧисло(Количество,"Введите кол-во п.ф.",9,3) Тогда
		СоздатьМТКНаСервере(ВыбЛинейка,Элементы.ТаблицаЗаданий.ТекущиеДанные.Изделие,Количество);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
