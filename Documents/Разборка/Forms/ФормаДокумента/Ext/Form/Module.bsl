﻿
&НаСервере
Процедура ПодборМПЗНаСервере(ТаблицаМПЗ)
	Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;		
		Иначе
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
		КонецЕсли; 
	ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
	ТЧ.Количество = ТЧ_МПЗ.Количество;
	ТЧ.ЕдиницаИзмерения = ТЧ_МПЗ.ЕдиницаИзмерения;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПодборМПЗ(Команда)
ТаблицаМПЗ = ОткрытьФормуМодально("ОбщаяФорма.ПодборМПЗ", Новый Структура("МестоХранения",Объект.МестоХранения));
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
Процедура ЗаполнитьПоНоменклатуреНаСервере(Изделие,Количество)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(Изделие,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
		ЗаполнитьПоНоменклатуреНаСервере(ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Количество);
		Иначе
		Выборка = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("МПЗ",ВыборкаНР.Элемент));
			Если Выборка.Количество() = 0 Тогда
			ТЧ = Объект.ТабличнаяЧасть.Добавить();
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
			ТЧ.МПЗ = ВыборкаНР.Элемент;
			ТЧ.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Количество;
			ТЧ.ЕдиницаИзмерения = ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения;
			Иначе
			Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Количество;
			КонецЕсли;  
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНоменклатуре(Команда)
Объект.ТабличнаяЧасть.Очистить();
ЗаполнитьПоНоменклатуреНаСервере(Объект.Изделие,Объект.Количество);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоМатериаламНаСервере(Изделие,Количество)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(Изделие,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
		ЗаполнитьПоМатериаламНаСервере(ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Количество);
		ИначеЕсли ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Материал Тогда
		Выборка = Объект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("МПЗ",ВыборкаНР.Элемент));
			Если Выборка.Количество() = 0 Тогда
			ТЧ = Объект.ТабличнаяЧасть.Добавить();
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
			ТЧ.МПЗ = ВыборкаНР.Элемент;
			ТЧ.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Количество;
			ТЧ.ЕдиницаИзмерения = ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения;
			Иначе
			Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Количество;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоМатериалам(Команда)
Объект.ТабличнаяЧасть.Очистить();
ЗаполнитьПоМатериаламНаСервере(Объект.Изделие,Объект.Количество);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоМатериаламИНоменклатуре(Команда)
Объект.ТабличнаяЧасть.Очистить();
ЗаполнитьПоМатериаламНаСервере(Объект.Изделие,Объект.Количество);
ЗаполнитьПоНоменклатуреНаСервере(Объект.Изделие,Объект.Количество);
КонецПроцедуры
