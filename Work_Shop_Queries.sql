linguist-language=postgresql
select * from products --ürünler
select * from employees --çalışanlar
select * from customers -- müşteriler
select * from orders --siparişler
select * from shippers --nakliyatçılar
select * from suppliers --tedarikçiler
select * from categories --kategori
select * from order_details --sipariş detayı
--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
select product_name, quantity_per_unit from products;
--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
select product_id, product_name, discontinued from products where discontinued=1;
--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
select product_id, product_name, discontinued from products where discontinued=0;
--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products where unit_price < 20;
--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products where unit_price > 15 and unit_price < 25;
--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
select product_id, product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order;
--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
select product_name from products where product_name like 'A%';
--8. İsmi `i` ile biten ürünleri listeleyeniz.
select product_name from products where product_name like '%i';
--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name, unit_price, (unit_price*118/100) FROM products;
--10. Fiyatı 30 dan büyük kaç ürün var?
select count(*) from products where unit_price > 30;
--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select unit_price, lower(product_name) from products order by unit_price desc;  
--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
select first_name || ' ' || last_name as name FROM employees;
--13. Region alanı NULL olan kaç tedarikçim var?
select count(*) from suppliers where region is null;
--14. a.Null olmayanlar?
select count(*) from suppliers where region is not null;
--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select UPPER(product_name) || 'TR'  as upper_name_tr FROM products;
--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select 'TR' || product_name as tr_name FROM products WHERE unit_price<20;
--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price FROM products WHERE unit_price = (SELECT MAX(unit_price) FROM products);
--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price FROM products order by unit_price desc limit 10;
--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products where unit_price > (select avg(unit_price) from products);
--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select SUM(unit_price * units_in_stock) FROM products;
--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select SUM(units_in_stock) , SUM(discontinued) FROM products;
--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
select product_name, category_name FROM products INNER JOIN categories ON products.category_id=categories.category_id;
--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select AVG(unit_price) FROM products GROUP BY category_id;
--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select product_name, unit_price, category_name FROM products INNER JOIN categories ON products.category_id=categories.category_id
WHERE unit_price = (SELECT MAX(unit_price) FROM products);
--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
SELECT product_name, category_name, company_name FROM products 
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
WHERE units_on_order=(SELECT MAX(units_on_order) FROM products);
--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select product_id, product_name, company_name, phone from products 
p join suppliers s on p.supplier_id=s.supplier_id where units_in_stock=0
--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select ship_address, first_name || ' ' || last_name as persons from orders o join employees e on o.employee_id = e.employee_id
where extract(year from order_date) = 1998 and extract (month from order_date) = 3
--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) from orders where extract(year from order_date) = 1997 and extract(month from order_date) = 2
--29. London şehrinden 1998 yılında kaç siparişim var?
select count(*) from orders where extract(year from order_date) = 1998 and ship_city = 'London'
--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name, order_id, phone from customers c join orders o on c.customer_id=o.customer_id where extract(year from order_date) = 1997
--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders where freight > 40
--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select ship_city, contact_name from orders o join customers c on o.customer_id=c.customer_id where freight > 40
--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select order_date, ship_city, upper(first_name || ' ' || last_name) as persons from orders o join employees e on e.employee_id=o.employee_id where extract(year from order_date) = 1997
--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select contact_name, replace(replace(replace(replace(replace(phone, '.', ''),'(', ''),'-', ''), ')', ''), ' ', '') from customers c join orders o on c.customer_id=o.customer_id where extract(year from order_date) = 1997
--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select order_date, contact_name, first_name || ' ' || last_name as persons from orders o join customers c on o.customer_id=c.customer_id
join employees e on e.employee_id= o.employee_id
--36. Geciken siparişlerim?
select * from orders where required_date < shipped_date
--37. Geciken siparişlerimin tarihi, müşterisinin adı
select order_date, contact_name from orders o join customers c on o.customer_id=c.customer_id where required_date < shipped_date
--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select order_id, product_name, category_name, quantity from order_details od
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where order_id = 10248;
--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select product_name, company_name from products p join suppliers s on p.supplier_id=s.supplier_id join order_details od on p.product_id=od.product_id where order_id =10248
--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, SUM(od.quantity) as total_quantity
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
  AND EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY p.product_name;
--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, first_name || ' ' || last_name as employes from employees e join orders o on o.employee_id=e.employee_id
join order_details od on o.order_id=od.order_id where extract(year from order_date) = 1997 and od.quantity = (select max(quantity) from order_details limit 1)
--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad YAPAMADIM
select e.employee_id, first_name || ' ' || last_name as employes from employees e join orders o on o.employee_id=e.employee_id
join order_details od on o.order_id=od.order_id where extract(year from order_date) = 1997 and od.quantity = (select sum(quantity) from order_details ad join orders o on od.order_id=o.order_id join employees e on e.employee_id = o.employee_id) order by od.quantity desc
--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, max(unit_price) as max_price, category_name from products p join categories c on p.category_id=c.category_id group by p.product_name, c.category_name order by max_price desc limit 1
--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select first_name || ' ' || last_name as persons, order_date, order_id from employees join orders on orders.employee_id=employees.employee_id order by order_date
--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir? YANLIŞ
select avg(unit_price) as average_price, od.order_id from orders o join customers c on c.customer_id=o.customer_id join order_details od on o.order_id=od.order_id where c.customer_id='ALFKI' group by od.order_id, o.order_date order by o.order_date desc limit 5
--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select product_name, category_name, sum(quantity) as total from products p join categories c on p.category_id=c.category_id
join order_details od on od.product_id=p.product_id join orders o on od.order_id=o.order_id where extract(month from order_date) = 1 group by product_name, category_name;
--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select product_name, avg(quantity) as avg_quantity from products p join order_details od on od.product_id=p.product_id group by product_name having avg(od.quantity) > (SELECT AVG(quantity) FROM order_details)
--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select quantity, product_name, category_name, company_name from products p join order_details od on p.product_id=od.product_id
join categories c on c.category_id=p.category_id
join suppliers s on s.supplier_id=p.supplier_id order by quantity desc limit 1
--49. Kaç ülkeden müşterim var
select count(DISTINCT ship_country) from orders
--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(quantity * unit_price) as toplam from orders o
join order_details od on od.order_id=o.order_id
where extract(month from order_date) = 1
and o.employee_id = 3 and o.order_date >= DATE '1998-01-01' AND o.order_date <= DATE '2023-11-15';
--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select product_name, category_name, quantity from products p join categories c on p.category_id=c.category_id
join order_details od on od.product_id=p.product_id where od.order_id = 10248
--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select product_name, company_name from products p
join order_details od on od.product_id=p.product_id join suppliers s on s.supplier_id=p.supplier_id
where od.order_id = 10248
--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select e.employee_id, product_name, quantity from employees e 
join orders o on o.employee_id=e.employee_id
join order_details od on od.order_id=o.order_id
join products p on p.product_id=od.product_id
where e.employee_id = 3 and extract(year from order_date) = 1997
--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, first_name || '' || last_name as person from employees e
join orders o on o.employee_id=e.employee_id
join order_details od on o.order_id=od.order_id
where extract(year from order_date) = 1997 order by quantity desc limit 1
--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, first_name || ' ' || last_name as person, sum(quantity) as toplam from employees e
join orders o on o.employee_id=e.employee_id
join order_details od on o.order_id=od.order_id
where extract(year from order_date) = 1997 group by e.employee_id order by toplam desc limit 1
--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select product_name, unit_price, category_name from products p
join categories c on c.category_id=p.category_id
order by unit_price desc limit 1
--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select first_name || ' ' || last_name as persons, order_date, order_id from orders o
join employees e on e.employee_id=o.employee_id
order by order_date
--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(od.unit_price) as ort_fiyat, od.order_id from products p
join order_details od on od.product_id=p.product_id
join orders o on o.order_id=od.order_id
group by od.order_id, o.order_date
order by order_date desc limit 5
--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select order_date, product_name, category_name, sum(od.quantity) as miktar_ort from products p
join categories c on c.category_id=p.category_id
join order_details od on od.product_id=p.product_id
join orders o on o.order_id=od.order_id 
where extract(month from order_date) = 01
group by product_name, category_name,order_date
--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select product_name, quantity from products p
join order_details od on p.product_id=od.product_id
group by product_name, quantity
having quantity > (select avg(quantity) from order_details)
--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select product_name, category_name, company_name, sum(quantity) as toplam from products p
join categories c on c.category_id=p.category_id
join suppliers s on s.supplier_id=p.supplier_id
join order_details od on od.product_id=p.product_id
group by product_name, category_name, company_name
order by toplam desc limit 1
