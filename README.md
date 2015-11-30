

有人加入房间的通知
<presence xmlns="jabber:client" from="128@muc.gzserver-pc/g0000000101" to="g0000000102@gzserver-pc/iphone"><x xmlns="http://jabber.org/protocol/muc#user"><item affiliation="none" role="participant" nick="g0000000101" jid="g0000000101@gzserver-pc/iphone"/></x></presence>

有人退出房间的通知
<presence xmlns="jabber:client" to="g0000000102@gzserver-pc/iphone" type="unavailable" from="128@muc.gzserver-pc/g0000000101"><x xmlns="http://jabber.org/protocol/muc#user"><item affiliation="none" role="participant" nick="g0000000101" jid="g0000000101@gzserver-pc/iphone"/></x></presence>

朋友登出的通知
<presence xmlns="jabber:client" type="unavailable" from="g0000000101@gzserver-pc/iphone" to="g0000000102@gzserver-pc”/>

有人登陆的通知
<presence xmlns="jabber:client" to="g0000000102@gzserver-pc" from="g0000000101@gzserver-pc/iphone"/>
