
===============================================================================

error @errornumber:
  your node @reason in the current nodelist on my system (@ndlname)
@end

;
; Здесь задаются сообщения, выводимые вместо темплейта @reason в зависимости
; от статуса обpабатываемого узла в текущем нодлисте.
;

REASON is absent         ;   TAbs    = 0; { Узел, отсутствующий в нодлисте }
REASON has normal status ;   TNormal = 1; { Обычный узел }
REASON has Down prefix   ;   TDown   = 2; { Узел с префиксом Down }
REASON has Hold prefix   ;   THold   = 3; { Узел с префиксом Hold }
REASON has Hub prefix    ;   THub    = 4; { Узел с префиксом Hub }
REASON has Pvt prefix    ;   TPvt    = 5; { Узел с префиксом Pvt }

