# 📊 Задание 3: Группировка данных и оконные функции (vo_HW)

## 📝 Файлы

Все запросы доступны в файле HW3.sql

## 📂 Задачи

✅ 
**Создать таблицы со следующими структурами и загрузить данные из csv-файлов.**

<details>
  <summary>Пруф</summary>
  
  ![Customer](images/image-2.png)

  ![Transaction](images/image-1.png)
  
</details>

<br>

✅ 
**Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)**

<details>
  <summary>Пруф</summary>

  ![alt text](images/image-3.png)

</details>

<br>

✅ 
**Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)**

<details>
  <summary>Пруф</summary>
  
  ![alt text](images/image-4.png)

</details>

<br>

✅ 
**Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)**

<details>
  <summary>Пруф</summary>
  
![alt text](images/image-5.png)

</details>

<br>

✅ 
**Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. Выполните двумя способами: используя только group by и используя только оконные функции. Сравните результат. — (2 балла)**

<details>
  <summary>Способ 1</summary>
  
![alt text](images/image-6.png)

</details>

<details>
  <summary>Способ 2</summary>
  
![alt text](images/image-7.png)

</details>

<details>
  <summary>Сравнение через EXCEPT</summary>

![alt text](images/image.png)

</details>



<br>

✅ 
**Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)**

<details>
  <summary>Мин</summary>
  
![alt text](images/image-8.png)

</details>

<details>
  <summary>Макс</summary>
  
![alt text](images/image-9.png)

</details>

<br>

✅ 
**Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)**

<details>
  <summary>Пруф</summary>
  
![alt text](images/image-10.png)

</details>

<br>

✅ 
**Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).**

<details>
  <summary>Пруф</summary>
  
![alt text](images/image-11.png)

</details>

<br>

