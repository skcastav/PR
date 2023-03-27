﻿
&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

Макет = Отчеты.СверкаЗаказовПоставщикамСДоговорнымиПозициями.ПолучитьМакет("Макет");
ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = НачалоДня(Отчет.Период.ДатаНачала);
ОблШапка.Параметры.ДатаКон = КонецДня(Отчет.Период.ДатаОкончания);
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;
ЗапросДП = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказПоставщикуТабличнаяЧасть.Ссылка,
	|	ЗаказПоставщикуТабличнаяЧасть.МПЗ КАК МПЗ,
	|	ЗаказПоставщикуТабличнаяЧасть.Цена,
	|	ЗаказПоставщикуТабличнаяЧасть.ЦенаВалюта,
	|	ЗаказПоставщикуТабличнаяЧасть.Ссылка.Контрагент КАК Контрагент,
	|	ЗаказПоставщикуТабличнаяЧасть.Ссылка.Договор КАК Договор
	|ИЗ
	|	Документ.ЗаказПоставщику.ТабличнаяЧасть КАК ЗаказПоставщикуТабличнаяЧасть
	|ГДЕ
	|	ЗаказПоставщикуТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ЗаказПоставщикуТабличнаяЧасть.Ссылка.Договор.ДоговорСНефиксированнымиЦенами = ЛОЖЬ";
	Если Не Отчет.Контрагент.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И ЗаказПоставщикуТабличнаяЧасть.Ссылка.Контрагент = &Контрагент";	
	Запрос.УстановитьПараметр("Контрагент",Отчет.Контрагент);
	КонецЕсли; 
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Контрагент,Договор,МПЗ";
Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Отчет.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон",КонецДня(Отчет.Период.ДатаОкончания));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ЗапросДП.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДоговорныеПозиции.Ссылка
		|ИЗ
		|	Справочник.ДоговорныеПозиции КАК ДоговорныеПозиции
		|ГДЕ
		|	ДоговорныеПозиции.Владелец = &Владелец
		|	И ДоговорныеПозиции.МПЗ = &МПЗ";
	ЗапросДП.УстановитьПараметр("Владелец", ВыборкаДетальныеЗаписи.Договор);
	ЗапросДП.УстановитьПараметр("МПЗ", ВыборкаДетальныеЗаписи.МПЗ);
	РезультатЗапросаДП = ЗапросДП.Выполнить();
	ВыборкаДетальныеЗаписиДП = РезультатЗапросаДП.Выбрать();
		Если ВыборкаДетальныеЗаписиДП.Количество() = 0 Тогда
		ОблМПЗ.Параметры.Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
		ОблМПЗ.Параметры.Договор = ВыборкаДетальныеЗаписи.Договор;
		ОблМПЗ.Параметры.НомерДок = ВыборкаДетальныеЗаписи.Ссылка.Номер;
		ОблМПЗ.Параметры.Док = ВыборкаДетальныеЗаписи.Ссылка;
		ОблМПЗ.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.МПЗ.Наименование);
		ОблМПЗ.Параметры.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
		ОблМПЗ.Параметры.Цена = ВыборкаДетальныеЗаписи.Цена;
		ТабДок.Вывести(ОблМПЗ);
		КонецЕсли; 	
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 3;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
