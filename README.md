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

<img src="https://meterpreter.org/wp-content/uploads/2018/09/flutter.png" width="600" height="300"
/>

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

#### 2. Уставновка VS Code

<img src="https://code.visualstudio.com/assets/images/code-stable.png" width="300" height="300"
/>

- VS Code нам нужен для запуска нашего приложения Flutter, поэтому важно установить его. Так что нужно перейти на официальный сайт для загрузки VS Code.

```
https://code.visualstudio.com
```

- Устанавливаем его и запускаем. После запуска внутри самого VS Code нужно установаить два расширения
> Расширение Dart  

![image](https://github.com/Just-Adikus/joomys/assets/74231081/82996c01-b19c-4b8a-a6ff-01295b9b3fcf)

> Расширение Flutter

![image](https://github.com/Just-Adikus/joomys/assets/74231081/ea70889c-f2b4-407b-b33a-6a28c80ef2e7)


#### 3. Уставновка Android Studio и Andoid Toolkit

<img src="https://github.com/Just-Adikus/joomys/assets/74231081/121889ce-8f72-48ab-8f40-782710048eea" width = 300 height =300
/>

- Android Studio нам нужен для сборки нашего приложения Flutter, под платформу Android, а также для конторля среды и активного инструментария для сборки. Так что нужно перейти на официальный сайт для загрузки Android Studio.
```
https://developer.android.com/studio
```

- После установки Android Studio нужно его соответсвенно запустить. И в меню нужно найти b нажать на иконку трех точек. Откроется доп. меню с опциями. Там нужно выбрать SDK Manager.

<img src="https://github.com/Just-Adikus/joomys/assets/74231081/4f02a19c-7b2f-426e-b1ce-fb3bb6773942"
/>

- В SDK Manager-е нужно выбрать платформы SDK, можно выбрать одну а можно несколько.
  
![image](https://github.com/Just-Adikus/joomys/assets/74231081/136c9957-18d1-4ae4-9e28-7f737da483a6)

- Также нужно выбрать инструментарий SDK, то есть SDK Tools. Нужно просто проставить галочки, можно сделать как на картинке, и нажать кнопку "Apply"
  
![image](https://github.com/Just-Adikus/joomys/assets/74231081/43bc901f-0417-4742-b162-7645b3fd57b7)

- Начнется загрузка

![image](https://github.com/Just-Adikus/joomys/assets/74231081/e59477d1-12e4-4237-981e-f07703d16523)


















