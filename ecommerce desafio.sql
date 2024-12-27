-- Criação de Benco de Dados para o cenário de E-commerce
-- drop database ecommerce_desafio;
create database ecommerce_desafio;
use ecommerce_desafio;

-- criar tabela cliente
create table clients(
idClient int auto_increment primary key,
Fname varchar(10),
Minit char(3),
Lname varchar(20),
Tipo_Client enum('PF','PJ') not null,
CPF char(11),
CNPJ char(14),
Address varchar(255),
Email varchar(45),
Telefone varchar(15),
Data_Cadastro datetime,
constraint unique_cpf_client unique (CPF),
constraint unique_cnpj_client unique (CNPJ)
);

alter table clients auto_increment=1;

desc clients;

-- criar tabela produto
  -- size = dimensão do produto
create table product(
idProduct int auto_increment primary key,
Pname varchar(50),
Classification_kids bool default false,
category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
avaliação float default 0,
size varchar(10),
valor decimal(10,2)
);

alter table product auto_increment=1;

-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar costraints relacionadas ao pagamento
-- create table payments(
-- idclient int,
-- idPayment int,
-- typePayment enum('Boleto','Cartão','Dois cartões'),
-- limitAvailable float,
-- primary key(idClient, id_payment)
-- );

-- criar tabela pedido
-- drop table orders;
create table orders(
idOrder int auto_increment primary key,
idOrderClient int,
orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
orderDescription varchar(255),
sendValue float default 10,
paymentCash boolean default false, 
constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
);

alter table orders auto_increment=1;
desc orders;


-- criar tabela de estoque
create table productstorage(
idProdStorage int auto_increment primary key,
storageLocation varchar(255),
quantity int default 0
);

alter table productstorage auto_increment=1;

-- criar tabela fornecedor
create table supplier(
idSupplier int auto_increment primary key,
SocialName varchar(255) not null,
CNPJ char(15) not null,
contact char(11) not null,
constraint unique_suplier unique (CNPJ)
);

alter table supplier auto_increment=1;
desc supplier;

-- criar tabela vendedor
create table seller(
idSeller int auto_increment primary key,
SocialName varchar(255) not null,
AbstName varchar(30),
CNPJ char(15),
CPF char(9),
location varchar(255),
contact char(11) not null,
constraint unique_cnpj_seller unique (CNPJ),
constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;

create table productseller(
idPSeller int,
idPproduct int,
prodQuantity int default 1,
primary key (idPseller, idPproduct),
constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);
desc productseller;

create table productOrder(
idPOProduct int,
idPOorder int,
poQuantity int default 1,
poStatus enum('Disponível','Sem estoque') default 'Disponível',
primary key (idPOProduct,idPOorder),
constraint fk_productOrder_seller foreign key (idPOProduct) references product(idProduct),
constraint fk_productOrder_product foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
idLproduct int,
idLstorage int,
location varchar(255) not null,
primary key (idLproduct,idLstorage),
constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
constraint fk_storage_location_storage foreign key (idLstorage) references ProductStorage(idProdStorage)
);

create table productSupplier(
idPsSupplier int,
idPsProduct int,
Quantity int not null,
primary key (idPsSupplier,idPsProduct),
constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
constraint fk_product_supplier_product foreign key (idPsProduct) references Product(idProduct)
);

-- desafio
create table payments(
idPayment int auto_increment primary key,
idPaymentClient int,
TypePayment enum('Boleto','Cartão','Pix'),
limitAvaliable float,
valor_pagamento decimal(10,2),
Data_Pagamento DATE,
Status_pagto ENUM('Pendente', 'Pago', 'Cancelado') DEFAULT 'Pendente',
constraint fk_payment_client foreign key (idPaymentClient) references clients(idClient)
		on update cascade
);

alter table payments auto_increment=1;
desc payments;


create table Pagto_Boleto(
idBoleto int auto_increment primary key,
idPgBoPayment int,
Codigo_de_barras int,
Data_Vencto_boleto date,
constraint fk_pagamento_boleto foreign key (idPgBoPayment) references payments(idPayment)
);
alter table Pagto_Boleto auto_increment=1;
desc Pagto_Boleto;

create table Pagto_Cartao(
idcartao int auto_increment primary key,
idPgCarPayment int,
Numero_cartao varchar(16),
Bandeira VARCHAR(50),               
Parcelas INT DEFAULT 1,
constraint fk_pagamento_cartao foreign key (idPgCarPayment) references payments(idPayment)
);
alter table Pagto_Cartao auto_increment=1;
desc Pagto_Cartao;

create table Pagto_Pix(
idPix int auto_increment primary key,
idPgPixPayment int,
Chave_Pix varchar(100),
Comprovante VARCHAR(255),               
constraint fk_pagamento_pix foreign key (idPgPixPayment) references payments(idPayment)
);
alter table Pagto_Pix auto_increment=1;
desc Pagto_Pix;

create table Client_payment(
idCPayment int,
idCClient int,
primary key (idCPayment, idCClient),
constraint fk_Payment_Pgto foreign key (idCPayment) references Payments(idPayment),
constraint fk_Client_Pagto foreign key (idCClient) references Clients(idClient)
);
desc Client_payment;

create table Entrega(
idEntrega int auto_increment primary key,
idEnOrder int,
Status_Entrega ENUM('Pendente', 'Entregue') DEFAULT 'Pendente',
Codigo_rastreio VARCHAR(50),               
constraint fk_Entrega_Order foreign key (idEnOrder) references Orders(idOrder)
);
alter table Entrega auto_increment=1;
desc Entrega;



desc productSupplier;
show tables;
show databases;
use information_schema;
show tables;

-- inserção de dados e queries
use ecommerce_desafio;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Adress
insert into Clients (Fname, Minit, Lname, Tipo_Client, CPF, CNPJ, Address, Email, Telefone, Data_Cadastro)
		values('Maria','M','Silva','PF','123456789',null,'rua silva de prata 29, Carangola - Cidade das flores','m@gmail.com','98980000','2024-01-01'),
        	  ('Matheus','O','Pimentel','PF','333456789',null,'rua alameda 289, Centro - Cidade das flores','mt@gmail.com','98980000','2024-01-03'),
              ('Ricardo','F','Selva','PF','443456789',null,'rua das rosas 244, Centro - Cidade das flores','r@gmail.com','98980000','2024-07-02'),
              ('Julia','S','França','PF','333456766',null,'rua vitória 33, Centro - Cidade das flores','j@gmail.com','98980000','2024-07-01'),
              ('Ro','G','Distribuidora','PJ',null,333452288343,'rua jardins 345, Centro - Cidade das flores','ro@gmail.com','98980000','2024-09-05'),
              ('Isa ','M','Presentes','PJ',null,112256789333,'avenida das rosas 22, Centro - Cidade das flores','i@gmail.com','98980000','2024-03-07');
 
 select * from clients; 
 
           
-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into Product (Pname, classification_kids, category, avaliação, size) values
							('Fone de ouvido',false,'Eletrônico','4',null),
                            ('Barbie Elsa',true,'Brinquedos','3',null),
                            ('Body Carters',true,'Vestimenta','5',null),
                            ('Microfone Vedo - Youtuber',false,'Eletrônico','4',null),
                            ('Sofá retrátil',false,'Móveis','3','3x57x80'),
                            ('Farinha de arroz',false,'Alimentos','2',null),
                            ('Fire Stick Amazon',false,'Eletrônico','3',null);
                            
-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
delete from orders where idOrderClient in (1,2,3,4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
							(1, default,'compra via aplicativo',null,1),
                            (2, default,'compra via aplicativo',50,0),
                            (3, 'Confirmado',null,null,1),
                            (4, default,'compra via web site',150,0);

select * from orders;                            
-- idPOproduct, idPOorder, poQuantity, poStatus
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						 (1,1,2,null),
                         (2,1,1,null),
                         (3,2,1,null);
                         
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
						 (4,2,2,null),  
                         (5,1,1,null);
                         
-- storageLocation, quantity
insert into productStorage (storageLocation, quantity) values
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);
                            
-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
							(1,2,'RJ'),
                            (2,6,'GO');
                            
-- idSupplier, SocialName, CNPJ, contact
insert into  supplier ( SocialName, CNPJ, contact) values
						('Ameida e filhos', 123456789123456, '18985474'),
                        ('Eletronicos Silva', 893456789123456, '18985438'),
                        ('Eletronicos Valma', 933456789123456, '18985455');
select * from supplier;

-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
						(1,1,500),
                        (1,2,400),
                        (2,4,633),
                        (3,3,5),
                        (2,5,10);
select * from productSupplier;

-- idSeller, SocialName, AbstName, Cnpj, CPF, Location, Contact
insert into seller (SocialName, AbstName, Cnpj, CPF, Location, Contact) values
						('Tech eltronics',null, 123456789456321, null,'Rio de Janeiro', 219946287),
                        ('Botique Durgas',null, null, 123456783,'Rio de Janeiro', 219946795),
                        ('Kids World',null, 456789123654485, null,'São Paulo', 1198996754);
select * from Seller;

-- idPseller, idProduct, prodQuantity
insert into productSeller (idPseller, idPProduct, prodQuantity) values
						  (1,6,80),
                          (2,7,10);
select * from productSeller;

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;

select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname,' ',Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
							(2, default,'compra via aplicativo',null,1);

select count(*) from clients c, orders o
			where c.idClient = idOrderClient;
            
select * from clients left outer join orders on idClient = idOrderClient;

select * from clients c inner join orders o on c.idClient = o.idOrderClient
					inner join productOrder p on p.idPOorder = o.idOrder;
                    
 -- recuperar quantos pedidos form realizados pelos clientes                   
select c.idClient, Fname, count(*) as Number_of_Orders from clients c
                    inner join orders o on c.idClient = o.idOrderClient
					inner join productOrder p on p.idPOorder = o.idOrder
			group by idClient;
            
-- recuperação de pedido com produto associado                   
select * from clients c
                    inner join orders o on c.idClient = o.idOrderClient
					inner join productOrder p on p.idPOorder = o.idOrder;
		-- group by idClient;

select * from clients;
select * from orders;
select * from productOrder;

-- Implentações do desafio------------------------------------------------------------------------
/* Assim como demonstrado durante o desafio, realize a criação do Script SQL para criação do esquema do banco de dados.
 Posteriormente, realize a persistência de dados para realização de testes. Especifique ainda queries mais complexas dos que apresentadas durante a explicação do desafio.
 Sendo assim, crie queries SQL com as cláusulas abaixo:

Recuperações simples com SELECT Statement
Filtros com WHERE Statement
Crie expressões para gerar atributos derivados
Defina ordenações dos dados com ORDER BY
Condições de filtros aos grupos – HAVING Statement
Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados

Algumas das perguntas que podes fazer para embasar as queries SQL:
*/

-- Quantos pedidos foram feitos por cada cliente?
select idOrderClient, COUNT(idorder) as total_pedidos
from orders
group by idOrderClient;

-- Algum vendedor também é fornecedor?
-- select * from seller;
-- select * from supplier;
select s.idSeller, s.SocialName
from seller s
join supplier sp on s.cnpj = sp.cnpj;
/*Nenhum vendedor é fornecedor*/


-- Relação de produtos fornecedores e estoques;
-- select * from product;
-- select * from productstorage;
-- select * from productSupplier;
select p.idProduct, p.Pname as Nome_Produto, i.quantity as Qtde_Estoque
from product p
inner join productstorage i on p.idProduct = i.idProdStorage
order by Nome_Produto;

-- Relação de produtos fornecedores e estoques com quantidade maior que 100;
select p.idProduct, p.Pname as Nome_Produto, i.quantity as Qtde_Estoque
from product p
inner join productstorage i on p.idProduct = i.idProdStorage
where i.quantity > 100
order by Nome_Produto;

-- Relação de produtos fornecedores e estoques com projeção de aumento de 10% no estoque.
select p.idProduct, p.Pname as Nome_Produto, i.Quantity as Qtde_Estoque,
i.Quantity * 0.1 as Projeção_de_Aumento
from product p
inner join productstorage i on p.idProduct = i.idProdStorage
where i.Quantity * 0.1
order by Nome_Produto;

-- Relação de nomes dos fornecedores e nomes dos produtos;
-- select * from product;
-- select * from supplier;
-- select * from productSupplier;
select s.SocialName as Nome_Fornecedor, p.Pname as Descrição_Produto
from supplier s
inner join productSupplier ps on s.idSupplier = ps.idPsSupplier
inner join product p on ps.idPsProduct = p.idProduct
order by Nome_Fornecedor;

-- Relação de quantidade de produtos por fornecedor
select s.SocialName as Nome_Fornecedor, COUNT(p.idProduct) as Qtde_Produtos
from supplier s
inner join productSupplier ps on s.idSupplier = ps.idPsSupplier
inner join product p on ps.idPsProduct = p.idProduct
group by s.SocialName
having COUNT(p.idProduct) > 1;




                        
                            
                            
                         








