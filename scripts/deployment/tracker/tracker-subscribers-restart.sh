#!/bin/bash
curl -l localhost:7032/subscriber/delayed-sub/restart
#ping filtered subscriber ports [7024]
curl -l localhost:7024/subscriber/filtered/restart
#ping postback-ping subscriber ports [7023]
curl -l localhost:7023/subscriber/postback-ping/restart
#ping postback subscriber ports [7022]
curl -l localhost:7022/subscriber/postback/restart
#ping rotated subscriber ports [7021]
curl -l localhost:7021/subscriber/rotated/restart
#ping click subscriber ports [7010-7020]
curl -l localhost:7020/subscriber/click/restart
curl -l localhost:7019/subscriber/click/restart
curl -l localhost:7018/subscriber/click/restart
curl -l localhost:7017/subscriber/click/restart
curl -l localhost:7016/subscriber/click/restart
curl -l localhost:7015/subscriber/click/restart
curl -l localhost:7014/subscriber/click/restart
curl -l localhost:7013/subscriber/click/restart
curl -l localhost:7012/subscriber/click/restart
curl -l localhost:7011/subscriber/click/restart
curl -l localhost:7010/subscriber/click/restart
