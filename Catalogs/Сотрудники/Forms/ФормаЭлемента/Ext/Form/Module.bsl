﻿
&НаСервере
Функция ПечатьКарточкиСотрудникаНаСервере()
ТабДок = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("КарточкаСотрудника");
ОблКарточка = Макет.ПолучитьОбласть("Карточка");

QRCode = ЗначениеВСтрокуВнутр(Объект.Ссылка);
ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRCode, 0, 100);	
	Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
	КартинкаQRКода = Новый Картинка(ДанныеQRКода);
	ОблКарточка.Рисунки.QRCode.Картинка = КартинкаQRКода;
	Иначе
	Сообщить("Не удалось сформировать QR-код!");
	КонецЕсли;
ОблКарточка.Параметры.ФИО = СокрЛП(Объект.Наименование);
ТабДок.Вывести(ОблКарточка);
ТабДок.РазмерСтраницы = "A4";
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьКарточкиСотрудника(Команда)
ТабДок = ПечатьКарточкиСотрудникаНаСервере();
ТабДок.Показать("Карточка клиента");
КонецПроцедуры

&НаКлиенте
Процедура ПодборЛинеек(Команда)
ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Ложь);
ОткрытьФорму("Справочник.Линейки.Форма.ФормаВыбораЭлементовИГрупп",ПараметрыПодбора,Элементы.ЛинейкиПроизводства);
КонецПроцедуры

&НаСервере
Процедура ДобавитьЛинейку(ВыбранноеЗначение)
	Если Объект.ЛинейкиПроизводства.НайтиСтроки(Новый Структура("Линейка",ВыбранноеЗначение)).Количество() = 0 Тогда
	ТЧ = Объект.ЛинейкиПроизводства.Добавить();
	ТЧ.Линейка = ВыбранноеЗначение;
	КонецЕсли; 
КонецПроцедуры 

&НаКлиенте
Процедура ЛинейкиПроизводстваОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
ДобавитьЛинейку(ВыбранноеЗначение);
ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПодборПодразделений(Команда)
ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Ложь);
ОткрытьФорму("Справочник.Подразделения.ФормаВыбора",ПараметрыПодбора,Элементы.Подразделения);
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодразделение(ВыбранноеЗначение)
	Если Объект.Подразделения.НайтиСтроки(Новый Структура("Подразделение",ВыбранноеЗначение)).Количество() = 0 Тогда
	ТЧ = Объект.Подразделения.Добавить();
	ТЧ.Подразделение = ВыбранноеЗначение;
	КонецЕсли; 
КонецПроцедуры 

&НаКлиенте
Процедура ПодразделенияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
ДобавитьПодразделение(ВыбранноеЗначение);
ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры
