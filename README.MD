# Backend PHP | Full stack dev test task v2

**`Перед началом выполнения задания внимательно прочтите этот текст!`**
#### Структура

В папке system находится наше модифицированное ядро CodeIgniter v3. Некоторая информация находится в папке system/README.MD


В папке application реализован полный пример приложения-инстаграма. Main_page - контроллер, где есть готовые Endpoints. В нем существуют пути-методы: инициализация объекта, получение данных, препарация данных и передача на фронт. Там же есть пример класса комментариев, поста, пользователя. После установки вы увидите главную страницу с информацией которая поможет сделать задание.


Мы работаем всегда с моделями Emerald_model - наши ORM-OOP модели для работы с базой, связями. Они представляют базу данных и работу с ней. 
Вся логика также хранится в них.


#### Инициализация
###### PHP 
Версии PHP 7.1+ . Составлялось и проверялось на 7.3

###### NGinx

nginx/test_task.conf - в nginx conf.d или sites_available укажите ваш домен `CI_DOMAIN`, к примеру `sometestworkspace.com`

###### Приложение
Изменить на ваши пути
public/index.php - **$application_folder**


config/database.php - **параметры базы**

###### MySQL

mysql/dump.sql - залить дамп


Какие то мелочи могут не работать, например `php - short_open_tags -> on`. Фиксим вручную :)

###### После сделаного тестового. 

**Заливайте пожалуйста новый дамп базы, config файл nginx, если надо собрать фронт - прям тут напишите инструкцию! Спасибо за понимание!**

--------------------------
#### ЗАДАЧИ

`Задачи идут по возрастанию сложности кроме "задачи со звездочкой". Не обязательно выполнять все до единой, но каждая задача показывает Ваш уровень разработки по-своему.`

У нас в нашем мини-инстаграме уже есть список постов и просмотр информации о посте. Но вот не хватает чуть монетизации и юзабилити.

**Задача 1**. `/main_page/login` - Реализовать авторизацию. Login model уже содержит наброски для работы с сессией. Достаточно сделать логин-пароль авторизацию в базе данных. 
Для удобства пароль можно не шифровать, чтобы при проверке мы могли легко авторизоваться. 


**Задача 2**. `/main_page/comment` - Реализовать возможность комментирования постов.
Реализовать вложенные комментарии. Количество уровней вложенности не ограничено. 
Любыми способами на основе нашей текущей структуры переделать/улучшить/расширить возможность комментирования любого поста неограниченное число раз.

**Задача 3**. `/main_page/like` - Реализовать возможность лайкнуть пост или комментарий. Число лайков на один пост/комментарий не ограничено (пользователь может лайкать пока у него на балансе еще есть лайки). 
  

**Задача 4**. `/main_page/add_money` - Реализовать монетизацию. Есть готовый API-Endpoint для зачисления средств принимающий количество валюты. У юзеров в базе есть столбец `wallet_balance` отвечающий за баланс.
`wallet_total_refilled` - сумма, на которую юзер пополнил баланс за все время, `wallet_total_withdrawn` - сумма, которую юзер потратил (превратил в лайки). Эти два поля должны учитывать все действия по счету пользователя (пополнения и траты). Используемая валюта - доллар США. Любая работа с балансом пользователя должна быть максимально безопасна и отказоустойчива (все решения по этому поводу необходимо описать и обосновать).


**Задача 5**. `/main_page/buy_boosterpack` - Поскольку сейчас в мире самым популярным способом монетизации игр является покупка "бустерпаков" - сундуков/ящиков/кейсов с предметами/карточками/деньгами, - 
предлагаем реализовать эту максимально простую функциональность для наших пользователей :) 


Нужно создать 3 бустерпака которые будут стоить 5$, 20$ и 50$. В базе для этого присутствует структура, класс также частично реализован.
Покупая такой пак пользователь получает случайное количество лайков которые может потратить на "лайкинг" постов и комментариев.
Лайки попадают на "лайк-счет" пользователя с которого он их будет тратить, то есть параллельно храним как счет в $, так и отдельный счет числа лайков у юзера. 


_Логика бустерпака:_
```
С учетом накопленного профитбанка нужно выбрать доступную для выдачи часть бустерпака с учетом его цены.
Основываясь на этом из диапазона от 1 лайка до [цена бустерпака + профитбанк] рандомно нужно выбрать  
получаемое юзером число лайков.  
По результату выполнения нужно уменьшить значение профитбанка на сумму  
[цена бустерпака — стоимость выданных в текущем открытии лайков]

1 лайк эквивалентен 1$.

	Рассмотрим пример бустерпака за 5$:

	Банк равен 0$. Пользователь покупает пак за 5$.

Формула: результат = рандом(от 1 до [цена бустерпака + профитбанк])  == рандом(от 1 до 5). Допустим,  
юзер получил 2 лайка, в банк уходит 5$ - 2 лайка(2$) = 3$

	Банк равен 3$. Пользователь покупает еще один пак за 5$.

Формула: итог = рандом(от 1 до [цена бустерпака + профитбанк])  == рандом(от 1 до 8). Допустим,  
юзер получил 2 лайка, в банк уходит 5$ - 4 лайка(4$) = 1$, итого банк равен $4

	Банк равен 4$. Пользователь покупает еще один пак за 5$.

Формула: итог = рандом(от 1 до [цена бустерпака + профитбанк])  == рандом(от 1 до 9). Допустим,  
юзер получил 8 лайков, в таком случае в банк уходит 5$ - 8 лайка(8$) = -3$, итого банк равен $1

```
Таким образом разность между результатом юзера и ценой бустерпака которую мы не выдали ему используется в будущих открытиях и выдается кому-то из следующих юзеров.


**Задача 6** `Class Transaction` Обеспечение максимальной безопасности и консистентности данных. Сделать лог любых изменений баланса.

Посказка:
Сделать `Class Transaction_type` который будет расширять наш класс - enum ( `\System\Core\Emerald_enum` ) в котором будут константы для таблицы транзакций, 
который будет отвечать в логе за тип - списание или зачисление средств. `Class Transaction_info` - отвечать за источник, на что были потрачены средства.
 
Основные требования к задаче - возможность создания mysql запросов, которые надо сделать и положить в mysql/6task.sql 

`Соотношение эквивалента лайка к $: 1лайк = 1$`

1. Выборка по часам сколько денег потрачено на бустерпаки,  по каждому бустерпаку. При этом, показать также сколько получили юзеры из них в эквиваленте $. Выборка должна быть за месяц.
2. Выборка по юзеру, сколько он пополнил средств и получил лайков, насколько он будет везучий так сказать :) . Остаток на счету $ и лайков.
3. Задачу 1 и 2 сделать в один Mysql запрос.

Для успещного прохождения проверки, необходимо выполинть сделующие условия:
- Склонировать проект, или создать его копию в своем публичном репозитории. 
- Выполнить все задания в отдельной ветке и сделать Pull Request в Master. 
- Все методы должны работать через Http запросы (а лучше сделать дополнительную задачу и написать фронт на vue.js). 
- Исходный код тестового задания не должен быть отформатирован ( чтоб в Pull Request были только изминения касающиеся задач )
- Сделать полное функцилнальное и техническое описание реализации задач в виде захвата экрана с вашими комментариями. Описание разделить на такие части:
    - Демонстрация работоспособности функционала. Необходимо продемонстрировать все созданные методы с точки зрения юзера (фронтенда). Вызвать все методы из консоли, или на фронте и показать запросы в консоли браузера.  
    - Детальный обзор реализации всех созданных методов. С точки зрения кода, пройтись по каждой задаче отдельно (чем подробнее, тем лучше).
    - Обзор базы данных. Как и зачем модифицировал поля, индексы, типы и т.д.    
- Видео можно залить на любой файлообменник, или YouTube (доступ по ссылке).
    
#### Дополнительная задача Vue.js | Frontend - Fullstack

Реализовать описанную в задачах выше функциональность на фронте.

**Доп. задача 1**. Авторизация, обновление страницы после отправки данных.

**Доп. задача 2**. Комментирование, вложенность комментариев (если реализована на беке).

**Доп. задача 3**. Возможность на фронте лайкать посты и комментарии (в том числе вложенные если вложенность реализована).

**Доп. задача 4**. Отображение баланса пользователя в $ и лайках. В отдельной мочалке реализовать через запрос на бек отображение истории пополнений и расходов, в отдельном табе модалки показать общую пополненную сумму юзером, общую потраченную сумму, текущий баланс.

**Доп. задача 5**. История открытия бустерпаков (стоимость каждого, полученные из каждого открытия лайки). 

**Доп. задача 6**. По связи безопасности и фронта конкретных требований нет но Вы можете проявить креативность.

#### Удачи Вам! ;)