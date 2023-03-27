﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ИспользоватьРучнуюНумерацию = Ложь;
Элементы.НачальныйНомер.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.Номенклатура", Истина);
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите группу номенклатуры", Элемент);
	Если Элемент <> Неопределено Тогда
		НаименованиеГруппыНоменклатуры = ПоказатьПредставлениеБезКода(Элемент.Представление);
		КодГруппыНоменклатуры = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРучнуюНумерациюПриИзменении(Элемент)
	Если ИспользоватьРучнуюНумерацию Тогда
	Элементы.НачальныйНомер.Видимость = Истина;
	Иначе
	Элементы.НачальныйНомер.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиСоздатьНоменклатуру(Подключение, Элемент, бсдГруппаПоУмолчанию)
бсдГруппа = бсдГруппаПоУмолчанию;
	Если Элемент.Уровень()>1 Тогда
		г = Подключение.Справочники.Номенклатура.НайтиПоНаименованию(Элемент.Родитель.Наименование, Истина);
		Если г <> Подключение.Справочники.Номенклатура.ПустаяСсылка() Тогда
			бсдГруппа = г;	
		КонецЕсли;
	КонецЕсли;
	
	
	ПолныйКод = СтрЗаменить(Элемент.ПолныйКод(),"/","-");
	ПолныйКод = СтрЗаменить(ПолныйКод, Символы.НПП, "");
	Ном = Подключение.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", ПолныйКод);
	Если Ном = Подключение.Справочники.Номенклатура.ПустаяСсылка() Тогда
		
		НомОбъект = Подключение.Справочники.Номенклатура.СоздатьЭлемент();
 		НомОбъект.Артикул 				= ПолныйКод;
	 	НомОбъект.Родитель 				= бсдГруппа;					
	  	НомОбъект.НаименованиеПолное 	= Элемент.ПолнНаименование;
	 	НомОбъект.Наименование 			= Элемент.Наименование;
	  	
	 	ЕдИзм = Подключение.Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию(Элемент.ЕдиницаИзмерения.Наименование);

	 	Если ЕдИзм = Подключение.Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка() Тогда
	 		ЕдИзмОбъект = Подключение.Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент(); 		
	 	    ЕдИзмОбъект.Наименование 		= Элемент.ЕдиницаИзмерения.Наименование;
	 	    ЕдИзмОбъект.НаименованиеПолное 	= Элемент.ЕдиницаИзмерения.ПолнНаименование;
	 	    ЕдИзмОбъект.Код 				= Элемент.ЕдиницаИзмерения.Код;
	 		ЕдИзмОбъект.Записать();
	 		ЕдИзм = ЕдИзмОбъект.Ссылка;
	 	КонецЕсли;
	 	
	 	НомОбъект.ЕдиницаИзмерения = ЕдИзм;	
	 	//НомОбъект.СтавкаНДС =  Подключение.Перечисления.СтавкиНДС.НДС20;
		ТЧ = НомОбъект.ИсторияВидаСтавкиНДС.Добавить();
		ТЧ.Период = ТекущаяДата();
		ТЧ.ВидСтавкиНДС = Подключение.Перечисления.ВидыСтавокНДС.Общая;
	 	НомОбъект.Записать();
	 
	 	Сообщить("Выгружен МПЗ "+ НомОбъект.Наименование);
	 	
	 	Возврат НомОбъект.Ссылка;
 	Иначе
	 	Возврат Ном;
 	КонецЕсли;
	
КонецФункции

&НаСервере          
Функция ПроверитьЗаполнениеНаСервере()
	Если СокрЛП(ПодрКод) = "" Тогда
		Возврат "Не задано ""Подразделение затрат"". Выберите ""Подразделение затрат"".";
	КонецЕсли;
	Если СокрЛП(СтЗатрКод) = "" Тогда
		Возврат "Не задана ""Статья затрат"". Выберите ""Статью затрат"".";
	КонецЕсли;	
	Если СокрЛП(НомГруппаКод) = "" Тогда
		Возврат "Не задана ""Номенклатурная группа"". Выберите ""Номенклатурную группу"".";
	КонецЕсли;
	Возврат "";
КонецФункции

&НаСервере
Функция ПолучитьЗапросДокументовНаСервере()
Запрос = Новый Запрос; 

Запрос.Текст =
	 "ВЫБРАТЬ
	 |	РазборкаТабличнаяЧасть.Ссылка.МестоХраненияВ КАК МестоХранения,
	 |	РазборкаТабличнаяЧасть.МПЗ КАК МПЗ,
	 |	РазборкаТабличнаяЧасть.Количество КАК Количество,
	 |	РазборкаТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	 |ИЗ
	 |	Документ.Разборка.ТабличнаяЧасть КАК РазборкаТабличнаяЧасть
	 |ГДЕ
	 |	РазборкаТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	 |	И РазборкаТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	 |	И РазборкаТабличнаяЧасть.Ссылка.МестоХраненияВ В ИЕРАРХИИ(&СписокМестХранения)
	 |	И РазборкаТабличнаяЧасть.ВидМПЗ = &ВидМПЗ";
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Период.ДатаОкончания));
Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
Запрос.УстановитьПараметр("ВидМПЗ", Перечисления.ВидыМПЗ.Материалы);                       
Запрос.Текст = Запрос.Текст + " ИТОГИ
								 |	СУММА(Количество)
								 |ПО
								 |	МестоХранения,
								 |	МПЗ,
								 |	ЕдиницаИзмерения";
Возврат Запрос.Выполнить();
КонецФункции

&НаСервере
Функция ПолучитьЦенуЦена(БухБаза,Н)
ТипЦен=БухБаза.Справочники.ТипыЦенНоменклатуры.НайтиПоКоду("00-000001");
Запрос = БухБаза.NewObject("Запрос"); 

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныНоменклатуры.ТипЦен,
	|	ЦеныНоменклатуры.Номенклатура,
	|	ЦеныНоменклатуры.Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|ГДЕ
	|	ЦеныНоменклатуры.Номенклатура = &Н
	|	И ЦеныНоменклатуры.ТипЦен = &ТипЦен
	|АВТОУПОРЯДОЧИВАНИЕ";
Запрос.УстановитьПараметр("Н", Н);
Запрос.УстановитьПараметр("ТипЦен", ТипЦен.Ссылка);	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Цена=ВыборкаДетальныеЗаписи.Цена;
	КонецЦикла;
Возврат Цена;
КонецФункции

&НаСервере
Процедура ВыполнитьВыгрузкуНаСервере()
БухБаза = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БухБаза = Неопределено Тогда
	Сообщить("Не открыто соединение с бух. базой!");
	Возврат;
	КонецЕсли;
		Если Не СокрЛП(КодГруппыНоменклатуры) = "" Тогда
		бсдГрНомПоУмолчанию = БухБаза.Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(НаименованиеГруппыНоменклатуры));
		Иначе
		бсдГрНомПоУмолчанию = БухБаза.Справочники.Номенклатура.ПустаяСсылка();	
		КонецЕсли; 
Результат = ПолучитьЗапросДокументовНаСервере();
	Если Результат.Пустой() Тогда
	Сообщить("Нет документов для выгрузки по заданным параметрам!");
	Возврат;
	КонецЕсли;	
ВыборкаМХ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМХ.Следующий() Цикл
	Склад	= БухБаза.Справочники.Склады.НайтиПоКоду(СокрЛП(ВыборкаМХ.МестоХранения.КодВБухБазе));
		Если Не Склад.Пустая() Тогда
		бсНовДок = БухБаза.Документы.ОтчетПроизводстваЗаСмену.СоздатьДокумент();	
		бсНовДок.Дата = НачалоДня(Период.ДатаОкончания)+72000;
		бсНовДок.Организация = БухБаза.Справочники.Организации.НайтиПоРеквизиту("ИНН","7112011490");
		бсНовДок.СчетЗатрат =  БухБаза.ПланыСчетов.Хозрасчетный.НайтиПоКоду(СчетЗатратКод);
		бсНовДок.ПодразделениеЗатрат = БухБаза.Справочники.ПодразделенияОрганизаций.НайтиПоНаименованию(ПодрНаименование,Истина);
		бсНовДок.Склад = Склад;
		бсНовДок.НДСвСтоимостиТоваров = БухБаза.Перечисления.ДействиеНДСВСтоимостиТоваров.НеИзменять;
		бсНовДок.Комментарий = "Выгрузка из производственной базы за период с "+Формат(Период.ДатаНачала,"ДФ=dd.MM.yyyy")+" по "+Формат(Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
		Иначе
		Сообщить("Склад с кодом "+СокрЛП(ВыборкаМХ.МестоХранения.КодВБухБазе)+" не найден в бух. базе!");
		Продолжить;
		КонецЕсли; 
	ВыборкаМПЗ = ВыборкаМХ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаМПЗ.Следующий() Цикл
		бсдНоменклатура = НайтиСоздатьНоменклатуру(БухБаза, ВыборкаМПЗ.МПЗ, бсдГрНомПоУмолчанию);			
			Если бсдНоменклатура = БухБаза.Справочники.Номенклатура.ПустаяСсылка() Тогда
			Сообщить("Не найден МПЗ " + ВыборкаМПЗ.МПЗ.Наименование);
			Продолжить;	                                     
			КонецЕсли;
		Количество = 0;
		ВыборкаЕИ = ВыборкаМПЗ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаЕИ.Следующий() Цикл
			Количество = Количество + ПолучитьБазовоеКоличество(ВыборкаЕИ.Количество,ВыборкаЕИ.ЕдиницаИзмерения);
			КонецЦикла; 		
		ТЧ_П = бсНовДок.ВозвратныеОтходы.Добавить();
		ТЧ_П.Номенклатура = бсдНоменклатура;
		//ТЧ_П.НоменклатурнаяГруппа = бсдНоменклатура.НоменклатурнаяГруппа;
		ТЧ_П.НоменклатурнаяГруппа = БухБаза.Справочники.НоменклатурныеГруппы.НайтиПоКоду(НомГруппаКод);
		ТЧ_П.Количество = Количество;
		//ТЧ_П.Цена = ПолучитьЦенуЦена(БухБаза,бсдНоменклатура);
		ТЧ_П.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(ВыборкаМПЗ.МПЗ,КонецДня(Период.ДатаОкончания));
		ТЧ_П.Сумма = ТЧ_П.Количество*ТЧ_П.Цена;
		ТЧ_П.Счет = БухБаза.ПланыСчетов.Хозрасчетный.НайтиПоКоду(СчетУчетаКод);
		ТЧ_П.СтатьяЗатрат = БухБаза.Справочники.СтатьиЗатрат.НайтиПоКоду(СтЗатрКод); 
		КонецЦикла;
			Если бсНовДок.ВозвратныеОтходы.Количество() > 0 Тогда
			бсНовДок.Записать();
			Сообщить("Создан документ Отчёт производства за смену №"+бсНовДок.Номер+" от "+бсНовДок.Дата);
			Иначе
			Сообщить("Документ ""Отчёт производства за смену"" не создан из-за отсутствия МПЗ в базе!!!");
			КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыгрузку(Команда)
РезультатПроверки  = ПроверитьЗаполнениеНаСервере();
	Если Не РезультатПроверки = "" Тогда
		ПоказатьПредупреждение(,РезультатПроверки , , );
		Возврат;
	КонецЕсли;
ВыполнитьВыгрузкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодрНаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.ПодразделенияОрганизаций");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите подразделение",Элемент);
	Если Элемент <> Неопределено Тогда
		ПодрНаименование = ПоказатьПредставлениеБезКода(Элемент.Представление);
		ПодрКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПоказатьПредставлениеБезКода(ТекстПредставления)
	ВозВрат Сред(ТекстПредставления, СтрНайти(ТекстПредставления, "|") + 2); 
КонецФункции

&НаСервере
Процедура ВыбратьЭлемент(СписокЭлементов, Таблица, ТолькоГруппы = Ложь)	
БухБаза = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БухБаза = Неопределено Тогда
	Сообщить("Не открыто соединение с бух. базой!");
	Возврат;
	КонецЕсли;
		Если Найти(Таблица,"ПланСчетов") = 0 Тогда
		ТекстУсловия = ?(БухБаза.String(БухБаза.Метаданные.НайтиПоПолномуИмени(Таблица).ВидИерархии) = "ИерархияГруппИЭлементов",
					   ?(Не ТолькоГруппы,"И НЕ  Таблица.ЭтоГруппа","И Таблица.ЭтоГруппа"), "");
		КонецЕсли;
	бсдЗапрос = БухБаза.NewObject("Запрос");
	бсдЗапрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Код + "" | "" + Таблица.Наименование КАК Представление,
	|	Таблица.Код КАК Код,
	|	Таблица.Наименование КАК Наименование
	|ИЗ
	|	"+Таблица+" КАК Таблица
	|ГДЕ
	|	НЕ Таблица.ПометкаУдаления
	|	"+ТекстУсловия+"
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";	
	бсдВыборка = бсдЗапрос.Выполнить().Выбрать();
	Пока бсдВыборка.Следующий() Цикл
		СписокЭлементов.Добавить(бсдВыборка.Код,бсдВыборка.Представление);
	КонецЦикла;		
КонецПроцедуры

&НаКлиенте
Процедура СтЗатрНаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.СтатьиЗатрат");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите статью затрат", Элемент);
	Если Элемент <> Неопределено Тогда
		СтЗатрНаименование = ПоказатьПредставлениеБезКода(Элемент.Представление);
		СтЗатрКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НомГруппаНаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.НоменклатурныеГруппы");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите номенклатурную группу", Элемент);
	Если Элемент <> Неопределено Тогда
		НомГруппаНаименование = ПоказатьПредставлениеБезКода(Элемент.Представление);
		НомГруппаКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "ПланСчетов.Хозрасчетный");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите счет затрат", Элемент);
	Если Элемент <> Неопределено Тогда
	СчетЗатрат = ПоказатьПредставлениеБезКода(Элемент.Представление);
	СчетЗатратКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "ПланСчетов.Хозрасчетный");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите счет учета", Элемент);
	Если Элемент <> Неопределено Тогда
	СчетУчета = ПоказатьПредставлениеБезКода(Элемент.Представление);
	СчетУчетаКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НастройкиНаСервере()
Настройки = Новый Структура;
Настройки.Вставить("СписокМестХранения",СписокМестХранения);
Настройки.Вставить("ПодрНаименование",ПодрНаименование);
Настройки.Вставить("ПодрКод",ПодрКод);
Настройки.Вставить("НомГруппаНаименование",НомГруппаНаименование);
Настройки.Вставить("НомГруппаКод",НомГруппаКод);
Возврат(Новый Структура("КлючНазначенияИспользования,Настройки","ВыгрузкаРазборок",Настройки));
КонецФункции

&НаКлиенте
Процедура Настройки(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.НастройкиФорм",НастройкиНаСервере());
	Если Результат <> Неопределено Тогда
	СписокМестХранения = Результат.СписокМестХранения;	
	ПодрНаименование = Результат.ПодрНаименование;
	ПодрКод = Результат.ПодрКод;
	НомГруппаНаименование = Результат.НомГруппаНаименование;
	НомГруппаКод = Результат.НомГруппаКод;
	КонецЕсли;
КонецПроцедуры
