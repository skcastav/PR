﻿
&НаСервере
Функция НайтиСоздатьНоменклатуру(БухБаза, Элемент, бсдГруппаПоУмолчанию)   
бсдГруппа = бсдГруппаПоУмолчанию;
	Если Элемент.Уровень()>1 Тогда
	г = БухБаза.Справочники.Номенклатура.НайтиПоНаименованию(Элемент.Родитель.Наименование,-1);
		Если БухБаза.ЗначениеЗаполнено(г) Тогда
		бсдГруппа = г;	
		КонецЕсли;
	КонецЕсли;
ПолныйКод = СтрЗаменить(Элемент.ПолныйКод(),"/","-");
ПолныйКод = СокрЛП(СтрЗаменить(ПолныйКод,Символы.НПП,""));	
Ном = БухБаза.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", ПолныйКод);
	Если Не БухБаза.ЗначениеЗаполнено(Ном) Тогда		
	НомОбъект = БухБаза.Справочники.Номенклатура.СоздатьЭлемент();
 	НомОбъект.Артикул 				= ПолныйКод;
 	НомОбъект.Родитель 				= бсдГруппа;					
	НомОбъект.ПометкаУдаления 		= Элемент.ПометкаУдаления;
  	НомОбъект.НаименованиеПолное 	= Элемент.ПолнНаименование;
 	НомОбъект.Наименование 			= Элемент.Наименование;	
 	ЕдИзм = БухБаза.Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию(Элемент.ЕдиницаИзмерения.Наименование);
	 	Если Не БухБаза.ЗначениеЗаполнено(ЕдИзм) Тогда
 		ЕдИзмОбъект = БухБаза.Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент(); 		
 	    ЕдИзмОбъект.Наименование 		= Элемент.ЕдиницаИзмерения.Наименование;
 	    ЕдИзмОбъект.НаименованиеПолное 	= Элемент.ЕдиницаИзмерения.ПолнНаименование;
 	    ЕдИзмОбъект.Код 				= Элемент.ЕдиницаИзмерения.Код;
 		ЕдИзмОбъект.Записать();
 		ЕдИзм = ЕдИзмОбъект.Ссылка;
	 	КонецЕсли;	 	
 	НомОбъект.ЕдиницаИзмерения = ЕдИзм;	
 	НомОбъект.СтавкаНДС =  БухБаза.Перечисления.СтавкиНДС.НДС18;
 	НомОбъект.Записать(); 
 	Сообщить("Выгружен МПЗ "+ НомОбъект.Наименование + " ("+ПолныйКод+")");
 	Возврат НомОбъект.Ссылка;
 	Иначе
	Возврат Ном;
 	КонецЕсли;	
КонецФункции

&НаСервере
Процедура ВыгрузитьНаСервере() 
БухБаза = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БухБаза = Неопределено Тогда
	Возврат;
	КонецЕсли;
бсдМенеджерНоменклатура = БухБаза.Справочники.Номенклатура;
бсдМенеджерСклады		= БухБаза.Справочники.Склады;
бсдМенеджерДокументы	= БухБаза.Документы.ТребованиеНакладная;
бсдМенеджерСтЗатр		= БухБаза.Справочники.СтатьиЗатрат;
бсдМенеджерПодр			= БухБаза.Справочники.ПодразделенияОрганизаций;
бсдМенеджерНомГрупп		= БухБаза.Справочники.НоменклатурныеГруппы;

	Если ЗначениеЗаполнено(Объект.ГруппаНоменклатурыКод) Тогда
	бсдГрНомПоУмолчанию = бсдМенеджерНоменклатура.НайтиПоКоду(СокрЛП(Объект.ГруппаНоменклатурыКод));
	Иначе
	бсдГрНомПоУмолчанию = бсдМенеджерНоменклатура.ПустаяСсылка();	
	КонецЕсли;

бсдНовДок = бсдМенеджерДокументы.СоздатьДокумент();
БухБаза.ЗаполнениеДокументов.Заполнить(бсдНовДок);
БухБаза.ЗаполнениеДокументов.ЗаполнитьПодразделениеЗатрат(бсдНовДок.ПодразделениеЗатрат, бсдНовДок.Организация);
	Если РучнаяНумерация Тогда
	бсдНовДок.Номер = СокрЛП(НомерДок);
	Иначе
	бсдНовДок.УстановитьНовыйНомер();
	КонецЕсли;	
бсдНовДок.Дата = КонецМесяца(Объект.Период.ДатаОкончания);
бсдНовДок.Склад = бсдМенеджерСклады.НайтиПоКоду(СокрЛП(Объект.МестоХраненияКод));
бсдНовДок.СчетЗатрат = БухБаза.ПланыСчетов.Хозрасчетный.ОсновноеПроизводство;
бсдНовДок.Субконто1 = бсдМенеджерНомГрупп.НайтиПоКоду(СокрЛП(Объект.НоменклатурнаяГруппаКод));
бсдНовДок.Субконто2 = бсдМенеджерСтЗатр.НайтиПоКоду(СокрЛП(Объект.СтатьяЗатратКод));
бсдНовДок.ПодразделениеЗатрат = бсдМенеджерПодр.НайтиПоКоду(СокрЛП(Объект.ПодразделениеЗатратКод));
бсдНовДок.Комментарий 	= "#Выгрузка из производства за период с "+Формат(Объект.Период.ДатаНачала,"ДФ=dd.MM.yyyy")+" по "+Формат(Объект.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");

бсдДанныеОб = БухБаза.NewObject("Структура");
бсдДанныеОб.Вставить("Организация",	бсдНовДок.организация);
бсдДанныеОб.Вставить("Дата", 		бсдНовДок.Дата);
бсдДанныеОб.Вставить("Склад", 		бсдНовДок.Склад);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПередачиВПроизводствоОбороты.КоличествоПриход,
	|	ПередачиВПроизводствоОбороты.МПЗ
	|ИЗ
	|	РегистрНакопления.ПередачиВПроизводство.Обороты(&ДатаНач, &ДатаКон, , ВидМПЗ = &ВидМПЗ) КАК ПередачиВПроизводствоОбороты";
Запрос.УстановитьПараметр("ВидМПЗ", Перечисления.ВидыМПЗ.Материалы);
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Объект.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Объект.Период.ДатаОкончания));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	бсдНоменклатура = НайтиСоздатьНоменклатуру(БухБаза, ВыборкаДетальныеЗаписи.МПЗ, бсдГрНомПоУмолчанию);	
		Если Не БухБаза.ЗначениеЗаполнено(бсдНоменклатура) Тогда
		Сообщить("Не найден МПЗ "+ВыборкаДетальныеЗаписи.МПЗ);
		Продолжить;	                                     
		КонецЕсли;		
	бсдНовСтр = бсдНовДок.Материалы.Добавить();
	бсдНовСтр.Номенклатура = бсдНоменклатура;
	бсдНомСв = БухБаза.БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(бсдНоменклатура, бсдДанныеОб);
	бсдНовСтр.Количество = ВыборкаДетальныеЗаписи.КоличествоПриход; 
	бсдНовСтр.ЕдиницаИзмерения = бсдНомСв.ЕдиницаИзмерения;
	бсдНовСтр.Коэффициент = бсдНомСв.Коэффициент;
	БухБаза.Документы.ТребованиеНакладная.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(бсдНовДок, бсдНовСтр, "Материалы", бсдНомСв);
	КонецЦикла;
		Если бсдНовДок.Материалы.Количество() > 0 Тогда
		бсдНовДок.Записать();
		Сообщить("Создан документ Требование-накладная №"+бсдНовДок.Номер+" от "+бсдНовДок.Дата);		
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Выгрузка в выбранную базу данных...");	
	ВыгрузитьНаСервере();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыбратьЭлемент(СписокЭлементов, Таблица, ТолькоГруппы = Ложь)	
БухБаза = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БухБаза = Неопределено Тогда
	Возврат;
	КонецЕсли;
ТекстУсловия = ?(БухБаза.String(БухБаза.Метаданные.НайтиПоПолномуИмени(Таблица).ВидИерархии) = "ИерархияГруппИЭлементов",
			   ?(Не ТолькоГруппы,"И НЕ  Таблица.ЭтоГруппа","И Таблица.ЭтоГруппа"), "");
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
Процедура ГруппаНоменклатурыПоУмолчаниюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.Номенклатура", Истина);
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите группу номенклатуры",Элемент);
	Если Элемент <> Неопределено Тогда
	Объект.ГруппаНоменклатуры = Элемент.Представление;
	Объект.ГруппаНоменклатурыКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.ПодразделенияОрганизаций");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите подразделение",Элемент);
	Если Элемент <> Неопределено Тогда
	Объект.ПодразделениеЗатрат = Элемент.Представление;
	Объект.ПодразделениеЗатратКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатьяЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.СтатьиЗатрат");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите статью затрат",Элемент);
	Если Элемент <> Неопределено Тогда
	Объект.СтатьяЗатрат = Элемент.Представление;
	Объект.СтатьяЗатратКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.Склады");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите склад",Элемент);
	Если Элемент <> Неопределено Тогда
	Объект.МестоХранения = Элемент.Представление;
	Объект.МестоХраненияКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатурнаяГруппаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.НоменклатурныеГруппы");
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите номенклатурную группу",Элемент);
	Если Элемент <> Неопределено Тогда
	Объект.НоменклатурнаяГруппа = Элемент.Представление;
	Объект.НоменклатурнаяГруппаКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры
