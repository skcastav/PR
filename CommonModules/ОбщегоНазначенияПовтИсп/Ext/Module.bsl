﻿#Область Оптимизация_Отчет_ИнструментПланированияЗакупок
Функция ПолучитьАналогиНормРасходов(НормаРасходов,НаДату = Неопределено,ВсеЭлементы = Ложь) Экспорт
Запрос = Новый Запрос; 

	Если ВсеЭлементы Тогда
	Запрос.Текст =	
		"ВЫБРАТЬ
		|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов КАК Ссылка,
		|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ВидЭлемента КАК ВидЭлемента,
		|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.Элемент КАК Элемент,
		|	АналогиНормРасходовСрезПоследних.Норма КАК Норма
		|ИЗ
		|	РегистрСведений.АналогиНормРасходов.СрезПоследних(&НаДату, Владелец = &Владелец) КАК АналогиНормРасходовСрезПоследних
		|ГДЕ
		|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ПометкаУдаления = ЛОЖЬ
		|	И АналогиНормРасходовСрезПоследних.Норма > 0";	
	Иначе	
	Запрос.Текст =	
		"ВЫБРАТЬ
	  	|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов КАК Ссылка,         
		|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ВидЭлемента КАК ВидЭлемента,
		|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.Элемент КАК Элемент,
	  	|	АналогиНормРасходовСрезПоследних.Норма КАК Норма
	  	|ИЗ
	  	|	РегистрСведений.АналогиНормРасходов.СрезПоследних(
	  	|			&НаДату,
	  	|			Владелец = &Владелец
	  	|				И (ТИПЗНАЧЕНИЯ(АналогНормыРасходов.Элемент) = ТИП(Справочник.Материалы)
	  	|					ИЛИ ТИПЗНАЧЕНИЯ(АналогНормыРасходов.Элемент) = ТИП(Справочник.Номенклатура))) КАК АналогиНормРасходовСрезПоследних
	  	|ГДЕ
	  	|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ПометкаУдаления = ЛОЖЬ
	    |	И АналогиНормРасходовСрезПоследних.Норма > 0";	
	КонецЕсли;
Запрос.УстановитьПараметр("НаДату", ?(НаДату = Неопределено,ТекущаяДата(),НаДату));
Запрос.УстановитьПараметр("Владелец", НормаРасходов);
Возврат(Запрос.Выполнить().Выгрузить()); 
КонецФункции

Функция ПолучитьАналогиМПЗ(МПЗ,НаДату = Неопределено) Экспорт
Запрос = Новый Запрос;

Запрос.Текст =		
	"ВЫБРАТЬ
  	|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов КАК Ссылка,
	|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.Элемент КАК Элемент,
  	|	АналогиНормРасходовСрезПоследних.Норма КАК Норма
  	|ИЗ
  	|	РегистрСведений.АналогиНормРасходов.СрезПоследних(
  	|			&НаДату,
  	|			Владелец.Элемент = &МПЗ
  	|				И (ТИПЗНАЧЕНИЯ(АналогНормыРасходов.Элемент) = ТИП(Справочник.Материалы)
  	|					ИЛИ ТИПЗНАЧЕНИЯ(АналогНормыРасходов.Элемент) = ТИП(Справочник.Номенклатура))) КАК АналогиНормРасходовСрезПоследних
  	|ГДЕ
  	|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ПометкаУдаления = ЛОЖЬ
  	|	И АналогиНормРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("НаДату", ?(НаДату = Неопределено,ТекущаяДата(),НаДату));
Запрос.УстановитьПараметр("МПЗ", МПЗ);
Возврат(Запрос.Выполнить().Выгрузить()); 
КонецФункции

Функция НормыРасходов_ПолучитьПоследнее(НормаРасходов,НаДату = Неопределено) Экспорт
	Если НаДату = Неопределено Тогда
	НаДатуВремя = ТекущаяДата();
	Иначе
		Если НаДату = НачалоДня(ТекущаяДата()) Тогда
		НаДатуВремя = ТекущаяДата();	
		Иначе	
		НаДатуВремя = НаДату;	
		КонецЕсли;
	КонецЕсли;
НормыАНР = РегистрыСведений.НормыРасходов.ПолучитьПоследнее(НаДатуВремя,Новый Структура("НормаРасходов",НормаРасходов)); 
Возврат НормыАНР;
КонецФункции

Функция АналогиНормРасходов_ПолучитьПоследнее(АналогНормыРасходов,НаДату = Неопределено) Экспорт
	Если НаДату = Неопределено Тогда
	НаДатуВремя = ТекущаяДата();
	Иначе
		Если НаДату = НачалоДня(ТекущаяДата()) Тогда
		НаДатуВремя = ТекущаяДата();	
		Иначе	
		НаДатуВремя = НаДату;	
		КонецЕсли;
	КонецЕсли;
НормыАНР = РегистрыСведений.АналогиНормРасходов.ПолучитьПоследнее(НаДатуВремя,Новый Структура("АналогНормыРасходов",АналогНормыРасходов)); 
Возврат НормыАНР;
КонецФункции

Функция ПолучитьЗначениеРеквизита(Ссылка, ИмяРеквизита) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

Функция ПринадлежитЭлементу(Элемент,ГруппаИлиЭлемент) Экспорт
	Возврат Элемент.ПринадлежитЭлементу(ГруппаИлиЭлемент);
КонецФункции

Функция ПолучитьБазовоеКоличествоБезОкругленияПИ(Количество,ОсновнаяЕдиницаИзмерения) Экспорт
	Возврат ПолучитьБазовоеКоличествоБезОкругления(Количество,ОсновнаяЕдиницаИзмерения);
КонецФункции

#КонецОбласти