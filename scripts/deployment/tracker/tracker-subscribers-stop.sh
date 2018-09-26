#!/bin/bash
#delayed
curl -l localhost:7032/subscriber/delayed-sub/shutdown
#ping filtered subscriber ports [7024]
curl -l localhost:7024/subscriber/filtered/shutdown
#ping postback-ping subscriber ports [7023]
curl -l localhost:7023/subscriber/postback-ping/shutdown
#ping postback subscriber ports [7022]
curl -l localhost:7022/subscriber/postback/shutdown
#ping rotated subscriber ports [7021]
curl -l localhost:7021/subscriber/rotated/shutdown
#ping click subscriber ports [7010-7020]
curl -l localhost:7020/subscriber/click/shutdown
curl -l localhost:7019/subscriber/click/shutdown
curl -l localhost:7018/subscriber/click/shutdown
curl -l localhost:7017/subscriber/click/shutdown
curl -l localhost:7016/subscriber/click/shutdown
curl -l localhost:7015/subscriber/click/shutdown
curl -l localhost:7014/subscriber/click/shutdown
curl -l localhost:7013/subscriber/click/shutdown
curl -l localhost:7012/subscriber/click/shutdown
curl -l localhost:7011/subscriber/click/shutdown
curl -l localhost:7010/subscriber/click/shutdown
