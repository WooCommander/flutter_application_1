import '../models/product_group.dart';
import '../models/product.dart';

// Предустановленные группы товаров с кодами
final List<ProductGroup> defaultProductGroups = [
  ProductGroup(groupCode: 'G001', name: 'Фрукты'),
  ProductGroup(groupCode: 'G002', name: 'Овощи'),
  ProductGroup(groupCode: 'G003', name: 'Мясо'),
  ProductGroup(groupCode: 'G004', name: 'Молочные продукты'),
  ProductGroup(groupCode: 'G005', name: 'Зерновые'),
  ProductGroup(groupCode: 'G006', name: 'Напитки'),
  ProductGroup(groupCode: 'G007', name: 'Сладости'),
  ProductGroup(groupCode: 'G008', name: 'Хлебобулочные изделия'),
  ProductGroup(groupCode: 'G009', name: 'Химия'), // Новая категория "Химия"
  ProductGroup(groupCode: 'G010', name: 'Техника'), // Новая категория "Техника"
];

// Предустановленные товары с кодами
final List<ProductName> defaultProductNames = [
  // Фрукты
  ProductName(productCode: 'P001', name: 'Персик', groupCode: 'G001'),
  ProductName(productCode: 'P002', name: 'Яблоко', groupCode: 'G001'),
  ProductName(productCode: 'P003', name: 'Груша', groupCode: 'G001'),
  ProductName(productCode: 'P004', name: 'Апельсин', groupCode: 'G001'),
  ProductName(productCode: 'P005', name: 'Банан', groupCode: 'G001'),
  ProductName(productCode: 'P006', name: 'Виноград', groupCode: 'G001'),
  ProductName(productCode: 'P007', name: 'Клубника', groupCode: 'G001'),

  // Овощи
  ProductName(productCode: 'P008', name: 'Капуста', groupCode: 'G002'),
  ProductName(productCode: 'P009', name: 'Морковка', groupCode: 'G002'),
  ProductName(productCode: 'P010', name: 'Картофель', groupCode: 'G002'),
  ProductName(productCode: 'P011', name: 'Помидор', groupCode: 'G002'),
  ProductName(productCode: 'P012', name: 'Огурец', groupCode: 'G002'),
  ProductName(productCode: 'P013', name: 'Перец', groupCode: 'G002'),
  ProductName(productCode: 'P014', name: 'Баклажан', groupCode: 'G002'),

  // Мясо
  ProductName(productCode: 'P015', name: 'Говядина', groupCode: 'G003'),
  ProductName(productCode: 'P016', name: 'Свинина', groupCode: 'G003'),
  ProductName(productCode: 'P017', name: 'Курица', groupCode: 'G003'),
  ProductName(productCode: 'P018', name: 'Баранина', groupCode: 'G003'),
  ProductName(productCode: 'P019', name: 'Колбаса', groupCode: 'G003'),
  ProductName(productCode: 'P020', name: 'Сало', groupCode: 'G003'),

  // Молочные продукты
  ProductName(productCode: 'P021', name: 'Молоко', groupCode: 'G004'),
  ProductName(productCode: 'P022', name: 'Сыр', groupCode: 'G004'),
  ProductName(productCode: 'P023', name: 'Творог', groupCode: 'G004'),
  ProductName(productCode: 'P024', name: 'Йогурт', groupCode: 'G004'),
  ProductName(productCode: 'P025', name: 'Сметана', groupCode: 'G004'),
  ProductName(productCode: 'P026', name: 'Кефир', groupCode: 'G004'),

  // Зерновые
  ProductName(productCode: 'P027', name: 'Рис', groupCode: 'G005'),
  ProductName(productCode: 'P028', name: 'Гречка', groupCode: 'G005'),
  ProductName(productCode: 'P029', name: 'Овсянка', groupCode: 'G005'),
  ProductName(productCode: 'P030', name: 'Пшеница', groupCode: 'G005'),
  ProductName(productCode: 'P031', name: 'Кукуруза', groupCode: 'G005'),

  // Напитки
  ProductName(productCode: 'P032', name: 'Вода', groupCode: 'G006'),
  ProductName(productCode: 'P033', name: 'Сок', groupCode: 'G006'),
  ProductName(productCode: 'P034', name: 'Чай', groupCode: 'G006'),
  ProductName(productCode: 'P035', name: 'Кофе', groupCode: 'G006'),
  ProductName(productCode: 'P036', name: 'Квас', groupCode: 'G006'),
  ProductName(productCode: 'P037', name: 'Морс', groupCode: 'G006'),

  // Сладости
  ProductName(productCode: 'P038', name: 'Шоколад', groupCode: 'G007'),
  ProductName(productCode: 'P039', name: 'Конфеты', groupCode: 'G007'),
  ProductName(productCode: 'P040', name: 'Печенье', groupCode: 'G007'),
  ProductName(productCode: 'P041', name: 'Пирожное', groupCode: 'G007'),
  ProductName(productCode: 'P042', name: 'Мороженое', groupCode: 'G007'),
  ProductName(productCode: 'P043', name: 'Мед', groupCode: 'G007'),

  // Хлебобулочные изделия
  ProductName(productCode: 'P044', name: 'Хлеб', groupCode: 'G008'),
  ProductName(productCode: 'P045', name: 'Булочка', groupCode: 'G008'),
  ProductName(productCode: 'P046', name: 'Батон', groupCode: 'G008'),
  ProductName(productCode: 'P047', name: 'Сушки', groupCode: 'G008'),
  ProductName(productCode: 'P048', name: 'Круассан', groupCode: 'G008'),
  ProductName(productCode: 'P049', name: 'Сухари', groupCode: 'G008'),

  // Химия
  ProductName(productCode: 'P050', name: 'Моющее средство', groupCode: 'G009'),
  ProductName(
      productCode: 'P051', name: 'Порошок стиральный', groupCode: 'G009'),
  ProductName(productCode: 'P052', name: 'Отбеливатель', groupCode: 'G009'),
  ProductName(
      productCode: 'P053', name: 'Чистящее средство', groupCode: 'G009'),
  ProductName(productCode: 'P054', name: 'Шампунь', groupCode: 'G009'),
  ProductName(
      productCode: 'P055', name: 'Кондиционер для белья', groupCode: 'G009'),

  // Техника
  ProductName(productCode: 'P056', name: 'Телевизор', groupCode: 'G010'),
  ProductName(productCode: 'P057', name: 'Смартфон', groupCode: 'G010'),
  ProductName(productCode: 'P058', name: 'Ноутбук', groupCode: 'G010'),
  ProductName(productCode: 'P059', name: 'Холодильник', groupCode: 'G010'),
  ProductName(
      productCode: 'P060', name: 'Стиральная машина', groupCode: 'G010'),
  ProductName(productCode: 'P061', name: 'Пылесос', groupCode: 'G010'),
  ProductName(productCode: 'P062', name: 'Микроволновка', groupCode: 'G010'),
];
