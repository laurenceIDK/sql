CREATE TABLE customer (
    cust_id             VARCHAR(5)      NOT NULL,
    cust_firstname      VARCHAR(50)     NOT NULL,
    cust_lastname       VARCHAR(50)     NOT NULL,
    cust_tel            VARCHAR(11)     NOT NULL,
    cust_gender         CHAR(1)         NOT NULL,
    cust_age            NUMBER(2)       NOT NULL,
    cust_email          VARCHAR(50)     DEFAULT 'NIL',
    cust_address        VARCHAR(100)    DEFAULT 'NIL',
    no_of_visit         NUMBER(3)       DEFAULT 0,
    PRIMARY KEY (cust_id),
    CONSTRAINT cust_gender_chk CHECK (cust_gender IN ('M', 'F')),
    CONSTRAINT cust_email_chk CHECK (cust_email LIKE '%@%.%'),
    CONSTRAINT cust_tel_chk CHECK (cust_tel LIKE '01_-%')
);

CREATE TABLE outlet (
    outlet_no           VARCHAR(3)      NOT NULL,
    outlet_name         VARCHAR(50)     NOT NULL,
    outlet_address      VARCHAR(100)    NOT NULL,
    outlet_tel          VARCHAR(11)     NOT NULL,
    outlet_email        VARCHAR(50)     NOT NULL,
    outlet_start_time   VARCHAR(8)      NOT NULL,
    outlet_end_time     VARCHAR(8)      NOT NULL,
    PRIMARY KEY (outlet_no),
    CONSTRAINT outlet_email_chk CHECK (outlet_email LIKE '%@hairstory.%'),
    CONSTRAINT outlet_tel_chk CHECK (outlet_tel LIKE '01_-%')
);

CREATE TABLE service (
    service_no          VARCHAR(3)      NOT NULL,
    service_name        VARCHAR(50)     NOT NULL,
    service_desc        VARCHAR(200)    NOT NULL,
    service_price       NUMBER(3,2)     NOT NULL,
    PRIMARY KEY (service_no),
    CONSTRAINT service_price_chk CHECK (service_price > 0)
);

CREATE TABLE stylist (
    stylist_id          VARCHAR(5)      NOT NULL,
    stylist_name        VARCHAR(50)     NOT NULL,
    stylist_gender      CHAR(1)         NOT NULL,
    stylist_age         NUMBER(2)       NOT NULL,
    stylist_tel         VARCHAR(11)     NOT NULL,
    stylist_role        VARCHAR(20)     NOT NULL,
    outlet_id           VARCHAR(3)      NOT NULL,
    PRIMARY KEY (stylist_id),
    FOREIGN KEY (outlet_id) REFERENCES outlet(outlet_no),
    CONSTRAINT stylist_gender_chk CHECK (stylist_gender IN ('M', 'F')),
    CONSTRAINT stylist_tel_chk CHECK (stylist_tel LIKE '01_-%'),
    CONSTRAINT stylist_role_chk CHECK (LOWER(stylist_role) IN ('junior', 'senior', 'trainee'))
);

CREATE TABLE appointment (
    apt_no              VARCHAR(5)      NOT NULL,
    apt_date            DATE            NOT NULL,
    apt_time            VARCHAR(8)      NOT NULL,
    apt_status          VARCHAR(10)     NOT NULL,
    cust_id             VARCHAR(5)      NOT NULL,
    PRIMARY KEY (apt_no),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id),
    CONSTRAINT apt_status_chk CHECK (UPPER(apt_status) IN ('COMPLETED', 'MISSED', 'CANCELLED'))
);

CREATE TABLE payment (
    payment_no          VARCHAR(5)      NOT NULL,
    payment_method      VARCHAR(20)     NOT NULL,
    payment_amount      NUMBER(5,2)     NOT NULL,
    payment_date        VARCHAR(10)     DEFAULT TO_CHAR(SYSDATE, 'DD/MM/YYYY')   NOT NULL,
    payment_status      VARCHAR(20)     NOT NULL,
    payment_recipient_name  VARCHAR(50) DEFAULT 'NIL',
    apt_no              VARCHAR(5)      NOT NULL,
    PRIMARY KEY (payment_no),
    FOREIGN KEY (apt_no) REFERENCES appointment (apt_no),
    CONSTRAINT pay_meth_chk CHECK (UPPER(payment_method) IN  ('TNG WALLET', 'CASH', 'ONLINE FPX', 'CREDIT CARD', 'DEBIT CARD')),
    CONSTRAINT pay_date_chk CHECK (TO_DATE(payment_date, 'DD/MM/YYYY') <= TRUNC(SYSDATE)),
    CONSTRAINT pay_status_chk CHECK (UPPER(payment_status) IN ('COMPLETED', 'CANCELLED'))
);

CREATE TABLE appointment_service (
    apt_no              VARCHAR(5)      NOT NULL,
    service_no          VARCHAR(5)      NOT NULL,
    stylist_id          VARCHAR(5)      NOT NULL,
    PRIMARY KEY (apt_no, service_no, stylist_id),
    FOREIGN KEY (apt_no) REFERENCES appointment (apt_no),
	FOREIGN KEY (service_no) REFERENCES service (service_no),
	FOREIGN KEY (stylist_id) REFERENCES stylist (stylist_id)
);


