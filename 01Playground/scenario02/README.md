# サンプルデータベースを利用する <!-- omit in toc -->
- [サンプルデータベースって](#サンプルデータベースって)
- [セットアップしてみよう](#セットアップしてみよう)
- [データを参照してみよう](#データを参照してみよう)
- [構造も見てみよう](#構造も見てみよう)
  - [テーブル](#テーブル)
  - [ビュー](#ビュー)
  - [トリガー](#トリガー)
  - [ストアドプロシージャ](#ストアドプロシージャ)
  - [ストアド関数](#ストアド関数)
- [練習してみよう](#練習してみよう)

## やってみよう <!-- omit in toc -->
### サンプルデータベースって
公式のサンプルデータベースがいくつかあるのでテストデータとして `sakila` を導入してみましょう  
* https://dev.mysql.com/doc/employee/en/
* https://dev.mysql.com/doc/world-setup/en/
* https://dev.mysql.com/doc/sakila/en/
* https://dev.mysql.com/doc/airportdb/en/
* https://dev.mysql.com/doc/index-other.html

### セットアップしてみよう
先ずは環境を起動して、`ladder`へログインします  
```
~/mysql-playground/01Playground$ docker compose up -d
[+] Running 2/2
 ✔ Container playground-mysql80-1  Started                                                                    0.4s 
 ✔ Container playground-ladder-1   Started                                                                    0.4s 

~/mysql-playground/01Playground$ docker compose ps -a
NAME                   IMAGE          COMMAND                  SERVICE   CREATED          STATUS          PORTS
playground-ladder-1    local/ladder   "/usr/sbin/sshd -D"      ladder    22 seconds ago   Up 21 seconds   0.0.0.0:32769->22/tcp, :::32769->22/tcp
playground-mysql80-1   mysql:8.0      "docker-entrypoint.s…"   mysql80   22 seconds ago   Up 21 seconds   3306/tcp, 33060/tcp

~/mysql-playground/01Playground$ ssh -o StrictHostKeyChecking=no localhost -l root -p 32769
Warning: Permanently added '[localhost]:32769' (ED25519) to the list of known hosts.
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

7807d2bfcfb7:~# 
```

`ladder`へログインしたらデータ( https://downloads.mysql.com/docs/sakila-db.zip )をダウンロードしてみます  
ダウンロードしたデータは展開しておきましょう  
```
7807d2bfcfb7:~# wget https://downloads.mysql.com/docs/sakila-db.zip
Connecting to downloads.mysql.com (23.36.106.252:443)
saving to 'sakila-db.zip'
sakila-db.zip        100% |*******************************************************************|  712k  0:00:00 ETA
'sakila-db.zip' saved

7807d2bfcfb7:~# unzip sakila-db.zip 
Archive:  sakila-db.zip
   creating: sakila-db/
  inflating: sakila-db/sakila-data.sql
  inflating: sakila-db/sakila-schema.sql
  inflating: sakila-db/sakila.mwb
```

データを展開してMySQLへインポートしてみます  
スキーマ、データの順でインポートします  
```
7807d2bfcfb7:~# mysql -h mysql80 < sakila-db/sakila-schema.sql
7807d2bfcfb7:~# mysql -h mysql80 < sakila-db/sakila-data.sql 
7807d2bfcfb7:~# 
```

### データを参照してみよう
MySQL へログインしてインポートしたデータを参照してみましょう  
```
7807d2bfcfb7:~# mysql -h mysql80
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.38 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sakila             |
| sys                |
+--------------------+
5 rows in set (0.003 sec)

MySQL [(none)]> use sakila;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

MySQL [sakila]> show full tables;
+----------------------------+------------+
| Tables_in_sakila           | Table_type |
+----------------------------+------------+
| actor                      | BASE TABLE |
| actor_info                 | VIEW       |
| address                    | BASE TABLE |
| category                   | BASE TABLE |
| city                       | BASE TABLE |
| country                    | BASE TABLE |
| customer                   | BASE TABLE |
| customer_list              | VIEW       |
| film                       | BASE TABLE |
| film_actor                 | BASE TABLE |
| film_category              | BASE TABLE |
| film_list                  | VIEW       |
| film_text                  | BASE TABLE |
| inventory                  | BASE TABLE |
| language                   | BASE TABLE |
| nicer_but_slower_film_list | VIEW       |
| payment                    | BASE TABLE |
| rental                     | BASE TABLE |
| sales_by_film_category     | VIEW       |
| sales_by_store             | VIEW       |
| staff                      | BASE TABLE |
| staff_list                 | VIEW       |
| store                      | BASE TABLE |
+----------------------------+------------+
23 rows in set (0.001 sec)

MySQL [sakila]> select count(*) from film;
+----------+
| count(*) |
+----------+
|     1000 |
+----------+
1 row in set (0.000 sec)

MySQL [sakila]> select count(*) from film_text;
+----------+
| count(*) |
+----------+
|     1000 |
+----------+
1 row in set (0.001 sec)
```

### 構造も見てみよう
テーブル、ビュー、トリガー、ストアドプロシージャ、ユーザ関数と一通り揃っているサンプルなので中身もチェックしましょう  
#### テーブル
`show tables` でテーブルの一覧がわかります  
`desc` を使うとテーブル構造、`show create table` でスキーマを確認できます  
※`\G`はテーブル表示じゃなくて表形式で出すオプション、スペースの都合上ね  
```
MySQL [sakila]> show tables;
+----------------------------+
| Tables_in_sakila           |
+----------------------------+
| actor                      |
| actor_info                 |
| address                    |
| category                   |
| city                       |
| country                    |
| customer                   |
| customer_list              |
| film                       |
| film_actor                 |
| film_category              |
| film_list                  |
| film_text                  |
| inventory                  |
| language                   |
| nicer_but_slower_film_list |
| payment                    |
| rental                     |
| sales_by_film_category     |
| sales_by_store             |
| staff                      |
| staff_list                 |
| store                      |
+----------------------------+
23 rows in set (0.001 sec)
```
```
MySQL [sakila]> desc actor;
+-------------+-------------------+------+-----+-------------------+-----------------------------------------------+
| Field       | Type              | Null | Key | Default           | Extra                                         |
+-------------+-------------------+------+-----+-------------------+-----------------------------------------------+
| actor_id    | smallint unsigned | NO   | PRI | NULL              | auto_increment                                |
| first_name  | varchar(45)       | NO   |     | NULL              |                                               |
| last_name   | varchar(45)       | NO   | MUL | NULL              |                                               |
| last_update | timestamp         | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
+-------------+-------------------+------+-----+-------------------+-----------------------------------------------+
4 rows in set (0.001 sec)
```
```
MySQL [sakila]> show create table actor\G;
*************************** 1. row ***************************
       Table: actor
Create Table: CREATE TABLE `actor` (
  `actor_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`actor_id`),
  KEY `idx_actor_last_name` (`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
1 row in set (0.000 sec)

ERROR: No query specified
```

#### ビュー
ビューはデータを持たないテーブルです。テーブルと同じように見えます  
`desc` を使うとテーブル構造、`show create table` または `show create view` でスキーマを確認できます  
```
MySQL [sakila]> desc actor_info;
+------------+-------------------+------+-----+---------+-------+
| Field      | Type              | Null | Key | Default | Extra |
+------------+-------------------+------+-----+---------+-------+
| actor_id   | smallint unsigned | NO   |     | 0       |       |
| first_name | varchar(45)       | NO   |     | NULL    |       |
| last_name  | varchar(45)       | NO   |     | NULL    |       |
| film_info  | text              | YES  |     | NULL    |       |
+------------+-------------------+------+-----+---------+-------+
4 rows in set (0.001 sec)
```
```
MySQL [sakila]> show create table actor_info\G;
*************************** 1. row ***************************
                View: actor_info
         Create View: CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY INVOKER VIEW `actor_info` AS select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`film` `f` join `film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` from (((`actor` `a` left join `film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) left join `film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) left join `category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name`
character_set_client: utf8mb4
collation_connection: utf8mb4_0900_ai_ci
1 row in set (0.000 sec)

ERROR: No query specified
```
```
MySQL [sakila]> show create view actor_info\G;
*************************** 1. row ***************************
                View: actor_info
         Create View: CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY INVOKER VIEW `actor_info` AS select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC separator ', ') from ((`film` `f` join `film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) join `film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` from (((`actor` `a` left join `film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) left join `film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) left join `category` `c` on((`fc`.`category_id` = `c`.`category_id`))) group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name`
character_set_client: utf8mb4
collation_connection: utf8mb4_0900_ai_ci
1 row in set (0.000 sec)

ERROR: No query specified
```

#### トリガー
トリガーはテーブル操作時にこっちも更新するよ的なやつです  
`show triggers`で一覧と `show create trigger` で定義を確認できます
```
MySQL [sakila]> show triggers\G
*************************** 1. row ***************************
             Trigger: customer_create_date
               Event: INSERT
               Table: customer
           Statement: SET NEW.create_date = NOW()
              Timing: BEFORE
             Created: 2024-07-16 00:14:01.27
            sql_mode: STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION
             Definer: root@%
character_set_client: utf8mb4
collation_connection: utf8mb4_0900_ai_ci
  Database Collation: utf8mb4_0900_ai_ci
*************************** 2. row ***************************
... snip ...
6 rows in set (0.001 sec)
```
```
MySQL [sakila]> show create trigger customer_create_date\G;
*************************** 1. row ***************************
               Trigger: customer_create_date
              sql_mode: STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION
SQL Original Statement: CREATE DEFINER=`root`@`%` TRIGGER `customer_create_date` BEFORE INSERT ON `customer` FOR EACH ROW SET NEW.create_date = NOW()
  character_set_client: utf8mb4
  collation_connection: utf8mb4_0900_ai_ci
    Database Collation: utf8mb4_0900_ai_ci
               Created: 2024-07-16 00:14:01.27
1 row in set (0.001 sec)

ERROR: No query specified
```
#### ストアドプロシージャ
ストアドプロシージャはいくつかのクエリをまとめたものです  
便利な一覧取得はなさそうなので、下のクエリで引っ張ります  
`select * from information_schema.routines where routine_schema = 'sakila' and routine_type = 'PROCEDURE'\G`
`show create procedure` で定義文が確認できます  
```
MySQL [sakila]> select * from information_schema.routines where routine_schema = 'sakila' and routine_type = 'PROCEDURE'\G
*************************** 1. row ***************************
           SPECIFIC_NAME: film_in_stock
         ROUTINE_CATALOG: def
          ROUTINE_SCHEMA: sakila
            ROUTINE_NAME: film_in_stock
            ROUTINE_TYPE: PROCEDURE
               DATA_TYPE: 
CHARACTER_MAXIMUM_LENGTH: NULL
  CHARACTER_OCTET_LENGTH: NULL
       NUMERIC_PRECISION: NULL
           NUMERIC_SCALE: NULL
      DATETIME_PRECISION: NULL
      CHARACTER_SET_NAME: NULL
          COLLATION_NAME: NULL
          DTD_IDENTIFIER: NULL
            ROUTINE_BODY: SQL
      ROUTINE_DEFINITION: BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
           EXTERNAL_NAME: NULL
       EXTERNAL_LANGUAGE: SQL
         PARAMETER_STYLE: SQL
        IS_DETERMINISTIC: NO
         SQL_DATA_ACCESS: READS SQL DATA
                SQL_PATH: NULL
           SECURITY_TYPE: DEFINER
                 CREATED: 2024-07-16 00:13:03
            LAST_ALTERED: 2024-07-16 00:13:03
                SQL_MODE: STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION
         ROUTINE_COMMENT: 
                 DEFINER: root@%
    CHARACTER_SET_CLIENT: utf8mb4
    COLLATION_CONNECTION: utf8mb4_0900_ai_ci
      DATABASE_COLLATION: utf8mb4_0900_ai_ci
*************************** 2. row ***************************
... snip ...
3 rows in set (0.001 sec)
```
```
MySQL [sakila]> show create procedure film_in_stock\G;
*************************** 1. row ***************************
           Procedure: film_in_stock
            sql_mode: STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION
    Create Procedure: CREATE DEFINER=`root`@`%` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
character_set_client: utf8mb4
collation_connection: utf8mb4_0900_ai_ci
  Database Collation: utf8mb4_0900_ai_ci
1 row in set (0.000 sec)

ERROR: No query specified
```
#### ストアド関数
ストアド関数は組み込み関数とは別に作成した関数のことです  
これも一覧は下記クエリで取得できます  
`select * from information_schema.routines where routine_schema = 'sakila' and routine_type = 'FUNCTION'\G`
これも `show create function` で定義が確認できます
```
MySQL [sakila]> select * from information_schema.routines where routine_schema = 'sakila' and routine_type = 'FUNCTION'\G
*************************** 1. row ***************************
           SPECIFIC_NAME: get_customer_balance
         ROUTINE_CATALOG: def
          ROUTINE_SCHEMA: sakila
            ROUTINE_NAME: get_customer_balance
            ROUTINE_TYPE: FUNCTION
               DATA_TYPE: decimal
CHARACTER_MAXIMUM_LENGTH: NULL
  CHARACTER_OCTET_LENGTH: NULL
       NUMERIC_PRECISION: 5
           NUMERIC_SCALE: 2
      DATETIME_PRECISION: NULL
      CHARACTER_SET_NAME: NULL
          COLLATION_NAME: NULL
          DTD_IDENTIFIER: decimal(5,2)
            ROUTINE_BODY: SQL
      ROUTINE_DEFINITION: BEGIN

       
       
       
       
       
       

  DECLARE v_rentfees DECIMAL(5,2); 
  DECLARE v_overfees INTEGER;      
  DECLARE v_payments DECIMAL(5,2); 

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END
           EXTERNAL_NAME: NULL
       EXTERNAL_LANGUAGE: SQL
         PARAMETER_STYLE: SQL
        IS_DETERMINISTIC: YES
         SQL_DATA_ACCESS: READS SQL DATA
                SQL_PATH: NULL
           SECURITY_TYPE: DEFINER
                 CREATED: 2024-07-16 00:13:03
            LAST_ALTERED: 2024-07-16 00:13:03
                SQL_MODE: STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION
         ROUTINE_COMMENT: 
                 DEFINER: root@%
    CHARACTER_SET_CLIENT: utf8mb4
    COLLATION_CONNECTION: utf8mb4_0900_ai_ci
      DATABASE_COLLATION: utf8mb4_0900_ai_ci
*************************** 2. row ***************************
... snip ...
3 rows in set (0.001 sec)
```
```
MySQL [sakila]> show create function get_customer_balance\G
*************************** 1. row ***************************
            Function: get_customer_balance
            sql_mode: STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_ENGINE_SUBSTITUTION
     Create Function: CREATE DEFINER=`root`@`%` FUNCTION `get_customer_balance`(p_customer_id INT, p_effective_date DATETIME) RETURNS decimal(5,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN

       
       
       
       
       
       

  DECLARE v_rentfees DECIMAL(5,2); 
  DECLARE v_overfees INTEGER;      
  DECLARE v_payments DECIMAL(5,2); 

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END
character_set_client: utf8mb4
collation_connection: utf8mb4_0900_ai_ci
  Database Collation: utf8mb4_0900_ai_ci
1 row in set (0.000 sec)
```

### 練習してみよう
使用例があるので見ながらクエリをたたいてSQLに慣れて見ましょう  
* https://dev.mysql.com/doc/sakila/en/sakila-usage.html


## References <!-- omit in toc -->
* https://dev.mysql.com/doc/sakila/en/sakila-installation.html
* https://dev.mysql.com/doc/sakila/en/sakila-structure.html
* https://dev.mysql.com/doc/refman/8.0/ja/show-triggers.html
* https://dev.mysql.com/doc/refman/8.0/ja/show.html
* https://dev.mysql.com/doc/refman/8.0/ja/information-schema-introduction.html
* https://dev.mysql.com/doc/sakila/en/sakila-usage.html