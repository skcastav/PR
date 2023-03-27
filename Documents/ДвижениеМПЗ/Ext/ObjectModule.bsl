﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)Экспорт
Автор = ПараметрыСеанса.Пользователь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ДвижениеМПЗ") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
	МестоХранения = ДанныеЗаполнения.МестоХраненияВ;
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.ВидМПЗ = ТекСтрокаТабличнаяЧасть.ВидМПЗ;
		НоваяСтрока.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
		НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения;
		НоваяСтрока.Количество = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаОтПокупателя") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.ВидМПЗ = ТекСтрокаТабличнаяЧасть.ВидМПЗ;
		НоваяСтрока.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
		НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения;
		НоваяСтрока.Количество = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеМПЗ") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
	МестоХранения = ДанныеЗаполнения.МестоХранения;
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.ВидМПЗ = ТекСтрокаТабличнаяЧасть.ВидМПЗ;
		НоваяСтрока.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
		НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения;
		НоваяСтрока.Количество = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеМПЗПрочее") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
	МестоХранения = ДанныеЗаполнения.МестоХранения;
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.ВидМПЗ = ТекСтрокаТабличнаяЧасть.ВидМПЗ;
		НоваяСтрока.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
		НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения;
		НоваяСтрока.Количество = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.МаршрутнаяКарта") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
	МестоХраненияВ = ДанныеЗаполнения.Линейка.МестоХраненияКанбанов;
	НоваяСтрока = ТабличнаяЧасть.Добавить();
	НоваяСтрока.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
	МПЗ = ПолучитьСпецификациюКанбана(ДанныеЗаполнения.Ссылка.Номенклатура);
		Если МПЗ <> Неопределено Тогда
		НоваяСтрока.МПЗ = МПЗ;
		НоваяСтрока.ЕдиницаИзмерения = МПЗ.ОсновнаяЕдиницаИзмерения;
		КонецЕсли;
	НоваяСтрока.Количество = ДанныеЗаполнения.Количество/МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеИзПереработки") Тогда
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
	МестоХранения = ДанныеЗаполнения.МестоХранения;
	НоваяСтрока = ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ДанныеЗаполнения.Номенклатура) = Тип("СправочникСсылка.Материалы") Тогда
		НоваяСтрока.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;	
		Иначе	
		НоваяСтрока.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;		
		КонецЕсли;
	МПЗ = ДанныеЗаполнения.Номенклатура; 
	НоваяСтрока.МПЗ = МПЗ;
	НоваяСтрока.ЕдиницаИзмерения = МПЗ.ОсновнаяЕдиницаИзмерения;
	НоваяСтрока.Количество = ДанныеЗаполнения.Количество/МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьСпецификациюКанбана(Номенклатура)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(Номенклатура,ТекущаяДата());
ВидКанбана = Справочники.ВидыКанбанов.НайтиПоНаименованию("Канбан ДД (произв.партиями)",Истина);
	Пока ВыборкаНР.Следующий() Цикл
		Если ВыборкаНР.Элемент.Канбан = ВидКанбана Тогда	
		Возврат(ВыборкаНР.Элемент);
		КонецЕсли; 
	КонецЦикла;
Возврат(Неопределено);
КонецФункции 

Функция ПроверитьРучнойЗапуск(ЗНП,Продукция)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказНаПроизводствоЗаказ.Продукция КАК Продукция
	|ИЗ
	|	Документ.ЗаказНаПроизводство.Заказ КАК ЗаказНаПроизводствоЗаказ
	|ГДЕ
	|	ЗаказНаПроизводствоЗаказ.Ссылка = &Ссылка
	|	И ЗаказНаПроизводствоЗаказ.Продукция = &Продукция
	|	И ЗаказНаПроизводствоЗаказ.РучнойЗапуск = 0";
Запрос.УстановитьПараметр("Ссылка", ЗНП);
Запрос.УстановитьПараметр("Продукция", Продукция);             
Возврат(Запрос.Выполнить().Пустой());
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	Если МестоХранения.Пустая() Тогда
	СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь); 
	Отказ = Истина;
	Сообщить("Укажите исходное место хранения!"); 
	Возврат;
	КонецЕсли;
		Если МестоХраненияВ.Пустая() Тогда
		СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);
		Отказ = Истина;
		Сообщить("Укажите место хранения для перемещения!");  
		Возврат;
		КонецЕсли; 
МестаХранения = РегистрыНакопления.МестаХранения;
Движения.МестаХранения.Записывать = Истина;
СписокМПЗ = Новый СписокЗначений;

ВиртуальнаяТабличнаяЧасть = ТабличнаяЧасть.Выгрузить();
ВиртуальнаяТабличнаяЧасть.Свернуть("ВидМПЗ,МПЗ,ЕдиницаИзмерения","Количество");
	Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
	СписокМПЗ.Добавить(ТЧ.МПЗ);
	Требуется = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
	КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоМестуХранения(МестоХранения,ТЧ.МПЗ,Дата);
		Если КолОстаток >= Требуется Тогда
		Движение = Движения.МестаХранения.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.МестоХранения = МестоХранения;
		Движение.ВидМПЗ = ТЧ.ВидМПЗ;
		Движение.МПЗ = ТЧ.МПЗ;
		Движение.Количество = Требуется;
			Если Не НаСборке Тогда
			Движение = Движения.МестаХранения.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.МестоХранения = МестоХраненияВ;
			Движение.ВидМПЗ = ТЧ.ВидМПЗ;
			Движение.МПЗ = ТЧ.МПЗ;
			Движение.Количество = Требуется;
			КонецЕсли;
		Иначе
		СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);
		Отказ = Истина;
		Сообщить("МПЗ: "+СокрЛП(ТЧ.МПЗ.Наименование)+" требуется: "+Требуется+" недостаёт на складе: "+Строка(Требуется-КолОстаток));
		КонецЕсли;		 
	КонецЦикла;
		
		Если НаСборке Тогда
		Возврат;
		КонецЕсли;
//Анализ документа основания
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
		Если МестоХранения = Константы.МестоХраненияТранзит.Получить() Тогда
		// регистр Долги Расход
		Движения.Долги.Записывать = Истина;
		КоличествоВсего = 0;
			Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
			БазовоеКоличество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
			КоличествоВсего = КоличествоВсего + БазовоеКоличество;
			КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоДолгам(ДокументОснование,ТЧ.МПЗ,Дата);
				Если КолОстаток >= БазовоеКоличество Тогда
				Движение = Движения.Долги.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.Документ = ДокументОснование;
				Движение.Продукция = ТЧ.МПЗ;
				Движение.Количество = БазовоеКоличество;
				Иначе
				СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);
				Отказ = Истина;
				Сообщить("Продукция: "+СокрЛП(ТЧ.МПЗ.Наименование)+" требуется переместить: "+БазовоеКоличество+" недостаёт в регистре долгов: "+Строка(БазовоеКоличество-КолОстаток));
				КонецЕсли;
			КонецЦикла;
		ОбщийМодульВызовСервера.ПроверитьЗаказНаПроизводство(ДокументОснование,КоличествоВсего,Дата);
		ИначеЕсли МестоХранения = Константы.МестоХраненияНеликвидов.Получить() Тогда
		Движения.РезервированиеГП.Записывать = Истина;
			Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
			Требуется = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
			КоличествоОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокВРезерве(МестоХранения,ТЧ.МПЗ,ДокументОснование,Дата);
				Если КоличествоОстаток >= Требуется Тогда
				Движения.РезервированиеГП.Записывать = Истина;
				Движение = Движения.РезервированиеГП.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.МестоХранения = МестоХранения;
				Движение.Продукция = ТЧ.МПЗ;
				Движение.Документ = ДокументОснование;
				Движение.Количество = Требуется;		
				Иначе
				СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);	
				Отказ = Истина;
				Сообщить("Изделие: "+СокрЛП(ТЧ.МПЗ.Наименование)+" требуется: "+Требуется+" недостаёт на складе неликвидов: "+Строка(Требуется-КоличествоОстаток));		
				КонецЕсли;
			Движение = Движения.РезервированиеГП.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.МестоХранения = МестоХраненияВ;
			Движение.Продукция = ТЧ.МПЗ;
			Движение.Документ = ДокументОснование;
			Движение.Количество = Требуется;		
			КонецЦикла;			
		КонецЕсли;		
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.Перепрогон") Тогда	
	ДвижениеОсн = ДокументОснование.ДокументОснование;
		Если ЗначениеЗаполнено(ДвижениеОсн) Тогда
		ЗНП = ДвижениеОсн.ДокументОснование;
			Если ЗначениеЗаполнено(ЗНП) Тогда
				Если ТипЗнч(ЗНП) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
				Изделие = ТабличнаяЧасть[0].МПЗ;
				Количество = ПолучитьБазовоеКоличество(ТабличнаяЧасть[0].Количество,ТабличнаяЧасть[0].ЕдиницаИзмерения);
				//регистр Резервирование ГП Расход
				КоличествоОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокВРезерве(ДвижениеОсн.МестоХраненияВ,Изделие,ЗНП,Дата);
					Если КоличествоОстаток >= Количество Тогда
					Движения.РезервированиеГП.Записывать = Истина;
					Движение = Движения.РезервированиеГП.Добавить();
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
					Движение.Период = Дата;
					Движение.МестоХранения = ДвижениеОсн.МестоХраненияВ;
					Движение.Продукция = Изделие;
					Движение.Документ = ЗНП;
					Движение.Количество = Количество;		
					Иначе
					СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);	
					Отказ = Истина;
					Сообщить("Изделие: "+СокрЛП(Изделие.Наименование)+" требуется: "+Количество+" недостаёт на складе: "+Строка(Количество-КоличествоОстаток));		
					КонецЕсли;
						Если ДокументОснование.Статус = 1 Тогда
						// регистр ЗаказыНаПроизводство Расход
							Если Не ПроверитьРучнойЗапуск(ЗНП,Изделие) Тогда
							КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоЗаказуНаПроизводство(ЗНП,Изделие,Дата);
								Если КолОстаток >= Количество Тогда
								Движения.ЗаказыНаПроизводство.Записывать = Истина;
								Движение = Движения.ЗаказыНаПроизводство.Добавить();
								Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
								Движение.Период = Дата;
								Движение.Продукция = Изделие;
								Движение.Количество = Количество;
								Движение.Документ = ЗНП;
									Если КолОстаток = Количество Тогда
										Если Не ЗНП.ВнутренниеСчета Тогда
										ДВПЗ = РегистрыСведений.ДатыВыполненияПоПозициямЗНП.СоздатьМенеджерЗаписи();
										ДВПЗ.НомерЗНП = ЗНП.Номер;
										ДВПЗ.КодТовара = Изделие.Товар.Код;
										ДВПЗ.ДатаВыполнения = Дата;
											Если ТипЗнч(Изделие) = Тип("СправочникСсылка.Номенклатура") Тогда
											ДВПЗ.ЗапрещеноКОтгрузке = Изделие.ЗапрещеноКОтгрузке;									
											КонецЕсли; 
										ДВПЗ.Записать(Истина);
										КонецЕсли;
									КонецЕсли;
								Иначе
								СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);
								Отказ = Истина;
								Сообщить("Изделие: "+СокрЛП(Изделие.Наименование)+" требуется: "+Количество+" в заказе на пр-во недостаёт: "+Строка(Количество-КолОстаток));
								КонецЕсли;
							КонецЕсли;
						// регистр РезервированиеГП Приход
						Движения.РезервированиеГП.Записывать = Истина;
						Движение = Движения.РезервированиеГП.Добавить();
						Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
						Движение.Период = Дата;
						Движение.МестоХранения = МестоХраненияВ;
						Движение.Продукция = Изделие;
						Движение.Документ = ЗНП;
						Движение.Количество = Количество;				
						КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
	Иначе
	//Анализ брака
		Если ОбщийМодульВызовСервера.АнализироватьБракПоМестуХранения(МестоХраненияВ) Тогда //перемещение в брак
		// регистр БракПроизводства
		Движения.БракПроизводства.Записывать = Истина;
			Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
			Движение = Движения.БракПроизводства.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.МестоХранения = МестоХраненияВ; 
				//Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
				//Движение.ПроизводственноеЗадание = ДокументОснование;					
				//Иначе	
				//Движение.ПроизводственноеЗадание = ДокументОснование.ДокументОснование;					
				//КонецЕсли;
			Движение.Линейка = РабочееМесто.Линейка;
			Движение.РабочееМесто = РабочееМесто;
			Движение.Изделие = ТЧ.МПЗ;
			Движение.ВидБрака = ВидБрака;
			Движение.ЭтапЖизненногоЦикла = ЭтапЖизненногоЦикла; 
			Движение.Документ = Ссылка;
			Движение.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
			КонецЦикла;
		ИначеЕсли ОбщийМодульВызовСервера.АнализироватьБракПоМестуХранения(МестоХранения) Тогда //перемещение из брака
			Если ЗначениеЗаполнено(ДокументОснование) Тогда
			// регистр БракПроизводства
			Движения.БракПроизводства.Записывать = Истина;
				Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
				КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоРегиструБрака(ДокументОснование,МестоХранения,ТЧ.МПЗ,Дата);
				БазовоеКоличество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
					Если КолОстаток < БазовоеКоличество Тогда
					СРМ_ОбменВебСервис.ОтправкаВебСервисДокументУдалениеПередУдалением(ЭтотОбъект, Ложь);
					Отказ = Истина;
					Сообщить("МПЗ "+ТЧ.МПЗ+" требуется списать: "+БазовоеКоличество+" наличествует в браке: "+КолОстаток);
					Продолжить;
					КонецЕсли; 		
				Движение = Движения.БракПроизводства.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.МестоХранения = МестоХранения;
					Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВыпускПродукцииКанбан") Тогда
					Движение.ПроизводственноеЗадание = ДокументОснование.ДокументОснование;
					КонецЕсли;
				Движение.Линейка = ДокументОснование.РабочееМесто.Линейка;
				Движение.РабочееМесто = ДокументОснование.РабочееМесто;
				Движение.Изделие = ТЧ.МПЗ;
				Движение.ВидБрака = ДокументОснование.ВидБрака;
				Движение.ЭтапЖизненногоЦикла = ДокументОснование.ЭтапЖизненногоЦикла;
				Движение.Документ = ДокументОснование;
				Движение.Количество = БазовоеКоличество;
				КонецЦикла;
			КонецЕсли;		
		КонецЕсли;
	ОбщийМодульРаботаСРегистрами.СнятиеСЛьготнойОчереди(СписокМПЗ,МестоХраненияВ,Дата);
	КонецЕсли; 
КонецПроцедуры
