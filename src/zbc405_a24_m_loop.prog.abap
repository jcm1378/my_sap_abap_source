*&---------------------------------------------------------------------*
*& Report ZBC405_A24_M_LOOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a24_m_loop.

*ztsa2001

*/---- TOP
TYPES : BEGIN OF ts_emp,

  pernr TYPE ztsa2001-pernr,
  ename TYPE ztsa2001-ename,
  depid TYPE ztsa2001-depid,
  gender TYPE ztsa2001-gender,
  gender_t TYPE c LENGTH 10, "내가 추가할 gender_text.
  phone TYPE ztsa2002-phone,

  END OF ts_emp.

  DATA : gs_emp TYPE ts_emp,
        gt_emp LIKE TABLE OF gs_emp,
        gs_dep TYPE ztsa2002, "type 뒤에 테이블 적어도 스트럭쳐가 됨
        gt_dep LIKE TABLE OF gs_dep.

*  " 단 하나의 데이터를 가져올때
*  select SINGLE pernr ename depid gender
*    FROM ztsa2001
*    into  gs_emp    "into에 괄호를 넣으면 쿼레스펀딩 처럼 찾아서 들어간다
*    where pernr = '20220001'.
*
*    write : '사원명 : ', gs_emp-pernr.
*    new-LINE.
*    write : 'ENAME : ', gs_emp-ename.
*    new-line.
*    write : '부서코드 : ' , gs_emp-depid.
*    write : /'성별' , gs_emp-gender.


* Table을 가져올때!

SELECT *
  FROM ztsa2001
  INTO CORRESPONDING FIELDS OF TABLE gt_emp. "이걸 쓸때는 DBtable과 internal table의  field명이 같아야 들어온다 이게 존나 중요함.

  "if문과 case문의 차이
  "if의 조건에는 연산, 과 범위로 조건을 줄 수 있지만
  "case문은 1:1 대응 이영야 한다!


*  loop at gt_emp into gs_emp.
**    gs_emp를 바꾸는 로직
*    case gs_emp-gender.
*      WHEN '1'.
*        gs_emp-gender_t = '남자'.
*      when '2'.
*        gs_emp-gender_t = '여자'.
*    ENDCASE.
*
*  "Loop를 탈때마다 DATA BASE에 접근을 해벌인다. ---- 01
*    select SINGLE phone
*      from ztsa2002
*      into CORRESPONDING FIELDS OF gs_emp
*      where depid = gs_emp-depid.
*
*    MODIFY gt_emp from gs_emp.
*    endloop.

  "그래서 애초에 데이터 베이스에서 dep-table을 다 긁어와서 read table로 loop를 돌아벌여 ---- 01
    SELECT *
    FROM ztsa2002
    INTO CORRESPONDING FIELDS OF TABLE gt_dep
    WHERE depid BETWEEN 'D001' AND 'D003'.

    LOOP AT gt_emp INTO gs_emp.

      case gs_emp-gender.
      WHEN '1'.
        gs_emp-gender_t = '남자'.
      when '2'.
        gs_emp-gender_t = '여자'.
    ENDCASE.

     "gs_emp
      READ TABLE gt_dep INTO gs_dep
      WITH KEY depid = gs_emp-depid.

      gs_emp-phone = gs_dep-phone.

      MODIFY gt_emp FROM gs_emp.
      CLEAR : gs_emp ,gs_dep.
      ENDLOOP.


      "//---- 상욱 code
*      DATA: lt_emp TYPE TABLE OF ts_emp.
*
*lt_emp = gt_emp.
*
*SORT lt_emp BY depid.
*DELETE ADJACENT DUPLICATES FROM lt_emp COMPARING depid.
*cl_demo_output=>display_data( lt_emp ).
*SELECT *
*  FROM ztsa2002
*  INTO CORRESPONDING FIELDS OF TABLE gt_dep
*  FOR ALL ENTRIES IN lt_emp
*  WHERE depid = lt_emp-depid.
*
*
*CLEAR gs_emp.
*LOOP AT gt_emp INTO gs_emp.
*  READ TABLE gt_dep INTO gs_dep WITH KEY depid = gs_emp-depid.
*  gs_emp-phone = gs_dep-phone.
*  MODIFY gt_emp FROM gs_emp.
*  CLEAR: gs_dep.
*ENDLOOP.
*CLEAR gs_emp.

  cl_demo_output=>display_data( gt_emp ).
