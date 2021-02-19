" vim:fen:fdm=marker:nowrap:ts=2:

" --- w3c web color --- {{{
" #fffafa,Snow            #ffffff,White            #b0e0e6,PowderBlue         #228b22,ForestGreen
" #f8f8ff,GhostWhite      #000000,Black            #afeeee,PaleTurquoise      #6b8e23,OliveDrab
" #f5f5f5,WhiteSmoke      #2f4f4f,DarkSlateGray    #00ced1,DarkTurquoise      #bdb76b,DarkKhaki
" #dcdcdc,Gainsboro       #696969,DimGray          #48d1cc,MediumTurquoise    #f0e68c,Khaki
" #fffaf0,FloralWhite     #708090,SlateGray        #40e0d0,Turquoise          #eee8aa,PaleGoldenrod
" #fdf5e6,OldLace         #778899,LightSlateGray   #00ffff,Cyan               #fafad2,LightGoldenrodYellow
" #faf0e6,Linen           #bebebe,Gray             #e0ffff,LightCyan          #ffffe0,LightYellow
" #faebd7,AntiqueWhite    #d3d3d3,LightGray        #5f9ea0,CadetBlue          #ffff00,Yellow
" #ffefd5,PapayaWhip      #191970,MidnightBlue     #66cdaa,MediumAquamarine   #ffd700,Gold
" #ffebcd,BlanchedAlmond  #000080,Navy             #7fffd4,Aquamarine         #eedd82,LightGoldenrod
" #ffe4c4,Bisque          #6495ed,CornflowerBlue   #006400,DarkGreen          #daa520,Goldenrod
" #ffdab9,PeachPuff       #483d8b,DarkSlateBlue    #556b2f,DarkOliveGreen     #b8860b,DarkGoldenrod
" #ffdead,NavajoWhite     #6a5acd,SlateBlue        #8fbc8f,DarkSeaGreen       #bc8f8f,RosyBrown
" #ffe4b5,Moccasin        #7b68ee,MediumSlateBlue  #2e8b57,SeaGreen           #cd5c5c,IndianRed
" #fff8dc,Cornsilk        #8470ff,LightSlateBlue   #3cb371,MediumSeaGreen     #8b4513,SaddleBrown
" #fffff0,Ivory           #0000cd,MediumBlue       #20b2aa,LightSeaGreen      #a0522d,Sienna
" #fffacd,LemonChiffon    #4169e1,RoyalBlue        #98fb98,PaleGreen          #cd853f,Peru
" #fff5ee,Seashell        #0000ff,Blue             #00ff7f,SpringGreen        #deb887,Burlywood
" #f0fff0,Honeydew        #1e90ff,DodgerBlue       #7cfc00,LawnGreen          #f5f5dc,Beige
" #f5fffa,MintCream       #00bfff,DeepSkyBlue      #00ff00,Green              #f5deb3,Wheat
" #f0ffff,Azure           #87ceeb,SkyBlue          #7fff00,Chartreuse         #f4a460,SandyBrown
" #f0f8ff,AliceBlue       #87cefa,LightSkyBlue     #00fa9a,MediumSpringGreen  #d2b48c,Tan
" #e6e6fa,Lavender        #4682b4,SteelBlue        #adff2f,GreenYellow        #d2691e,Chocolate
" #fff0f5,LavenderBlush   #b0c4de,LightSteelBlue   #32cd32,LimeGreen          #b22222,Firebrick
" #ffe4e1,MistyRose       #add8e6,LightBlue        #9acd32,YellowGreen        #a52a2a,Brown

" #e9967a,DarkSalmon       #8a2be2,BlueViolet     #eecfa1,NavajoWhite2    #cdb7b5,MistyRose3
" #fa8072,Salmon           #a020f0,Purple         #cdb38b,NavajoWhite3    #8b7d7b,MistyRose4
" #ffa07a,LightSalmon      #9370db,MediumPurple   #8b795e,NavajoWhite4    #f0ffff,Azure1
" #ffa500,Orange           #d8bfd8,Thistle        #fffacd,LemonChiffon1   #e0eeee,Azure2
" #ff8c00,DarkOrange       #fffafa,Snow1          #eee9bf,LemonChiffon2   #c1cdcd,Azure3
" #ff7f50,Coral            #eee9e9,Snow2          #cdc9a5,LemonChiffon3   #838b8b,Azure4
" #f08080,LightCoral       #cdc9c9,Snow3          #8b8970,LemonChiffon4   #836fff,SlateBlue1
" #ff6347,Tomato           #8b8989,Snow4          #fff8dc,Cornsilk1       #7a67ee,SlateBlue2
" #ff4500,OrangeRed        #fff5ee,Seashell1      #eee8cd,Cornsilk2       #6959cd,SlateBlue3
" #ff0000,Red              #eee5de,Seashell2      #cdc8b1,Cornsilk3       #473c8b,SlateBlue4
" #ff69b4,HotPink          #cdc5bf,Seashell3      #8b8878,Cornsilk4       #4876ff,RoyalBlue1
" #ff1493,DeepPink         #8b8682,Seashell4      #fffff0,Ivory1          #436eee,RoyalBlue2
" #ffc0cb,Pink             #ffefdb,AntiqueWhite1  #eeeee0,Ivory2          #3a5fcd,RoyalBlue3
" #ffb6c1,LightPink        #eedfcc,AntiqueWhite2  #cdcdc1,Ivory3          #27408b,RoyalBlue4
" #db7093,PaleVioletRed    #cdc0b0,AntiqueWhite3  #8b8b83,Ivory4          #0000ff,Blue1
" #b03060,Maroon           #8b8378,AntiqueWhite4  #f0fff0,Honeydew1       #0000ee,Blue2
" #c71585,MediumVioletRed  #ffe4c4,Bisque1        #e0eee0,Honeydew2       #0000cd,Blue3
" #d02090,VioletRed        #eed5b7,Bisque2        #c1cdc1,Honeydew3       #00008b,Blue4
" #ff00ff,Magenta          #cdb79e,Bisque3        #838b83,Honeydew4       #1e90ff,DodgerBlue1
" #ee82ee,Violet           #8b7d6b,Bisque4        #fff0f5,LavenderBlush1  #1c86ee,DodgerBlue2
" #dda0dd,Plum             #ffdab9,PeachPuff1     #eee0e5,LavenderBlush2  #1874cd,DodgerBlue3
" #da70d6,Orchid           #eecbad,PeachPuff2     #cdc1c5,LavenderBlush3  #104e8b,DodgerBlue4
" #ba55d3,MediumOrchid     #cdaf95,PeachPuff3     #8b8386,LavenderBlush4  #63b8ff,SteelBlue1
" #9932cc,DarkOrchid       #8b7765,PeachPuff4     #ffe4e1,MistyRose1      #5cacee,SteelBlue2
" #9400d3,DarkViolet       #ffdead,NavajoWhite1   #eed5d2,MistyRose2      #4f94cd,SteelBlue3

" #36648b,SteelBlue4      #e0ffff,LightCyan1      #76eec6,Aquamarine2     #66cd00,Chartreuse3
" #00bfff,DeepSkyBlue1    #d1eeee,LightCyan2      #66cdaa,Aquamarine3     #458b00,Chartreuse4
" #00b2ee,DeepSkyBlue2    #b4cdcd,LightCyan3      #458b74,Aquamarine4     #c0ff3e,OliveDrab1
" #009acd,DeepSkyBlue3    #7a8b8b,LightCyan4      #c1ffc1,DarkSeaGreen1   #b3ee3a,OliveDrab2
" #00688b,DeepSkyBlue4    #bbffff,PaleTurquoise1  #b4eeb4,DarkSeaGreen2   #9acd32,OliveDrab3
" #87ceff,SkyBlue1        #aeeeee,PaleTurquoise2  #9bcd9b,DarkSeaGreen3   #698b22,OliveDrab4
" #7ec0ee,SkyBlue2        #96cdcd,PaleTurquoise3  #698b69,DarkSeaGreen4   #caff70,DarkOliveGreen1
" #6ca6cd,SkyBlue3        #668b8b,PaleTurquoise4  #54ff9f,SeaGreen1       #bcee68,DarkOliveGreen2
" #4a708b,SkyBlue4        #98f5ff,CadetBlue1      #4eee94,SeaGreen2       #a2cd5a,DarkOliveGreen3
" #b0e2ff,LightSkyBlue1   #8ee5ee,CadetBlue2      #43cd80,SeaGreen3       #6e8b3d,DarkOliveGreen4
" #a4d3ee,LightSkyBlue2   #7ac5cd,CadetBlue3      #2e8b57,SeaGreen4       #fff68f,Khaki1
" #8db6cd,LightSkyBlue3   #53868b,CadetBlue4      #9aff9a,PaleGreen1      #eee685,Khaki2
" #607b8b,LightSkyBlue4   #00f5ff,Turquoise1      #90ee90,PaleGreen2      #cdc673,Khaki3
" #c6e2ff,SlateGray1      #00e5ee,Turquoise2      #7ccd7c,PaleGreen3      #8b864e,Khaki4
" #b9d3ee,SlateGray2      #00c5cd,Turquoise3      #548b54,PaleGreen4      #ffec8b,LightGoldenrod1
" #9fb6cd,SlateGray3      #00868b,Turquoise4      #00ff7f,SpringGreen1    #eedc82,LightGoldenrod2
" #6c7b8b,SlateGray4      #00ffff,Cyan1           #00ee76,SpringGreen2    #cdbe70,LightGoldenrod3
" #cae1ff,LightSteelBlue1 #00eeee,Cyan2           #00cd66,SpringGreen3    #8b814c,LightGoldenrod4
" #bcd2ee,LightSteelBlue2 #00cdcd,Cyan3           #008b45,SpringGreen4    #ffffe0,LightYellow1
" #a2b5cd,LightSteelBlue3 #008b8b,Cyan4           #00ff00,Green1          #eeeed1,LightYellow2
" #6e7b8b,LightSteelBlue4 #97ffff,DarkSlateGray1  #00ee00,Green2          #cdcdb4,LightYellow3
" #bfefff,LightBlue1      #8deeee,DarkSlateGray2  #00cd00,Green3          #8b8b7a,LightYellow4
" #b2dfee,LightBlue2      #79cdcd,DarkSlateGray3  #008b00,Green4          #ffff00,Yellow1
" #9ac0cd,LightBlue3      #528b8b,DarkSlateGray4  #7fff00,Chartreuse1     #eeee00,Yellow2
" #68838b,LightBlue4      #7fffd4,Aquamarine1     #76ee00,Chartreuse2     #cdcd00,Yellow3

" #8b8b00,Yellow4         #ffd39b,Burlywood1  #ee8262,Salmon2       #cd3700,OrangeRed3
" #ffd700,Gold1           #eec591,Burlywood2  #cd7054,Salmon3       #8b2500,OrangeRed4
" #eec900,Gold2           #cdaa7d,Burlywood3  #8b4c39,Salmon4       #ff0000,Red1
" #cdad00,Gold3           #8b7355,Burlywood4  #ffa07a,LightSalmon1  #ee0000,Red2
" #8b7500,Gold4           #ffe7ba,Wheat1      #ee9572,LightSalmon2  #cd0000,Red3
" #ffc125,Goldenrod1      #eed8ae,Wheat2      #cd8162,LightSalmon3  #8b0000,Red4
" #eeb422,Goldenrod2      #cdba96,Wheat3      #8b5742,LightSalmon4  #ff1493,DeepPink1
" #cd9b1d,Goldenrod3      #8b7e66,Wheat4      #ffa500,Orange1       #ee1289,DeepPink2
" #8b6914,Goldenrod4      #ffa54f,Tan1        #ee9a00,Orange2       #cd1076,DeepPink3
" #ffb90f,DarkGoldenrod1  #ee9a49,Tan2        #cd8500,Orange3       #8b0a50,DeepPink4
" #eead0e,DarkGoldenrod2  #cd853f,Tan3        #8b5a00,Orange4       #ff6eb4,HotPink1
" #cd950c,DarkGoldenrod3  #8b5a2b,Tan4        #ff7f00,DarkOrange1   #ee6aa7,HotPink2
" #8b6508,DarkGoldenrod4  #ff7f24,Chocolate1  #ee7600,DarkOrange2   #cd6090,HotPink3
" #ffc1c1,RosyBrown1      #ee7621,Chocolate2  #cd6600,DarkOrange3   #8b3a62,HotPink4
" #eeb4b4,RosyBrown2      #cd661d,Chocolate3  #8b4500,DarkOrange4   #ffb5c5,Pink1
" #cd9b9b,RosyBrown3      #8b4513,Chocolate4  #ff7256,Coral1        #eea9b8,Pink2
" #8b6969,RosyBrown4      #ff3030,Firebrick1  #ee6a50,Coral2        #cd919e,Pink3
" #ff6a6a,IndianRed1      #ee2c2c,Firebrick2  #cd5b45,Coral3        #8b636c,Pink4
" #ee6363,IndianRed2      #cd2626,Firebrick3  #8b3e2f,Coral4        #ffaeb9,LightPink1
" #cd5555,IndianRed3      #8b1a1a,Firebrick4  #ff6347,Tomato1       #eea2ad,LightPink2
" #8b3a3a,IndianRed4      #ff4040,Brown1      #ee5c42,Tomato2       #cd8c95,LightPink3
" #ff8247,Sienna1         #ee3b3b,Brown2      #cd4f39,Tomato3       #8b5f65,LightPink4
" #ee7942,Sienna2         #cd3333,Brown3      #8b3626,Tomato4       #ff82ab,PaleVioletRed1
" #cd6839,Sienna3         #8b2323,Brown4      #ff4500,OrangeRed1    #ee799f,PaleVioletRed2
" #8b4726,Sienna4         #ff8c69,Salmon1     #ee4000,OrangeRed2    #cd6889,PaleVioletRed3

" #8b475d,PaleVioletRed4  #bf3eff,DarkOrchid1    #171717,Gray9    #575757,Gray34
" #ff34b3,Maroon1         #b23aee,DarkOrchid2    #1a1a1a,Gray10   #595959,Gray35
" #ee30a7,Maroon2         #9a32cd,DarkOrchid3    #1c1c1c,Gray11   #5c5c5c,Gray36
" #cd2990,Maroon3         #68228b,DarkOrchid4    #1f1f1f,Gray12   #5e5e5e,Gray37
" #8b1c62,Maroon4         #9b30ff,Purple1        #212121,Gray13   #616161,Gray38
" #ff3e96,VioletRed1      #912cee,Purple2        #242424,Gray14   #636363,Gray39
" #ee3a8c,VioletRed2      #7d26cd,Purple3        #262626,Gray15   #666666,Gray40
" #cd3278,VioletRed3      #551a8b,Purple4        #292929,Gray16   #696969,Gray41
" #8b2252,VioletRed4      #ab82ff,MediumPurple1  #2b2b2b,Gray17   #6b6b6b,Gray42
" #ff00ff,Magenta1        #9f79ee,MediumPurple2  #2e2e2e,Gray18   #6e6e6e,Gray43
" #ee00ee,Magenta2        #8968cd,MediumPurple3  #303030,Gray19   #707070,Gray44
" #cd00cd,Magenta3        #5d478b,MediumPurple4  #333333,Gray20   #737373,Gray45
" #8b008b,Magenta4        #ffe1ff,Thistle1       #363636,Gray21   #757575,Gray46
" #ff83fa,Orchid1         #eed2ee,Thistle2       #383838,Gray22   #787878,Gray47
" #ee7ae9,Orchid2         #cdb5cd,Thistle3       #3b3b3b,Gray23   #7a7a7a,Gray48
" #cd69c9,Orchid3         #8b7b8b,Thistle4       #3d3d3d,Gray24   #7d7d7d,Gray49
" #8b4789,Orchid4         #000000,Gray0          #404040,Gray25   #7f7f7f,Gray50
" #ffbbff,Plum1           #030303,Gray1          #424242,Gray26   #828282,Gray51
" #eeaeee,Plum2           #050505,Gray2          #454545,Gray27   #858585,Gray52
" #cd96cd,Plum3           #080808,Gray3          #474747,Gray28   #878787,Gray53
" #8b668b,Plum4           #0a0a0a,Gray4          #4a4a4a,Gray29   #8a8a8a,Gray54
" #e066ff,MediumOrchid1   #0d0d0d,Gray5          #4d4d4d,Gray30   #8c8c8c,Gray55
" #d15fee,MediumOrchid2   #0f0f0f,Gray6          #4f4f4f,Gray31   #8f8f8f,Gray56
" #b452cd,MediumOrchid3   #121212,Gray7          #525252,Gray32   #919191,Gray57
" #7a378b,MediumOrchid4   #141414,Gray8          #545454,Gray33   #949494,Gray58

" #969696,Gray59  #d6d6d6,Gray84
" #999999,Gray60  #d9d9d9,Gray85
" #9c9c9c,Gray61  #dbdbdb,Gray86
" #9e9e9e,Gray62  #dedede,Gray87
" #a1a1a1,Gray63  #e0e0e0,Gray88
" #a3a3a3,Gray64  #e3e3e3,Gray89
" #a6a6a6,Gray65  #e5e5e5,Gray90
" #a8a8a8,Gray66  #e8e8e8,Gray91
" #ababab,Gray67  #ebebeb,Gray92
" #adadad,Gray68  #ededed,Gray93
" #b0b0b0,Gray69  #f0f0f0,Gray94
" #b3b3b3,Gray70  #f2f2f2,Gray95
" #b5b5b5,Gray71  #f5f5f5,Gray96
" #b8b8b8,Gray72  #f7f7f7,Gray97
" #bababa,Gray73  #fafafa,Gray98
" #bdbdbd,Gray74  #fcfcfc,Gray99
" #bfbfbf,Gray75  #ffffff,Gray100
" #c2c2c2,Gray76  #a9a9a9,DarkGray
" #c4c4c4,Gray77  #00008b,DarkBlue
" #c7c7c7,Gray78  #008b8b,DarkCyan
" #c9c9c9,Gray79  #8b008b,DarkMagenta
" #cccccc,Gray80  #8b0000,DarkRed
" #cfcfcf,Gray81  #90ee90,LightGreen
" #d1d1d1,Gray82
" #d4d4d4,Gray83
" }}}

" --- Xterm 256 color ---{{{
" #000000,000 #ce0000,001 #00cb00,002 #cecb00,003 #0000ef,004 #ce00ce,005 #00cbce,006 #e7e3e7,007 #7b7d7b,008 #ff0000,009
" #00ff00,010 #ffff00,011 #5a5dff,012 #ff00ff,013 #00ffff,014 #ffffff,015 #000000,016 #00005f,017 #000087,018 #0000af,019
" #0000d7,020 #0000ff,021 #005f00,022 #005f5f,023 #005f87,024 #005faf,025 #005fd7,026 #005fff,027 #008700,028 #00875f,029
" #008787,030 #0087af,031 #0087d7,032 #0087ff,033 #00af00,034 #00af5f,035 #00af87,036 #00afaf,037 #00afd7,038 #00afff,039
" #00d700,040 #00d75f,041 #00d787,042 #00d7af,043 #00d7d7,044 #00d7ff,045 #00ff00,046 #00ff5f,047 #00ff87,048 #00ffaf,049
" #00ffd7,050 #00ffff,051 #5f0000,052 #5f005f,053 #5f0087,054 #5f00af,055 #5f00d7,056 #5f00ff,057 #5f5f00,058 #5f5f5f,059
" #5f5f87,060 #5f5faf,061 #5f5fd7,062 #5f8700,064 #5f875f,065 #5f8787,066 #5f5fff,063 #5f87af,067 #5f87d7,068 #5f87ff,069
" #5faf00,070 #5faf5f,071 #5faf87,072 #5fafaf,073 #5fafd7,074 #5fafff,075 #5fd700,076 #5fd75f,077 #5fd787,078 #5fd7af,079
" #5fd7d7,080 #5fd7ff,081 #5fff00,082 #5fff5f,083 #5fff87,084 #5fffaf,085 #5fffd7,086 #5fffff,087 #870000,088 #87005f,089
" #870087,090 #8700af,091 #8700d7,092 #8700ff,093 #875f00,094 #875f5f,095 #875f87,096 #875faf,097 #875fd7,098 #875fff,099
" #878700,100 #87875f,101 #878787,102 #8787af,103 #8787d7,104 #8787ff,105 #87af00,106 #87af5f,107 #87af87,108 #87afaf,109
" #87afd7,110 #87afff,111 #87d700,112 #87d75f,113 #87d787,114 #87d7af,115 #87d7d7,116 #87d7ff,117 #87ff00,118 #87ff5f,119
" #87ff87,120 #87ffaf,121 #87ffd7,122 #87ffff,123 #af0000,124 #af005f,125 #af0087,126 #af00af,127 #af00d7,128 #af00ff,129
" #af5f00,130 #af5f5f,131 #af5f87,132 #af5faf,133 #af5fd7,134 #af5fff,135 #af8700,136 #af875f,137 #af8787,138 #af87af,139
" #af87d7,140 #af87ff,141 #afaf00,142 #afaf5f,143 #afaf87,144 #afafaf,145 #afafd7,146 #afafff,147 #afd700,148 #afd75f,149
" #afd787,150 #afd7af,151 #afd7d7,152 #afd7ff,153 #afff00,154 #afff5f,155 #afff87,156 #afffaf,157 #afffd7,158 #afffff,159
" #d70000,160 #d7005f,161 #d70087,162 #d700af,163 #d700d7,164 #d700ff,165 #d75f00,166 #d75f5f,167 #d75f87,168 #d75faf,169
" #d75fd7,170 #d75fff,171 #d78700,172 #d7875f,173 #d78787,174 #d787af,175 #d787d7,176 #d787ff,177 #d7af00,178 #d7af5f,179
" #d7af87,180 #d7afaf,181 #d7afd7,182 #d7afff,183 #d7d700,184 #d7d75f,185 #d7d787,186 #d7d7af,187 #d7d7d7,188 #d7d7ff,189
" #d7ff00,190 #d7ff5f,191 #d7ff87,192 #d7ffaf,193 #d7ffd7,194 #d7ffff,195 #ff0000,196 #ff005f,197 #ff0087,198 #ff00af,199
" #ff00d7,200 #ff00ff,201 #ff5f00,202 #ff5f5f,203 #ff5f87,204 #ff5faf,205 #ff5fd7,206 #ff5fff,207 #ff8700,208 #ff875f,209
" #ff8787,210 #ff87af,211 #ff87d7,212 #ff87ff,213 #ffaf00,214 #ffaf5f,215 #ffaf87,216 #ffafaf,217 #ffafd7,218 #ffafff,219
" #ffd700,220 #ffd75f,221 #ffd787,222 #ffd7af,223 #ffd7d7,224 #ffd7ff,225 #ffff00,226 #ffff5f,227 #ffff87,228 #ffffaf,229
" #ffffd7,230 #ffffff,231 #080808,232 #121212,233 #1c1c1c,234 #262626,235 #303030,236 #3a3a3a,237 #444444,238 #4e4e4e,239
" #585858,240 #626262,241 #6c6c6c,242 #767676,243 #808080,244 #8a8a8a,245 #949494,246 #9e9e9e,247 #a8a8a8,248 #b2b2b2,249
" #bcbcbc,250 #c6c6c6,251 #d0d0d0,252 #dadada,253 #e4e4e4,254 #eeeeee,255 }}}

" --- cterm-colors available on most systems ---{{{
" Black    DarkBlue DarkGreen    DarkCyan DarkRed     DarkMagenta Brown      DarkYellow LightGray LightGrey Gray
" Grey     DarkGray DarkGrey     Blue     LightBlue   Green       LightGreen Cyan       LightCyan Red
" LightRed Magenta  LightMagenta Yellow   LightYellow White       }}}

" Test : #346712 #784310 #ff0000
"
let s:higroup_prefix = 'ColorTable'
let s:hex_pat = '#\x\{6}'
"does current vim support 24-bit color ?
let s:true_color = v:false
if has('gui_running')
  let s:true_color = v:true
elseif has('termguicolors')
  set termguicolors
  let s:true_color = v:true
endif

for line in filter(getline(line(1),line('$')), 'v:val =~ s:hex_pat')
"for line in filter(getline(line('w0'),line('w$')), 'v:val =~ s:hex_pat')
  let cnt = 1
  let mat = matchstr(line, s:hex_pat, 0, cnt)
  while !empty(mat)
    let hlgroup_name = s:higroup_prefix.mat[1:]
    " echo hlgroup_name
    let rgb_list=[]
    let rgb_list+=[printf("%d", "0x".mat[1:2])]
    let rgb_list+=[printf("%d", "0x".mat[3:4])]
    let rgb_list+=[printf("%d", "0x".mat[5:6])]
    let guifg = (max(rgb_list)+min(rgb_list))/510.0>=0.4?"black":"white"
    if !s:true_color
      " use nearest 8bit color for term
      let ctermbg = rgb_list[0]*8/256 . rgb_list[1]*8/256 . rgb_list[2]*8/256
      exe 'hi '.hlgroup_name.' ctermfg='.guifg.' ctermbg='.mat
    else
      exe 'hi '.hlgroup_name.' guifg='.guifg.' guibg='.mat
    endif
    call matchadd(hlgroup_name,mat)
    let cnt += 1
    let mat = matchstr(line, s:hex_pat, 0, cnt)
  endwhile
endfor
