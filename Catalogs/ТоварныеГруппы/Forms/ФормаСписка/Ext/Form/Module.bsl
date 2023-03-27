﻿
&НаСервере
Функция ПолучитьСписокПрименения(ВыбЭлемент)
СписокПрименения = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Ссылка
	|ИЗ
	|	Справочник.Товары КАК Товары
	|ГДЕ
	|	Товары.ТоварнаяГруппа = &ТоварнаяГруппа
	|	И Товары.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("ТоварнаяГруппа", ВыбЭлемент);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокПрименения.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(СписокПрименения);
КонецФункции

&НаКлиенте
Процедура Применение(Команда)
СписокПрименения = ПолучитьСписокПрименения(Элементы.Список.ТекущаяСтрока);
	Если СписокПрименения.Количество() = 1 Тогда
	ТекФорма = ПолучитьФорму("Справочник.Товары.ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = СписокПрименения[0].Значение;
	ИначеЕсли СписокПрименения.Количество() > 0 Тогда
	СписокПрименения.СортироватьПоЗначению();
	ВыбЭлемент = СписокПрименения.ВыбратьЭлемент();
		Если ВыбЭлемент <> Неопределено Тогда
		ТекФорма = ПолучитьФорму("Справочник.Товары.ФормаСписка");
		ТекФорма.Открыть();
		ТекФорма.Элементы.Список.ТекущаяСтрока = ВыбЭлемент.Значение;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ПараметрыТоварныхГрупп.Параметры.УстановитьЗначениеПараметра("ТоварнаяГруппа",Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
ПараметрыТоварныхГрупп.Параметры.УстановитьЗначениеПараметра("ТоварнаяГруппа",Элементы.Список.ТекущаяСтрока);
КонецПроцедуры
