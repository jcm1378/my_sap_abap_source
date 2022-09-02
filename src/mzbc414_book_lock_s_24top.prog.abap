*&---------------------------------------------------------------------*
*& Include MBC414_BOOK_LOCK_STOP
*&---------------------------------------------------------------------*

PROGRAM sapmbc414_book_lock_s MESSAGE-ID bc414.

* ***************************** TYPES **********************************
TYPES BEGIN OF gty_s_bookings.
        INCLUDE TYPE sbook.
TYPES   name TYPE s_custname.
TYPES   mark TYPE c LENGTH 1.
TYPES END OF gty_s_bookings.

TYPES gty_t_bookings TYPE STANDARD TABLE OF gty_s_bookings
                     WITH NON-UNIQUE DEFAULT KEY.
TYPES gty_t_cd       TYPE STANDARD TABLE OF sbook
                     WITH NON-UNIQUE KEY carrid connid fldate bookid customid.
TYPES gty_t_sbook    TYPE STANDARD TABLE OF sbook
                     WITH NON-UNIQUE DEFAULT KEY.
*
* ***************************** VARIABLES *******************************
* transporting fields to/from screen
TABLES: sdyn_conn, sdyn_book.

* work area and internal table used to display bookings in table control
DATA gs_bookings TYPE gty_s_bookings.
DATA gt_bookings TYPE gty_t_bookings.

* bookings to be modified on database table
DATA gt_bookings_mod TYPE gty_t_sbook.
* change documents: bookings before changes are performed
DATA gt_cd TYPE gty_t_cd.

* transport function codes from screens
DATA ok_code TYPE sy-ucomm.
* define subscreen screen number on tabstrip, screen 300
DATA gv_screen_no TYPE sy-dynnr.

* flags
DATA gv_read_bookings TYPE c.
DATA gv_init_booking  TYPE c.

*
* ***************************** CONTROLS ********************************
* table control declaration (display bookings),
CONTROLS tc_sbook TYPE TABLEVIEW USING SCREEN '0200'.
* tabstrip declaration (create booking)
CONTROLS tab      TYPE TABSTRIP.
