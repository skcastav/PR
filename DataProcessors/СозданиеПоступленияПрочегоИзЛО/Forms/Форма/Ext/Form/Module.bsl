﻿
&НаСервере
Функция СоздатьНаСервере(ВыбКол)
	Попытка
	Запрос = Новый Запрос;
	ПоступлениеПрочее = Документы.ПоступлениеМПЗПрочее.СоздатьДокумент();

	ПоступлениеПрочее.Дата = ТекущаяДата();
	ПоступлениеПрочее.Подразделение = Линейка.Подразделение;
	ПоступлениеПрочее.МестоХранения = Линейка.МестоХраненияКанбанов;
	ПоступлениеПрочее.Статья = Статья;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ
		|ИЗ
		|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
		|ГДЕ
		|	ЛьготнаяОчередь.Линейка = &Линейка
		|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1,1,1,0,0,0)";
	Запрос.УстановитьПараметр("Линейка",Линейка);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
		ТЧ = ПоступлениеПрочее.ТабличнаяЧасть.Добавить();
			Если ТипЗнч(Выборка.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
			Иначе
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
			КонецЕсли;  
		ТЧ.МПЗ = Выборка.МПЗ;
		ТЧ.ЕдиницаИзмерения = Выборка.МПЗ.ОсновнаяЕдиницаИзмерения;
		ТЧ.Количество = ВыбКол;
		КонецЦикла;
	ПоступлениеПрочее.Записать(РежимЗаписиДокумента.Запись);
	Возврат(ПоступлениеПрочее.Ссылка);
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Документы.ПоступлениеМПЗПрочее.ПустаяСсылка());
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура Создать(Команда)
ВыбКол = 100;
	Если ВвестиЧисло(ВыбКол,"Введите кол-во приходуемых МПЗ",14,3) Тогда
	ПП = СоздатьНаСервере(ВыбКол);
		Если Не ПП.Пустая() Тогда
		ОткрытьФорму("Документ.ПоступлениеМПЗПрочее.Форма.ФормаДокумента",Новый Структура("Ключ",ПП));
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры
