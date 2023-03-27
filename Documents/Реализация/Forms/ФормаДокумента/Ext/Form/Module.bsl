﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЭтотОбъект.ТолькоПросмотр = ОбщийМодульСозданиеДокументов.ЗапретРедактирования(Объект.Ссылка,Истина,Ложь);
Элементы.Коэфф.Доступность = Не ЗначениеЗаполнено(Объект.ДокументОснование);
Элементы.ИзменитьКоэффициент.Доступность = Не ЗначениеЗаполнено(Объект.ДокументОснование);
Элементы.ПодразделениеПолучатель.Видимость = Объект.Внутренняя;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьМПЗПриИзменении(Элемент)
ТабличнаяЧастьМПЗПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьМПЗПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.ЕдиницаИзмерения = ТЧ.Товар.ОсновнаяЕдиницаИзмерения;
	Если ТипЗнч(ТЧ.Товар) = Тип("СправочникСсылка.Материалы") Тогда
	ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Материалы;	
	Иначе
	ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Полуфабрикаты;	
	КонецЕсли;
ПересчётСтрокиТабличнойЧасти(ТЧ.ПолучитьИдентификатор());
КонецПроцедуры

&НаСервере
Функция ВнесёнВДоговорныеПозиции(МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДоговорныеПозиции.Ссылка
	|ИЗ
	|	Справочник.ДоговорныеПозиции КАК ДоговорныеПозиции
	|ГДЕ
	|	ДоговорныеПозиции.Владелец = &Владелец
	|	И ДоговорныеПозиции.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("Владелец", Объект.Договор);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
	Возврат(Истина);
	Иначе
	Возврат(Ложь);
	КонецЕсли; 			
КонецФункции

&НаСервере
Процедура ПересчётСтрокиТабличнойЧасти(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
	Если Не ВнесёнВДоговорныеПозиции(ТЧ.Товар) Тогда
	Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",ТЧ.Товар));
	ТЧ.Цена = Цены.Цена*ТЧ.ЕдиницаИзмерения.Коэффициент*Объект.Коэфф;
	Иначе
		Если Объект.Договор.ДоговорСНефиксированнымиЦенами Тогда
		Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",ТЧ.Товар));
		ТЧ.Цена = Цены.Цена*ТЧ.ЕдиницаИзмерения.Коэффициент*Объект.Коэфф;			
		Иначе
		ТЧ.Цена = ОбщийМодульРаботаСРегистрами.ПолучитьЦенуДП(Объект.Договор,1,ТЧ.Товар,Объект.Дата)*Объект.Коэфф;
		КонецЕсли;  		
	КонецЕсли; 
ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;	
	Если Объект.Договор.БезНДС Тогда
	ТЧ.СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
	ТЧ.НДС = 0;
	ТЧ.Всего = ТЧ.Сумма;
	Иначе
	ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
	ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
	ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПодборМПЗНаСервере(ТаблицаМПЗ)
	Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Материалы;		
		Иначе
		ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Полуфабрикаты;	
		КонецЕсли; 
	ТЧ.Товар = ТЧ_МПЗ.МПЗ;
	ТЧ.Количество = ТЧ_МПЗ.Количество;
	ТЧ.ЕдиницаИзмерения = ТЧ_МПЗ.ЕдиницаИзмерения;  
	ПересчётСтрокиТабличнойЧасти(ТЧ.ПолучитьИдентификатор());
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПодборМПЗ(Команда)
ТаблицаМПЗ = ОткрытьФормуМодально("ОбщаяФорма.ПодборМПЗ", Новый Структура("МестоХранения,Договор",Объект.МестоХранения,Объект.Договор));
	Если ТаблицаМПЗ <> Неопределено Тогда
		Если ТаблицаМПЗ.Количество() > 0 Тогда
			Если Объект.ТабличнаяЧасть.Количество() > 0 Тогда
				Если Вопрос("Очистить таблицу?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				Объект.ТабличнаяЧасть.Очистить();		
				КонецЕсли; 			
			КонецЕсли; 
		ПодборМПЗНаСервере(ТаблицаМПЗ);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьСклонениеНомераСтраницы(НомерСтраницы)
	Если (НомерСтраницы = 1) или (НомерСтраницы = 21)
	или (НомерСтраницы = 31) или (НомерСтраницы = 41)
	или (НомерСтраницы = 51) или (НомерСтраницы = 61)
	или (НомерСтраницы = 71) или (НомерСтраницы = 81)
	или (НомерСтраницы = 91) или (НомерСтраницы = 101) Тогда		
	Возврат "листе"; 
	КонецЕсли;	
Возврат "листах";	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуГТД(Товар);
Запрос = Новый Запрос;
ТаблицаГТД = Новый ТаблицаЗначений;

ТаблицаГТД.Колонки.Добавить("ГТД");
ТаблицаГТД.Колонки.Добавить("Количество");

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГТД.НомерГТД КАК НомерГТД,
	|	ГТД.Количество КАК Количество
	|ИЗ
	|	РегистрНакопления.ГТД КАК ГТД
	|ГДЕ
	|	ГТД.Регистратор = &Регистратор
	|	И ГТД.Товар = &Товар";
Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);
Запрос.УстановитьПараметр("Товар", Товар);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаГТД.Добавить();
	ТЧ.ГТД = ВыборкаДетальныеЗаписи.НомерГТД;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Возврат(ТаблицаГТД);
КонецФункции

&НаСервере
Процедура ПечатьУПДНаСервере(ТабДок)
НомерСтраницы = 1;
СтрокНаСтранице = 26;
СтрокПодвала = 13; 
	Если НачалоДня(Объект.Дата) >= Дата(2021,7,1) Тогда
	Макет = Документы.Реализация.ПолучитьМакет("УПД_010721");
	СтрокШапки = 17;
	Иначе	
	Макет = Документы.Реализация.ПолучитьМакет("УПД");
	СтрокШапки = 16;
	КонецЕсли; 
ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблПодвал = Макет.ПолучитьОбласть("Подвал");

ОблШапка.Параметры.СтатусУПД = 1;
ОблШапка.Параметры.НомерДокумента = СокрЛП(Объект.Номер)+"/01";
ОблШапка.Параметры.ДатаДокумента = Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
	Если НачалоДня(Объект.Дата) >= Дата(2021,7,1) Тогда
	ОблШапка.Параметры.ДокОбОтгрузке = "№ п/п 1-"+Строка(Объект.ТабличнаяЧасть.Количество())+" № "+СокрЛП(Объект.Номер)+"/01"+" от "+Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
	КонецЕсли;
ОблШапка.Параметры.НомерИсправления = "----";
ОблШапка.Параметры.ДатаИсправления = "----";
ОблШапка.Параметры.Продавец = Константы.НазваниеОрганизации.Получить();
ОблШапка.Параметры.АдресПродавца = Константы.АдресОрганизации.Получить();
ОблШапка.Параметры.ИННКПППродавца = Константы.ИННОрганизации.Получить();
ОблШапка.Параметры.Грузоотправитель = "Он же";
ОблШапка.Параметры.Грузополучатель = СокрЛП(Объект.Контрагент.ПолнНаименование)+", "+Объект.Контрагент.ПочтовыйАдрес;
ОблШапка.Параметры.ПлатРасчДок = "";
ОблШапка.Параметры.Покупатель = СокрЛП(Объект.Контрагент.ПолнНаименование);
ОблШапка.Параметры.АдресПокупателя = Объект.Контрагент.ПочтовыйАдрес;
ОблШапка.Параметры.ИННКПППокупателя = Объект.Контрагент.ИНН; 
ОблШапка.Параметры.ИННКПППокупателя = Объект.Контрагент.ИНН;		
ОблШапка.Параметры.ВалютаПечати = "Российский рубль, 643";
ТабДок.Вывести(ОблШапка);
ТабДок.Вывести(ОблЗаголовок);

	Если Объект.ТабличнаяЧасть.Количество() <= 3 Тогда
	ПереноситьПоследнююСтроку = 0;
	Иначе
	ЦелыхСтраницСПодвалом = Цел((СтрокШапки + Объект.ТабличнаяЧасть.Количество() + СтрокПодвала) / СтрокНаСтранице);
	ЦелыхСтраницБезПодвала = Цел((СтрокШапки + Объект.ТабличнаяЧасть.Количество() - 1) / СтрокНаСтранице);
	ПереноситьПоследнююСтроку = ЦелыхСтраницСПодвалом - ЦелыхСтраницБезПодвала;
	КонецЕсли;
Ном = 0;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	Ном = Ном + 1;
	ЦелаяСтраница = (СтрокШапки + ТЧ.НомерСтроки - 1)/СтрокНаСтранице;
		Если (ЦелаяСтраница = Цел(ЦелаяСтраница)) или ((ПереноситьПоследнююСтроку = 1) и (Ном = Объект.ТабличнаяЧасть.Количество())) Тогда 
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		НомерСтраницы = НомерСтраницы + 1; 
		ТабДок.Вывести(ОблЗаголовок);
		КонецЕсли;
	НомерСтраницыПрописью = ПолучитьСклонениеНомераСтраницы(НомерСтраницы);				
	ТаблицаГТД = ПолучитьТаблицуГТД(ТЧ.Товар);
	КолОстаток = ТЧ.Количество;
			Для каждого ТЧ_ГТД Из ТаблицаГТД Цикл
			ОблСтрока.Параметры.НомерСтроки = Ном;
				Если ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Материалы Тогда
				ОблСтрока.Параметры.ТоварКод = ТЧ.Товар.Код;	
				КонецЕсли;							
			ОблСтрока.Параметры.СтранаКод = ТЧ_ГТД.ГТД.Страна.Код;
			ОблСтрока.Параметры.СтранаН = СокрЛП(ТЧ_ГТД.ГТД.Страна.Наименование);	
			ОблСтрока.Параметры.НомерГТД_Н = ТЧ_ГТД.ГТД.Наименование;
			ОблСтрока.Параметры.ПечКоличество = Формат(ТЧ_ГТД.Количество,"ЧЦ=10; ЧДЦ=2");
			ОблСтрока.Параметры.ПечСумма = Формат(ТЧ.Цена*ТЧ_ГТД.Количество,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
				Если Не Объект.Договор.БезНДС Тогда
				НДС = ТЧ.Цена*ТЧ_ГТД.Количество*ТЧ.СтавкаНДС.Ставка/100;	
				ТЧ.НДС = Формат(НДС,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
				ОблСтрока.Параметры.ПечВсего = Формат(ТЧ.Цена*ТЧ_ГТД.Количество+НДС,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
				Иначе
				ОблСтрока.Параметры.ПечВсего = Формат(ТЧ.Цена*ТЧ_ГТД.Количество,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
				КонецЕсли;
			ОблСтрока.Параметры.Наименование = ?(Не ЗначениеЗаполнено(ТЧ.Товар.ПолнНаименование), ТЧ.Товар.Наименование, ТЧ.Товар.ПолнНаименование);
			ОблСтрока.Параметры.КодВидаТовара = "-----";
			ОблСтрока.Параметры.ЕдиницаИзмеренияКод = ТЧ.ЕдиницаИзмерения.ЕдиницаИзмерения.Код;
			ОблСтрока.Параметры.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения.ЕдиницаИзмерения;
				Если (ЗначениеЗаполнено(ТЧ.СтавкаНДС)) и (ТЧ.СтавкаНДС.Ставка > 0) Тогда
				ОблСтрока.Параметры.ПредставлениеСтавкиНДС = "" + ТЧ.СтавкаНДС.Ставка + "%";
				Иначе
				ОблСтрока.Параметры.ПредставлениеСтавкиНДС = "Без НДС";
				КонецЕсли;     
			ОблСтрока.Параметры.ПечЦена = Формат(ТЧ.Цена,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
			ОблСтрока.Параметры.ПечАкциз = "без акциза";  
			ТабДок.Вывести(ОблСтрока);		
			КолОстаток = КолОстаток - ТЧ_ГТД.Количество;
			Ном = Ном + 1; 
			КонецЦикла;		
				Если КолОстаток > 0 Тогда
				ОблСтрока.Параметры.НомерСтроки = Ном;
					Если ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Материалы Тогда
					ОблСтрока.Параметры.ТоварКод = ТЧ.Товар.Код;	
					КонецЕсли;				
				ОблСтрока.Параметры.СтранаКод = "";
				ОблСтрока.Параметры.СтранаН = "-----";	
				ОблСтрока.Параметры.НомерГТД_Н = "-----";				
				ОблСтрока.Параметры.ПечКоличество = Формат(КолОстаток,"ЧЦ=10; ЧДЦ=2");
				ОблСтрока.Параметры.ПечСумма = Формат(ТЧ.Цена*КолОстаток,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
					Если Не Объект.Договор.БезНДС Тогда
					НДС = ТЧ.Цена*КолОстаток*ТЧ.СтавкаНДС.Ставка/100;	
					ТЧ.НДС = Формат(НДС,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
					ОблСтрока.Параметры.ПечВсего = Формат(ТЧ.Цена*КолОстаток+НДС,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
					Иначе
					ОблСтрока.Параметры.ПечВсего = Формат(ТЧ.Цена*КолОстаток,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
					КонецЕсли;
				ОблСтрока.Параметры.Наименование = ?(Не ЗначениеЗаполнено(ТЧ.Товар.ПолнНаименование), ТЧ.Товар.Наименование, ТЧ.Товар.ПолнНаименование);
				ОблСтрока.Параметры.КодВидаТовара = "-----";
				ОблСтрока.Параметры.ЕдиницаИзмеренияКод = ТЧ.ЕдиницаИзмерения.ЕдиницаИзмерения.Код;
				ОблСтрока.Параметры.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения.ЕдиницаИзмерения;
					Если (ЗначениеЗаполнено(ТЧ.СтавкаНДС)) и (ТЧ.СтавкаНДС.Ставка > 0) Тогда
					ОблСтрока.Параметры.ПредставлениеСтавкиНДС = "" + ТЧ.СтавкаНДС.Ставка + "%";
					Иначе
					ОблСтрока.Параметры.ПредставлениеСтавкиНДС = "Без НДС";
					КонецЕсли;     
				ОблСтрока.Параметры.ПечЦена = Формат(ТЧ.Цена,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
				ОблСтрока.Параметры.ПечАкциз = "без акциза";  
				ТабДок.Вывести(ОблСтрока);				
				КонецЕсли;
	КонецЦикла;
ОблПодвал.Параметры.Основание = "Основной договор";//Объект.Контрагент.ОсновнойДоговор.Наименование
ОблПодвал.Параметры.ДатаОтгрузкиПередачи = Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
ОблПодвал.Параметры.НомерСтраницы = НомерСтраницы;
ОблПодвал.Параметры.НомерСтраницыПрописью = НомерСтраницыПрописью;
ОблПодвал.Параметры.ПечИтогБезНДС = Формат(Объект.ТабличнаяЧасть.Итог("Сумма"),"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
ОблПодвал.Параметры.ПечИтогНДС = ?(Объект.ТабличнаяЧасть.Итог("НДС")=0, "-----", Формат(Объект.ТабличнаяЧасть.Итог("НДС"), "ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=."));
ОблПодвал.Параметры.ПечИтогВсего = Формат(Объект.ТабличнаяЧасть.Итог("Всего"),"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
//ОблПодвал.Параметры.Руководитель = "/"+ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Директор завода")+"/";
//ОблПодвал.Параметры.ГлавныйБухгалтер = "/"+ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Главный бухгалтер")+"/";
ОблПодвал.Параметры.ПредставлениеОрганизации = СокрЛП(Константы.НазваниеОрганизации.Получить())+", ИНН/КПП "+Константы.ИННОрганизации.Получить(); 
ОблПодвал.Параметры.ПредставлениеКонтрагента = ?(ЗначениеЗаполнено(Объект.Контрагент.ИНН), СокрЛП(Объект.Контрагент.ПолнНаименование) + ", ИНН/КПП " + Объект.Контрагент.ИНН, СокрЛП(Объект.Контрагент.ПолнНаименование));
ТабДок.Вывести(ОблПодвал);
ТабДок.РазмерСтраницы = "A4";
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ТабДок.Автомасштаб = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУПД(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьУПДНаСервере(ТабДок);
ТабДок.Показать("Печать УПД");
КонецПроцедуры

&НаСервере
Процедура ПечатьУПД_ЗЛОНаСервере(ТабДок)
НомерСтраницы = 1;
СтрокНаСтранице = 26;
СтрокПодвала = 13; 
	Если НачалоДня(Объект.Дата) >= Дата(2021,7,1) Тогда
	Макет = Документы.Реализация.ПолучитьМакет("УПД_010721");
	СтрокШапки = 17;
	Иначе	
	Макет = Документы.Реализация.ПолучитьМакет("УПД");
	СтрокШапки = 16;
	КонецЕсли;
ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблЗаголовок = Макет.ПолучитьОбласть("Заголовок");
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблПодвал = Макет.ПолучитьОбласть("Подвал");

ОблШапка.Параметры.СтатусУПД = 1;
ОблШапка.Параметры.НомерДокумента = Прав(Объект.Номер,5);
ОблШапка.Параметры.ДатаДокумента = Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
	Если НачалоДня(Объект.Дата) >= Дата(2021,7,1) Тогда
	ОблШапка.Параметры.ДокОбОтгрузке = "№ п/п 1-"+Строка(Объект.ТабличнаяЧасть.Количество())+" № "+Прав(Объект.Номер,5)+"/01"+" от "+Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
	КонецЕсли;
ОблШапка.Параметры.НомерИсправления = "----";
ОблШапка.Параметры.ДатаИсправления = "----";
ОблШапка.Параметры.Продавец = "Общество с ограниченной ответственностью " +""""+"Завод литьевой оснастки"+"""";
ОблШапка.Параметры.АдресПродавца = Константы.АдресОрганизации.Получить();
ОблШапка.Параметры.ИННКПППродавца = "7112028215/711201001";
ОблШапка.Параметры.Грузоотправитель = "Он же";
ОблШапка.Параметры.Грузополучатель = СокрЛП(Объект.Контрагент.ПолнНаименование)+", "+Объект.Контрагент.ПочтовыйАдрес;
ОблШапка.Параметры.ПлатРасчДок = "";
ОблШапка.Параметры.Покупатель = СокрЛП(Объект.Контрагент.ПолнНаименование);
ОблШапка.Параметры.АдресПокупателя = Объект.Контрагент.ПочтовыйАдрес;
ОблШапка.Параметры.ИННКПППокупателя = Объект.Контрагент.ИНН; 
ОблШапка.Параметры.ИННКПППокупателя = Объект.Контрагент.ИНН;		
ОблШапка.Параметры.ВалютаПечати = "Российский рубль, 643";
ТабДок.Вывести(ОблШапка);
ТабДок.Вывести(ОблЗаголовок);
 
	Если Объект.ТабличнаяЧасть.Количество() <= 3 Тогда
	ПереноситьПоследнююСтроку = 0;
	Иначе
	ЦелыхСтраницСПодвалом = Цел((СтрокШапки + Объект.ТабличнаяЧасть.Количество() + СтрокПодвала) / СтрокНаСтранице);
	ЦелыхСтраницБезПодвала = Цел((СтрокШапки + Объект.ТабличнаяЧасть.Количество() - 1) / СтрокНаСтранице);
	ПереноситьПоследнююСтроку = ЦелыхСтраницСПодвалом - ЦелыхСтраницБезПодвала;
	КонецЕсли;
Ном = 0;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	ОблСтрока.Параметры.НомерСтроки = ТЧ.НомерСтроки;
	ЦелаяСтраница = (СтрокШапки + ТЧ.НомерСтроки - 1)/СтрокНаСтранице;
		Если (ЦелаяСтраница = Цел(ЦелаяСтраница)) или ((ПереноситьПоследнююСтроку = 1) и (ТЧ.НомерСтроки = Объект.ТабличнаяЧасть.Количество())) Тогда 
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		НомерСтраницы = НомерСтраницы + 1; 
		ТабДок.Вывести(ОблЗаголовок);
		КонецЕсли;
	НомерСтраницыПрописью = ПолучитьСклонениеНомераСтраницы(НомерСтраницы);				
	Ном = Ном + 1;
		Если ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Материалы Тогда
		ОблСтрока.Параметры.ТоварКод = ТЧ.Товар.Код;	
		КонецЕсли;
	ОблСтрока.Параметры.Наименование = ?(Не ЗначениеЗаполнено(ТЧ.Товар.ПолнНаименование), ТЧ.Товар.Наименование, ТЧ.Товар.ПолнНаименование);
	ОблСтрока.Параметры.КодВидаТовара = "-----";
	ОблСтрока.Параметры.ЕдиницаИзмеренияКод = ТЧ.ЕдиницаИзмерения.ЕдиницаИзмерения.Код;
	ОблСтрока.Параметры.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения.ЕдиницаИзмерения;
	ОблСтрока.Параметры.СтранаКод = "";
	ОблСтрока.Параметры.СтранаН = "-----";	
	ОблСтрока.Параметры.НомерГТД_Н = "-----";
		Если (ЗначениеЗаполнено(ТЧ.СтавкаНДС)) и (ТЧ.СтавкаНДС.Ставка > 0) Тогда
		ОблСтрока.Параметры.ПредставлениеСтавкиНДС = "" + ТЧ.СтавкаНДС.Ставка + "%";
		Иначе
		ОблСтрока.Параметры.ПредставлениеСтавкиНДС = "Без НДС";
		КонецЕсли;     
	ОблСтрока.Параметры.ПечКоличество = Формат(ТЧ.Количество,"ЧЦ=10; ЧДЦ=2");
	ОблСтрока.Параметры.ПечЦена = Формат(ТЧ.Цена,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
	ОблСтрока.Параметры.ПечСумма = Формат(ТЧ.Сумма,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
	ОблСтрока.Параметры.ПечАкциз = "без акциза";
	ОблСтрока.Параметры.ПечНДС = ?(ТЧ.НДС = 0,"----------",Формат(ТЧ.НДС,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=."));
	ОблСтрока.Параметры.ПечВсего = Формат(ТЧ.Всего,"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");  
	ТабДок.Вывести(ОблСтрока);
	КонецЦикла;
ОблПодвал.Параметры.Основание = "Основной договор";//Объект.Контрагент.ОсновнойДоговор.Наименование
ОблПодвал.Параметры.ДатаОтгрузкиПередачи = Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
ОблПодвал.Параметры.НомерСтраницы = НомерСтраницы;
ОблПодвал.Параметры.НомерСтраницыПрописью = НомерСтраницыПрописью;
ОблПодвал.Параметры.ПечИтогБезНДС = Формат(Объект.ТабличнаяЧасть.Итог("Сумма"),"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
ОблПодвал.Параметры.ПечИтогНДС = ?(Объект.ТабличнаяЧасть.Итог("НДС")=0, "-----", Формат(Объект.ТабличнаяЧасть.Итог("НДС"), "ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=."));
ОблПодвал.Параметры.ПечИтогВсего = Формат(Объект.ТабличнаяЧасть.Итог("Всего"),"ЧЦ=15; ЧДЦ=2; ЧРД=,; ЧРГ=.");
ОблПодвал.Параметры.ПредставлениеОрганизации = "Общество с ограниченной ответственностью " +""""+"Завод литьевой оснастки"+""""+", ИНН/КПП 7112028215/711201001"; 
ОблПодвал.Параметры.ПредставлениеКонтрагента = ?(ЗначениеЗаполнено(Объект.Контрагент.ИНН), СокрЛП(Объект.Контрагент.ПолнНаименование) + ", ИНН/КПП " + Объект.Контрагент.ИНН, СокрЛП(Объект.Контрагент.ПолнНаименование));
ОблПодвал.Параметры.ГлавныйБухгалтер = "/Трушкина Н.А. /(по доверенности №4 от 09.01.2019 г.)"; 
ОблПодвал.Параметры.Руководитель = "/Ширин Д.С./";
ОблПодвал.Параметры.ПередалДолжность = "Зав. складом";
ОблПодвал.Параметры.Передал = "Самарина М.В.";
ОблПодвал.Параметры.ПередалОтветственныйДолжность = "Генеральный директор";
ОблПодвал.Параметры.ПередалОтветственный = "Ширин Д.С.";
ТабДок.Вывести(ОблПодвал);
ТабДок.РазмерСтраницы = "A4";
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ТабДок.Автомасштаб = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУПД_ЗЛО(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьУПД_ЗЛОНаСервере(ТабДок);
ТабДок.Показать("Печать УПД (З.Л.О.)");
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьКоличествоПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;
ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьКоличествоПриИзменении(Элемент)
ТабличнаяЧастьКоличествоПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьЕдиницаИзмеренияПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",ТЧ.Товар));
ТЧ.Цена = Цены.Цена*ТЧ.ЕдиницаИзмерения.Коэффициент;
ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;
ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьЕдиницаИзмеренияПриИзменении(Элемент)
ТабличнаяЧастьЕдиницаИзмеренияПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьЦенаПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;
	Если Не Объект.Договор.БезНДС Тогда
	ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
	КонецЕсли; 
ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьЦенаПриИзменении(Элемент)
ТабличнаяЧастьЦенаПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьСуммаПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.Цена = ТЧ.Сумма/ТЧ.Количество;
	Если Не Объект.Договор.БезНДС Тогда
	ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
	КонецЕсли;
		Если Объект.Договор.Валюта <> Константы.ОсновнаяВалюта.Получить() Тогда
		ТЧ.ЦенаВалюта = ТЧ.Цена/Объект.Курс;
		КонецЕсли;
ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСуммаПриИзменении(Элемент)
ТабличнаяЧастьСуммаПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьСтавкаНДСПриИзменении(Элемент)
ТабличнаяЧастьСтавкаНДСПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьСтавкаНДСПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
	Если Не Объект.Договор.БезНДС Тогда
	ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
	КонецЕсли;
ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;
КонецПроцедуры

&НаСервере
Процедура ПересчётТабличнойЧастиПоКоэффициенту()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;	
		Если Объект.Договор.БезНДС Тогда
		ТЧ.СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
		ТЧ.НДС = 0;
		ТЧ.Всего = ТЧ.Сумма;
		Иначе
		ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
		ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
		ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;		
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
КонтрагентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
Объект.Договор = Объект.Контрагент.ОсновнойДоговор;
КонецПроцедуры

&НаСервере
Процедура КоэффПриИзмененииНаСервере()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	Цены = РегистрыСведений.Цены.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",ТЧ.Товар));
	ТЧ.Цена = Цены.Цена*ТЧ.ЕдиницаИзмерения.Коэффициент*Объект.Коэфф;
	КонецЦикла;
ПересчётТабличнойЧастиПоКоэффициенту();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКоэффициент(Команда)
	Если Вопрос("Вы действительно хотите изменить коэффициент?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		Если ВвестиЧисло(Объект.Коэфф,"Введите новый коэффициент?",4,2) Тогда
		КоэффПриИзмененииНаСервере();
		КонецЕсли; 	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
Элементы.ИзменитьКоэффициент.Доступность = Не ЗначениеЗаполнено(Объект.ДокументОснование);
ДокументОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
	Возврат;
	КонецЕсли; 
Объект.ТабличнаяЧасть.Очистить();
Об = РеквизитФормыВЗначение("Объект");
Об.ОбработкаЗаполнения(Объект.ДокументОснование,Истина);
ВыгрузкаТЧ = Об.ТабличнаяЧасть.Выгрузить();
Объект.ТабличнаяЧасть.Загрузить(ВыгрузкаТЧ);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Элементы.ТабличнаяЧастьСтавкаНДС.Видимость = Не Объект.Договор.БезНДС;
Элементы.ТабличнаяЧастьНДС.Видимость = Не Объект.Договор.БезНДС;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
Отказ = Не ЭтаФорма.ПроверитьЗаполнение();
КонецПроцедуры

&НаСервере
Процедура ПересчётТабличнойЧасти()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	ПересчётСтрокиТабличнойЧасти(ТЧ.ПолучитьИдентификатор());
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	Если Объект.Договор.Валюта <> Константы.ОсновнаяВалюта.Получить() Тогда
	Объект.Договор = Справочники.Договоры.ПустаяСсылка();
	Сообщить("В реализации запрещено выбирать валютный договор!");	
	Возврат;
	КонецЕсли;		
Элементы.ТабличнаяЧастьСтавкаНДС.Видимость = Не Объект.Договор.БезНДС;
Элементы.ТабличнаяЧастьНДС.Видимость = Не Объект.Договор.БезНДС;
ПересчётТабличнойЧасти();
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
ДоговорПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьВсегоПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
	Если Не Объект.Договор.БезНДС Тогда
	ТЧ.НДС = ТЧ.Всего/118*18;
	КонецЕсли;
ТЧ.Сумма = ТЧ.Всего - ТЧ.НДС;
ТЧ.Цена = ТЧ.Сумма/ТЧ.Количество;
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьВсегоПриИзменении(Элемент)
ТабличнаяЧастьВсегоПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВнутренняяПриИзменении(Элемент)
Элементы.ПодразделениеПолучатель.Видимость = Объект.Внутренняя;
КонецПроцедуры

