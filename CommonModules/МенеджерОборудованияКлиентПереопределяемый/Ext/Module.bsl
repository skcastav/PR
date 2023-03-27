﻿
#Область ПрограммныйИнтерфейс

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
// Предназначена для использования вместо функции ТекущаяДата().
//
Функция ДатаСеанса() Экспорт
	
	Возврат ТекущаяДата();
	
КонецФункции

// Функция возвращает объект обработчика драйвера по его наименованию.
//
Функция ПолучитьОбработчикДрайвера(ОбработчикДрайвера, ЗагружаемыйДрайвер) Экспорт
	
	// Используем универсальный обработчик драйвера по стандарту "1С:Совместимо".
#Если ВебКлиент Тогда
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверАсинхронноКлиент; 
#Иначе
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент;
#КонецЕсли

	// Обработчики драйверов не удовлетворяющие стандарту "1С:Совместимо".
	Если Не ЗагружаемыйДрайвер И ОбработчикДрайвера <> Неопределено Тогда
		
		// Сканеры штрихкода
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудование1ССканерыШтрихкодаКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудованиеСканкодСканерыШтрихкодаКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудованиеАтолСканерыШтрихкодаКлиент;
		КонецЕсли;
		// Конец Сканеры штрихкода
				
		// Терминалы сбора данных
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеАтолТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеСканкодТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеСканситиТерминалыСбораДанныхКлиент;
		КонецЕсли;
		// Конец Терминалы сбора данных.
				
		// Web-сервис оборудование
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СWebСервисОборудование") Тогда
			Возврат Неопределено;
		КонецЕсли;
		// Конец Web-сервис оборудование

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Переопределяет формируемый шаблон чека.
//
Функция СформироватьШаблонЧека(ВходныеПараметры, ДополнительныйТекст, СтандартнаяОбработка) Экспорт
	
КонецФункции

// Переопределяет формируемый текст нефискального чека по шаблону.
//
Функция СформироватьТексНефискальногоЧека(ШиринаСтроки, ВходныеПараметры, СтандартнаяОбработка) Экспорт
	
КонецФункции

// Переопределяет печать чека по шаблону.
//
Функция ПечатьЧекаПоШаблону(ОбщийМодульОборудования, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры, СтандартнаяОбработка) Экспорт
	
КонецФункции

// Переопределяет печать фискального чека.
//
Функция ПечатьЧека(ОбщийМодульОборудования, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры, СтандартнаяОбработка) Экспорт
	
КонецФункции

#КонецОбласти

#Область ПроцедурыПодключенияОтключенияОборудования

// Начать подключение необходимых типов оборудования при открытии формы.
//
// Параметры:
// Форма - УправляемаяФорма
// ПоддерживаемыеТипыПодключаемогоОборудования - Строка
//  Содержит перечень типов подключаемого оборудования, разделенных запятыми.
//
Процедура НачатьПодключениеОборудованиеПриОткрытииФормы(Форма, ПоддерживаемыеТипыПодключаемогоОборудования) Экспорт
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, Форма, ПоддерживаемыеТипыПодключаемогоОборудования);
	
КонецПроцедуры

// Начать отключать оборудование по типу при закрытии формы.
//
Процедура НачатьОтключениеОборудованиеПриЗакрытииФормы(Форма) Экспорт
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, Форма);
	
КонецПроцедуры

#КонецОбласти
 
#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриОткрытии".
//
Процедура ЭкземплярОборудованияПриОткрытии(Объект, ЭтаФорма, Отказ) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗакрытием".
//
Процедура ЭкземплярОборудованияПередЗакрытием(Объект, ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписью".
//
Процедура ЭкземплярОборудованияПередЗаписью(Объект, ЭтаФорма, Отказ, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписи".
//
Процедура ЭкземплярОборудованияПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ТипОборудованияОбработкаВыбора".
//
Процедура ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтаФорма, ЭтотОбъект, Элемент, ВыбранноеЗначение) Экспорт
	
КонецПроцедуры

#КонецОбласти