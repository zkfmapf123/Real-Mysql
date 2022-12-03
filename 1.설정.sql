-- 설치 부분은 Skip

-- Global 변수
show global variables;

/*
글로벌 변수 vs 세션 변수

글로벌 변수 : 하나의 MYSQL 인스턴스에 영향을 미치는 시스템 변수 (주로 서버자체 설정)
세션 변수 : MYSQL 서버에 접속할때 기본으로 부여하는 옵션의 기본 값 (주로 my.cnf, my.ini 위치)
*/

show global variables '%max%';

/*
    시스템 변수의 설정 변경
    SET 명령어를 통한 설정 변경은 해당 설정파일(my.cnf) 저장되는 것이 아니기 때문에, 일시적으로 반영
    영구적인 변경을 위해선 -> my.cnf 변경을 해야함
*/

/*
    in Docker
    find / -name 'my.cnf'
*/

set global max_connections=500;             -- 일시적 반영 my.cnf
set persist max_connections=5000;           -- 현재반영 + 재시작에도 반영 my.cnf + mysqld-auto.cnf
set persist_only max_connections=5000;      -- 재시작에 반영 my.cnf + mysqld-auto.cnf

/*
    SET은 일시적인 수정이기때문에, 서버가 다시 동작하면 원래 값으로 돌아간다 (이슈..)
    해당 이슈를 극복하기 위해서, persist 명령을 도입한다.
    mysqld-auto.cnf 파일에 해당 변수의 값을 기록한 후, 다시 서버가 동작하면 추가로 이 파일을 참조하여
    수정된 값을 참조한다. (서버 재시작에도 수정된 값을 적용하기 위함...)
*/

/*
    find / -name 'mysqld-auto.cnf'
    ex) {"Version": 2, "mysql_dynamic_parse_early_variables": {"max_connections": {"Value": "800", "Metadata": {"Host": "", "User": "root", "Timestamp": 1670083820174685}}}}
*/
select 
a.variable_name,
b.variable_value,
a.set_time,
a.set_user,
a.set_host
from performance_schema.variables_info a
inner join
performance_schema.persisted_variables b
on 
a.variable_name=b.variable_name