### Lab-2

**Тема:** Банк (BetaBank)

**Архитектура:** YARCH + Coordinator

Я выбрал связку YARCH + Coordinator, потому что она даёт чёткое разделение ответственности между слоями и хорошо масштабируется при росте количества экранов и сценариев. В YARCH каждый модуль строится одинаково: Builder собирает зависимости, ViewController принимает действия пользователя, Interactor содержит сценарии и бизнес-правила, Presenter преобразует данные в готовое состояние для UI, а Provider/Service/Storage изолируют работу с данными. Это снижает связность: экран не знает, откуда берутся данные и как они хранятся, а бизнес-логика не зависит от UIKit. Coordinator вынес навигацию и управление flow (Auth → Home → Details/Settings → Edit/Add/Transfer) из модулей, чтобы переходы не размывались по view/controllers и не смешивались с use-case логикой. Такая структура упрощает тестирование (Interactor/Presenter тестируются отдельно), повторное использование модулей и изменения (например, смена источника данных или добавление нового сценария не ломает UI). В итоге проект остаётся предсказуемым: одинаковый шаблон модулей, единые точки входа/выхода и минимальные зависимости между экранами.

**Экраны:**

1. Auth — авторизация/регистрация пользователя и старт приложения.
2. Home — главный экран: показывает пользователя, карты и историю, даёт вход в основные функции.
3. CardDetails — отображение детальной информации по выбранной карте.
4. TransactionDetails — отображение детальной информации по выбранной транзакции.
5. Settings — настройки аккаунта: выход, удаление аккаунта, переход в редактирование профиля.
6. EditProfile — просмотр и изменение данных пользователя с сохранением результата.
7. AddCard — создание новой карты (учебный сценарий выпуска карты).
8. Transfer — перевод между картами: выбор карт, ввод суммы/комментария, выполнение перевода.

**Input, Output, States, Scenarios:**

(1)
AuthScreen:

Вход: ничего.

Выход: didCompleteAuth(user/session).

Состояния: content, loading, error, transition.

Сценарии:

1. Пользователь регистрируется → успех → переход на домашний экран.
2. Пользователь входит → успех → переход на главный экран.
3. Пользователь регистрируется → неуспех → показываем пользователю, в чём проблема.
4. Пользователь входит → неуспех → показываем пользователю, в чём проблема.

(2)
HomeScreen:

Вход: session/userId.

Выход: didRequestOpenSettings(), didSelectCard(cardId), didRequestTransfer(fromCardId), didRequestAddCard(), didSelectTransaction(transactionId).

Состояния: content, initial, loading, error, transition.

Сценарии:

1. Пользователь тапнул по кнопке профиля → открылся экран с настройками.
2. Пользователь тапнул по текущей карте → открылся экран с детальной информацией по карте.
3. Пользователь тапнул по истории → открылась детальная информация о транзакции.
4. Пользователь тапнул по кнопке перевода → открылся экран для перевода.
5. Пользователь тапнул по кнопке создания карты → открылся экран для создания карты.

(3)
CardDetailsScreen:

Вход: cardId.

Выход: didTapBack().

Состояния: content, loading, error.

Сценарии:

1. Посмотрели информацию → удивились → вернулись на главный экран.

(4)
TransactionDetailsScreen:

Вход: transactionId.

Выход: didTapBack().

Состояния: content, loading, error.

Сценарии:

1. Посмотрели информацию → расстроились из-за большой суммы → вернулись на главный экран.

(5)
SettingsScreen:

Вход: userId/session.

Выход: didTapBack(), didRequestEditProfile(), didRequestLogout(), didRequestDeleteAccount().

Состояния: content, loading, error.

Сценарии:

1. Нажали на кнопку Back → вернулись на главный экран.
2. Нажали на кнопку Delete → словили алерт с подтверждением действия → согласились → удалили все данные и перешли на экран авторизации.
3. Нажали на кнопку Logout → вышли на экран авторизации.
4. Нажали кнопку «О себе» → перешли на экран редактирования данных.

(6)
EditProfileScreen:

Вход: userId.

Выход: didTapBack(), didSaveChanges().

Состояния: content, editing, saving, error.

Сценарии:

1. Посмотрели информацию → убедились, что стоит красивая фотография и данные заполнены корректно → вернулись на экран с настройками.
2. Посмотрели информацию → увидели неточность или захотели поменять фотографию → нажали на кнопку редактирования → поменяли данные → сохранили изменения → вернулись на экран с настройками.

(7)
AddCardScreen:

Вход: userId.

Выход: didTapBack(), didSubmitCreateCard(draft).

Состояния: content, loading, error.

Сценарии:

1. Ввести корректные данные → создать карту → вернуться на главный экран.
2. Ввести некорректные данные → создать карту → получить информацию об ошибках.
3. Передумать → вернуться на главный экран.

(8)
TransferScreen:

Вход: userId.

Выход: didTapBack(), didSubmitTransfer(draft).

Состояния: content, loading, error.

Сценарии:

1. Ввести корректные данные → перевести → вернуться на главный экран → увидеть новую историю и корректный баланс карты.
2. Ввести некорректные данные → перевести → получить информацию об ошибках.
3. Передумать → вернуться на главный экран.

**Список ключевых протоколов и моделей**

**Протоколы:**

* Coordinator — навигация между экранами.
* Storage (+ UserStorageProtocol, CardStorageProtocol, TransactionStorageProtocol) — CRUD-интерфейс хранилищ.
* AuthServiceProtocol, UserServiceProtocol, CardServiceProtocol, TransactionServiceProtocol — бизнес-операции домена.
* *ProviderProtocol (Auth/Home/Settings/EditProfile/AddCard/Transfer/Details) — доступ к данным/сервисам внутри модуля.
* *ViewControllerInput / *InteractorInput / *PresenterInput — контракты слоёв YARCH внутри каждого модуля.
* *ViewDelegate — события UI из View в ViewController.

**Сущности:**

* User — пользователь.
* Card — банковская карта.
* Transaction (+ Direction, Status) — транзакция и её тип/статус.
* StorageError (+ LocalizedError) — ошибки слоя хранения.
* DataFlow DTO для модулей: Request/Response/ViewModel (например, Auth.SignIn, Home.LoadData, Transfer.LoadCards и т.д.).

---

### Lab-3

**Как запустить**

В Xcode выбираем симулятор, на котором будем запускаться (или реальное устройство), далее нажимаем Start the active scheme.

**Правильные данные для входа**

Email: не должен быть пустым, должен соответствовать регулярному выражению `#"^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]{2,}$"#`, должен быть ранее зарегистрирован.

Password: не должен быть пустым, должен иметь хотя бы 1 заглавную букву, 1 цифру, 1 спецсимвол из набора `!@?.`, должен быть идентичен паролю, который вводился пользователем на этапе регистрации.

**Успешный вход**

Показывается экран-заглушка с надписью: `Главный экран. UUID: ...`


---

### Lab-4


**какое API используете и какой endpoint дергаете**

Используется echo-сервер alfaitmo.ru.

Endpoints:
- GET/POST `https://alfaitmo.ru/server/echo/409950/users`
- GET/POST `https://alfaitmo.ru/server/echo/409950/cards`
- GET/POST `https://alfaitmo.ru/server/echo/409950/transactions`

**пример ответа (ссылка/описание)**

GET https://alfaitmo.ru/server/echo/409950/users
Тип: [UserDTO]
Пример: { "id": "4C562B89-...", "first_name": "Slava", "last_name": "Yandola", "email": "yandola@mail.ru", "password": "VfRc100200300!@?", "phone": null, "data_image": null }

GET https://alfaitmo.ru/server/echo/409950/cards
Тип: [CardDTO]
Пример: { "id": "A1000000-...", "user_id": "4C562B89-...", "balance": 150000, "number": "4276 1234 5678 9010", "user_full_name": "Slava Yandola", "validate_period": "2028-01-01T00:00:00Z", "bank_name": "Sberbank", "code": "123" }

GET https://alfaitmo.ru/server/echo/409950/transactions
Тип: [TransactionDTO]
Пример: { "id": "B1000000-...", "date": "2024-01-10T10:00:00Z", "amount_minor": 5000, "direction": "debit", "status": "success", "comment": "Оплата в магазине", "from_card": "A1000000-...", "to_card": "A1000000-..." }

**какие поля вы показываете в CellViewModel**

CardCellViewModel: id, balance, number, userFullName, validatePeriod, bankName, code

TransactionCellViewModel: id, date, amountMinor, direction, status, comment

**как проверить**

Авторизоваться на экране Auth — после успешного входа откроется HomeViewController, 
в консоли Xcode будут выведены загруженные User, Cards и Transactions.

---

### Lab-5 — Экран списка (UIKit)

**Подход к списку**

Использован **UICollectionView** в двух местах:
- **Карты** — горизонтальный `UICollectionViewFlowLayout`, управляется `CardsListManager`
- **Транзакции** — вертикальный `UICollectionViewCompositionalLayout` с секциями по датам, управляется `TransactionsListManager`

Оба списка работают через отдельные менеджеры (`CardsListManager`, `TransactionsListManager`), которые берут на себя datasource и delegate — `HomeViewController` не содержит бизнес-логики и не работает с данными напрямую.

Такой подход выбран, чтобы:
- избежать проблем с вложенными скроллами (карты и транзакции — независимые `UICollectionView`)
- использовать `UICollectionViewDiffableDataSource` для анимированных обновлений без `reloadData`
- сохранить чистую архитектуру: каждый менеджер — отдельная сущность с единственной ответственностью


**Как открыть экран списка**

Запустить приложение → авторизоваться на экране Auth → после успешного входа автоматически откроется `HomeViewController` с картами и транзакциями.


**Как увидеть состояния**

- **loading** — показывается автоматически при каждом запросе данных (на старте и при pull-to-refresh)
- **content** — показывается после успешной загрузки карт и транзакций
- **empty** — показывается если сервер вернул пустые массивы карт и транзакций одновременно
- **error** — показывается при сетевой ошибке; на экране есть кнопка «Повторить» для повторного запроса


**Что происходит по tap**

- **Tap по карте** → открывается `CardDetailsViewController` (заглушка)
- **Tap по транзакции** → открывается `TransactionDetailsViewController` (заглушка)
- **Кнопка профиля** → открывается `SettingsViewController` (заглушка)
- **Кнопка «Отправить»** → открывается `TransferViewController` (заглушка)
- **Кнопка «Добавить карту»** → открывается `AddCardViewController` (заглушка)


**Дополнительные задания**

- **D1. Pull-to-refresh** — реализован через `UIRefreshControl` на коллекции транзакций
- **D2. Поиск** — реализован через `UISearchBar`; фильтрация происходит на уровне `CellViewModel` без перезапроса сети
- **D4. Diffable DataSource** — реализован в `TransactionsListManager` через `UICollectionViewDiffableDataSource` с группировкой по датам
