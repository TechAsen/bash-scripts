#!/bin/bash

echo " Starting Zabbix MySQL cleanup..."

sudo mysql <<'EOF'
USE zabbix;

DELIMITER //

CREATE PROCEDURE delete_history_uint()
BEGIN
  DECLARE rows_deleted INT DEFAULT 1;
  WHILE rows_deleted > 0 DO
    DELETE FROM history_uint
    WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 7 DAY))
    LIMIT 50000;
    SET rows_deleted = ROW_COUNT();
  END WHILE;
END;
//

CREATE PROCEDURE delete_history_str()
BEGIN
  DECLARE rows_deleted INT DEFAULT 1;
  WHILE rows_deleted > 0 DO
    DELETE FROM history_str
    WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 7 DAY))
    LIMIT 50000;
    SET rows_deleted = ROW_COUNT();
  END WHILE;
END;
//

CREATE PROCEDURE delete_history_text()
BEGIN
  DECLARE rows_deleted INT DEFAULT 1;
  WHILE rows_deleted > 0 DO
    DELETE FROM history_text
    WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 7 DAY))
    LIMIT 50000;
    SET rows_deleted = ROW_COUNT();
  END WHILE;
END;
//

CREATE PROCEDURE delete_history_log()
BEGIN
  DECLARE rows_deleted INT DEFAULT 1;
  WHILE rows_deleted > 0 DO
    DELETE FROM history_log
    WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 7 DAY))
    LIMIT 50000;
    SET rows_deleted = ROW_COUNT();
  END WHILE;
END;
//

DELIMITER ;

CALL delete_history_uint();
CALL delete_history_str();
CALL delete_history_text();
CALL delete_history_log();

DROP PROCEDURE delete_history_uint;
DROP PROCEDURE delete_history_str;
DROP PROCEDURE delete_history_text;
DROP PROCEDURE delete_history_log;

OPTIMIZE TABLE history_uint;
OPTIMIZE TABLE history_str;
OPTIMIZE TABLE history_text;
OPTIMIZE TABLE history_log;
EOF

echo " Zabbix MySQL cleanup completed."
