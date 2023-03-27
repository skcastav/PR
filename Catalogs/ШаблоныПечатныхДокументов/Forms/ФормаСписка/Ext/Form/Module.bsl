﻿
&НаСервере
Процедура ПоказатьШаблонНаСервере(Стр)
ТабДок.Очистить();
СписокПеременныхДанных.Очистить();
	Если Стр.Внешний Тогда
	Макет = Новый ТабличныйДокумент;
	
	Макет.Прочитать(Константы.КаталогДокументовИПрограмм.Получить()+"532 (Паспорта)\Шаблоны\Шаблоны1С8\"+СокрЛП(Стр.Шаблон));
	Иначе	
	Макет = ПолучитьОбщийМакет(Стр.Шаблон);
	КонецЕсли;
		Если Стр.КоличествоРядов > 1 Тогда
		ОблШаблон = Макет.ПолучитьОбласть(,1,,1);
		Иначе	
		ОблШаблон = Макет.ПолучитьОбласть(,,,);
		КонецЕсли; 
Парам = ПолучитьМассивИменПараметров(ОблШаблон);
	Для к = 0 по Парам.ВГраница() Цикл
	ОблШаблон.Параметры[Парам[к]] = "<"+Парам[к]+">";
	СписокПеременныхДанных.Добавить(Парам[к]);
	КонецЦикла;
СписокПеременныхДанных.СортироватьПоЗначению();
ТабДок.Вывести(ОблШаблон);
	Если Стр.КоличествоРядов > 1 Тогда
		Для к = 1 По Стр.КоличествоРядов-1 Цикл
		ТабДок.Присоединить(ОблШаблон);
		КонецЦикла; 
	КонецЕсли; 
ТабДок.РазмерСтраницы = Стр.РазмерСтраницы;
ТабДок.ПолеСлева = Стр.ПолеСлева;
ТабДок.ПолеСверху = Стр.ПолеСверху;
ТабДок.ПолеСнизу = Стр.ПолеСнизу;
ТабДок.ПолеСправа = Стр.ПолеСправа;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьШаблон(Команда)
ПоказатьШаблонНаСервере(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры
