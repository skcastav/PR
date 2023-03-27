﻿
&НаСервере
Процедура СписатьНаСервере(НаДату)
	Для каждого ТЧ_Движение Из Объект.ТабличнаяЧасть Цикл
		Если ТЧ_Движение.Пометка Тогда
			Для каждого ТЧ_Стр Из ТЧ_Движение.ДокументПрихода.ТабличнаяЧасть Цикл
				Если ТЧ_Стр.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы Тогда
				Статья = "Брак материалов, полученный в процессе производства";
				ВыбСтатья = Справочники.СтатьиПоступленийСписанийПрочих.НайтиПоНаименованию(Статья,Истина);
				Иначе
				Статья = "Брак полуфабрикатов, полученный в процессе производства";	
				ВыбСтатья = Справочники.СтатьиПоступленийСписанийПрочих.НайтиПоНаименованию(Статья,Истина);
				КонецЕсли; 
			Прервать;
			КонецЦикла;
				Если Не ВыбСтатья.Пустая() Тогда
					Попытка
					НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
					Списание = Документы.СписаниеМПЗПрочее.СоздатьДокумент();
					Списание.Дата = НаДату;
					Списание.УстановитьНовыйНомер(ПрисвоитьПрефикс(Объект.МестоХраненияБрака.Подразделение));
					Списание.Автор = ПараметрыСеанса.Пользователь;
					Списание.ДокументОснование = ТЧ_Движение.ДокументПрихода;
					Списание.Подразделение = Объект.МестоХраненияБрака.Подразделение;
					Списание.МестоХранения = Объект.МестоХраненияБрака;
					Списание.Статья = ВыбСтатья;
					Списание.Утвердил = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Заместитель директора по производству");
					Списание.Комментарий = "Списание в брак";  
					ТЧ = ТЧ_Движение.ДокументПрихода.ТабличнаяЧасть.Выгрузить();
					Списание.ТабличнаяЧасть.Загрузить(ТЧ);
					Списание.Записать(РежимЗаписиДокумента.Проведение);
					ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
					ТЧ_Движение.Пометка = Ложь;
					ТЧ_Движение.ДокументРасхода = Списание.Ссылка;
					ТЧ_Движение.КоличествоРасход = ТЧ_Движение.КоличествоПриход;
					Исключение
					Сообщить(ОписаниеОшибки());
					ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
					Возврат;
					КонецПопытки;
				Иначе
				Сообщить("Не найдена статья списания: "+Статья+"!");
				КонецЕсли; 	
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппуСтатейСписания(НаименованиеГруппа)
Возврат(Справочники.СтатьиПоступленийСписанийПрочих.НайтиПоНаименованию(НаименованиеГруппа,Истина));
КонецФункции

&НаКлиенте
Процедура Списать(Команда)
ВыбДата = ТекущаяДата();
	Если ВвестиДату(ВыбДата,"Введите дату создания документов") Тогда
	СписатьНаСервере(ВыбДата);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьДвиженияНаСервере()
Объект.ТабличнаяЧасть.Очистить();
Запрос = Новый Запрос;
ЗапросРасход = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстаткиИОбороты.Регистратор КАК Регистратор,
	|	МестаХраненияОстаткиИОбороты.КоличествоПриход
	|ИЗ
	|	РегистрНакопления.МестаХранения.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК МестаХраненияОстаткиИОбороты
	|ГДЕ
	|	МестаХраненияОстаткиИОбороты.МестоХранения = &МестоХранения";
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Объект.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Объект.Период.ДатаОкончания));
Запрос.УстановитьПараметр("МестоХранения", Объект.МестоХраненияБрака);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДвижения = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДвижения.Следующий() Цикл	
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
	ТЧ.ДокументПрихода = ВыборкаДвижения.Регистратор;
	ТЧ.КоличествоПриход = ВыборкаДвижения.КоличествоПриход;
	ТЧ.ДатаДокументаПрихода = ВыборкаДвижения.Регистратор.Дата;
	ТЧ.Комментарий = ВыборкаДвижения.Регистратор.Комментарий;
	ЗапросРасход.Текст = 
		"ВЫБРАТЬ
		|	СтруктураПодчиненности.Ссылка
		|ИЗ
		|	КритерийОтбора.ПодчиненныеДокументы(&ЗначениеКритерияОтбора) КАК СтруктураПодчиненности";
	ЗапросРасход.УстановитьПараметр("ЗначениеКритерияОтбора", ВыборкаДвижения.Регистратор);
	РезультатЗапроса = ЗапросРасход.Выполнить();
	ВыборкаРасход = РезультатЗапроса.Выбрать();
		Пока ВыборкаРасход.Следующий() Цикл
			Для каждого ТЧ_МПЗ Из ВыборкаРасход.Ссылка.ТабличнаяЧасть Цикл
			ТЧ.ДокументРасхода = ВыборкаРасход.Ссылка;
			ТЧ.КоличествоРасход = ТЧ.КоличествоРасход+ТЧ_МПЗ.Количество*ТЧ_МПЗ.ЕдиницаИзмерения.Коэффициент;
			КонецЦикла; 
		КонецЦикла;			
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДвижения(Команда)
ПолучитьДвиженияНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеНаСервере()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл	
		Если ТЧ.ДокументРасхода = Неопределено Тогда
		ТЧ.Пометка = Истина;
		Иначе
		ТЧ.Пометка = Ложь;
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
ВыбратьВсеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеНаСервере()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл	
	ТЧ.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
ОтменитьВсеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыбратьПоЧастиКомментарияНаСервере(Подстрока)
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл	
		Если Найти(Врег(ТЧ.Комментарий),Врег(Подстрока)) > 0 Тогда
		ТЧ.Пометка = Истина;
		Иначе
		ТЧ.Пометка = Ложь;
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПоЧастиКомментария(Команда)
Подстрока = "";
	Если ВвестиСтроку(Подстрока,"Введите подстроку для поиска",100) Тогда
	ВыбратьПоЧастиКомментарияНаСервере(СокрЛП(Подстрока));
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеМатериалыНаСервере()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл	
		Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.Пометка = Истина;
		Иначе
		ТЧ.Пометка = Ложь;
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеМатериалы(Команда)
ВыбратьВсеМатериалыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеПФНаСервере()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл	
		Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
		ТЧ.Пометка = Истина;
		Иначе
		ТЧ.Пометка = Ложь;
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеПФ(Команда)
ВыбратьВсеПФНаСервере();
КонецПроцедуры

&НаСервере
Функция СписатьОднимДокументомНаСервере(ВыбСтатья)
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	Списание = Документы.СписаниеМПЗПрочее.СоздатьДокумент();
	Списание.Дата = ТекущаяДата();
	Списание.УстановитьНовыйНомер(ПрисвоитьПрефикс(Объект.МестоХраненияБрака.Подразделение));
	Списание.Автор = ПараметрыСеанса.Пользователь;
	Списание.Подразделение = Объект.МестоХраненияБрака.Подразделение;
	Списание.МестоХранения = Объект.МестоХраненияБрака;
	Списание.Статья = ВыбСтатья;
	Списание.Утвердил = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Заместитель директора по производству");
	Списание.Комментарий = "Списание в брак";
		Для каждого ТЧ_МПЗ Из Объект.ТабличнаяЧасть Цикл
			Если ТЧ_МПЗ.Пометка Тогда
			ТЧ = Списание.ТабличнаяЧасть.Добавить();
				Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
				ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
				Иначе					
				ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;				
				КонецЕсли; 
			ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
			ТЧ.Количество = ТЧ_МПЗ.КоличествоПриход/ТЧ_МПЗ.МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
			ТЧ.ЕдиницаИзмерения =  ТЧ_МПЗ.МПЗ.ОсновнаяЕдиницаИзмерения;	
			ТЧ_МПЗ.Пометка = Ложь;
			ТЧ_МПЗ.ДокументРасхода = Списание.Ссылка;
			КонецЕсли;
		КонецЦикла; 
	Списание.Записать(РежимЗаписиДокумента.Проведение);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(Списание.Ссылка);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Неопределено);
	КонецПопытки;
КонецФункции

&НаСервере
Функция НомерДокументаСписания(Док)
Возврат(Док.Номер);	
КонецФункции

&НаКлиенте
Процедура СписатьОднимДокументом(Команда)
Ф = ПолучитьФорму("Справочник.СтатьиПоступленийСписанийПрочих.ФормаВыбора");
ЭлементОтбора = Ф.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Родитель");
ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
ЭлементОтбора.Использование = Истина;
ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
ЭлементОтбора.ПравоеЗначение = ПолучитьГруппуСтатейСписания("Брак");
Ф.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
ВыбСтатья = Ф.ОткрытьМодально();
	Если ВыбСтатья <> Неопределено Тогда
	Док = СписатьОднимДокументомНаСервере(ВыбСтатья);
		Если Док <> Неопределено Тогда
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",ПолучитьНавигационнуюСсылку(Док),"Создан документ списания "+НомерДокументаСписания(Док),БиблиотекаКартинок.Пользователь);	
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры
