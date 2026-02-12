CREATE TABLE dept(NO INT PRIMARY KEY, NAME VARCHAR(10), tel VARCHAR(15), inwon INT, addr TEXT) CHARSET=UTF8; -- 테이블 생성 

-- 자료 추가 
# insert into 테이블명 (칼럼명,...) values(입력자료,...NO)
INSERT INTO dept(NO,NAME,tel,inwon,addr) VALUES(1,'인사과','111-1111',3,'삼성동12');
INSERT INTO dept VALUES(2,'영업과','222-2222',5,'서초동12');
INSERT INTO dept(NO,NAME) VALUES(3,'자재과');
INSERT INTO dept(NO,addr, tel, NAME) VALUES(4,'역삼2동33','111-5555','자재2과');

# INSERT INTO dept VALUES(5,'판매과');  -- err : 입력 자료와 칼럼 갯수 불일치 
# INSERT INTO dept(NAME,tel) VALUES('판매2과','111-6666'); -- NO : pk, 생략 불가
# INSERT INTO dept(NO,NAME) VALUES(5,'판매과부서는 사람들이 좋아 일하기 좋은 우수한 부서임'); -- err : 자리수 넘침
SELECT * FROM dept;
SELECT * FROM dept WHERE NO=1;

-- 자료 수정
-- update 테이블명 set 수정칼럼명=수정값,... where 조건 <== 수정 대상 칼럼을 지정
-- pk 칼럼의 자료는 수정 대상에서 제외 
UPDATE dept SET tel='123-4567' WHERE NO=2;
UPDATE dept SET addr='압구정동33',inwon=7,tel='777-8888' WHERE NO=3;
SELECT * FROM dept;

-- 자료 삭제
-- delete from 테이블명 where 조건    -- 전체 또는 부분적 레코드 삭제 가능
-- truncate table 테이블명    -- where 조건을 사용X , 전체 레코드 삭제 가능
DELETE FROM dept WHERE NAME='자재2과';
truncate TABLE dept;
SELECT * FROM dept;

DROP TABLE dept;     -- 테이블 자체(구조,자료)가 제거됨 

-- 무결성 제약조건
--테이블 생성시  잘못된 자료 입력을 막고자 다양한 입력 제한 조건을 줄 수 있다.
-- 1) 기본키 제약: primary key(pk) 사용, 중복 레코드 입력 방지
CREATE TABLE aa(bun INT PRIMARY KEY, irum CHAR(10));   -- bun : NOT NULL , UNIQUE 
SELECT * FROM information_schema.table_constraints WHERE TABLE_NAME='aa';
INSERT INTO aa VALUES(1,'tom');
INSERT INTO aa VALUES(2,'tom');
# INSERT INTO aa VALUES(2,'tom');       -- err : pk
# INSERT INTO aa(irum) VALUES('tom');   -- err : pk
INSERT INTO aa(bun) VALUES('3');
SELECT * FROM aa;
DROP TABLE aa;

CREATE TABLE aa(bun INT , irum CHAR(10),CONSTRAINT aa_bun_pk PRIMARY KEY(bun));
INSERT INTO aa VALUES(1,'tom');
SELECT * FROM aa;
DROP TABLE aa;
-- 2) check 제약: 입력 자료의 특정 칼럼값 조건 검사 
CREATE TABLE aa(bun INT , nai INT CHECK(nai >= 20));
INSERT INTO aa VALUES(1,23);
# INSERT INTO aa VALUES(2,13); -- err : 조건 충족X
SELECT * FROM aa;
DROP TABLE aa;

-- 3) unique 제약: 특정 칼럼값 중복 불허 
CREATE TABLE aa(bun INT , irum CHAR(10) NOT NULL UNIQUE);
INSERT INTO aa VALUES(1,'tom');
INSERT INTO aa VALUES(2,'john');
# INSERT INTO aa VALUES(3,'john'); -- err : 중복값 
SELECT * FROM aa;
DROP TABLE aa;

-- 4) foreign key(fk), 외부키, 참조키 제약. 특정 칼럼이 다른 테이블의 칼럼을 참조
-- fk 대상은 pk 
CREATE TABLE jikwon(bun INT PRIMARY KEY, irum VARCHAR(10) NOT NULL, buser CHAR(10) NOT NULL);
INSERT INTO jikwon VALUES(1,'한송이', '인사과');
INSERT INTO jikwon VALUES(2,'이기자', '인사과');
INSERT INTO jikwon VALUES(3,'한송이', '판매과');

CREATE TABLE gajok(CODE INT PRIMARY KEY, NAME VARCHAR(10) NOT NULL, birth DATETIME , jikwonbun INT, FOREIGN KEY(jikwonbun) REFERENCES jikwon(bun));
INSERT INTO gajok VALUES(10,'한가해','2015-05-12',3);
INSERT INTO gajok VALUES(20,'공기밥','2011-12-12',2);
# INSERT INTO gajok VALUES(30,'김밥','2013-03-02',5);   -- err : 참조 대상 없음.
INSERT INTO gajok VALUES(30,'심심','2010-05-12',3);
SELECT * FROM gajok;

DELETE FROM jikwon WHERE bun=1;
# DELETE FROM jikwon WHERE bun=2;  -- err : 가족이 연결되어있음
# DELETE FROM jikwon WHERE bun=3;  -- err : 가족이 연결되어있음
# DROP TABLE jikwon; -- err : 가족이 연결되어있음

DELETE FROM gajok WHERE jikwonbun=2; --  1) 참조키(pk가 2번) 가족 자료 삭제 
DELETE FROM jikwon WHERE bun=2; -- 2) 참조 가족이 없으므로 2번 직원 삭제 가능
DELETE FROM gajok WHERE jikwonbun=3;
SELECT * FROM jikwon;

-- 참고
-- CREATE TABLE gajok(CODE INT PRIMARY KEY,...bun) on delete cascade
-- 직원자료를 삭제하면 관련있는 가족 자료도 함께 삭제 가능 -- 실무에선 되도록 안함.
DROP TABLE gajok
DROP TABLE jikwon

-- default : 특정 칼럼에 초기치 부여. null 예방 
CREATE TABLE aa(bun INT AUTO_INCREMENT PRIMARY KEY , juso CHAR(20) DEFAULT '강남구 역삼동');     -- AUTO_INCREMENT: 번호(bun) 자동 증가 (오라클은 안됨)
INSERT INTO aa VALUES(1, '서초구 서초2동');
INSERT INTO aa(juso) VALUES('서초구 서초3동');
INSERT INTO aa(juso) VALUES('서초구 서초4동');
INSERT INTO aa(bun) VALUES(5);
INSERT INTO aa(bun) VALUES(6);
SELECT * FROM aa;
DROP TABLE aa;

-- 연습문제 
CREATE TABLE professor(pro_code INT PRIMARY KEY , pro_name CHAR(10) , lab_number INT CHECK(lab_number >= 100 AND lab_number <= 500));
INSERT INTO professor VALUES(1, '이대한', 120);
INSERT INTO professor VALUES(2, '장홍제', 400);
INSERT INTO professor VALUES(3, '데프콘', 370);
SELECT * FROM professor;

CREATE TABLE subjects(sub_num INT AUTO_INCREMENT PRIMARY KEY , sub_name CHAR(10) NOT NULL UNIQUE, book_name CHAR(20) 
, sub_pro INT , FOREIGN KEY(sub_pro) REFERENCES professor(pro_code));
INSERT INTO subjects VALUES(1, '생명과학', '생명의 이해', 1);
INSERT INTO subjects(sub_name,book_name,sub_pro) VALUES('화학', '화학의 이해', 2);
INSERT INTO subjects(sub_name,book_name,sub_pro) VALUES('방산의 이해', '군사의 이해', 3);
SELECT * FROM subjects;

CREATE TABLE students(stu_code INT PRIMARY KEY, stu_name CHAR(10) , stu_sub INT, stu_grade INT DEFAULT 1 CHECK(stu_grade <= 4 AND stu_grade >= 1),
 FOREIGN KEY(stu_sub) REFERENCES subjects(sub_num));
INSERT INTO students VALUES(2, '정진원', 1 , 2);
INSERT INTO students(stu_code,stu_name,stu_sub,stu_grade) VALUES(5,'정진투',2, 3);
INSERT INTO students(stu_code,stu_name,stu_sub) VALUES(8,'정진삼',3);
SELECT * FROM students;

DROP TABLE students;
DROP TABLE subjects;
DROP TABLE professor;

-- index (색인) : 검색 속도 향샹을 위해 특정 column에 색인 부여 가능
-- pk column은 자동으로 인덱싱됨(ascending sort : 오름차순 정렬)
-- index를 자제해야 하는 경우 : 입력, 수정, 삭제 등의 작업이 빈번한 경우
CREATE TABLE aa(bun INT PRIMARY KEY, irum VARCHAR(10) NOT NULL, juso VARCHAR(50));
INSERT INTO aa VALUES(1, '신선해', '테레란로111');
ALTER TABLE aa ADD INDEX ind_juso(juso);   -- juso column에 인덱스를 부여 
SELECT * FROM aa;
EXPLAIN SELECT * FROM aa;
DESC aa;
SHOW INDEX FROM aa;
ALTER TABLE aa DROP INDEX ind_juso;
SHOW INDEX FROM aa;

DROP TABLE aa;

-- 테이블 관련 주요 명령
-- create table 테이블명 
-- ALTER table 테이블명
-- DROP table 테이블명
CREATE TABLE aa(bun INT , irum VARCHAR(10),juso VARCHAR(50));
INSERT INTO aa VALUES(1, 'tom', 'seoul');
SELECT * FROM aa;

ALTER TABLE aa RENAME kbs;  -- 테이블명 변경 
SELECT * FROM kbs;
ALTER TABLE kbs RENAME aa;

-- column 관련 명령
ALTER TABLE aa ADD (job_id INT DEFAULT 10);  -- column 추가
SELECT * FROM aa;
ALTER TABLE aa CHANGE job_id job_num INT;    -- column 수정 (이름이나 성격 변경 가능)
SELECT * FROM aa;
ALTER TABLE aa MODIFY job_num VARCHAR(10);   -- column의 성격 변경
DESC aa;
ALTER TABLE aa DROP COLUMN job_num;          -- column 삭제
DESC aa;
DROP TABLE aa;

-- -------------------------------------------------------
create table sangdata(code int primary KEY, sang varchar(20), su INT, dan INT);
insert into sangdata values(1,'장갑',3,10000);
insert into sangdata values(2,'벙어리장갑',2,12000);
insert into sangdata values(3,'가죽장갑',10,50000);
insert into sangdata values(4,'가죽점퍼',5,650000);
SELECT * FROM sangdata;
DESC sangdata;

create table buser(buserno int primary key, busername varchar(10) not null,buserloc varchar(10),busertel varchar(15));
insert into buser values(10,'총무부','서울','02-100-1111');
insert into buser values(20,'영업부','서울','02-100-2222');
insert into buser values(30,'전산부','서울','02-100-3333');
insert into buser values(40,'관리부','인천','032-200-4444');
SELECT * FROM buser;
DESC buser;

create table jikwon(jikwonno int primary KEY,
jikwonname varchar(10) not NULL,
busernum int not nulljikwonjik varchar(10) DEFAULT '사원',
jikwonpay INT,
jikwonibsail DATE,
jikwongen varchar(4),
jikwonrating char(3), CONSTRAINT ck_jikwongen check(jikwongen='남' or jikwongen='여'));

insert into jikwon values(1,'홍길동',10,'이사',9900,'2008-09-01','남','a');
insert into jikwon values(2,'한송이',20,'부장',8800,'2010-01-03','여','b');
insert into jikwon values(3,'이순신',20,'과장',7900,'2010-03-03','남','b');
insert into jikwon values(4,'이미라',30,'대리',4500,'2014-01-04','여','b');
insert into jikwon values(5,'이순라',20,'사원',3000,'2017-08-05','여','b');
insert into jikwon values(6,'김이화',20,'사원',2950,'2019-08-05','여','c');
insert into jikwon values(7,'김부만',40,'부장',8600,'2009-01-05','남','a');
insert into jikwon values(8,'김기만',20,'과장',7800,'2011-01-03','남','a');
insert into jikwon values(9,'채송화',30,'대리',5000,'2013-03-02','여','a');
insert into jikwon values(10,'박치기',10,'사원',3700,'2016-11-02','남','a');
insert into jikwon values(11,'김부해',30,'사원',3900,'2016-03-06','남','a');
insert into jikwon values(12,'박별나',40,'과장',7200,'2011-03-05','여','b');
insert into jikwon values(13,'박명화',10,'대리',4900,'2013-05-11','남','a');
insert into jikwon values(14,'박궁화',40,'사원',3400,'2016-01-15','여','b');
insert into jikwon values(15,'채미리',20,'사원',4000,'2016-11-03','여','a');
insert into jikwon values(16,'이유가',20,'사원',3000,'2016-02-01','여','c');
insert into jikwon values(17,'한국인',10,'부장',8000,'2006-01-13','남','c');
insert into jikwon values(18,'이순기',30,'과장',7800,'2011-11-03','남','a');
insert into jikwon values(19,'이유라',30,'대리',5500,'2014-03-04','여','a');
insert into jikwon values(20,'김유라',20,'사원',2900,'2019-12-05','여','b');
insert into jikwon values(21,'장비',20,'사원',2950,'2019-08-05','남','b');
insert into jikwon values(22,'김기욱',40,'대리',5850,'2013-02-05','남','a');
insert into jikwon values(23,'김기만',30,'과장',6600,'2015-01-09','남','a');
insert into jikwon values(24,'유비',20,'대리',4500,'2014-03-02','남','b');
insert into jikwon values(25,'박혁기',10,'사원',3800,'2016-11-02','남','a');
insert into jikwon values(26,'김나라',10,'사원',3500,'2016-06-06','남','b');
insert into jikwon values(27,'박하나',20,'과장',5900,'2012-06-05','여','c');
insert into jikwon values(28,'박명화',20,'대리',5200,'2013-06-01','여','a');
insert into jikwon values(29,'박가희',10,'사원',4100,'2016-08-05','여','a');
insert into jikwon values(30,'최미숙',30,'사원',4000,'2015-08-03','여','b');

SELECT * FROM jikwon;
DESC jikwon;

CREATE TABLE gogek(
gogekno int PRIMARY KEY,
gogekname varchar(10) NOT NULL,
gogektel varchar(20),
gogekjumin char(14),
gogekdamsano INT,
CONSTRAINT FK_gogekdamsano FOREIGN KEY(gogekdamsano) REFERENCES jikwon(jikwonno));

insert INTO gogek VALUES(1,'이나라','02-535-2580','850612-1156777',5);
insert into gogek VALUES(2,'김혜순','02-375-6946','700101-1054777',3);
insert into gogek VALUES(3,'최부자','02-692-8926','890305-1065777',3);
insert into gogek VALUES(4,'김해자','032-393-6277','770412-2028777',13);
insert into gogek VALUES(5,'차일호','02-294-2946','790509-1062777',2);
insert into gogek VALUES(6,'박상운','032-631-1204','790623-1023777',6);
insert into gogek VALUES(7,'이분','02-546-2372','880323-2558777',2);
insert into gogek VALUES(8,'신영래','031-948-0283','790908-1063777',5);
insert into gogek VALUES(9,'장도리','02-496-1204','870206-2063777',4);
insert into gogek VALUES(10,'강나루','032-341-2867','780301-1070777',12);
insert into gogek VALUES(11,'이영희','02-195-1764','810103-2070777',3);
insert into gogek VALUES(12,'이소리','02-296-1066','810609-2046777',9);
insert into gogek VALUES(13,'배용중','02-691-7692','820920-1052777',1);
insert into gogek VALUES(14,'김현주','031-167-1884','800128-2062777',11);
insert into gogek VALUES(15,'송운하','02-887-9344','830301-2013777',2);

SELECT * FROM  gogek;
DESC gogek;

-- select: db 서버로부터 클라이언트로 자료를 읽는 명령
-- select 칼럼명 as 별명, .. from 테이블명 where 조건 order by 기준키,...
SELECT * FROM jikwon;  -- *은 모든 칼럼 가져오기 
SELECT jikwonno, jikwonname FROM jikwon;  -- selection : 필요한 column만 가져오기 
SELECT jikwonno, jikwongen, busernum,jikwonname FROM jikwon;   -- column의 순서는 중요하지 않음.
SELECT jikwonno AS 직원번호,  jikwonname AS 직업명  FROM jikwon;  -- as: column명 as 별명  -> 별명으로 불러야함.
SELECT 10,'안녕', 12/3 AS 결과  FROM DUAL;  -- 가상테이블
SELECT jikwonname, jikwonpay , jikwonpay * 0.05 AS tax FROM jikwon;   -- column에 수식 만들기 가능
SELECT jikwonname,CONCAT(jikwonname,'님') AS jikwonetc FROM jikwon;   -- concat() : 문자열 더하기 함수

-- 정렬(sort)
SELECT * FROM jikwon ORDER BY jikwonpay ASC;  -- asc : 오름차순(생략 가능)
SELECT * FROM jikwon ORDER BY jikwonpay DESC; -- desc : 내림차순
SELECT * FROM jikwon ORDER BY jikwonjik ASC; 
SELECT * FROM jikwon ORDER BY jikwonjik ASC, busernum DESC, jikwongen ASC, jikwonpay;
SELECT jikwonname, jikwonpay, jikwonpay / 100 AS pay FROM jikwon ORDER BY pay DESC;   -- 수식 column도 가능

SELECT distinct jikwonjik FROM jikwon;  -- distinct: 중복 배제
SELECT distinct jikwonjik,jikwonname FROM jikwon;  -- 중복을 배제할 때는 column 하나만! 

-- 연산자: () > 산술(*,/ -> +,-) > 관계(비교) > is null, like, in > between, not > and > or
SELECT * FROM jikwon WHERE jikwonjik = '대리';   -- 레코드 선택
SELECT * FROM jikwon WHERE jikwonno = 3;
SELECT * FROM jikwon WHERE jikwonibsail ='2010-03-03';
SELECT * FROM jikwon WHERE jikwonno = 5 OR jikwonno =7;   -- and는 말안됨.
SELECT * FROM jikwon WHERE jikwonjik = '사원' AND jikwongen = '여' AND jikwonpay <= 3000;
SELECT * FROM jikwon WHERE jikwonjik = '사원' AND (jikwongen = '여' OR jikwonibsail >= '2017-01-01'); -- (): 먼저 연산

SELECT * FROM jikwon WHERE jikwonno >= 5 AND jikwonno <= 10;
SELECT * FROM jikwon WHERE jikwonno BETWEEN 5 AND 10;
SELECT * FROM jikwon WHERE jikwonibsail BETWEEN '2017-01-01' AND '2019-12-31';

SELECT * FROM jikwon WHERE jikwonno < 5 or jikwonno > 20;
SELECT * FROM jikwon WHERE jikwonno not BETWEEN 5 AND 20; -- 긍정적 형태의 조건이 속도가 빠름.(되도록 긍정적인 형태로 코드를 작성해라)

SELECT * FROM jikwon WHERE jikwonpay > 5000;
SELECT * FROM jikwon WHERE jikwonpay > 3000 + 2000;

SELECT * FROM jikwon WHERE jikwonname = '홍길동';
SELECT * FROM jikwon WHERE jikwonname >= '박'; -- 박 이후에 사람들
SELECT * FROM jikwon WHERE jikwonname >= '이'; -- 문자도 산술연산자 사용 가능(모든 문자는 숫자처리 됨.)
SELECT ASCII('a'),  ASCII('A') ,  ASCII('가'),  ASCII('나')FROM DUAL;
SELECT * FROM jikwon WHERE jikwonname BETWEEN '김' AND '박';  -- '박' 까지만 나온다.

-- in 멤버 조건 연산
SELECT * FROM jikwon WHERE jikwonjik = '대리' OR jikwonjik = '과장' OR jikwonjik = '부장';
SELECT * FROM jikwon WHERE jikwonjik IN('대리','과장','부장');  -- or가 연속으로 나올때 
SELECT * FROM jikwon WHERE jikwonno IN(3,12,29);

-- like 조건 연산 : %(0개 이상의 문자열), _(한개 문자)
SELECT * FROM jikwon WHERE jikwonname LIKE '이%';   -- '이%' : 첫글자 '이' + 아무글자(없어도 가능) => 출력
SELECT * FROM jikwon WHERE jikwonname LIKE '이순%';
SELECT * FROM jikwon WHERE jikwonname LIKE '%라';
SELECT * FROM jikwon WHERE jikwonname LIKE '이%라';

SELECT * FROM jikwon WHERE jikwonname LIKE '이__';  -- '이__' : '이'로 시작하는 3글자 데이터 출력
SELECT * FROM jikwon WHERE jikwonname LIKE '이_라';

SELECT * FROM jikwon WHERE jikwonname LIKE '__';
SELECT * FROM jikwon WHERE jikwonpay LIKE '3___'; -- 3000단위만
SELECT * FROM jikwon WHERE jikwonpay LIKE '3%'; -- 3으로 시작

SELECT * FROM gogek WHERE gogekjumin LIKE '_______1%'; 
SELECT * FROM gogek WHERE gogekjumin LIKE '%-1%';

UPDATE jikwon SET jikwonjik = NULL WHERE jikwonno = 5;
SELECT * FROM jikwon;
SELECT * FROM jikwon WHERE jikwonjik IS NULL; -- is null : = null -> false

SELECT * FROM jikwon LIMIT 3; 
SELECT * FROM jikwon order by jikwonno desc LIMIT 3; # 뒤에서 3명
SELECT * FROM jikwon LIMIT 5,3; -- limit 시작행, 갯수

SELECT jikwonno AS 직원번호 , jikwonname AS 직원명,jikwonjik AS 직급, jikwonpay AS 연봉,
round(jikwonpay /12) AS 보너스, jikwonibsail AS 입사일 FROM jikwon
WHERE jikwonjik IN('과장',' 부장', '사원') AND jikwonpay >= 4000 AND jikwonibsail BETWEEN '2015-1-1' AND '2019-12-31'
ORDER BY jikwonjik, jikwonpay DESC LIMIT 3;

-- 내장함수 : 데이터 조작의 효율성 증진이 목적
-- 단일 행 함수 : 각 행에 대해 작업한다. 행 단위 처리
-- 문자 함수
SELECT LOWER('hello'), UPPER('hello') FROM DUAL;
SELECT SUBSTR('hello world',3),SUBSTR('hello world',3,3),SUBSTR('hello world',-3,3) FROM DUAL; -- substr('문자', 시작, 갯수)
SELECT LENGTH('hello world'),INSTR('hello world', 'e') FROM DUAL;  -- LENGTH('문자') : 문자 길이 ,INSTR('문자', '찾을 문자')
SELECT REPLACE('010.111.1234','.','-') FROM DUAL;   --  REPLACE('문자','변경될 문자','변경할 문자')
-- ...
-- jikwon table에서 이름에 '이'가 포함된 직원이 있으면 '이'부터 두글자 출력하기
SELECT jikwonname, substr(jikwonname,instr(jikwonname,'이'),2) FROM jikwon WHERE jikwonname LIKE '%이%'; 

-- 숫자 함수 
SELECT ROUND(45.678,2), ROUND(45.678), ROUND(45.678,0) , ROUND(45.678,-1) FROM DUAL; -- round(숫자, 어디에서 반올림)
SELECT jikwonname, jikwonpay, jikwonpay * 0.25 AS tax ,ROUND(jikwonpay * 0.25, 0) FROM jikwon;

SELECT TRUNCATE(45.678,0),TRUNCATE(45.678,1),TRUNCATE(45.678,-1) FROM DUAL; -- TRUNCATE(숫자,버릴 자릿수)
SELECT mod(15,2),15 / 2 FROM DUAL;
SELECT GREATEST(23,25,5,1,12),LEAST(23,25,5,1,12) FROM DUAL;

-- 날짜 함수 
SELECT NOW(), NOW() + 2, SYSDATE(), CURDATE() FROM DUAL;
SELECT NOW(), SLEEP(3), NOW() FROM DUAL;        -- sleep(n) : n초 후 출력, NOW(): 하나의 query내에서 동일값 출력
SELECT SYSDATE(), SLEEP(3), SYSDATE() FROM DUAL; -- SYSDATE() : 실행 시점값 출력
SELECT ADDDATE('2020-08-01',3),ADDDATE('2020-08-01',-3), SUBDATE('2020-08-01',3) , SUBDATE('2020-08-01',-3) -- 날짜 연산 - 윤년 체크 가능
SELECT DATE_ADD(NOW(),INTERVAL 3 MINUTE),DATE_ADD(NOW(),INTERVAL 5 day),DATE_ADD(NOW(),INTERVAL 5 MONTH) FROM DUAL; -- year

SELECT DATEDIFF(NOW(),'2005-3-2') FROM DUAL;
-- ...

-- 형태 변환 함수
SELECT NOW(), DATE_FORMAT(NOW(), '%Y%m%d'), DATE_FORMAT(NOW(), '%Y년%m월%d일')
SELECT jikwonname,jikwonibsail, DATE_FORMAT(jikwonibsail, '%W') FROM jikwon WHERE busernum = 10;

SELECT STR_TO_DATE('2026-02-12', '%Y-%m-%d');
SELECT STR_TO_DATE('2026-02-12 13:16:34', '%Y-%m-%d %H:%i:%S');

-- 기타 함수
-- rank() : 순위 결정
SELECT jikwonno, jikwonname,jikwonpay, RANK() OVER(ORDER BY jikwonpay) AS result, dense_RANK() OVER(ORDER BY jikwonpay) AS result2 FROM jikwon;  -- rank() / dense_rank(): 동점자 처리가 다르다. 
SELECT jikwonno, jikwonname,jikwonpay, RANK() OVER(ORDER BY jikwonpay desc) AS result, dense_RANK() OVER(ORDER BY jikwonpay desc) AS result2 FROM jikwon;

-- nvl(value1, value2) : value1이 null이면 value2를 취함
SELECT jikwonname,jikwonjik, nvl(jikwonjik, '임시직') FROM jikwon;

--  nvl2(value1, value2, value3) : value1이 null이면 value3, 아니면 value2을 취함
SELECT jikwonname,jikwonjik, nvl2(jikwonjik,'정규직', '임시직') FROM jikwon;

-- nullif(value1,value2) : 두 개의 값이 일치하면 null, 아니면 value1을 취함
SELECT jikwonname,jikwonjik, NULLIF(jikwonjik,'대리') FROM jikwon;  -- '대리'만 null로 치환

-- 조건 표현식
-- 형식 1) 
-- case 표현식 when 비교값1 then 결과값1  when 비교값2 then 결과값2 ...[else 결과값n] end as 별명
SELECT case 10 / 5 
when 5 then '안녕' 
when 2 then '반가워' 
ELSE '잘가' END AS 결과 FROM DUAL;


SELECT jikwonname, jikwonpay, jikwonjik, 
case jikwonjik 
when '이사' then jikwonpay * 0.05
when '부장' then jikwonpay * 0.04
when '과장' then jikwonpay * 0.03
ELSE  jikwonpay * 0.02 END donation FROM jikwon;

-- 형식 2) 
-- case when 조건1 then 결과값1  when 조건2 then 결과값2 ...[else 결과값n] end as 별명
SELECT jikwonname, 
case when jikwongen='남' then '남성' 
when jikwongen = '여' then '여성' 
END AS gender FROM jikwon;

SELECT jikwonname,jikwonpay,
case 
when jikwonpay >= 7000 then '우수연봉'
when jikwonpay >= 5000 then '보통연봉'
ELSE '저조' END AS result,jikwongen FROM jikwon WHERE jikwonjik IN('대리','과장');

-- if(조건, 참값, 거짓값) as 별명
SELECT jikwonname, jikwonpay, TRUNCATE(jikwonpay/1000,0) FROM jikwon;

SELECT jikwonname, jikwonpay, jikwonjik, if(TRUNCATE(jikwonpay/1000,0) >= 5, 'good', 'normal') AS result FROM jikwon;

-- 1)5년 이상 근무하면 '감사합니다', 그 외는 '열심히' 라고 표현 ( 2010 년 이후 직원만 참여 )
--  특별수당(pay를 기준) : 5년 이상 5%, 나머지 3% (정수로 표시:반올림)

SELECT jikwonname AS 직원명, 
year(NOW()) - year(jikwonibsail) AS 근무년수,
if(year(NOW())- year(jikwonibsail) >= 10, '감사합니다','열심히') AS 표현,
case 
when year(NOW())- year(jikwonibsail) >= 10 then round(jikwonpay * 0.05,0)
ELSE round(jikwonpay * 0.03,0) END AS 특별수당
FROM jikwon
WHERE year(jikwonibsail) > 2010;

-- 2) 입사 후 8년 이상이면 왕고참, 5년 이상이면 고참, 
-- 3년 이상이면 보통, 나머지는 일반으로 표현
-- 출력==>  직원명    직급    입사년월일    구분      부서

SELECT jikwonname AS 직원명, jikwonjik AS 직급, jikwonibsail AS 입사년월일, 
case
when year(NOW())- year(jikwonibsail) >= 8 then '왕고참'
when year(NOW())- year(jikwonibsail) >= 5 then '고참'
when year(NOW())- year(jikwonibsail) >= 3 then '보통'
ELSE '일반' end AS 구분,
case 
when busernum =10 then '총무부'
when busernum =20 then '영업부'
when busernum =30 then '전산부'
when busernum =40 then '관리부'
end AS 부서
FROM jikwon;

-- 3) 각 부서번호별로 실적에 따라 급여를 다르게 인상하려 한다. 
-- pay를 기준으로 10번은 10%, 30번은 20% 인상하고 나머지 부서는 동결한다.
-- 8년 이상 장기근속을 O,X로 표시
-- 금액은 정수만 출력(반올림)
-- 출력==>   사번    직원명   부서    연봉    인상연봉    장기근속

SELECT jikwonno AS 사번, jikwonname AS 직원명, busernum AS 부서,jikwonpay AS 연봉,
case busernum
when 10 then ROUND(jikwonpay * 1.1,0)
when 30 then ROUND(jikwonpay * 1.2,0)
ELSE jikwonpay END 인상연봉,
IF(2019- year(jikwonibsail) >= 8, 'o','x') AS 장기근속
FROM jikwon;

-- 집계함수(복수행 함수) : 전체 자료를 그룹별로 구분해 통계 결과를 얻기 위한 함수
SELECT sum(jikwonpay) AS 합, AVG(jikwonpay) AS 평균 FROM jikwon;
SELECT max(jikwonpay) AS 최대값 , min(jikwonpay) AS 최소값  FROM jikwon;

UPDATE jikwon SET jikwonpay = NULL WHERE jikwonno = 5;
SELECT * FROM jikwon;
DESC jikwon;

SELECT AVG(jikwonpay), AVG(nvl(jikwonpay, 0)) FROM jikwon;  -- AVG(): null 값은 제외 
SELECT sum(jikwonpay) / 29, sum(jikwonpay) / 30 FROM jikwon;

SELECT COUNT(jikwonno), COUNT(jikwonpay) FROM jikwon;  -- 출력:  30   /    29
SELECT stddev(jikwonpay) AS 표준편차, var_samp(jikwonpay) AS 분산 FROM jikwon;   -- 표준편차 / 분산
SELECT COUNT(*) AS 인원수 FROM jikwon;

SELECT COUNT(*) AS 인원수,var_samp(jikwonpay) AS 분산 FROM jikwon WHERE busernum = 10;
SELECT COUNT(*) AS 인원수,var_samp(jikwonpay) AS 분산 FROM jikwon WHERE busernum = 20;
SELECT COUNT(*) AS 인원수,var_samp(jikwonpay) AS 분산 FROM jikwon WHERE busernum = 30;

