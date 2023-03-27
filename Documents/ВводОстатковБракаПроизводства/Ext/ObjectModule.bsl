﻿
Процедура ОбработкаПроведения(Отказ, Режим)
// регистр БракПроизводства Приход
Движения.БракПроизводства.Записывать = Истина;
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
	Движение = Движения.БракПроизводства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Линейка = Линейка;
	Движение.МестоХранения = ТекСтрокаТабличнаяЧасть.МестоХранения;
	Движение.ПроизводственноеЗадание = ТекСтрокаТабличнаяЧасть.ПроизводственноеЗадание;
	Движение.РабочееМесто = ТекСтрокаТабличнаяЧасть.РабочееМесто;
	Движение.ВидБрака = ТекСтрокаТабличнаяЧасть.ВидБрака;
	Движение.ЭтапЖизненногоЦикла = ТекСтрокаТабличнаяЧасть.ЭтапЖизненногоЦикла;
	Движение.Изделие = ТекСтрокаТабличнаяЧасть.Изделие;
	Движение.Количество = ТекСтрокаТабличнаяЧасть.Количество;
	Движение.Документ = ТекСтрокаТабличнаяЧасть.Документ;
	КонецЦикла;
КонецПроцедуры
