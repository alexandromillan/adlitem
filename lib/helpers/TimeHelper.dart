import 'package:flutter/material.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

extension FormatDate on DateTime {
  String toYMD() {
    final dia = this.day.toString().padLeft(2, "0");
    final mes = this.month.toString().padLeft(2, "0");
    final anno = this.year.toString();
    return '$anno-$mes-$dia';
  }
}

TimeDiff(timeEnd, timeInit) {
  var timeSplit = timeInit.split(':');
  int minutos_inicio = 0;
  minutos_inicio += int.parse(timeSplit[0]) * 60 + int.parse(timeSplit[1]);

  var timeSplitEnd = timeEnd.split(':');
  int minutos_final = 0;
  minutos_final = int.parse(timeSplitEnd[0]) * 60 + int.parse(timeSplitEnd[1]);

  // Si la hora final es anterior a la hora inicial sale
  if (minutos_final < minutos_inicio) return null;
  // Diferencia de minutos
  var diferencia = minutos_final - minutos_inicio;

  // Cálculo de horas y minutos de la diferencia
  var horas = ((diferencia / 60)).round().floor();
  var minutos = diferencia % 60;

  return {
    'difMin': diferencia,
    'horas': horas,
    'minutos': minutos,
  };
}
