﻿
&НаСервере
Функция СоздатьРеализациюИСчётФактуру(БазаСбыта,ПоступлениеТоваровИУслуг,ОшибкиПриВыгрузкеГП)
	Попытка
	бсСклад = БазаСбыта.Справочники.Склады.НайтиПоНаименованию("СД 423",Истина);
	бсНовДок = БазаСбыта.Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	бсНовДок.Дата = ТекущаяДата();
	бсНовДок.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("30");
	бсНовДок.Партнер = БазаСбыта.Справочники.Партнеры.НайтиПоКоду("00-00000010");
	бсНовДок.Контрагент = БазаСбыта.Справочники.Контрагенты.НайтиПоКоду("99999911267");
	бсНовДок.Склад = бсСклад;
	бсНовДок.ХозяйственнаяОперация = БазаСбыта.Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию;
	бсНовДок.НалогообложениеНДС = БазаСбыта.Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	бсНовДок.БанковскийСчетОрганизации = БазаСбыта.ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(бсНовДок.Организация);
	бсНовДок.Валюта = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
	бсНовДок.ВалютаВзаиморасчетов = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
		Для каждого ТЧ Из ПоступлениеТоваровИУслуг.Товары Цикл
		ТЧ_Р = бсНовДок.Товары.Добавить();
		ТЧ_Р.Склад = бсСклад;	
		ТЧ_Р.Номенклатура = ТЧ.Номенклатура;
		ТЧ_Р.ИМНомерЗаказаЗаказнойТовар = ТЧ.ИМНомерЗаказаЗаказнойТовар;
		ТЧ_Р.КоличествоУпаковок = ТЧ.КоличествоУпаковок;
		ТЧ_Р.ИмКоличествоЗарегистрировано = ТЧ.ИмКоличествоЗарегистрировано;
		ТЧ_Р.Количество = ТЧ.Количество;
		ТЧ_Р.СтавкаНДС = ТЧ.СтавкаНДС;
		ТЧ_Р.Цена = ТЧ.Цена;
		ТЧ_Р.Сумма = ТЧ.Сумма;
		ТЧ_Р.СуммаНДС = ТЧ.СуммаНДС;
		ТЧ_Р.СуммаСНДС = ТЧ.СуммаСНДС;
		КонецЦикла;
			Для каждого ТЧ Из ПоступлениеТоваровИУслуг.Штрихкоды Цикл
			ТЧ_ШК = бсНовДок.Штрихкоды.Добавить();	
			ТЧ_ШК.Номенклатура = ТЧ.Номенклатура;
			ТЧ_ШК.ШК = ТЧ.ШК;
			КонецЦикла;
	бсНовДок.Записать(БазаСбыта.РежимЗаписиДокумента.Проведение);
	бсСФ = БазаСбыта.Документы.СчетФактураВыданный.СоздатьДокумент();
	бсСФ.Номер = бсНовДок.Номер;
	бсСФ.Дата = ТекущаяДата();
	бсСФ.ДокументОснование = бсНовДок.Ссылка;
	бсСФ.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("30");
	бсСФ.КодВидаОперации = "01";
	бсСФ.ТипСчетаФактуры = БазаСбыта.Перечисления.ТипыВыданныхСчетовФактур.НаРеализацию;
	бсСФ.ДатаВыставления = ТекущаяДата();
	бсСФ.Записать(БазаСбыта.РежимЗаписиДокумента.Проведение);
	Исключение
	ОшибкиПриВыгрузкеГП = ОшибкиПриВыгрузкеГП+ОписаниеОшибки()+Символы.ПС;
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Ложь);
	КонецПопытки;
Возврат(Истина);
КонецФункции  

&НаСервере
Функция ПолучитьКоличествоВЗаказеНаПроизводство(ЗаказНаПроизводство,Продукция)
Выборка = ЗаказНаПроизводство.Заказ.Найти(Продукция,"Продукция");
	Если Выборка <> Неопределено Тогда
	Возврат(Выборка[0].Количество);
	КонецЕсли;
Возврат(0) 
КонецФункции

&НаСервере
Процедура ВыгрузкаМТК(БазаСбыта,ТорговыйДом,Подразделение,ОшибкиПриВыгрузкеГП)
Запрос = Новый Запрос;
ЗапросШК = Новый Запрос;
СписокМТК = Новый СписокЗначений;	

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Номенклатура КАК Номенклатура,
	|	МаршрутнаяКарта.Количество,
	|	МаршрутнаяКарта.Ссылка,
	|	МаршрутнаяКарта.ДокументОснование КАК ЗаказНаПроизводство
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.Подразделение = &Подразделение
	|	И ТИПЗНАЧЕНИЯ(МаршрутнаяКарта.ДокументОснование) = ТИП(Документ.ЗаказНаПроизводство)
	|	И МаршрутнаяКарта.ДокументОснование.ТорговыйДом = &ТорговыйДом
	|	И МаршрутнаяКарта.Линейка.ВидЛинейки <> &ВидЛинейки
	|	И МаршрутнаяКарта.Проведен = ИСТИНА
	|	И МаршрутнаяКарта.Выгружено = ЛОЖЬ
	|	И МаршрутнаяКарта.Статус = 3
	|ИТОГИ ПО
	|	ЗаказНаПроизводство,
	|	Номенклатура";
Запрос.УстановитьПараметр("Подразделение",Подразделение);
Запрос.УстановитьПараметр("ВидЛинейки",Перечисления.ВидыЛинеек.Канбан);
Запрос.УстановитьПараметр("ТорговыйДом",ТорговыйДом);
РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Попытка
		НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		бсСклад = БазаСбыта.Справочники.Склады.НайтиПоНаименованию("СД 423",Истина);
		бсНовДок = БазаСбыта.Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
		бсНовДок.Дата = ТекущаяДата();
		бсНовДок.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("02");
		бсНовДок.Партнер = БазаСбыта.Справочники.Партнеры.НайтиПоКоду("00-00000010");
		бсНовДок.Склад = бсСклад;
		бсНовДок.ХозяйственнаяОперация = БазаСбыта.Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		бсНовДок.НалогообложениеНДС = БазаСбыта.Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
		бсНовДок.БанковскийСчетОрганизации = БазаСбыта.ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(бсНовДок.Организация);
		бсНовДок.Валюта = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
		бсНовДок.ВалютаВзаиморасчетов = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");

		ВыборкаЗаказыНаПроизводство = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаЗаказыНаПроизводство.Следующий() Цикл
			ВыборкаНоменклатура = ВыборкаЗаказыНаПроизводство.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаНоменклатура.Следующий() Цикл
				СписокМТК.Очистить();
				КоличествоНоменклатуры = 0;
				ВыборкаДетальныеЗаписи = ВыборкаНоменклатура.Выбрать();
					Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					СписокМТК.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
					КоличествоНоменклатуры = КоличествоНоменклатуры + ВыборкаНоменклатура.Количество;
					КонецЦикла;
						Если КоличествоНоменклатуры = ПолучитьКоличествоВЗаказеНаПроизводство(ВыборкаЗаказыНаПроизводство.ЗаказНаПроизводство,ВыборкаНоменклатура.Номенклатура) Тогда
						Артикул = ОбщийМодульВызовСервера.ПолучитьАртикулПоКодуТовара(ВыборкаДетальныеЗаписи.Номенклатура.Товар.Код);
						бсНомен = БазаСбыта.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
							Если бсНомен.Пустая() Тогда
							ОшибкиПриВыгрузкеГП = ОшибкиПриВыгрузкеГП+ВыборкаДетальныеЗаписи.ДокументОснование.Номер+" ("+СокрЛП(ВыборкаНоменклатура.Номенклатура.Товар.Наименование)+") - товар с артикулом "+Артикул+" не найден в торговой базе!"+Символы.ПС;				Продолжить;
							КонецЕсли;
						ТЧ = бсНовДок.Товары.Добавить();
						ТЧ.Склад = бсСклад;	
						ТЧ.Номенклатура = бсНомен;
						ТЧ.ИМНомерЗаказаЗаказнойТовар = ВыборкаЗаказыНаПроизводство.ЗаказНаПроизводство.Номер;
						ТЧ.КоличествоУпаковок = КоличествоНоменклатуры;
						ТЧ.ИмКоличествоЗарегистрировано = КоличествоНоменклатуры;
						ТЧ.Количество = КоличествоНоменклатуры;
						ТЧ.СтавкаНДС = бсНомен.СтавкаНДС;
						ТЧ.Цена = бсНомен.ИмЦена;
						ТЧ.Сумма = ТЧ.КоличествоУпаковок*ТЧ.Цена;
							Если БазаСбыта.Перечисления.СтавкиНДС.Индекс(ТЧ.СтавкаНДС) = БазаСбыта.Перечисления.СтавкиНДС.Индекс(БазаСбыта.Перечисления.СтавкиНДС.НДС18) Тогда
							ТЧ.СуммаНДС = ТЧ.Сумма*0.18;
							ТЧ.СуммаСНДС = ТЧ.Сумма + ТЧ.СуммаНДС;
							ИначеЕсли БазаСбыта.Перечисления.СтавкиНДС.Индекс(ТЧ.СтавкаНДС) = БазаСбыта.Перечисления.СтавкиНДС.Индекс(БазаСбыта.Перечисления.СтавкиНДС.НДС20) Тогда
							ТЧ.СуммаНДС = ТЧ.Сумма*0.2;
							ТЧ.СуммаСНДС = ТЧ.Сумма + ТЧ.СуммаНДС;
							Иначе	
							ТЧ.СуммаСНДС = ТЧ.Сумма;
							КонецЕсли;						
						ЗапросШК.Текст = 
							"ВЫБРАТЬ
							|	БарКоды.БарКод
							|ИЗ
							|	РегистрСведений.БарКоды КАК БарКоды
							|ГДЕ
							|	БарКоды.ПЗ.ДокументОснование В(&СписокМТК)";
						ЗапросШК.УстановитьПараметр("СписокМТК", СписокМТК);
						РезультатЗапроса = Запрос.Выполнить();
						ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
							Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
							ТЧ_ШК = бсНовДок.Штрихкоды.Добавить();	
							ТЧ_ШК.Номенклатура = бсНомен;
							ТЧ_ШК.ШК = ВыборкаДетальныеЗаписи.БарКод;
							КонецЦикла;
								Для каждого Стр Из СписокМТК Цикл
								МТК = Стр.Значение.ПолучитьОбъект();
								МТК.Выгружено = Истина;
								МТК.Записать(РежимЗаписиДокумента.Проведение);
								КонецЦикла;
						КонецЕсли;
				КонецЦикла;
			КонецЦикла;
				Если бсНовДок.Товары.Количество() > 0 Тогда
					Если Найти(Подразделение.Наименование,"УПЭА") > 0 Тогда
					бсНовДок.Комментарий = "Выгрузка УПЭА из производственной базы от "+ТекущаяДата();
					Иначе	
					бсНовДок.Комментарий = "&ДД Выгрузка УД из производственной базы от "+ТекущаяДата();
					КонецЕсли;
				бсНовДок.Записать(БазаСбыта.РежимЗаписиДокумента.Проведение);
					Если ТорговыйДом Тогда
						Если Не СоздатьРеализациюИСчётФактуру(БазаСбыта,бсНовДок.Ссылка,ОшибкиПриВыгрузкеГП) Тогда
						ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
						Возврат;
						КонецЕсли; 
					КонецЕсли; 
				ОшибкиПриВыгрузкеГП = ОшибкиПриВыгрузкеГП+"Создан документ "+бсНовДок.Номер+Символы.ПС;
				КонецЕсли; 
		ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Исключение
		ОшибкиПриВыгрузкеГП = ОшибкиПриВыгрузкеГП+ОписаниеОшибки()+Символы.ПС;
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьНаСервере()
БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БазаСбыта = Неопределено Тогда
	//Константы.ДатаПоследнейВыгрузкиГотовойПродукции.Установить(ТекущаяДата());
	//Константы.ОшибкиПриВыгрузкеГП.Установить("Не открыто соединение с базой сбыта!");
	Сообщить("Не открыто соединение с базой сбыта!");
	Возврат;
	КонецЕсли;
ОшибкиПриВыгрузкеГП = "";
ВыгрузкаМТК(БазаСбыта,Ложь,Справочники.Подразделения.НайтиПоНаименованию("Богородицк УПЭА",Истина),ОшибкиПриВыгрузкеГП);
ВыгрузкаМТК(БазаСбыта,Истина,Справочники.Подразделения.НайтиПоНаименованию("Богородицк УПЭА",Истина),ОшибкиПриВыгрузкеГП);
ВыгрузкаМТК(БазаСбыта,Ложь,Справочники.Подразделения.НайтиПоНаименованию("Богородицк УД",Истина),ОшибкиПриВыгрузкеГП);
ВыгрузкаМТК(БазаСбыта,Истина,Справочники.Подразделения.НайтиПоНаименованию("Богородицк УД",Истина),ОшибкиПриВыгрузкеГП);
ВыгрузкаМТК(БазаСбыта,Ложь,Справочники.Подразделения.НайтиПоНаименованию("Богородицк датчики давления",Истина),ОшибкиПриВыгрузкеГП);
ВыгрузкаМТК(БазаСбыта,Истина,Справочники.Подразделения.НайтиПоНаименованию("Богородицк датчики давления",Истина),ОшибкиПриВыгрузкеГП);
//Константы.ДатаПоследнейВыгрузкиГотовойПродукции.Установить(ТекущаяДата());
//Константы.ОшибкиПриВыгрузкеГП.Установить(ОшибкиПриВыгрузкеГП);
Сообщить(ОшибкиПриВыгрузкеГП);
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Выгрузка в выбранную базу данных...");	
	ВыгрузитьНаСервере();	
	КонецЕсли;
КонецПроцедуры
