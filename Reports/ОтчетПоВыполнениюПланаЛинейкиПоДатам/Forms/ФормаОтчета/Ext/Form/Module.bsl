﻿
&НаСервере
Процедура НастроитьСерии(График)
ГСЧ = Новый ГенераторСлучайныхЧисел(255);

Серия = График.УстановитьСерию("Заказано");
ЦветСерии = Новый Цвет(ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255));
Серия.Цвет = ЦветСерии;
ЛинияСерии = Новый Линия(ТипЛинииДиаграммы.Сплошная,2);
Серия.Линия = ЛинияСерии;
Серия.Маркер = ТипМаркераДиаграммы.Нет;	
Серия.Текст = "Заказано";
Серия = График.УстановитьСерию("Выпущено");
ЦветСерии = Новый Цвет(ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255));
Серия.Цвет = ЦветСерии;
ЛинияСерии = Новый Линия(ТипЛинииДиаграммы.Сплошная,2);
Серия.Линия = ЛинияСерии;
Серия.Маркер = ТипМаркераДиаграммы.Нет;
Серия.Текст = "Выпущено";
Серия = График.УстановитьСерию("Долг");
ЦветСерии = Новый Цвет(ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255));
Серия.Цвет = ЦветСерии;
ЛинияСерии = Новый Линия(ТипЛинииДиаграммы.Пунктир,2);
Серия.Линия = ЛинияСерии;
Серия.Маркер = ТипМаркераДиаграммы.Нет;
Серия.Текст = "Долг";
Серия = График.УстановитьСерию("Мощность");
ЦветСерии = Новый Цвет(ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255));
Серия.Цвет = ЦветСерии;
ЛинияСерии = Новый Линия(ТипЛинииДиаграммы.Пунктир,2);
Серия.Линия = ЛинияСерии;
Серия.Маркер = ТипМаркераДиаграммы.Нет;
Серия.Текст = "Мощность";
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
Запрос = Новый Запрос;
 
ТабДок.Очистить();
График = ГрафикТД.Рисунки[0].Объект;
График.Очистить();
График.ОбластьЗаголовка.Текст = СокрЛП(Отчет.Линейка.Наименование) + " за период с " + Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy") + " по " + Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
НастроитьСерии(График);

Макет = Отчеты.ОтчетПоВыполнениюПланаЛинейкиПоДатам.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблДата = Макет.ПолучитьОбласть("Дата");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy");
ОблШапка.Параметры.ДатаКон = Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ОблШапка.Параметры.Линейка = ""+Отчет.Линейка+" ("+Отчет.Линейка.Комментарий+")";
ТабДок.Вывести(ОблШапка);

//ОтставаниеОтПланаПроизводства = РегистрыСведений.ОтставаниеОтПланаПроизводства.Получить(Отчет.Период.ДатаНачала,Новый Структура("Линейка",Отчет.Линейка));
//КолОтставание = ОтставаниеОтПланаПроизводства.Количество;
//КолОтставаниеУсл = ОтставаниеОтПланаПроизводства.КоличествоУсл;
	Если Отчет.ВидУсловногоКоэффициента = 1 Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланыВыпускаОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	ПланыВыпускаОстатки.КоличествоОстаток * ПланыВыпускаОстатки.Номенклатура.УсловныеПриборы КАК КоличествоОстатокУсл,
		|	ПланыВыпускаОстатки.Линейка КАК Линейка
		|ИЗ
		|	РегистрНакопления.ПланыВыпуска.Остатки(&НаДату, Линейка = &Линейка) КАК ПланыВыпускаОстатки
		|ГДЕ
		|	ПланыВыпускаОстатки.МаршрутнаяКарта.Ремонт = ЛОЖЬ
		|ИТОГИ
		|	СУММА(КоличествоОстаток),
		|	СУММА(КоличествоОстатокУсл)
		|ПО
		|	Линейка";
	Иначе
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланыВыпускаОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	ПланыВыпускаОстатки.КоличествоОстаток * ПланыВыпускаОстатки.Номенклатура.УсловныйКоэффициентПЭО КАК КоличествоОстатокУсл,
		|	ПланыВыпускаОстатки.Линейка КАК Линейка
		|ИЗ
		|	РегистрНакопления.ПланыВыпуска.Остатки(&НаДату, Линейка = &Линейка) КАК ПланыВыпускаОстатки
		|ГДЕ
		|	ПланыВыпускаОстатки.МаршрутнаяКарта.Ремонт = ЛОЖЬ
		|ИТОГИ
		|	СУММА(КоличествоОстаток),
		|	СУММА(КоличествоОстатокУсл)
		|ПО
		|	Линейка";
	КонецЕсли;	
Запрос.УстановитьПараметр("НаДату",КонецДня(Отчет.Период.ДатаНачала - 86400));
Запрос.УстановитьПараметр("Линейка",Отчет.Линейка);
Результат = Запрос.Выполнить();
ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
КолОтставание = 0;
КолОтставаниеУсл = 0;
	Пока ВыборкаИтоги.Следующий() Цикл
	КолОтставание = ВыборкаИтоги.КоличествоОстаток;	
	КолОтставаниеУсл = ВыборкаИтоги.КоличествоОстатокУсл;		
	КонецЦикла;
ОблДата.Параметры.Дата = Формат(Отчет.Период.ДатаНачала-86400,"ДФ=dd.MM.yyyy");
ОблДата.Параметры.КолЗагр = 0;
ОблДата.Параметры.КолЗагрУсл = 0;
ОблДата.Параметры.КолИзгот = 0;
ОблДата.Параметры.КолИзготУсл = 0;
ОблДата.Параметры.ПроцентВып = 0;
ОблДата.Параметры.КолОтставание = КолОтставание;
ОблДата.Параметры.КолОтставаниеУсл = КолОтставаниеУсл;
ТабДок.Вывести(ОблДата);

КолЗагрВсего = 0;
КолЗагрУслВсего = 0;
КолИзготВсего = 0;
КолИзготУслВсего = 0;
КолПланВсего = 0;
ПроцентВыпВсего = 0;
//КолДней = 0;
ВыбДата = НачалоДня(Отчет.Период.ДатаНачала);
	Пока ВыбДата <= НачалоДня(Отчет.Период.ДатаОкончания) Цикл
	//Выборка = РегистрыСведений.ДанныеПроизводственногоКалендаря.Получить(Новый Структура("ПроизводственныйКалендарь,Дата,Год",Константы.ОсновнойПроизводственныйКалендарь.Получить(),ВыбДата,Год(ВыбДата)));
		//Если Выборка.ВидДня <> Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
		//ВыбДата = ВыбДата + 86400;
		//Продолжить;
		//КонецЕсли; 
		Если Отчет.ВидУсловногоКоэффициента = 1 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПланыВыпускаОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
			|	ПланыВыпускаОстаткиИОбороты.КоличествоПриход * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныеПриборы КАК ПрихУсл
			|ИЗ
			|	РегистрНакопления.ПланыВыпуска.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ) КАК ПланыВыпускаОстаткиИОбороты
			|ГДЕ
			|	ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Линейка = &Линейка
			|	И ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Ремонт = ЛОЖЬ
			|ИТОГИ
			|	СУММА(КоличествоПриход),
			|	СУММА(ПрихУсл)
			|ПО
			|	ОБЩИЕ";
		Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПланыВыпускаОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
			|	ПланыВыпускаОстаткиИОбороты.КоличествоПриход * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныйКоэффициентПЭО КАК ПрихУсл
			|ИЗ
			|	РегистрНакопления.ПланыВыпуска.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ) КАК ПланыВыпускаОстаткиИОбороты
			|ГДЕ
			|	ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Линейка = &Линейка
			|	И ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Ремонт = ЛОЖЬ
			|ИТОГИ
			|	СУММА(КоличествоПриход),
			|	СУММА(ПрихУсл)
			|ПО
			|	ОБЩИЕ";
		КонецЕсли;	
	Запрос.УстановитьПараметр("ДатаНач",НачалоДня(ВыбДата));
	Запрос.УстановитьПараметр("ДатаКон",КонецДня(ВыбДата));
	Запрос.УстановитьПараметр("Линейка",Отчет.Линейка);
	Результат = Запрос.Выполнить();
	ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	КолПриход = 0;
	ПрихУсл = 0;
		Пока ВыборкаИтоги.Следующий() Цикл
		КолПриход = ВыборкаИтоги.КоличествоПриход;	
		ПрихУсл = ВыборкаИтоги.ПрихУсл;		
		КонецЦикла;
			Если Отчет.ВидУсловногоКоэффициента = 1 Тогда		
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ПланыВыпускаОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоРасход КАК КоличествоРасход,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоНачальныйОстаток * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныеПриборы КАК НОУсл,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоРасход * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныеПриборы КАК РасхУсл,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоКонечныйОстаток * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныеПриборы КАК КОУсл
				|ИЗ
				|	РегистрНакопления.ПланыВыпуска.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ) КАК ПланыВыпускаОстаткиИОбороты
				|ГДЕ
				|	(ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Дата МЕЖДУ &ДатаНач И &ДатаКон
				|				И ПланыВыпускаОстаткиИОбороты.КоличествоРасход > 0
				|			ИЛИ ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Дата < &ДатаНач)
				|	И ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Линейка = &Линейка
				|	И ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Ремонт = ЛОЖЬ
				|ИТОГИ
				|	СУММА(КоличествоНачальныйОстаток),
				|	СУММА(КоличествоРасход),
				|	СУММА(КоличествоКонечныйОстаток),
				|	СУММА(НОУсл),
				|	СУММА(РасхУсл),
				|	СУММА(КОУсл)
				|ПО
				|	ОБЩИЕ";
			Иначе
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ПланыВыпускаОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоРасход КАК КоличествоРасход,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоНачальныйОстаток * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныйКоэффициентПЭО КАК НОУсл,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоРасход * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныйКоэффициентПЭО КАК РасхУсл,
				|	ПланыВыпускаОстаткиИОбороты.КоличествоКонечныйОстаток * ПланыВыпускаОстаткиИОбороты.Номенклатура.УсловныйКоэффициентПЭО КАК КОУсл
				|ИЗ
				|	РегистрНакопления.ПланыВыпуска.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ) КАК ПланыВыпускаОстаткиИОбороты
				|ГДЕ
				|	(ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Дата МЕЖДУ &ДатаНач И &ДатаКон
				|				И ПланыВыпускаОстаткиИОбороты.КоличествоРасход > 0
				|			ИЛИ ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Дата < &ДатаНач)
				|	И ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Линейка = &Линейка
				|	И ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Ремонт = ЛОЖЬ
				|ИТОГИ
				|	СУММА(КоличествоНачальныйОстаток),
				|	СУММА(КоличествоРасход),
				|	СУММА(КоличествоКонечныйОстаток),
				|	СУММА(НОУсл),
				|	СУММА(РасхУсл),
				|	СУММА(КОУсл)
				|ПО
				|	ОБЩИЕ";
			КонецЕсли;  	
	Запрос.УстановитьПараметр("ДатаНач",НачалоДня(ВыбДата));
	Запрос.УстановитьПараметр("ДатаКон",КонецДня(ВыбДата));
	Запрос.УстановитьПараметр("Линейка",Отчет.Линейка);
	Результат = Запрос.Выполнить();
	ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	КолРасход = 0;
	КолРасходУсл = 0;
	КолПлан = 0;
	ПроцентВып = 0;
		Пока ВыборкаИтоги.Следующий() Цикл
		КолРасход = ВыборкаИтоги.КоличествоРасход;
		КолРасходУсл = ВыборкаИтоги.РасхУсл;
		//КолДней = КолДней + 1;
		КонецЦикла;		
	ПаспортЛинейки = РегистрыСведений.ПаспортЛинейки.ПолучитьПоследнее(ВыбДата,Новый Структура("Линейка",Отчет.Линейка));
		Если КолОтставание + КолПриход < ПаспортЛинейки.ВыпускЗаДеньРасчётный Тогда
		КолПлан = КолОтставание + КолПриход;
		Иначе
		КолПлан = ПаспортЛинейки.ВыпускЗаДеньРасчётный;
		КонецЕсли;
			Если КолРасход > 0 Тогда
			КолПланВсего = КолПланВсего + КолПлан;
			КонецЕсли;
	КолОтставание = КолОтставание + КолПриход - КолРасход;
	КолОтставаниеУсл = КолОтставаниеУсл + ПрихУсл - КолРасходУсл; 
	ВремяПростоя = 0;
	ПростойЛинейки = РегистрыСведений.ПростойЛинейки.Выбрать(НачалоДня(ВыбДата),КонецДня(ВыбДата),Новый Структура("Линейка",Отчет.Линейка));
		Пока ПростойЛинейки.Следующий() Цикл
		ВремяПростоя = ВремяПростоя + (ПростойЛинейки.Окончание - ПростойЛинейки.Период)/60;
		КонецЦикла;
	ПроцентВып = ?(КолПлан > 0,Окр(КолРасход/КолПлан*100,2,1),0); 	
	ПроцентВыпВсего = ПроцентВыпВсего + ПроцентВып;		
	КолЗагрВсего = КолЗагрВсего + КолПриход;
	КолЗагрУслВсего = КолЗагрУслВсего + ПрихУсл;
	КолИзготВсего = КолИзготВсего + КолРасход;
	КолИзготУслВсего = КолИзготУслВсего + КолРасходУсл;
	ОблДата.Параметры.Дата = Формат(ВыбДата,"ДФ=dd.MM.yyyy");
	ОблДата.Параметры.КолЗагр = КолПриход;
	ОблДата.Параметры.КолЗагрУсл = ПрихУсл;
	ОблДата.Параметры.КолИзгот = КолРасход;
	ОблДата.Параметры.КолИзготУсл = КолРасходУсл;
	ОблДата.Параметры.КолПлан = КолПлан;
	ОблДата.Параметры.КолПланРасч = ПаспортЛинейки.ВыпускЗаДеньРасчётный;
	ОблДата.Параметры.ПроцентВып = ПроцентВып;
	ОблДата.Параметры.КолОтставание = КолОтставание;
	ОблДата.Параметры.КолОтставаниеУсл = КолОтставаниеУсл;
	ТабДок.Вывести(ОблДата);
	Точка = График.Точки.Добавить(Формат(ВыбДата,"ДФ=dd.MM.yy"));
	Серия = График.УстановитьСерию("Заказано");
	График.УстановитьЗначение(Точка,Серия,КолПриход,КолПриход);
	Серия = График.УстановитьСерию("Выпущено");
	График.УстановитьЗначение(Точка,Серия,КолРасход,КолРасход);
	Серия = График.УстановитьСерию("Долг");
	График.УстановитьЗначение(Точка,Серия,КолОтставание,КолОтставание);
	Серия = График.УстановитьСерию("Мощность");
	График.УстановитьЗначение(Точка,Серия,ПаспортЛинейки.ВыпускЗаДеньРасчётный,ПаспортЛинейки.ВыпускЗаДеньРасчётный);
	ВыбДата = ВыбДата + 86400;
	КонецЦикла;
ОблКонец.Параметры.КолЗагрВсего = КолЗагрВсего;
ОблКонец.Параметры.КолЗагрУслВсего = КолЗагрУслВсего;
ОблКонец.Параметры.КолИзготВсего = КолИзготВсего;
ОблКонец.Параметры.КолИзготУслВсего = КолИзготУслВсего;
ОблКонец.Параметры.ПроцентВыпВсего = ?(КолПланВсего > 0,Окр(КолИзготВсего*100/КолПланВсего,2,1),0);
ОблКонец.Параметры.КолОтставаниеВсего = КолОтставание;
ОблКонец.Параметры.КолОтставаниеУслВсего = КолОтставаниеУсл;		
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 4;
ГрафикТД.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ГрафикТД.ПолеСверху = 0;
ГрафикТД.ПолеСлева = 0;
ГрафикТД.ПолеСнизу = 0;
ГрафикТД.ПолеСправа = 0;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере(); 
КонецПроцедуры

&НаСервере
Процедура СохранитьОтставаниеНаСервере()
ОтставаниеОтПлана = РегистрыСведений.ОтставаниеОтПланаПроизводства.СоздатьМенеджерЗаписи();
ОтставаниеОтПлана.Период = Отчет.Период.ДатаОкончания+86400;
ОтставаниеОтПлана.Линейка = Отчет.Линейка;
ОтставаниеОтПлана.Количество = КолОтставание; 
ОтставаниеОтПлана.КоличествоУсл = КолОтставаниеУсл;
ОтставаниеОтПлана.Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьОтставание(Команда)
СохранитьОтставаниеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Ф = ПолучитьФорму("ОбщаяФорма.ВыборМесяца");
Результат = Ф.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
	Отчет.Период.ДатаНачала = Результат;
	Отчет.Период.ДатаОкончания = КонецМесяца(Результат);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Если ТипЗнч(Расшифровка) = Тип("Строка") Тогда
	СтандартнаяОбработка = Ложь;
	ВыбДата = Дата(Сред(Расшифровка,7,4),Сред(Расшифровка,4,2),Лев(Расшифровка,2));
	П = Новый Структура("Линейка,ДатаНач,ДатаКон",Отчет.Линейка,НачалоДня(ВыбДата),КонецДня(ВыбДата));
	ОткрытьФорму("Отчет.ОтчетПоВыполнениюПланаЛинейки.Форма.ФормаОтчета",П);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.ВидУсловногоКоэффициента = 1;
КонецПроцедуры
