import '../models/product_group.dart';
import '../models/product.dart';

// Предустановленные группы товаров
final List<ProductGroup> defaultProductGroups = [
  ProductGroup('Фрукты'),
  ProductGroup('Овощи'),
  ProductGroup('Мясо'),
  ProductGroup('Молочные продукты'),
  ProductGroup('Зерновые'),
  ProductGroup('Напитки'),
  ProductGroup('Сладости'),
  ProductGroup('Хлебобулочные изделия'),
  ProductGroup('Химия'), // Новая категория "Химия"
  ProductGroup('Техника'), // Новая категория "Техника"
];

// Предустановленные товары
final List<ProductName> defaultProductNames = [
  // Фрукты
  ProductName('Персик', 'Фрукты'),
  ProductName('Яблоко', 'Фрукты'),
  ProductName('Груша', 'Фрукты'),
  ProductName('Апельсин', 'Фрукты'),
  ProductName('Банан', 'Фрукты'),
  ProductName('Виноград', 'Фрукты'),
  ProductName('Клубника', 'Фрукты'),

  // Овощи
  ProductName('Капуста', 'Овощи'),
  ProductName('Морковка', 'Овощи'),
  ProductName('Картофель', 'Овощи'),
  ProductName('Помидор', 'Овощи'),
  ProductName('Огурец', 'Овощи'),
  ProductName('Перец', 'Овощи'),
  ProductName('Баклажан', 'Овощи'),

  // Мясо
  ProductName('Говядина', 'Мясо'),
  ProductName('Свинина', 'Мясо'),
  ProductName('Курица', 'Мясо'),
  ProductName('Баранина', 'Мясо'),
  ProductName('Колбаса', 'Мясо'),
  ProductName('Сало', 'Мясо'),

  // Молочные продукты
  ProductName('Молоко', 'Молочные продукты'),
  ProductName('Сыр', 'Молочные продукты'),
  ProductName('Творог', 'Молочные продукты'),
  ProductName('Йогурт', 'Молочные продукты'),
  ProductName('Сметана', 'Молочные продукты'),
  ProductName('Кефир', 'Молочные продукты'),

  // Зерновые
  ProductName('Рис', 'Зерновые'),
  ProductName('Гречка', 'Зерновые'),
  ProductName('Овсянка', 'Зерновые'),
  ProductName('Пшеница', 'Зерновые'),
  ProductName('Кукуруза', 'Зерновые'),

  // Напитки
  ProductName('Вода', 'Напитки'),
  ProductName('Сок', 'Напитки'),
  ProductName('Чай', 'Напитки'),
  ProductName('Кофе', 'Напитки'),
  ProductName('Квас', 'Напитки'),
  ProductName('Морс', 'Напитки'),

  // Сладости
  ProductName('Шоколад', 'Сладости'),
  ProductName('Конфеты', 'Сладости'),
  ProductName('Печенье', 'Сладости'),
  ProductName('Пирожное', 'Сладости'),
  ProductName('Мороженое', 'Сладости'),
  ProductName('Мед', 'Сладости'),

  // Хлебобулочные изделия
  ProductName('Хлеб', 'Хлебобулочные изделия'),
  ProductName('Булочка', 'Хлебобулочные изделия'),
  ProductName('Батон', 'Хлебобулочные изделия'),
  ProductName('Сушки', 'Хлебобулочные изделия'),
  ProductName('Круассан', 'Хлебобулочные изделия'),
  ProductName('Сухари', 'Хлебобулочные изделия'),

  // Химия
  ProductName('Моющее средство', 'Химия'),
  ProductName('Порошок стиральный', 'Химия'),
  ProductName('Отбеливатель', 'Химия'),
  ProductName('Чистящее средство', 'Химия'),
  ProductName('Шампунь', 'Химия'),
  ProductName('Кондиционер для белья', 'Химия'),

  // Техника
  ProductName('Телевизор', 'Техника'),
  ProductName('Смартфон', 'Техника'),
  ProductName('Ноутбук', 'Техника'),
  ProductName('Холодильник', 'Техника'),
  ProductName('Стиральная машина', 'Техника'),
  ProductName('Пылесос', 'Техника'),
  ProductName('Микроволновка', 'Техника'),
];
