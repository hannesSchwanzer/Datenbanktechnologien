CREATE OR REPLACE TABLE Product (
    maker VARCHAR(1),
    model INT,
    type VARCHAR(20)
);

CREATE OR REPLACE TABLE PC (
    model INT,
    speed FLOAT,
    ram INT,
    `hard-disk` INT,
    price INT,
    PRIMARY KEY (model)
);

INSERT INTO PC (model, speed, ram, `hard-disk`, price) VALUES (1001, 2.66, 1024, 250, 2114);
INSERT INTO PC (model, speed, ram, `hard-disk`, price) VALUES (1002, 2.10, 512, 250, 995);
INSERT INTO PC (model, speed, ram, `hard-disk`, price) VALUES (1003, 1.42, 512, 80, 478);
INSERT INTO PC (model, speed, ram, `hard-disk`, price) VALUES (1004, 2.80, 1024, 250, 649);
INSERT INTO PC (model, speed, ram, `hard-disk`, price) VALUES (1005, 3.20, 512, 250, 630);

CREATE OR REPLACE TABLE Laptop (
    model INT,
    speed FLOAT,
    ram INT,
    `hard-disk` INT,
    screen FLOAT,
    price INT
);
INSERT INTO Laptop (model, speed, ram, `hard-disk`, screen, price) VALUES (2001, 2.00, 2048, 240, 20.1, 3673);
INSERT INTO Laptop (model, speed, ram, `hard-disk`, screen, price) VALUES (2002, 1.73, 1024, 80, 17.0, 949);
INSERT INTO Laptop (model, speed, ram, `hard-disk`, screen, price) VALUES (2003, 1.80, 512, 60, 15.4, 549);
INSERT INTO Laptop (model, speed, ram, `hard-disk`, screen, price) VALUES (2004, 2.00, 512, 60, 13.3, 1150);
INSERT INTO Laptop (model, speed, ram, `hard-disk`, screen, price) VALUES (2005, 2.16, 1024, 120, 17.0, 2500);

CREATE OR REPLACE TABLE Printer (
    model INT,
    color BOOLEAN,
    type VARCHAR(20),
    price INT
);

INSERT INTO Printer (model, color, type, price) VALUES (3001, 1, 'ink-jet', 99);
INSERT INTO Printer (model, color, type, price) VALUES (3002, 0, 'laser', 239);
INSERT INTO Printer (model, color, type, price) VALUES (3003, 1, 'laser', 899);
INSERT INTO Printer (model, color, type, price) VALUES (3004, 1, 'ink-jet', 120);
INSERT INTO Printer (model, color, type, price) VALUES (3005, 0, 'laser', 120);


INSERT INTO Product(maker, model, type) VALUES ('A', 1001, 'pc');
INSERT INTO Product(maker, model, type) VALUES ('B', 1002, 'pc');
INSERT INTO Product(maker, model, type) VALUES ('C', 1003, 'pc');
INSERT INTO Product(maker, model, type) VALUES ('D', 1004, 'pc');
INSERT INTO Product(maker, model, type) VALUES ('E', 1005, 'pc');
INSERT INTO Product(maker, model, type) VALUES ('A', 2001, 'laptop');
INSERT INTO Product(maker, model, type) VALUES ('B', 2002, 'laptop');
INSERT INTO Product(maker, model, type) VALUES ('C', 2003, 'laptop');
INSERT INTO Product(maker, model, type) VALUES ('D', 2004, 'laptop');
INSERT INTO Product(maker, model, type) VALUES ('E', 2005, 'laptop');
INSERT INTO Product(maker, model, type) VALUES ('A', 3001, 'printer');
INSERT INTO Product(maker, model, type) VALUES ('B', 3002, 'printer');
INSERT INTO Product(maker, model, type) VALUES ('C', 3003, 'printer');
INSERT INTO Product(maker, model, type) VALUES ('D', 3004, 'printer');
INSERT INTO Product(maker, model, type) VALUES ('E', 3005, 'printer');
