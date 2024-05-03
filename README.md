# joomys

joomys это приложение для поиска работы. Данная часть является мобильной версией реализованной на Flutter SDK и Andoid Toolkit. Backend часть данного приложения доступна по данной ссылке.

```
https://github.com/adaskhan/joomys
```

### Установка и запуск проекта на Flutter

Для запуска проекта на Flutter в первую очередь нужно установить Flutter SDK.

---
Если нужен видео туториал то вот, можно посмотреть данное видео, просто кликните на картинку :

[<img src="https://owenhalliday.co.uk/static/ee54ba1ab58fec57cf4784cc67336993/f3b7d/intro-flutter-thumb.png" width="600" height="300"
/>](https://youtu.be/k7vCccuDlzc?si=aLqeqd0C2L6qQELj)

Но я на всякий случай распишу пошаговое руководство.

#### 1. Уставновка Flutter SDK

- Установка на Windows OS. Перейдите по ссылке и установите zip файл flutter_windows_3.19.6-stable.zip

```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip 
```
- Разархивируйте zip файл в удобную для вас директорию. Я например, выбрал директорию "Документы"

![image](https://github.com/Just-Adikus/joomys/assets/74231081/be6a4120-7f3a-41b9-b661-be8c811ca5fb)
> P.S не обращяйте на мою версию flutter-а

- После скопируйте путь до файла bin внутри разархивированного zip файла.Данный скопированный путь еще пригодится

![image](https://github.com/Just-Adikus/joomys/assets/74231081/d7bc21ce-0471-40fc-bf05-c8bdd2d667b3)

- В поисковой строке ищем "изменение системных переменных среды"

![image](https://github.com/Just-Adikus/joomys/assets/74231081/4a3f3d5d-0067-4037-a6dd-449d77a5a794)

- По правой кнопке снизу переходим ко списку переменных

![image](https://github.com/Just-Adikus/joomys/assets/74231081/3f8d004d-187e-4b11-b846-195f29b567da)

- Здесь находим переменную Path и кликаем по ней.

![image](https://github.com/Just-Adikus/joomys/assets/74231081/d5470362-de47-4d49-9417-0ae28fec4afe)

- Вставляем скопированный путь к файлу bin в пустую ячейку

![image](https://github.com/Just-Adikus/joomys/assets/74231081/63aa4458-b461-43d8-8b90-2256f2680fc3)

- Нажимаем везде "Ок" и кнопку "Применить" в конце. После открываем командную строку "cmd"  и вводим команду:

```
flutter doctor -v
```

- Должно получиться что-то наподобии этого

![image](https://github.com/Just-Adikus/joomys/assets/74231081/9958255a-b0f1-4387-aaf6-be15b5f249a0)

> Возможно вывод команды у вас будет другой с ошибками, но не стоит беспокоиться. Ведь это лишь начало уставновки.


    










