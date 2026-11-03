import 'package:flutter/material.dart';

class TransactionItem {//TransactionItem sınfın açılışı uygulamada kullanılacak verinin model'i şemasıdır
  final String id;//string türünden id adlı değişken
  final String title;//string türünden title adlı değişken
  final String category;//string türünden category adlı değişken
  final DateTime date;//DateTime türünden date adlı değişken
  final double amount;//double türünden amount adlı değişken
  final bool isExpense;//bool türünden isExpense adlı değişken
  final IconData icon;//IconData türünden icon adlı değişken

  const TransactionItem({//genel, sabit sınıf constructor'ı   
    required this.id,//id değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.title,//title değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.category,//category değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.date,//date değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.amount,//amount değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.isExpense,//isExpense değişkenin girilmesi zorunlu olduğunu söylüyoruz
    required this.icon,//icon değişkenin girilmesi zorunlu olduğunu söylüyoruz
  });
}
