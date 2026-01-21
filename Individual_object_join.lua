--[[
装飾セット.anm2などで使う用の.luaファイル。
個別オブジェクトを１つの単一のオブジェクトにするための処理を行っている。
rikky氏の「テキスト一体化」スクリプトのようなことを簡易的に行っている。
他の所でも使いまわしをする予定があるので、.luaファイルに個別にまとめている。

このファイルを皆様の使用するスクリプトと同等のファイルに配置し、そのコード内で、

if(require("Individual_object_join")) then
    Individual_object_join()
end

と記述すれば他のスクリプトでも使用することができます。
]]
function Individual_object_join()
    if(obj.index == 0) then -- indexが0のときだけ(1文字目の時だけ)実行する。
        obj.setoption("drawtarget","tempbuffer",obj.screen_w,obj.screen_h) -- 仮想バッファを新規に作成。
    end

    obj.setoption("drawtarget","tempbuffer")  --  if内の仮想バッファは1回目のみなので、2回目以降はifの外で、初期化せずに作成。

    local scale = obj.sx * obj.sy * obj.sz -- obj.sx,obj.sy,obj.sz,はx,y,zの拡大率であり、Aviutl2から実装されたようだ。このscaleを拡大率とする。
    local alpha = obj.getvalue("alpha") -- alpha変数があった方がコードが見やすいと思ったので、ここの記述は必要はないが作っておく。

    obj.draw(obj.ox,obj.oy,obj.oz,scale,alpha,obj.rx,obj.ry,obj.rz) -- 拡大率はscaleに1つにまとめて引数として渡す。

    obj.alpha = 0 -- このままだと仮想バッファに描画したオブジェクトと、手持ちのobj.にあるオブジェクトが2重で存在する事になるため、手持ちのobj.のオブジェクトを透明にする。

    if (obj.index == obj.num - 1) then -- indexが-1のときだけ(最後の文字の時だけ)実行する処理。最後のオブジェクトはこの部分に来る前のobj.drawですでに仮想バッファに描画されている。
        obj.setoption("drawtarget","framebuffer") -- 描画先をフレームバッファに戻す。
        obj.load("tempbuffer")  -- ここまでに作成した仮想バッファを読み込む。
        obj.clearbuffer("tempbuffer") -- 仮想バッファをクリア。仮想バッファは共有らしいので念のために消去。
    end
end