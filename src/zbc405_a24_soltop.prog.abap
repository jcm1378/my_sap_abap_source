*&---------------------------------------------------------------------*
*& Include ZBC405_A24_SOLTOP                        - Report ZBC405_A24_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a24_sol.

DATA: gs_glight TYPE dv_flights.


PARAMETERS: p_car TYPE dv_flight-carrid
                       MEMORY ID car
                       OBLIGATORY "값을 입력하지 않으면 진행되지 않도록 필수값 지정
                       DEFAULT 'LH' " 초기값 설정
                       VALUE CHECK. " Check 필드가 Check table에 체크안에 없는 값이면 에러처리,
                                    " 파라미터의 타입안에 테이블 타입이여야 가능함. 데이터 엘리먼트 타입은 불가능.



" MODIF ID Screen
" Lower Case. "소문자 입력데이터 저장
" MODIF ID -> MODIFY ID Screen을 입력 가능 여부나, 안보이게하거나 설정할 수 있는데 설정할때에
" MODIF에 설정한 ID를 가지고 사용한다 이 옵션 사용하기 위해서는 INITALIZATION(이벤트 설정 이 필요함).

PARAMETERS p_str TYPE string LOWER CASE
                             MODIF ID mod.

"Check box Button
PARAMETERS p_chk AS CHECKBOX DEFAULT 'X' " 체크박스 버튼
                              MODIF ID mod.

"Radio Button
PARAMETERS : p_rad1 RADIOBUTTON GROUP rd1, "RadioButton 그룹으로 묶어줌 rd1은 그룹이름
             p_rad2 RADIOBUTTON GROUP rd1, "
             p_rad3 RADIOBUTTON GROUP rd1.

"select-optins 하나의 Entry가 있는 Internal Table
select-options : s_fldate for dv_flights-fladate.


"Radio Button 사용할때
CASE 'X'.
  WHEN p_rad1.

  WHEN p_rad2.

  WHEN p_rad3.

ENDCASE.





*set Parameter id 'z01' field p_car.
*get PARAMETER ID 'z02' field p_car.
