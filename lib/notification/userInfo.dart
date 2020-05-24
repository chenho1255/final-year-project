import 'dart:io';
import 'package:path_provider/path_provider.dart';

class user_save{

  final String name;
  final String DOB;
  final String PPSN;
  final String Medicatation;
  final String Dosage;
  final String Frequency;
  final String Instructions;


  user_save({this.name, this.DOB, this.PPSN, this.Medicatation,
    this.Dosage,this.Frequency, this.Instructions});

  factory user_save.fromJson(Map<String, dynamic> json) {
    return user_save(
      name: json['name'] ,
      DOB: json['DOB'] ,
      PPSN: json['PPSN'],
      Medicatation: json['Medictation_Name'],
      Dosage:json['Dosage'],
      Frequency:json['Frequency'],
      Instructions:json['Instructions'],
    );
  }
}