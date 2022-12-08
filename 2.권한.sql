/*
    mysql.sys@localhost : sys 스키마의 객체(View, Procedure) 사용 계정
    mysql.session@localhost : 서버로 접근할때 사용하는 계정
    mysql.infoschema@localhost : information_schema 정의된 뷰 접근 계정
*/

-- 계정 생성
-- 계정 인증방식은 4가지가 존재한다 -> 어렵 일단 Native_Authentication 방식을 주로 사용
-- set global default_authentication_plugin="mysql_native_password"
create user 'test_dk'@'%'
	identified with 'mysql_native_password' by 'password' -- 인증 방식
    require none -- 암호화된 SSL/TLS 채널을 사용할지의 여부
    password expire interval 30 day 
    account unlock
    password history default -- 한번 사용했던 비밀번호 재사용 여부
    password reuse interval default -- 한번 사용했던 비밀번호의 재사용 금지 기간설정
    password require current default; -- 비밀번호 갱신시 이전 비밀번호가 필요한가?

-- 해당 계정의 권한 보기
show grants;

-- 권한은 좀더 읽어봐야 할듯 하다. 어렵스