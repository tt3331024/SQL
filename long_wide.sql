/*
將資料從long format 轉換成 wide format

TALBE TEST_LONG
---------------------               ------------------------
| ID | ITEM | SCORE |               | ID | ITEM_A | ITEM_B |
---------------------       \       ------------------------
| 1  |  A   |  72   |     ---\      | 1  |   72   |   81   |
| 1  |  B   |  81   |     ---/      | 2  |   85   |   89   |
| 2  |  A   |  85   |       /       | 3  |   79   |   93   |
| 2  |  B   |  89   |               ------------------------
| 3  |  A   |  79   |               
| 3  |  B   |  93   |               
---------------------               
*/
-- 1. 先使用IF判斷式找出ITEM為A的資料，並取出SCORE，如果不是A，則等於0。ITEM為B的資料亦同。
-- 2. 之後再透過子查詢的方式，以GROUP BY的方式加總ITEM_A、ITEM_B等欄位即可。

SELECT ID, SUM(ITEM_A) AS ITEM_A, SUM(ITEM_B) AS ITEM_B
FROM (SELECT ID, IF(ITEM = 'A', SCORE, 0) AS ITEM_A, IF(ITEM = 'B', SCORE, 0) AS ITEM_B
      FROM  TEST_LONG) L
GROUP BY ID
;




/*
將資料從 wide format 轉換成 long format

TALBE TEST_WIDE
------------------------               ---------------------
| ID | ITEM_A | ITEM_B |               | ID | ITEM | SCORE |
------------------------       \       ---------------------
| 1  |   72   |   81   |     ---\      | 1  |  A   |  72   |
| 2  |   85   |   89   |     ---/      | 1  |  B   |  81   |
| 3  |   79   |   93   |       /       | 2  |  A   |  85   |              
------------------------               | 2  |  B   |  89   |
                                       | 3  |  A   |  79   |
                                       | 3  |  B   |  93   |
                                       ---------------------
*/
-- 1. 先SELECT ITEM_A的分數，並創建ITEM欄位，其值都為"A"。ITEM_B的資料亦同。
-- 2. 使用UNION將ITEM_A的SELECT和ITEM_B的SELECT合併，最後一ID排序即可。


SELECT ID, 'A' AS ITEM, ITEM_A AS SCORE
FROM TEST_WIDE
UNION
SELECT ID, 'B' AS ITEM, ITEM_B AS SCORE
FROM TEST_WIDE
ORDER BY ID
;