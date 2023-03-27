﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЭтотОбъект.ТолькоПросмотр = ОбщийМодульСозданиеДокументов.ЗапретРедактирования(Объект.Ссылка,Истина,Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьМПЗПриИзменении(Элемент)
ТабличнаяЧастьМПЗПриИзмененииНаСервере(Элементы.ТабличнаяЧасть.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ТабличнаяЧастьМПЗПриИзмененииНаСервере(Стр)
ТЧ = Объект.ТабличнаяЧасть.НайтиПоИдентификатору(Стр);
ТЧ.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения;
	Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
	ТЧ.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(ТЧ.МПЗ,ТекущаяДата())*ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
	Иначе
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
	ТЧ.Цена = ОбщийМодульВызовСервера.ПолучитьПолнуюСебестоимость(ТЧ.МПЗ)*ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения.Коэффициент;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюНаСервере()
Объект.ТабличнаяЧасть.Очистить();
Об = РеквизитФормыВЗначение("Объект");
Об.ОбработкаЗаполнения(Объект.ДокументОснование,Истина);
ВыгрузкаТЧ = Об.ТабличнаяЧасть.Выгрузить();
Объект.ТабличнаяЧасть.Загрузить(ВыгрузкаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
ЗаполнитьПоОснованиюНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодборМПЗНаСервере(ТаблицаМПЗ)
	Для каждого ТЧ_МПЗ Из ТаблицаМПЗ Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;		
		ТЧ.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(ТЧ_МПЗ.МПЗ,ТекущаяДата());
		Иначе
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
		ТЧ.Цена =  ОбщийМодульВызовСервера.ПолучитьПолнуюСебестоимость(ТЧ_МПЗ.МПЗ);		
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

&НаКлиенте
Процедура ТабличнаяЧастьВидМПЗПриИзменении(Элемент)
Элементы.ТабличнаяЧасть.ТекущиеДанные.МПЗ = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
Отказ = Не ЭтаФорма.ПроверитьЗаполнение();
КонецПроцедуры

&НаСервере
Функция ПечатьQRКодыНаСервере()
ТабДок = Новый ТабличныйДокумент;

barcode = ПолучитьCOMОбъект("","STROKESCRIBE.StrokeScribeClass.1");
barcode.Alphabet=25; //QRCODE
Макет = ПолучитьОбщийМакет("QRКодКанбан3");
ОблQRКод = Макет.ПолучитьОбласть("QRКод|Секция");
Четный = Ложь;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	QRCode = ЗначениеВСтрокуВнутр(ТЧ.МПЗ);
	ИмяФайла=ПолучитьИмяВременногоФайла("wmf");
	barcode.Text=QRCode;
	barcode.UTF8=1;
	barcode.QrECL=2;
	код=barcode.SavePicture(ИмяФайла,7,100,100);          
		Если код <> 0 Тогда //Проверка результата генерации штрихкода
		Сообщить(строка(код) + " - " + barcode.ErrorDescription);
		Возврат Неопределено;
		КонецЕсли;
	рис=ОблQRКод.Рисунки.QRCode;
	рис.РазмерКартинки=РазмерКартинки.Пропорционально;
	рис.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии);
	рис.Картинка = Новый Картинка(ИмяФайла);
	ОблQRКод.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование); 
		Если Не Четный Тогда
		ТабДок.Вывести(ОблQRКод);
		Четный = Истина;
		Иначе	
		ТабДок.Присоединить(ОблQRКод);
		Четный = Ложь;
		КонецЕсли;  
	УдалитьФайлы(ИмяФайла);
	КонецЦикла; 
ТабДок.РазмерСтраницы = "A4";
ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьQRКоды(Команда)
ТД = ПечатьQRКодыНаСервере();
	Если ТД <> Неопределено Тогда
	ТД.Показать("QR-коды");
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПечатьПриходныйОрдерНаСервере()
ТабДок = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("ПриходныйОрдер");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблПодвал = Макет.ПолучитьОбласть("Подвал");

ОблШапка.Параметры.Организация = "Организация: " +Константы.НазваниеОрганизации.Получить();
ОблШапка.Параметры.КодОКПО = Константы.КодОКПО.Получить();
ОблШапка.Параметры.СтруктурноеПодразделение = "Структурное подразделение: " + Объект.МестоХранения;
ОблШапка.Параметры.МестоХранения = Объект.МестоХранения;
ОблШапка.Параметры.Номер = Объект.Номер;
ОблШапка.Параметры.ДатаСоставления = Формат(Объект.Дата,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);
ИтогоКоличество = 0;
ИтогоСумма = 0;
ИтогоНДС = 0;
ИтогоВсего = 0;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	ОблСтрока.Параметры.МПЗКод = ?(ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы,ТЧ.МПЗ.Код,"");
	ОблСтрока.Параметры.МПЗ = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблСтрока.Параметры.ЕдиницаИзмеренияКод = ТЧ.ЕдиницаИзмерения.Код;
	ОблСтрока.Параметры.ЕдиницаИзмерения = СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование);
	ОблСтрока.Параметры.Принято = ТЧ.Количество;
	Цена = ОбщийМодульВызовСервера.ПолучитьСтоимостьМПЗ(ТЧ.МПЗ,1,Объект.Дата,0);
	ОблСтрока.Параметры.Цена = Цена;
	Сумма = Цена*ТЧ.Количество;
	ОблСтрока.Параметры.Сумма = Сумма;
	НДС = Сумма*Константы.ОсновнаяСтавкаНДС.Получить().Ставка;
	ОблСтрока.Параметры.НДС = НДС;
	ОблСтрока.Параметры.Всего = Сумма+НДС;		
	ТабДок.Вывести(ОблСтрока);
	ИтогоКоличество = ИтогоКоличество+ТЧ.Количество;
	ИтогоСумма = ИтогоСумма+Сумма;
	ИтогоНДС = ИтогоНДС+НДС;
	ИтогоВсего = ИтогоВсего+Сумма+НДС;
	КонецЦикла;
ОблПодвал.Параметры.ИтогоКоличество = ИтогоКоличество;
ОблПодвал.Параметры.ИтогоСумма = ИтогоСумма;
ОблПодвал.Параметры.ИтогоНДС = ИтогоНДС;
ОблПодвал.Параметры.ИтогоВсего = ИтогоВсего;		
ТабДок.Вывести(ОблПодвал);
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьПриходныйОрдер(Команда)
ТД = ПечатьПриходныйОрдерНаСервере();
ТД.Показать("Приходный ордер (форма №М-4)");
КонецПроцедуры

&НаСервере
Процедура ПечатьПриходнаяНакладнаяНаСервере(ТабДок)
Макет = Документы.ПоступлениеМПЗПрочее.ПолучитьМакет("ПриходнаяНакладная");
ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблСтрока = Макет.ПолучитьОбласть("Строка");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.Документ = Объект.Ссылка;
ОблШапка.Параметры.ДокументОснование = Объект.ДокументОснование;
ОблШапка.Параметры.Подразделение = Объект.Подразделение;
ОблШапка.Параметры.МестоХранения = Объект.МестоХранения;
ОблШапка.Параметры.Статья = Объект.Статья;
ОблШапка.Параметры.ДатаВывода = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);
НомСтр = 0;
СуммаИтого = 0;
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
	НомСтр = НомСтр + 1;
	ОблСтрока.Параметры.НомСтр = НомСтр;
	ОблСтрока.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблСтрока.Параметры.ЕдиницаИзмерения = СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование);
	ОблСтрока.Параметры.Количество = ТЧ.Количество;
	Цена = ОбщийМодульВызовСервера.ПолучитьСтоимостьМПЗ(ТЧ.МПЗ,1,Объект.Дата,0)*ТЧ.ЕдиницаИзмерения.Коэффициент;
	ОблСтрока.Параметры.Цена = Формат(Цена,"ЧЦ=9; ЧДЦ=2");
	ОблСтрока.Параметры.Сумма = Цена*ТЧ.Количество;	
	СуммаИтого = СуммаИтого+Цена*ТЧ.Количество;	
	ТабДок.Вывести(ОблСтрока);
	КонецЦикла;
ОблКонец.Параметры.СуммаИтого = СуммаИтого;
ОблКонец.Параметры.ДолжностьПолучил = СокрЛП(Объект.МестоХранения.МОЛ.Должность.Наименование); 
ОблКонец.Параметры.Получил = СокрЛП(Объект.МестоХранения.МОЛ.Наименование); 
ОблКонец.Параметры.ДолжностьУтвердил = СокрЛП(Объект.Подразделение.Руководитель.Должность.Наименование);
ОблКонец.Параметры.Утвердил = СокрЛП(Объект.Подразделение.Руководитель.Наименование); 
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПриходнаяНакладная(Команда)
	Если ЭтаФорма.Модифицированность Тогда	
	Сообщить("Для печати документ необходимо перепровести.");
	Возврат;		
	КонецЕсли;
ТабДок = Новый ТабличныйДокумент;

ПечатьПриходнаяНакладнаяНаСервере(ТабДок);
ТабДок.Показать("Приходная накладная");
КонецПроцедуры

&НаСервере
Функция СовпадаетСПодразделенимДокумента(МестоХранения)
Возврат(?(МестоХранения.Подразделение = Объект.Подразделение,Истина,Ложь));
КонецФункции 

&НаКлиенте
Процедура МестоХраненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не СовпадаетСПодразделенимДокумента(ВыбранноеЗначение) Тогда	
	СтандартнаяОбработка = Ложь;
	Сообщить("Выбранное место хранения принадлежит другому подразделению!");	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПечатьМаркировкаSMD(Команда)
ОткрытьФорму("Обработка.МаркировкаМатериалов.Форма.Форма",Новый Структура("Документ",Объект.Ссылка),,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
КонецПроцедуры
