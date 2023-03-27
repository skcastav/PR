﻿
&НаКлиенте
Перем КлючФЗ,КлючВХ;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
	Если Объект.Исполнитель.Пустая() Тогда
	Элементы.РабочееМесто.Доступность = Ложь;
	Сообщить("Вы не внесены в справочник Сотрудников! Работа невозможна!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОписаниеОшибки = "";
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
      ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не Объект.ПроизводственноеЗадание.Пустая() Тогда
		Если Вопрос("Задание не завершено. Вы действительно хотите авторизоваться?",РежимДиалогаВопрос.ДаНет,,,"ВНИМАНИЕ!") = КодВозвратаДиалога.Нет Тогда
		СтандартнаяОбработка = Ложь;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево(ЭтапСпецификации)
Объект.Спецификация.Сортировать("ТипСправочника Убыв,ВидМПЗ,Позиция,МПЗ");
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ТипСпр = "";
	Для каждого ТЧ Из Объект.Спецификация Цикл
		Если ТЧ.ЭтапСпецификации <> ЭтапСпецификации Тогда
		Продолжить;		
		КонецЕсли; 
			Если ТипСпр <> ТЧ.ТипСправочника Тогда
			Стр = тДерево.Строки.Добавить();
			Стр.ТипСправочника = ТЧ.ТипСправочника;
			ТипСпр = ТЧ.ТипСправочника;
			КонецЕсли; 
	СтрЗнч = Стр.Строки.Добавить();
	СтрЗнч.Позиция = ТЧ.Позиция;
	СтрЗнч.ВидЭлемента = ТЧ.ВидМПЗ;
	СтрЗнч.МПЗ = ТЧ.МПЗ;
	СтрЗнч.Количество = ТЧ.Количество;
	СтрЗнч.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения;
	СтрЗнч.Аналог = ТЧ.Аналог;
	СтрЗнч.Примечание = ТЧ.Примечание;
		Если ТЧ.Владелец <> Неопределено Тогда
		СтрЗнч.Владелец = ТЧ.Владелец.Элемент;
		КонецЕсли; 		 
	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоСпецификации");
КонецПроцедуры

&НаСервере
Функция ПолучитьЗаданиеНаСервере()
Результат = ОбщийМодульАРМ.ПолучитьНезавершенноеЗадание(Этапы,ЭтапыАРМ,Объект.РабочееМесто,Объект.Исполнитель);
	Если Результат <> Неопределено Тогда 
	Объект.ПроизводственноеЗадание = Результат.ПЗ;
	Возврат(1);
	КонецЕсли;
НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
КолПЗ = 0;

СписокИзделийЛО = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала КАК ДатаНачала,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних(, РабочееМесто = &РабочееМесто) КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ                                                                            
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2";
	Если Объект.РабочееМесто.ОбработкаЗаданийПоВремениПоступления Тогда
	Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО ЭтапыПроизводственныхЗаданийСрезПоследних.Период
									|ИТОГИ ПО ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование";
	Иначе                           
	Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.НомерОчереди,
									|ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.ДатаОтгрузки,
									|ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер
									|ИТОГИ ПО ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование";
	КонецЕсли;
Запрос.УстановитьПараметр("РабочееМесто",Объект.РабочееМесто);
Результат = Запрос.Выполнить();
ВыборкаМТК = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМТК.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаМТК.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолПЗ = КолПЗ + 1;
			Если СписокИзделийЛО.НайтиПоЗначению(ВыборкаДетальныеЗаписи.ПЗ.Изделие) <> Неопределено Тогда
			Прервать; //Переходим к следующей МТК
			КонецЕсли;
				Если Не ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,Объект.РабочееМесто,Объект.Исполнитель) Тогда	
				Прервать; //Переходим к следующей МТК			
				КонецЕсли; 
					Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска) Тогда
					Результат = ОбщийМодульВызовСервера.ЗапуститьВПроизводство(ВыборкаДетальныеЗаписи.ПЗ,Объект.РабочееМесто,Этапы,,Ложь);
						Если Результат = 0 Тогда
						СписокИзделийЛО.Добавить(ВыборкаДетальныеЗаписи.ПЗ.Изделие);
						Прервать; //Переходим к следующей МТК
						ИначеЕсли Результат = -1 Тогда
						Возврат(-1);
						КонецЕсли; 
					КонецЕсли;
		Объект.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		ОкончаниеЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ОбщийМодульРаботаСРегистрами.СборИнформацииПоАРМ(1,Объект.РабочееМесто,Объект.ПроизводственноеЗадание.Изделие,КолПЗ,(ОкончаниеЗамера - НачалоЗамера)/1000);
		Возврат(1);
		КонецЦикла;
	КонецЦикла;
ОкончаниеЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбщийМодульРаботаСРегистрами.СборИнформацииПоАРМ(1,Объект.РабочееМесто,Справочники.Номенклатура.ПустаяСсылка(),КолПЗ,(ОкончаниеЗамера - НачалоЗамера)/1000);
Возврат(0);
КонецФункции

&НаСервере      
Функция ПолучитьСледующееПЗ(Адрес)
ТекстФоновойПроцедуры = "ФоновоеВыполнение.ПолучитьСледующееЗаданиеНаСервере(РабочееМесто,Исполнитель,ПроизводственноеЗадание,Адрес);";                                                                                                                                                                                                                        
ПараметрыФЗ = Новый Структура("РабочееМесто,Исполнитель,ПроизводственноеЗадание,Адрес",Объект.РабочееМесто,Объект.Исполнитель,Объект.ПроизводственноеЗадание,Адрес);
Ключ = ФоновоеВыполнение.ЗапуститьФоновоеВыполнение(ТекстФоновойПроцедуры,ПараметрыФЗ);
Возврат(Ключ);
КонецФункции  
   
&НаСервере   
Функция ПолучитьСостояниеФЗ(Ключ) 
Возврат(ФоновоеВыполнение.НайтиЗадание(Ключ));
КонецФункции 
           
&НаСервере
Процедура ПолучитьРезультатФЗ(КлючВХ)
ПараметрыФЗ = ПолучитьИзВременногоХранилища(КлючВХ);                                   
ПроизводственноеЗаданиеСледующее = ПараметрыФЗ.ПроизводственноеЗаданиеСледующее;
ЭтапыАРМСледующее.ЗагрузитьЗначения(ПараметрыФЗ.ЭтапыАРМСледующее.ВыгрузитьЗначения());
ЭтапыСледующее.Загрузить(ПараметрыФЗ.ЭтапыСледующее);
КонецПроцедуры

&НаКлиенте   
Функция СостояниеФЗ() Экспорт 
Результат = ПолучитьСостояниеФЗ(КлючФЗ);
	Если Результат.Выполняется Тогда
	Элементы.ПоискПЗ.Заголовок = "Выполняется поиск следующего задания...";
	ИначеЕсли Результат.Успех Тогда	
	Элементы.ПоискПЗ.Заголовок = "";
	ОтключитьОбработчикОжидания("СостояниеФЗ");
	ПолучитьРезультатФЗ(КлючВХ);
	КлючФЗ = Неопределено;
	Иначе
   	Элементы.ПоискПЗ.Заголовок = Результат.Ошибка;
	ОтключитьОбработчикОжидания("СостояниеФЗ");
	КлючФЗ = Неопределено;
	КонецЕсли;
Возврат(Не Результат.Выполняется);
КонецФункции

&НаКлиенте
Процедура ПолучитьСледущееЗаданиеВФоне()
КлючВХ = ПоместитьВоВременноеХранилище(Неопределено,ЭтаФорма.КлючУникальности);
КлючФЗ = ПолучитьСледующееПЗ(КлючВХ);
ПодключитьОбработчикОжидания("СостояниеФЗ",1,Ложь);	
КонецПроцедуры
 
&НаСервере
Функция ПолучитьIMEI()
Код = "";
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1; 
	НаборЗаписей = РегистрыСведений.БарКоды.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл
		Выборка = Справочники.КодыIMEI.Выбрать();
			Пока Выборка.Следующий() Цикл
			Код = Выборка.Код;
			Прервать;
			КонецЦикла; 
				Если ЗначениеЗаполнено(Код) Тогда
				Запись.IMEI = Код;						
				Иначе
				Сообщить("Нет свободных кодов IMEI!");
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат("");						
				КонецЕсли;   
	    КонецЦикла;
	НаборЗаписей.Записать(Истина);
	КодIMEI = Справочники.КодыIMEI.НайтиПоКоду(Код);
		Если Не КодIMEI.Пустая() Тогда
		ЭлементУдаления = КодIMEI.ПолучитьОбъект();
		ЭлементУдаления.Удалить();
		КонецЕсли; 
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат("");
	КонецПопытки;		 
Возврат(Код);
КонецФункции

&НаСервере
Процедура ПолучитьДополнительныеКоды()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	БарКоды.MAC КАК MAC,
	|	БарКоды.IMEI КАК IMEI,
	|	БарКоды.КодDanfoss КАК КодDanfoss,
	|	БарКоды.BT КАК BT
	|ИЗ
	|	РегистрСведений.БарКоды КАК БарКоды
	|ГДЕ
	|	БарКоды.ПЗ = &ПЗ";
Запрос.УстановитьПараметр("ПЗ", Объект.ПроизводственноеЗадание);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	КодDanfoss = ВыборкаДетальныеЗаписи.КодDanfoss;
	IMEI = ВыборкаДетальныеЗаписи.IMEI;
	MAC = ВыборкаДетальныеЗаписи.MAC;
	BT = ВыборкаДетальныеЗаписи.BT;
	КонецЦикла;
Элементы.КодDanfoss.Видимость = Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяКодDanfoss;
	Если Не Объект.ПроизводственноеЗадание.Изделие.Товар.ТоварнаяГруппа.НумераторMAC.Пустая()или
		 Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяMACАдрес Тогда
	Элементы.MAC.Видимость = Истина;
	КонецЕсли;
Элементы.BT.Видимость = Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяBT_IMEI;
	Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяIMEI Тогда
	Элементы.IMEI.Видимость = Истина;
	КонецЕсли;
		Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяBT_IMEI Тогда
		Элементы.IMEI.Видимость = Истина;
			Если Не ЗначениеЗаполнено(IMEI) Тогда
			IMEI = ПолучитьIMEI();
			КонецЕсли;
		КонецЕсли;
КонецПроцедуры 

&НаСервере
Функция ПолучитьНомерВТ()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РемонтнаяКарта.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РемонтнаяКарта КАК РемонтнаяКарта
	|ГДЕ
	|	РемонтнаяКарта.ДокументОснование = &ДокументОснование
	|	И РемонтнаяКарта.РабочееМесто = &РабочееМесто
	|	И РемонтнаяКарта.ВозвратнаяТара = &ВозвратнаяТара";
Запрос.УстановитьПараметр("ВозвратнаяТара", Объект.ПроизводственноеЗадание.ВозвратнаяТара);
Запрос.УстановитьПараметр("ДокументОснование", Объект.ПроизводственноеЗадание);
Запрос.УстановитьПараметр("РабочееМесто", Объект.РабочееМесто);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(Новый Структура("ВозвратнаяТара,Ремонт",СокрЛП(ВыборкаДетальныеЗаписи.Ссылка.ВозвратнаяТара),Истина));
	КонецЦикла;
Возврат(Новый Структура("ВозвратнаяТара,Ремонт",Объект.ПроизводственноеЗадание.ВозвратнаяТара,Ложь));
КонецФункции 

&НаСервере
Функция ПолучитьСпецификациюЭтапов()
Возврат(ОбщийМодульАРМ.ПолучитьСпецификациюЭтапов(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Этапы,Объект.Спецификация,ТаблицаКомплектации));
КонецФункции
 
&НаСервере          
Процедура ПолучитьСледующее()
Объект.ПроизводственноеЗадание = ПроизводственноеЗаданиеСледующее;
Этапы.Загрузить(ЭтапыСледующее.Выгрузить());
ЭтапыАРМ = ЭтапыАРМСледующее.Скопировать();
ОчиститьСсылкуНаПЗСледующее();
КонецПроцедуры 

&НаКлиенте
Процедура ПолучитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ОстановкаЛинейки(Объект.РабочееМесто) Тогда
		Если ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Объект.РабочееМесто,"Код") = 1 Тогда
			Если Вопрос("Линейка остановлена! Снять остановку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				Если Не ОбщийМодульРаботаСРегистрами.СнятьОстановкуЛинейки(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда	
				Возврат;
				КонецЕсли;
			Иначе
			Возврат;			
			КонецЕсли;
		Иначе
		Возврат; 
		КонецЕсли;
	КонецЕсли;                                          
		Если КлючФЗ <> Неопределено Тогда
			Если Не СостояниеФЗ() Тогда
			Предупреждение("Дождитесь окончания выполнения автоматического получения задания!",5,"Внимание!");
			Возврат;
			КонецЕсли;
		КонецЕсли;
			Если ПроизводственноеЗаданиеСледующее.Пустая() Тогда
			Состояние("Обработка...",,"Получение задания...");
			Результат = ПолучитьЗаданиеНаСервере();
			Иначе 
			ПолучитьСледующее();
			Результат = 1;
			КонецЕсли;  
				Если Результат = 1 Тогда 
				Рез = ПолучитьНомерВТ(); 
				НомерВТ = Рез.ВозвратнаяТара; 
				Элементы.НомерВТ.Заголовок = ?(Рез.Ремонт = Истина,"№ в.т.(ремонтная)","№ в.т.");
				Элементы.НомерВТ.ЦветТекста = ?(Рез.Ремонт = Истина,Новый Цвет(255,0,0),Новый Цвет(0,0,0));
					Если ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Объект.РабочееМесто,"ВозвратнаяТара") Тогда
						Если Не ЗначениеЗаполнено(НомерВТ) Тогда			
							Если ВвестиСтроку(НомерВТ,"Введите номер возвратной тары",4) Тогда
								Если Не ОбщийМодульВызовСервера.СохранитьНомерВозвратнойТары(Объект.ПроизводственноеЗадание,НомерВТ) Тогда
								Сообщить("Номер возвратной тары не введён!");
								ОчиститьСсылкуНаПЗ();
								Возврат;
								КонецЕсли;
							Иначе
							Сообщить("Номер возвратной тары не введён!");
							ОчиститьСсылкуНаПЗ();
							Возврат;
							КонецЕсли;			
						КонецЕсли; 		
					КонецЕсли;
				ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(Объект.ПроизводственноеЗадание,Новый Структура("РабочееМесто,Исполнитель,ДатаНачала",Объект.РабочееМесто,Объект.Исполнитель,ТекущаяДата())); 
				ПолучитьСпецификациюЭтапов();
				ПолучитьДополнительныеКоды();
					Если ТипЗнч(ТаблицаКомплектации[0].Комплектация) = Тип("СправочникСсылка.Номенклатура") Тогда
					Элементы.ТаблицаКомплектации.ТекущаяСтрока = ТаблицаКомплектации[0].ПолучитьИдентификатор();
					ТаблицаКомплектацииВыборЗначения(Элементы.ТаблицаКомплектации,Элементы.ТаблицаКомплектации.ТекущаяСтрока,Истина);
					КонецЕсли;
				Элементы.Завершить.КнопкаПоУмолчанию = Истина;
				Элементы.ПолучитьЗадание.Доступность = Ложь;
				Элементы.ОбщаяКомандаПростойЛинейки.Доступность = Ложь;
				Элементы.Гравировка.Доступность = Истина;
				Элементы.ПечатьБарКода.Доступность = Истина;
				Элементы.Завершить.Доступность = Истина;
				Элементы.Ремонт.Доступность = Истина;
				Элементы.Прошивка.Доступность = Истина;
				Элементы.ВвестиКоды.Доступность = Истина;
				ТекДата = ТекущаяДата() - НачалоДня(ТекущаяДата());
					//Если (ТекДата < 41400) или ((ТекДата > 46800) и (ТекДата < 59400)) Тогда //11.30, 13.00, 16.30
					Если ТекДата < 59400 Тогда //16.30
					ПолучитьСледущееЗаданиеВФоне();
					КонецЕсли;		 
				Иначе
				Сообщить("Нет производственных заданий!");  		
				КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ОчиститьСсылкуНаПЗ()
Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
НомерВТ = "";
Элементы.НомерВТ.Заголовок = "№ в.т.";
Элементы.НомерВТ.ЦветТекста = Новый Цвет(255,255,255);
КодDanfoss = "";
MAC = "";
BT = "";
Этапы.Очистить();
ЭтапыАРМ.Очистить();
ТаблицаКомплектации.Очистить();
Объект.Спецификация.Очистить();
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ЗначениеВРеквизитФормы(тДерево,"ДеревоСпецификации");
Элементы.ПолучитьЗадание.КнопкаПоУмолчанию = Истина;
Элементы.ПолучитьЗадание.Доступность = Истина;
Элементы.ОбщаяКомандаПростойЛинейки.Доступность = Истина;
Элементы.Гравировка.Доступность = Ложь;
Элементы.ПечатьБарКода.Доступность = Ложь;
Элементы.Завершить.Доступность = Ложь;
Элементы.Ремонт.Доступность = Ложь;
Элементы.Прошивка.Доступность = Ложь;
Элементы.ВвестиКоды.Доступность = Ложь;
Элементы.КодDanfoss.Видимость = Ложь;
Элементы.IMEI.Видимость = Ложь;
Элементы.MAC.Видимость = Ложь;
Элементы.BT.Видимость = Ложь;
КонецПроцедуры  

&НаСервере
Процедура ОчиститьСсылкуНаПЗСледующее()
ПроизводственноеЗаданиеСледующее = Документы.ПроизводственноеЗадание.ПустаяСсылка();
ЭтапыСледующее.Очистить();
ЭтапыАРМСледующее.Очистить();
КонецПроцедуры

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(Объект.РабочееМесто.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура РабочееМестоПриИзменении(Элемент)
	Если Не МожноРаботатьВАРМ() Тогда
	Возврат;
	КонецЕсли;
ОчиститьСсылкуНаПЗ();
ОчиститьСсылкуНаПЗСледующее();
Элементы.ОбщаяКомандаПростойЛинейки.Видимость = ?(ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(Объект.РабочееМесто,"Код") = 1,Истина,Ложь);
ПрефиксРМ = ОбщийМодульВызовСервера.ПолучитьПрефиксРабочегоМеста(Объект.РабочееМесто);
	Если ПрефиксРМ = "СБ" Тогда
	Элементы.Прошивка.Видимость = Ложь;
	Элементы.Гравировка.Видимость = Истина;
	Элементы.ПечатьБарКода.Видимость = Истина;
	ИначеЕсли ПрефиксРМ = "НЛ" Тогда
	Элементы.Прошивка.Видимость = Истина;
	Элементы.Гравировка.Видимость = Ложь;
	Элементы.ПечатьБарКода.Видимость = Ложь;
	ИначеЕсли ПрефиксРМ = "РД" Тогда
	Элементы.Прошивка.Видимость = Истина;
	Элементы.Гравировка.Видимость = Ложь;
	Элементы.ПечатьБарКода.Видимость = Ложь;
	Иначе
	Элементы.Прошивка.Видимость = Ложь;
	Элементы.Гравировка.Видимость = Ложь;
	Элементы.ПечатьБарКода.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗавершитьЗаданиеНаСервере()
	Попытка
	ДатаЗавершения = ТекущаяДата();
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	НовоеРабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
	флТекущийЭтапПоследний = Ложь;
	ТекРМ = ЭтапыАРМ.НайтиПоЗначению(Объект.РабочееМесто);
		Если ТекРМ <> Неопределено Тогда
		НомСтр = ЭтапыАРМ.Индекс(ТекРМ)+1;
			Если НомСтр <> ЭтапыАРМ.Количество() Тогда
				Для к = НомСтр По ЭтапыАРМ.Количество()-1 Цикл
					Если ЭтапыАРМ[к].Значение.Авторизовано Тогда
					НовоеРабочееМесто = ЭтапыАРМ[к].Значение;
					Прервать;
					КонецЕсли; 
				КонецЦикла; 	
			Иначе
			флТекущийЭтапПоследний = Истина;			
			КонецЕсли; 
		Иначе
		Сообщить("В списке этапов рабочих мест этого изделия не найдено текущее рабочее место!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат("");		
		КонецЕсли;
			Если НовоеРабочееМесто.Пустая() Тогда
				Если Не флТекущийЭтапПоследний Тогда
				Сообщить("Нет авторизованных рабочих мест!");
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат("");
				КонецЕсли; 
			Иначе
			ПрефиксРМ = ОбщийМодульВызовСервера.ПолучитьПрефиксРабочегоМеста(НовоеРабочееМесто);
			КонецЕсли;
	НаборЗаписей = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
	    	Если Запись.РабочееМесто = Объект.РабочееМесто Тогда
			Запись.ДатаОкончания = ДатаЗавершения;
			Прервать;
			КонецЕсли;  
	    КонецЦикла;
			Если Не флТекущийЭтапПоследний Тогда
			МестоПередачи = "на "+СокрЛП(НовоеРабочееМесто.Наименование);
			ЭПЗ = НаборЗаписей.Добавить();
			ЭПЗ.Период = ДатаЗавершения;
			ЭПЗ.ПЗ = Объект.ПроизводственноеЗадание; 
			ЭПЗ.Линейка = Объект.ПроизводственноеЗадание.Линейка;
			ЭПЗ.Изделие = Объект.ПроизводственноеЗадание.Изделие;
			ЭПЗ.Количество = 1;
			ЭПЗ.БарКод = Объект.ПроизводственноеЗадание.БарКод;
			ЭПЗ.РабочееМесто = НовоеРабочееМесто;
				Если ПрефиксРМ = "СТ" Тогда
				ЭПЗ.ДатаНачала = ДатаЗавершения;	
				ЭПЗ.Исполнитель = НовоеРабочееМесто.Стенд.Исполнитель;	
				СП = РегистрыСведений.СтендовыйПрогон.СоздатьМенеджерЗаписи();
				СП.Период = ДатаЗавершения;
				СП.ПЗ = Объект.ПроизводственноеЗадание;
				СП.Изделие = Объект.ПроизводственноеЗадание.Изделие;
				СП.БарКод = Объект.ПроизводственноеЗадание.БарКод;
				СП.Стенд = НовоеРабочееМесто.Стенд;
				СП.Прогон = 1;
				СП.ИсполнительПоступление = НовоеРабочееМесто.Стенд.Исполнитель;
				СП.ДатаПоступления = ДатаЗавершения;
				СП.ИсполнительПостановка = НовоеРабочееМесто.Стенд.Исполнитель;
				СП.ДатаПостановки = ДатаЗавершения;
				СП.Записать();		
				КонецЕсли;
					Если НовоеРабочееМесто.ГруппаРабочихМест <> Объект.РабочееМесто.ГруппаРабочихМест Тогда
						Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Объект.Спецификация,Этапы,ДатаЗавершения) Тогда
						Сообщить("Документ выпуска не создан!");
						ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
						Возврат("");
						КонецЕсли; 		
					КонецЕсли;
						Если Не НовоеРабочееМесто.ВозвратнаяТара Тогда					
							Если ЗначениеЗаполнено(НомерВТ) Тогда
							ОбщийМодульВызовСервера.ОчиститьНомерВозвратнойТары(Объект.ПроизводственноеЗадание);					
							КонецЕсли;					
						КонецЕсли;
			Иначе
				Если Объект.ПроизводственноеЗадание.ДокументОснование.Ремонт Тогда
					Если Найти(Объект.ПроизводственноеЗадание.ДокументОснование.СтандартныйКомментарий.Наименование,"Полуфабрикаты для СЦ") > 0 Тогда
					МестоПередачи = "на склад сервис-центров";
					Иначе	
					МестоПередачи = "ремонтнику";
					КонецЕсли;	
				Иначе
				МестоПередачи = "на склад линейки";
				КонецЕсли; 
					Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Объект.Спецификация,Этапы,ДатаЗавершения) Тогда
					Сообщить("Документ выпуска не создан!"); 
					ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
					Возврат("");
					КонецЕсли;			
			КонецЕсли;
	НаборЗаписей.Записать();
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(МестоПередачи);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат("");
	КонецПопытки;
КонецФункции

&НаСервере
Функция ПроверкаВводаКодов()
Запрос = Новый Запрос;

флНайден = Истина;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	БарКоды.MAC КАК MAC,
	|	БарКоды.IMEI КАК IMEI,
	|	БарКоды.КодDanfoss КАК КодDanfoss,
	|	БарКоды.BT КАК BT
	|ИЗ
	|	РегистрСведений.БарКоды КАК БарКоды
	|ГДЕ
	|	БарКоды.ПЗ = &ПЗ";
Запрос.УстановитьПараметр("ПЗ", Объект.ПроизводственноеЗадание);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяКодDanfoss и
			 Объект.РабочееМесто.ВводКодDanfoss Тогда
			Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.КодDanfoss) Тогда
			Сообщить("Не внесён код Danfoss!");
			флНайден = Ложь;
			КонецЕсли;		
		КонецЕсли;
		Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяIMEI и
			 Объект.РабочееМесто.ВводIMEI Тогда
			Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.IMEI) Тогда
			Сообщить("Не внесён IMEI!");
			флНайден = Ложь;
			КонецЕсли;		
		КонецЕсли;
		Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяMACАдрес и
			 Объект.РабочееМесто.ВводMACАдрес Тогда
			Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.MAC) Тогда
			Сообщить("Не внесён MAC-адрес!");
			флНайден = Ложь;
			КонецЕсли;		
		КонецЕсли;
		Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяBT_IMEI и
			 Объект.РабочееМесто.ВводBT Тогда
			Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.BT) Тогда
			Сообщить("Не внесён код BT!");
			флНайден = Ложь;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.IMEI) Тогда
			Сообщить("Не внесён IMEI!");
			флНайден = Ложь;
			КонецЕсли;		
		КонецЕсли; 
	КонецЦикла;
Возврат(флНайден);
КонецФункции 

&НаКлиенте
Процедура ЗавершитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ЛинейкаОстановлена(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда
	Возврат;
	КонецЕсли;
		Если Не ПроверкаВводаКодов() Тогда
		Возврат; 
		КонецЕсли;
МестоПередачи = ЗавершитьЗаданиеНаСервере();
	Если МестоПередачи <> "" Тогда
	ОчиститьСсылкуНаПЗ();
	ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"Передайте изделие "+МестоПередачи,БиблиотекаКартинок.Пользователь);
		Если (МестоПередачи = "ремонтнику")или(МестоПередачи = "на склад сервис-центров") Тогда
		Предупреждение("Передайте изделие "+МестоПередачи+"!",5,"ВНИМАНИЕ!");
		КонецЕсли; 
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЭтапов()
СписокЭтапов = Новый СписокЗначений;
	Для каждого ТЧ Из ТаблицаКомплектации Цикл
		Если СписокЭтапов.НайтиПоЗначению(ТЧ.ЭтапСпецификации) = Неопределено Тогда
		СписокЭтапов.Добавить(ТЧ.ЭтапСпецификации);
		КонецЕсли; 
	КонецЦикла;
Возврат(СписокЭтапов);
КонецФункции 

&НаКлиенте
Процедура Ремонт(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ОформлениеРемонта",Новый Структура("РабочееМесто,ПроизводственноеЗадание,Исполнитель,Этапы",Объект.РабочееМесто,Объект.ПроизводственноеЗадание,Объект.Исполнитель,Этапы));
	Если Результат <> Неопределено Тогда
	ОчиститьСсылкуНаПЗ(); 
	КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБарКода(Команда)
ОткрытьФорму("Обработка.СозданныеБарКоды.Форма.Форма",Новый Структура("ПЗ,РабочееМесто",Объект.ПроизводственноеЗадание,Объект.РабочееМесто)); 
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоСпецификации.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоСпецификации.Свернуть(тСтр.ПолучитьИдентификатор());
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	Если ТипЗнч(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ) = Тип("СправочникСсылка.Документация") Тогда
	ОбщийМодульКлиент.ОткрытьФайлДокумента(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСпецификацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ) = Тип("СправочникСсылка.Документация") Тогда
	ОбщийМодульКлиент.ОткрытьФайлДокумента(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Прошивка(Команда)
СписокЭтапов = Новый СписокЗначений;

СписокЭтапов = ПолучитьСписокЭтапов();
	Если СписокЭтапов.Количество() > 1 Тогда
	ВыбЭтап = СписокЭтапов.ВыбратьЭлемент("Выберите спецификацию");
	Иначе
	ВыбЭтап = СписокЭтапов[0];
	КонецЕсли;
П = Новый Структура("Спецификация",ВыбЭтап.Значение);
ОткрытьФорму("Обработка.ПрошивкаПриборов.Форма",П);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомплектацииВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Если ТипЗнч(Элемент.ТекущиеДанные.Комплектация) = Тип("СправочникСсылка.Документация") Тогда
	ОбщийМодульКлиент.ОткрытьФайлДокумента(Элемент.ТекущиеДанные.Комплектация);	
	Иначе	
	ЗаполнитьДерево(Элемент.ТекущиеДанные.ЭтапСпецификации);
	РазвернутьДерево(Неопределено);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ТребуетсяВвод()
СписокДействий = Новый СписокЗначений;

	Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяКодDanfoss Тогда
	СписокДействий.Добавить(1,"Записать код Danfoss");	
	КонецЕсли; 
	Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяIMEI Тогда
	СписокДействий.Добавить(2,"Записать IMEI");	
	КонецЕсли;
	Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяMACАдрес Тогда
	СписокДействий.Добавить(3,"Записать MAC-адрес");	
	КонецЕсли;
	Если Объект.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяBT_IMEI Тогда
	СписокДействий.Добавить(4,"Записать BT");	
	КонецЕсли;
Возврат(СписокДействий);
КонецФункции

&НаСервере
Процедура ЗаписатьКод(НомерКода,Код)
	Попытка				
	НаборЗаписей = РегистрыСведений.БарКоды.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
			Если НомерКода = 1 Тогда
			Запись.КодDanfoss = Код;
			ИначеЕсли НомерКода = 2 Тогда
				Если Найти(Код,"IMEI:") > 0 Тогда
				Код = Сред(Код,Найти(Код,"IMEI:")+5);
				Код = Лев(Код,Найти(Код,";")-1);	
				Запись.IMEI = Код;
				КонецЕсли;
			ИначеЕсли НомерКода = 3 Тогда
			Запись.MAC = Код;
			ИначеЕсли НомерКода = 4 Тогда
			Запись.BT = Код;
			КонецЕсли;
	    КонецЦикла;
	НаборЗаписей.Записать(Истина);
	Исключение
	Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры 
       
&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если Массив[0] = "3" Тогда
		ЗначениеПараметра1 = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
			Если ЗначениеПараметра1 = Неопределено Тогда
			Сообщить("Линейка или место хранения не найдена!");
			Возврат;	
			КонецЕсли; 
		МПЗ = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
			Если МПЗ = Неопределено Тогда
			Сообщить(Массив[3]+" - МПЗ не найдена!");
			Возврат;	
			КонецЕсли;
				Если ТипЗнч(ЗначениеПараметра1) = Тип("СправочникСсылка.Линейки") Тогда
				МестоХранения = ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(ЗначениеПараметра1,"МестоХраненияКанбанов");
				Иначе
				МестоХранения = ЗначениеПараметра1;			
				КонецЕсли;
		МестоХраненияОтправитель = ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоКоду(Массив[2]);
		П = Новый Структура("МестоХраненияОтправитель,МестоХраненияКанбанов,МПЗ,НомерЯчейки,Сотрудник",МестоХраненияОтправитель,МестоХранения,МПЗ,Массив[5],Объект.Исполнитель);
		ОткрытьФорму("ОбщаяФорма.ОформлениеПустыхКанбанов",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
		СписокДействий = ТребуетсяВвод();
		Действие = 1;
		Действие = СписокДействий.ВыбратьЭлемент("Выберите действие",Действие);
			Если Действие <> Неопределено Тогда
			ЗаписатьКод(Действие.Значение,СокрЛП(Данные));
			ПолучитьДополнительныеКоды();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостачу(Команда)
	Если ОбщийМодульАРМКлиент.ОформитьНедостачу(ЭтаФорма,Объект.РабочееМесто,Объект.ПроизводственноеЗадание) Тогда
	ОчиститьСсылкуНаПЗ();
	КонецЕсли; 
КонецПроцедуры
       
&НаСервере
Процедура ОтменитьФоновоеЗадание(КлючФЗ)
ФоновоеВыполнение.ОтменитьФоновоеЗадание(КлючФЗ);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗадание(Команда)
ОчиститьСсылкуНаПЗ();
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКоды(Команда)
Результат = ОткрытьФормуМодально("Обработка.РабочееМестоЗапускСборка.Форма.ВводКодов",Новый Структура("ПроизводственноеЗадание",Объект.ПроизводственноеЗадание));
	Если Результат <> Неопределено Тогда
	ПолучитьДополнительныеКоды();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомплектациюНаСервере()
ТаблицаКомплектации.Очистить();
Объект.Спецификация.Очистить();
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ЗначениеВРеквизитФормы(тДерево,"ДеревоСпецификации");
ПолучитьСпецификациюЭтапов();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКомплектацию(Команда)
ОбновитьКомплектациюНаСервере();
	Если ТипЗнч(ТаблицаКомплектации[0].Комплектация) = Тип("СправочникСсылка.Номенклатура") Тогда
	Элементы.ТаблицаКомплектации.ТекущаяСтрока = ТаблицаКомплектации[0].ПолучитьИдентификатор();
	ТаблицаКомплектацииВыборЗначения(Элементы.ТаблицаКомплектации,Элементы.ТаблицаКомплектации.ТекущаяСтрока,Истина);
	КонецЕсли;
КонецПроцедуры
