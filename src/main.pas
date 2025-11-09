unit main;

interface
{$ifdef gui4} {$define gui3} {$define gamecore}{$endif}
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define bmp} {$define ico} {$define gif} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define bmp} {$define ico} {$define gif} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, {$ifdef gui}gossgui,{$endif} {$ifdef snd}gosssnd,{$endif} gosswin, gossio, gossimg, gossnet;
{$align on}{$iochecks on}{$O+}{$W-}{$U+}{$V+}{$B-}{$X+}{$T-}{$P+}{$H+}{$J-} { set critical compiler conditionals for proper compilation - 10aug2025 }
//## ==========================================================================================================================================================================================================================
//##
//## MIT License
//##
//## Copyright 2025 Blaiz Enterprises ( http://www.blaizenterprises.com )
//##
//## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//## files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//## modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//## is furnished to do so, subject to the following conditions:
//##
//## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//##
//## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. app code (main.pas)
//## Version.................. 1.00.2047 (+34)
//## Items.................... 2
//## Last Updated ............ 07nov2025, 15sep2025, 12jun2025, 13may2025
//## Lines of Code............ 2,800+
//##
//## main.pas ................ app code
//## gossroot.pas ............ console/gui app startup and control
//## gossio.pas .............. file io
//## gossimg.pas ............. image/graphics
//## gossnet.pas ............. network
//## gosswin.pas ............. 32bit windows api's/xbox controller
//## gosssnd.pas ............. sound/audio/midi/chimes
//## gossgui.pas ............. gui management/controls
//## gossdat.pas ............. app icons (32px and 20px), splash image (208px), help documents (gui only) in txt, bwd or bwp format
//## gosszip.pas ............. zip support
//## gossjpg.pas ............. jpeg support
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | tapp                   | tbasicapp         | 1.00.142  | 12jun2025   | App - 09jun2025, 09may2025
//## | tmicon                 | tbasiccontrol     | 1.00.1871 | 15sep2025   | Multi-icon editor - 12jun2025, 09jun2025, 09may2025, 06may2025
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


var
   itimerbusy:boolean=false;
   iapp:tobject=nil;


type

{tmicon}
   tmiconinfo=record
    id :longint;//data id
    ref:string;//settings info
    dat:tstr8;//image data (0=png, 1..N=ico)
    i  :tbasicimage;//input image
    o  :tbasicimage;//output image
    s  :longint;//size
    a  :twinrect;
    c  :string;//caption
    f  :string;//format -> PNG or ICO
    cc :longint;//color count
    end;

   tmicon=class(tbasiccontrol)
   private
    igrid:tbasicimage;
    //.screen images
    ilist:array[0..5] of tmiconinfo;
    icustommask,icustommask2,iscaleimg:tbasicimage;
    iscaleimgref:string;
    //.other
    ilangarea:twinrect;
    ilangid,imaskid,imaskid2,ilastbackmode,ibackcolor,ibackmode,imaster,iico_bytes,ires_bytes,irotate,ipngQuality,igridsize,ilastmaskfilter,ilastopenfilter,ifocusindex,ihoverindex:longint;
    ilanghover,icanforce,imaskdel,inewfocus,iupscale,iflip,imirror,ishowframe:boolean;
    isettingsref,ishape,ilastmaskfile,ilastopenfile,ilastsavefile:string;
    iflashON:boolean;
    iico_data,ires_data:tstr8;
    itimer500:comp;
    function xvalidindex(xindex:longint):boolean;
    function xsafeindex(xindex:longint):longint;
    function xfindindex(sx,sy:longint):longint;
    procedure xopenimg(xindex:longint);
    function ximgext:string;
    function ximgfile(xindex:longint):string;
    function xmaskfile(xindex:longint):string;
    procedure xloadimg(xindex:longint;xfromfile:string);
    procedure xsaveimg(xindex:longint);
    procedure xclearimg(xindex:longint);
    function popopenmask(var xfilename:string;var xfilterindex:longint;xcommonfolder:string):boolean;//12apr2021
    function xpushimg(xindex:longint;s:tbasicimage;sfilename:string):boolean;
    function xmakedata(xres:boolean;xdata:pobject):boolean;
    function popsaveimgICO(var xfilename:string;xcommonfolder,xtitle2:string):boolean;
    function popsaveRES(var xfilename:string;xcommonfolder,xtitle2:string):boolean;
    procedure xsaveas(xres:boolean);
    procedure xonshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
    function xonshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    procedure xlangidCustom;
    procedure setlangid(x:longint);
    procedure setpngQuality(x:longint);
    procedure setbackmode(x:longint);
    function findbackcolor:longint;
    procedure setshape(x:string);
    function xshapeinfo(xindex:longint;var xtep:longint;var xlabel,xhelp,xcmd,xshape:string):boolean;
    function xbackinfo(xindex:longint;var xtep:longint;var xlabel,xhelp,xcmd:string):boolean;
    function xbackinfo0(xindex:longint;var xcmd:string):boolean;
    procedure setrotate(x:longint);
    procedure setmaster(x:longint);
    function xsettingschanged(xreset:boolean):boolean;
    function xsyncref(xindex:longint):string;
    function xsyncimages:boolean;
    function xsyncimage(xindex:longint):boolean;
    function xcanchange(xindex:longint):boolean;
    procedure xsyncresample;
    function xfindfocusindex:longint;
    function xcopyhint(xmaster,xcopyraw:boolean):string;
   public
    ohostmustupdate:boolean;
    //create
    constructor create2(xparent:tobject;xstart:boolean); override;
    destructor destroy; override;
    procedure _ontimer(sender:tobject); override;
    procedure _onpaint(sender:tobject); override;
    function _onnotify(sender:tobject):boolean; override;
    function _onaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
    //information
    property langid:longint        read ilangid write setlangid;//14sep2025
    property pngQuality:longint    read ipngQuality write setpngQuality;
    property backmode:longint      read ibackmode write setbackmode;
    property backcolor:longint     read ibackcolor write ibackcolor;
    property showframe:boolean     read ishowframe write ishowframe;
    property shape:string          read ishape write setshape;
    property rotate:longint        read irotate write setrotate;
    property flip:boolean          read iflip write iflip;
    property mirror:boolean        read imirror write imirror;
    property upscale:boolean       read iupscale write iupscale;
    property maskdel:boolean       read imaskdel write imaskdel;
    property master:longint        read imaster write setmaster;
    //command
    function cancmd(x:string):boolean;
    procedure cmd(x:string);
    //can
    function cancopy:boolean;
    function cancopyraw:boolean;//09jun2025
    function canpaste:boolean;
    function canopen:boolean;
    function cansave:boolean;
    function canclear:boolean;
    property canforce:boolean read icanforce;
    //other
    procedure flash;
    function settingsref:string;
    function copyhint(xcopyraw:boolean):string;
   end;

{tapp}
   tapp=class(tbasicapp)
   private
    icore:tmicon;
    itimer500:comp;
    itoolbar1,itoolbar2,itoolbar3:tbasictoolbar;
    iloaded,ibuildingcontrol:boolean;
    isettingsref:string;
    procedure xcmd(sender:tobject;xcode:longint;xcode2:string);
    procedure __onclick(sender:tobject);
    procedure __ontimer(sender:tobject); override;
    procedure xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
    function xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    procedure xloadsettings;
    procedure xsavesettings;
    procedure xautosavesettings;
    procedure xupdatebuttons;
    procedure ab(xtep:longint;xname,xhelp,xcmd:string);//add button
   public
    //create
    constructor create; virtual;
    destructor destroy; override;
   end;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024


//app procs --------------------------------------------------------------------
//.create / destroy
procedure app__remove;//does not fire "app__create" or "app__destroy"
procedure app__create;
procedure app__destroy;

//.event handlers
function app__onmessage(m,w,l:longint):longint;
procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
procedure app__onpaint(sw,sh:longint);
procedure app__ontimer;

//.support procs
function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;
function app__syncandsavesettings:boolean;

function mis__resample(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xsmoothresample:boolean):boolean;
function make__shape32(s,scustom,scustom2:tobject;xshape:string;xoverridemask:boolean):boolean;//10jun2025
function mis__bwTOba32(s:tobject):boolean;//black and white -> black and alpha
function mask__add(s,d:tobject):boolean;


implementation

{$ifdef gui}
uses
    gossdat;
{$endif}


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//get
if      (xname='slogan')              then result:=info__app('name')+' by Blaiz Enterprises'
else if (xname='width')               then result:='1100'
else if (xname='height')              then result:='700'
else if (xname='language')            then result:='english-australia'//14sep2025 - for Clyde
else if (xname='codepage')            then result:='1252'
else if (xname='ver')                 then result:='1.00.2047'
else if (xname='date')                then result:='07nov2025'
else if (xname='name')                then result:='Multi Icon'
else if (xname='web.name')            then result:='multiicon'//used for website name
else if (xname='des')                 then result:='Reliably create and save a multi-resolution icon (.ico) or "mainicon" resource (.res) with ease'
else if (xname='infoline')            then result:=info__app('name')+#32+info__app('des')+' v'+app__info('ver')+' (c) 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='size')                then result:=low__b(io__filesize64(io__exename),true)
else if (xname='diskname')            then result:=io__extractfilename(io__exename)
else if (xname='service.name')        then result:=info__app('name')
else if (xname='service.displayname') then result:=info__app('service.name')
else if (xname='service.description') then result:=info__app('des')
else if (xname='new.instance')        then result:='1'//1=allow new instance, else=only one instance of app permitted
else if (xname='screensizelimit%')    then result:='95'//95% of screen area
else if (xname='realtimehelp')        then result:='0'//1=show realtime help, 0=don't
else if (xname='hint')                then result:='1'//1=show hints, 0=don't

//.links and values
else if (xname='linkname')            then result:=info__app('name')+' by Blaiz Enterprises.lnk'
else if (xname='linkname.vintage')    then result:=info__app('name')+' (Vintage) by Blaiz Enterprises.lnk'
//.author
else if (xname='author.shortname')    then result:='Blaiz'
else if (xname='author.name')         then result:='Blaiz Enterprises'
else if (xname='portal.name')         then result:='Blaiz Enterprises - Portal'
else if (xname='portal.tep')          then result:=intstr32(tepBE20)
//.software
else if (xname='url.software')        then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.html'
else if (xname='url.software.zip')    then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.zip'
//.urls
else if (xname='url.portal')          then result:='https://www.blaizenterprises.com'
else if (xname='url.contact')         then result:='https://www.blaizenterprises.com/contact.html'
else if (xname='url.facebook')        then result:='https://web.facebook.com/blaizenterprises'
else if (xname='url.mastodon')        then result:='https://mastodon.social/@BlaizEnterprises'
else if (xname='url.twitter')         then result:='https://twitter.com/blaizenterprise'
else if (xname='url.x')               then result:=info__app('url.twitter')
else if (xname='url.instagram')       then result:='https://www.instagram.com/blaizenterprises'
else if (xname='url.sourceforge')     then result:='https://sourceforge.net/u/blaiz2023/profile/'
else if (xname='url.github')          then result:='https://github.com/blaiz2023'
//.program/splash
else if (xname='license')             then result:='MIT License'
else if (xname='copyright')           then result:='© 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='splash.web')          then result:='Web Portal: '+app__info('url.portal')

else
   begin
   //nil
   end;

except;end;
end;




//app procs --------------------------------------------------------------------
procedure app__create;
begin
{$ifdef gui}
iapp:=tapp.create;
{$else}

//.starting...
app__writeln('');
//app__writeln('Starting server...');

//.visible - true=live stats, false=standard console output
scn__setvisible(false);


{$endif}
end;

procedure app__remove;
begin
try

except;end;
end;

procedure app__destroy;
begin
try
//save
//.save app settings
app__syncandsavesettings;

//free the app
freeobj(@iapp);
except;end;
end;

function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;

  procedure m(const x:array of byte);//map array to pointer record
  begin
  {$ifdef gui}
  xdata:=low__maplist(x);
  {$else}
  xdata.count:=0;
  xdata.bytes:=nil;
  {$endif}
  end;
begin//Provide the program with a set of optional custom "tep" images, supports images in the TEA format (binary text image)
//defaults
result:=false;

//sample custom image support

//m(tep_none);
{
case xindex of
5000:m(tep_write32);
5001:m(tep_search32);
end;
}

//successful
//result:=(xdata.count>=1);
end;

function app__syncandsavesettings:boolean;
begin
//defaults
result:=false;
try
//.settings
{
app__ivalset('powerlevel',ipowerlevel);
app__ivalset('ramlimit',iramlimit);
{}


//.save
app__savesettings;

//successful
result:=true;
except;end;
end;

function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
begin
result:=tnetbasic.create;
end;

function app__onmessage(m,w,l:longint):longint;
begin
//defaults
result:=0;
end;

procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
begin
//nil
end;

procedure app__onpaint(sw,sh:longint);
begin
//console app only
end;

procedure app__ontimer;
begin
try
//check
if itimerbusy then exit else itimerbusy:=true;//prevent sync errors

//last timer - once only
if app__lasttimer then
   begin

   end;

//check
if not app__running then exit;


//first timer - once only
if app__firsttimer then
   begin

   end;



except;end;
try
itimerbusy:=false;
except;end;
end;


//## tmicon ####################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111111111
constructor tmicon.create2(xparent:tobject;xstart:boolean);
var
   s,sx,sy,sw,sh,p:longint;
   sr32:pcolorrow32;
   c0,c1:tcolor32;
   bol1:boolean;
   e:string;
begin
//self
inherited create2(xparent,false);

//var
itimer500        :=ms64;
ilangid          :=0;//14sep2025
ilangarea        :=area__nil;
ilanghover       :=false;
bordersize       :=0;
oautoheight      :=true;
ihoverindex      :=-1;
ifocusindex      :=0;
inewfocus        :=false;
ilastopenfile    :='';
ilastopenfilter  :=0;
ilastsavefile    :='';
ilastmaskfile    :='';
ilastmaskfilter  :=0;
iflashON         :=false;
igridsize        :=2;
ibackmode        :=0;
ibackcolor       :=rgba0__int(127,127,127);
ilastbackmode    :=4;
ishowframe       :=true;
ishape           :='asis';
irotate          :=0;
iflip            :=false;
imirror          :=false;
iupscale         :=false;
maskdel          :=false;
icanforce        :=false;
imaster          :=0;
isettingsref     :='';
ohostmustupdate  :=false;
iico_data        :=str__new8;
ires_data        :=str__new8;
iico_bytes       :=0;
ires_bytes       :=0;

//imagea
iscaleimg        :=misimg32(1,1);
iscaleimgref     :='';
icustommask      :=misimg32(1,1);
icustommask2     :=misimg32(1,1);
imaskid          :=0;
imaskid2         :=0;

for p:=0 to high(ilist) do
begin

case p of
0 :s:=256;
1 :s:=64;
2 :s:=48;
3 :s:=32;
4 :s:=24;
5 :s:=16;
else s:=32;
end;//case

ilist[p].id :=0;
ilist[p].ref:='';
ilist[p].dat:=str__new8;
ilist[p].s  :=s;
ilist[p].i  :=misimg32(1,1);
ilist[p].o  :=misimg32(1,1);
ilist[p].a  :=nilarea;
ilist[p].c  :='';
ilist[p].f  :=low__aorbstr('PNG','ICO',p>=1);
ilist[p].cc :=0;
end;//p

//.grid
c0:=rgba__c32(128,128,128,100);
c1:=rgba__c32(255,255,255,200);

sw:=256+igridsize;
sh:=256+igridsize;
igrid:=misimg32(sw,sh);
bol1:=false;

for sy:=0 to (sh-1) do
begin
if not misscan32(igrid,sy,sr32) then break;

bol1:=low__iseven(sy div igridsize);

for sx:=0 to (sw-1) do
begin
if bol1 then sr32[sx]:=c0 else sr32[sx]:=c1;

if (sx=((sx div igridsize)*igridsize)) and low__iseven(sx) then bol1:=not bol1;
end;//sx
end;//sy


//load
//.images
for p:=0 to high(ilist) do xloadimg(p,'');

//.mask
mis__fromfile(icustommask,xmaskfile(1),e);
mis__onecell(icustommask);

//.mask2
mis__fromfile(icustommask2,xmaskfile(2),e);
mis__onecell(icustommask2);

//events
ocanshowmenu:=true;
showmenuFill1:=xonshowmenuFill1;
showmenuClick1:=xonshowmenuClick1;


//start
if xstart then start;
end;

destructor tmicon.destroy;
var
   p:longint;
begin
try
//save
for p:=0 to high(ilist) do xsaveimg(p);

//controls
for p:=0 to high(ilist) do
begin
freeobj(@ilist[p].i);
freeobj(@ilist[p].o);
str__free(@ilist[p].dat);
end;//p

freeobj(@icustommask);
freeobj(@icustommask2);
freeobj(@iscaleimg);
str__free(@iico_data);
str__free(@ires_data);

freeobj(@igrid);

//self
inherited destroy;
except;end;
end;

procedure tmicon.setlangid(x:longint);
begin
ilangid:=frcrange32(x,0,max16);
end;

procedure tmicon.xlangidCustom;
var
   str1:string;
begin

str1:=intstr32(ilangid);
if gui.popedit(str1,'Custom Language ID','Language|Enter a custom language ID value in the range of 0..'+k64(max16)) then langid:=strint32(str1);

end;

procedure tmicon.setpngQuality(x:longint);
begin
ipngquality:=frcrange32(x,0,2);
end;

procedure tmicon.setbackmode(x:longint);
begin
ibackmode:=frcrange32(x,0,ilastbackmode);
end;

function tmicon.findbackcolor:longint;
begin
case ibackmode of
1   :result:=rgba0__int(255,255,255);
2   :result:=rgba0__int(0,0,0);
3   :result:=info.background;
4   :result:=ibackcolor;
else result:=clnone;
end;//case
end;

function tmicon.xshapeinfo(xindex:longint;var xtep:longint;var xlabel,xhelp,xcmd,xshape:string):boolean;
   procedure s(dtep:longint;dlabel,dhelp,dshape:string);
   begin
   xtep   :=dtep;
   xlabel :=dlabel;
   xhelp  :='Shape|Set mask shape to '+dhelp;
   xcmd   :='micon.shape.'+dshape;
   xshape :=dshape;
   end;
begin
//defaults
result:=true;

case xindex of
0:s(tepAsis20        ,'Original'    ,'original','asis');
1:s(tepSquircle20    ,'Squircle'    ,'squircle','squircle');
2:s(tepSquircle20    ,'Squircle 2'  ,'squircle','squircle2');
3:s(tepSquircle20    ,'Squircle 3'  ,'squircle','squircle3');
4:s(tepSquircle20    ,'Squircle 4'  ,'squircle','squircle4');

5:s(tepCircle20      ,'Circle'      ,'circle','circle');
6:s(tepCircle20      ,'Circle 2'    ,'circle','circle2');
7:s(tepCircle20      ,'Circle 3'    ,'circle','circle3');
8:s(tepCircle20      ,'Rings'       ,'rings','rings');
9:s(tepDiamond20     ,'Diamond'     ,'diamond','diamond');
10:s(tepDiamond20    ,'Diamond 2'   ,'diamond','diamond2');

11:s(tepSquare20     ,'Square'      ,'square','square');
12:s(tepSquare20     ,'Square 2'    ,'square','square2');
13:s(tepSquare20     ,'Square 3'    ,'square','square3');

14:s(tepTransparent20,'Transparent' ,'top-left pixel color transparency','transparent');
15:s(tepAsis20       ,'Custom' ,'a custom shape.  Select again to load a mask from file.','custom');
16:s(tepAsis20       ,'Custom 2' ,'a custom shape.  Select again to paste a mask from Clipboard.','custom2');
else
   begin
   s(tepNone,'','','');
   result:=false;
   end;
end;//case

end;

function tmicon.xbackinfo0(xindex:longint;var xcmd:string):boolean;
var
   xtep:longint;
   xlabel,xhelp:string;
begin
result:=xbackinfo(xindex,xtep,xlabel,xhelp,xcmd);
end;

function tmicon.xbackinfo(xindex:longint;var xtep:longint;var xlabel,xhelp,xcmd:string):boolean;
   procedure s(dtep:longint;dlabel,dhelp,dcmd:string);
   begin
   xtep   :=dtep;
   xlabel :=dlabel;
   xhelp  :='Transparent Regions|View transparent image regions as '+dhelp;
   xcmd   :='micon.backmode.'+dcmd;
   end;
begin
//defaults
result:=true;

case xindex of
0:s(tepYesBlank20    ,'Checker'   ,'checkerboard pattern','0');
1:s(tepYesBlank20    ,'White'     ,'white','1');
2:s(tepYesBlank20    ,'Black'     ,'black','2');
3:s(tepYesBlank20    ,'Window'    ,'window color','3');
4:s(tepYesBlank20    ,'Custom'    ,'custom color','4');

else
   begin
   s(tepNone,'','','');
   result:=false;
   end;
end;//case

end;

procedure tmicon.setshape(x:string);
var
   slabel,shelp,scmd,sshape:string;
   step,p:longint;
   bol1:boolean;
begin
//defaults
bol1:=false;

//find
for p:=0 to max32 do
begin
if xshapeinfo(p,step,slabel,shelp,scmd,sshape) then
   begin
   if strmatch(sshape,x) then
      begin
      bol1:=true;
      break;
      end;
   end
else break;
end;//p

//get
if not bol1 then x:='asis';

//set
ishape   :=x;
icanforce:=(not strmatch(ishape,'asis')) and (not strmatch(ishape,'square')) and (not strmatch(ishape,'transparent'));
end;

procedure tmicon.setmaster(x:longint);
begin
//filter
case x of
0,1,2,3:;
else  x:=0;
end;//case

//get
imaster:=x;
end;

procedure tmicon.setrotate(x:longint);
begin
//filter
case x of
0,90,180,270:;
else         x:=0;
end;//case

//get
irotate:=x;
end;

function tmicon.xmakedata(xres:boolean;xdata:pobject):boolean;
label//Note: icon files have their headers trimmed => str__del(d,0,21) fit resource format
   skipend;
var
   p:longint;
   xstartofdata,dcount,dpos,dsize:longint;

   procedure xres_padto4;//padding with zeros to 4 byte boundary
   var
      xlen,p,v:longint;
   begin
   xlen:=str__len(xdata);
   v   :=int__round4( xlen );
   for p:=xlen to (v-1) do str__addbyt1(xdata,0);
   end;


   procedure xres_hdr32A;
   begin
   str__addint4(xdata,0);//data size(4)
   str__addint4(xdata,32);//header size(4)
   str__aadd(xdata,[255,255,0,0]);//type(4)
   str__aadd(xdata,[255,255,0,0]);//name(4)
   str__aadd(xdata,[0,0,0,0]);//data version(4)
   str__aadd(xdata,[0,0]);//memory flags(2)
   str__aadd(xdata,[0,0]);//language id(2)
   str__aadd(xdata,[0,0,0,0]);//version(4)
   str__aadd(xdata,[0,0,0,0]);//characteristics(4)
   end;

   procedure xres_hdr32B(xindex:longint);
   begin
   {32b=typedef struct {
   DWORD DataSize;
   DWORD HeaderSize;
   DWORD TYPE;
   DWORD NAME;
   DWORD DataVersion;
   WORD  MemoryFlags;
   WORD  LanguageId;
   DWORD Version;
   DWORD Characteristics;
   } //RESOURCEHEADER;

   //check
   if not xvalidindex(xindex) then exit;

   //get
   str__addint4(xdata,str__len(@ilist[xindex].dat) );//data size(4)
   str__addint4(xdata,32);//header size(4)
   str__aadd(xdata,[255,255,3,0]);//type(4)

   str__aadd(xdata,[255,255]);//name(2+2=4)
   str__addwrd2(xdata,xindex+1);

   str__addint4(xdata,0);//data version(4)
   str__aadd(xdata,[48,16]);//memory flags(2)
//was:   str__aadd(xdata,[9,12]);//languageid(2)
   str__addwrd2(xdata,ilangid);//languageid(2)
   str__addint4(xdata,0);//version(4)
   str__addint4(xdata,0);//characteristics(4)
   end;
begin
//defaults
result :=false;
dcount :=high(ilist)+1;

try
//check
if not str__lock(xdata) then goto skipend;

//init
str__clear(xdata);

//check we have image data for each image slot
for p:=0 to (dcount-1) do if (str__len(@ilist[p].dat)<=2) then goto skipend;


//.res format ------------------------------------------------------------------
if xres then
   begin
   //root header
   xres_hdr32A;

   //icons => header + data + padto4
   for p:=0 to (dcount-1) do
   begin
   //.icon header
   xres_hdr32B(p);

   //.icon data
   str__add(xdata,@ilist[p].dat);

   //.pad with zeros if required
   xres_padto4;
   end;//p

   //mainicon index
   str__addint4(xdata,6 + (dcount*14) );//data size(4)
   str__addint4(xdata,48);//header size(4)
   str__aadd(xdata,[255,255,14,0]);//type(4)
   str__aadd(xdata,[uuM,0,uuA,0,uuI,0,uuN,0,uuI,0,uuC,0,uuO,0,uuN,0]);//mainicon(16) - variable length
   str__aadd(xdata,[0,0,0,0]);//data version(4)

   str__aadd(xdata,[0,0,0,0]);//null

   str__aadd(xdata,[48,16]);//memory flags(2)
   //was:  str__aadd(xdata,[9,12]);//languageid(2)
   str__addwrd2(xdata,ilangid);//languageid(2)

   str__aadd(xdata,[0,0,0,0]);//version(4)
   str__aadd(xdata,[0,0,0,0]);//characteristics(4)

   //.mainicon index
   str__addwrd2(xdata,0);//null
   str__addwrd2(xdata,1);//1=icon, 2=cursor
   str__addwrd2(xdata,dcount);//number of RESDIR records that follow

   //.resdir records
   for p:=0 to (dcount-1) do
   begin
   dsize:=ilist[p].s;
   if (dsize>=256) then dsize:=0;//0=256px
   //.width
   str__addbyt1(xdata,dsize);
   //.height
   str__addbyt1(xdata,dsize);
   //.colors in palette (0 if no palette used)
   str__addbyt1(xdata,0);
   //.null
   str__addbyt1(xdata,0);
   //.color planes
   str__addwrd2(xdata,1);
   //.bits
   str__addwrd2(xdata,32);
   //.size of image data
   str__addint4(xdata,str__len(@ilist[p].dat));
   //.unique ordinal identifier of the RT_ICON or RT_CURSOR resource
   str__addwrd2(xdata,p+1);//1..N
   end;//p

   //.pad with zeros if required
   xres_padto4;
   end


//.icon format -----------------------------------------------------------------
else
   begin

   //header
   str__addwrd2(xdata,0);
   str__addwrd2(xdata,1);//type: 1=ico, 2=cursor
   str__addwrd2(xdata,dcount);//number of images

   xstartofdata:=6 + (dcount*16);
   dpos        :=xstartofdata;

   //get
   for p:=0 to (dcount-1) do
   begin
   dsize:=ilist[p].s;
   if (dsize>=256) then dsize:=0;//0=256px

   //.width
   str__addbyt1(xdata,dsize);
   //.height
   str__addbyt1(xdata,dsize);
   //.colors in palette (0 if no palette used)
   str__addbyt1(xdata,0);
   //.null
   str__addbyt1(xdata,0);
   //.color planes
   str__addwrd2(xdata,1);
   //.bits
   str__addwrd2(xdata,32);
   //.size of image data
   str__addint4(xdata,str__len(@ilist[p].dat));
   //.offset from beginning of this file
   str__addint4(xdata,dpos);

   //inc
   inc(dpos, str__len(@ilist[p].dat) );
   end;//p

   //append image data
   for p:=0 to (dcount-1) do str__add(xdata,@ilist[p].dat);
   end;

//successful
result:=true;
skipend:
except;end;
//clear on error
if not result then str__clear(xdata);
//free
str__uaf(xdata);
end;

procedure tmicon.flash;
begin
iflashON:=not iflashON;
if (ibackmode<=0) then paintnow;
end;

procedure tmicon._ontimer(sender:tobject);
begin
try

//timer500
if (ms64>=itimer500) then
   begin
   //flash - checkerboard
   flash;

   //reset
   itimer500:=ms64+500;
   end;

//sync
if xsyncimages then paintnow;

except;end;
end;

function tmicon.popsaveimgICO(var xfilename:string;xcommonfolder,xtitle2:string):boolean;
var
   xfilterindex:longint;
   daction,xfilterlist:string;
begin
result:=false;

try
//filterlist
xfilterindex:=0;
xfilterlist:=peico;
need_ico;
//get
daction:='';
result:=gui.xpopnav3(xfilename,xfilterindex,xfilterlist,strdefb(xcommonfolder,low__platfolder('images')),'save','','Save Image'+xtitle2,daction,true);
except;end;
end;

function tmicon.popsaveRES(var xfilename:string;xcommonfolder,xtitle2:string):boolean;
var
   xfilterindex:longint;
   daction,xfilterlist:string;
begin
result:=false;

try
//filterlist
xfilterindex:=0;
xfilterlist:=peres;
//get
daction:='';
result:=gui.xpopnav3(xfilename,xfilterindex,xfilterlist,strdefb(xcommonfolder,low__platfolder('images')),'save','','Save Image'+xtitle2,daction,true);
except;end;
end;

procedure tmicon.xsaveas(xres:boolean);
label
   skipend;
var
   bol1,xresult:boolean;
   e:string;
begin
//defaults
xresult :=false;
e       :=gecTaskfailed;

try
//check
if not cansave then exit;

//get
ilastsavefile:=strdefb(ilastsavefile,ilastopenfile);
case xres of
true:bol1:=popsaveRES(ilastsavefile,'','');
else bol1:=popsaveimgICO(ilastsavefile,'','');
end;//case

if bol1 then
   begin
   case xres of
   true:if not io__tofile(ilastsavefile,@ires_data,e) then goto skipend;
   else if not io__tofile(ilastsavefile,@iico_data,e) then goto skipend;
   end;//case
   end;

//successful
xresult:=true;
skipend:
except;end;
//show error
if (not xresult) and (app__gui<>nil) then app__gui.poperror('',e);
end;

function tmicon.canclear:boolean;
var
   p:longint;
begin
result:=false;
for p:=0 to high(ilist) do if not misempty(ilist[p].i) then
   begin
   result:=true;
   break;
   end;
end;

function tmicon.cansave:boolean;
var
   p:longint;
begin
result:=true;
for p:=0 to high(ilist) do if misempty(ilist[p].i) then
   begin
   result:=false;
   break;
   end;
end;

function tmicon.xfindfocusindex:longint;
begin
if (imaster>=1) then result:=0 else result:=ifocusindex;
end;

function tmicon.cancopy:boolean;
begin
result:=(xfindfocusindex>=0) and (not misempty(ilist[xfindfocusindex].o));
end;

function tmicon.cancopyraw:boolean;//09jun2025
begin
result:=(xfindfocusindex>=0) and (not misempty(ilist[xfindfocusindex].i));
end;

function tmicon.canpaste:boolean;
begin
result:=xcanchange(xfindfocusindex) and clip__canpasteimage;
end;

function tmicon.canopen:boolean;
begin
result:=xcanchange(xfindfocusindex);
end;

procedure tmicon.xonshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
var
   p,xcode:longint;
   xcaption,xlabel:string;
begin
try
//check
if zznil(xmenudata,5000) then exit;

//init
xmenuname:='main-app.'+xstyle;

//menu
if (xstyle='menu.image') then
   begin
   low__menuitem2(xmenudata,tepCopy20,'Copy',xcopyhint(imaster>=1,false),'micon.copy',100,aknone,cancopy);
   low__menuitem2(xmenudata,tepCopy20,'Copy Raw',xcopyhint(imaster>=1,true),'micon.copyraw',100,aknone,cancopyraw);

   low__menuitem2(xmenudata,tepPaste20,'Paste','Image|Paste image from Clipboard','micon.paste',100,aknone,canpaste);
   low__menuitem2(xmenudata,tepOpen20,'Open','Image|Open an image from file','micon.open',100,aknone,canopen);
   end
else if (xstyle='langid') then
   begin

   low__menutitle(xmenudata,tepNone,'Select Language','');

   for p:=0 to max32 do
   begin

   if res__listenglish__langcode2(p,xcaption,xlabel,xcode) then
      begin

      low__menuitem2(xmenudata,tep__tick(ilangid=xcode),xcaption+'  '+intstr32(xcode),'Language|Set resource language ID to '+k64(xcode)+' "'+xlabel+'"','micon.langid.'+intstr32(xcode),100,aknone,true);

      end
   else break;

   end;//p

   low__menuitem2(xmenudata,tepEdit20,'Custom...','Language|Set a custom resource language ID','micon.langid.custom',100,aknone,true);

   end;

except;end;
end;

function tmicon.copyhint(xcopyraw:boolean):string;
begin
result:=xcopyhint( (imaster>=1) or (ifocusindex=0) ,xcopyraw);
end;

function tmicon.xcopyhint(xmaster,xcopyraw:boolean):string;
var
   m:string;
begin
m:=insstr(' Master',xmaster);

case xcopyraw of
true:result:='Image|Copy raw'+m+' image to Clipboard';
else result:='Image|Copy'+m+' image to Clipboard';
end;//case
end;

function tmicon.xonshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
result:=true;
cmd(xcode2);
end;

function tmicon.settingsref:string;
begin
result:=bolstr(imaskdel)+bolstr(iupscale)+bolstr(ishowframe)+bolstr(imirror)+bolstr(iflip)+'|'+intstr32(ibackcolor)+'|'+intstr32(ibackmode)+'|'+intstr32(irotate)+'|'+intstr32(ilangid)+'|'+intstr32(ipngquality)+'|'+intstr32(imaster)+'|'+shape;
end;

function tmicon.xsettingschanged(xreset:boolean):boolean;
var
   v:string;
begin
v:=settingsref;
result:=(v<>isettingsref);
if xreset then isettingsref:=v;
end;

function tmicon.xsyncref(xindex:longint):string;
begin
//range
xindex:=xsafeindex(xindex);

//get
result:=intstr32(imaster)+'|'+intstr32(imaskid2)+'|'+intstr32(imaskid)+'|'+bolstr(imaskdel)+bolstr(iupscale)+bolstr(imirror)+bolstr(iflip)+'|'+intstr32(irotate)+'|'+intstr32(ilangid)+'|'+intstr32(low__aorb(0,ipngquality,xindex=0))+'|'+intstr32(low__aorb(ilist[xindex].id,ilist[0].id,imaster>=1))+'|'+shape;
end;

function tmicon.xsyncimages:boolean;
var
   p:longint;
begin
//defaults
result:=false;

//sync images
for p:=0 to high(ilist) do if xsyncimage(p) then result:=true;

//sync data streams
if result then
   begin
   //.icon
   xmakedata(false,@iico_data);
   iico_bytes:=str__len(@iico_data);

   //.resource
   xmakedata(true,@ires_data);
   ires_bytes:=str__len(@ires_data);
   end;

end;

function tmicon.xcanchange(xindex:longint):boolean;
begin
result:=xvalidindex(xindex) and ( (xindex<=0) or (imaster<=0) );
end;

function tmicon.xsyncimage(xindex:longint):boolean;
var
   sfrom,d:tbasicimage;//pointers only
   dref,s:tbasicimage;
   dindex,v,p,sw,sh:longint;
   e,daction:string;
begin
//defaults
s   :=nil;
dref:=nil;

//range
xindex:=xsafeindex(xindex);

//check
result:=low__setstr(ilist[xindex].ref,xsyncref(xindex));
if not result then exit;

try
//init
if (xindex>=1) and (imaster>=1) then
   begin
   sw:=128;
   sh:=128;
   end
else
   begin
   sw:=ilist[xindex].s;
   sh:=ilist[xindex].s;
   end;

s:=misimg32(sw,sh);
d:=ilist[xindex].o;//output image
//if stransparent then dref:=misimg32(ilist[xindex].s,ilist[xindex].s);

//.size d
missize(d,ilist[xindex].s,ilist[xindex].s);
mis__cls(d,0,0,0,0);


//.determine source image to use
if (xindex=0) or ((xindex>=1) and (imaster>=1)) then
   begin
   dindex:=0;

   if iupscale and (master>=1) then
      begin
      xsyncresample;
      sfrom:=iscaleimg;
      end
   else
      begin
      sfrom:=ilist[0].i;
      end;

   end
else
   begin
   sfrom :=ilist[xindex].i;
   dindex:=xindex;
   end;

//sfrom -> s
//.resample
if (xindex>=1) and (imaster>=1) then
   begin
   mis__resample(maxarea,0,0,sw,sh,misarea(sfrom),s,sfrom,true);
   end
//.straight
else
   begin
   mis__copyfast82432(maxarea,0,0,sw,sh,misarea(sfrom),s,sfrom);
   end;

//resample
if (xindex>=1) and (imaster>=1) then
   begin
   //blur
   v:=0;

   if (imaster>=3) then
      begin
      case ilist[xindex].s of
      0..16 :v:=8;
      17..24:v:=4;
      25..32:v:=2;
      else   v:=1;
      end;//case
      end
   else if (imaster>=2) then
      begin
      case ilist[xindex].s of
      0..16 :v:=4;
      17..24:v:=2;
      else   v:=1;
      end;//case
      end;

   for p:=1 to v do misblur82432b(s,false,100,clnone);
   end;

//get
case (xindex>=1) and (imaster>=1) of
true:mis__resample(maxarea,0,0,misw(d),mish(d),misarea(s),d,s,imaster>=1);//required for fine detail at 24x24 and 16x16 - 06jun2025
else mis__copyfast82432(maxarea,0,0,misw(d),misw(d),misarea(s),d,s);
end;

//.shape
if strmatch(shape,'transparent') then
   begin
   //.transparency (top-left) must be done here without a resampled/blur version of image - 11jun2025
   dref:=misimg32(misw(d),mish(d));
   mis__copyfast82432(maxarea,0,0,misw(dref),mish(dref),misarea(ilist[dindex].i),dref,ilist[dindex].i);
   mask__setval(d,255);
   mask__feather2(dref,d,0,clTopLeft,false,p);
   end
else make__shape32(d,icustommask,icustommask2,shape,imaskdel);

//.options
if imirror then mis__mirror82432(d);
if iflip   then mis__flip82432(d);

case irotate of
90,180,270:mis__rotate82432(d,irotate);
end;//case

//.png
if (xindex=0) then
   begin
   case ipngQuality of
   0   :daction:=ia_bestquality;
   1   :daction:=ia_goodquality;
   else daction:=ia_lowquality;
   end;

   png__todata4(d,@ilist[xindex].dat,32,daction,e);//save - Windows only handles 32bit PNGs at scale - 24/8bit are shrunk down - 04jun2025
   mis__fromdata(d,@ilist[xindex].dat,e);//load
   end
//.ico
else
   begin
   ico__todata(d,@ilist[xindex].dat,e);//save - 04jun2025
   mis__fromdata(d,@ilist[xindex].dat,e);//load
   str__del(@ilist[xindex].dat,0,21);//trim part of icon header to fit with resource format
   end;

//.color count
ilist[xindex].cc:=miscountcolors(d);

except;end;
//free
freeobj(@s);
freeobj(@dref);
end;

function tmicon.cancmd(x:string):boolean;
begin
result:=strmatch(strcopy1(x,1,6),'micon.');
end;

procedure tmicon.cmd(x:string);
var
   int1,int2,v32,p:longint;
   str1,v,e:string;
   xmustpaint:boolean;

   function m(s:string):boolean;
   begin
   result:=strmatch(s,x);
   end;

   function mv(s:string):boolean;
   begin
   result:=strmatch(s,strcopy1(x,1,low__len(s)));
   if result then
      begin
      v:=strcopy1(x,low__len(s)+1,low__len(x));
      v32:=strint32(v);
      end;
   end;

begin
try
//defaults
xmustpaint:=false;
v         :='';
v32       :=0;

//check
if cancmd(x) then x:=strcopy1(x,7,low__len(x)) else exit;

//get
if m('clear') then
   begin
   if gui.popquery('Clear all images?') then
      begin

      for p:=0 to high(ilist) do
      begin
      xclearimg(p);
      xsaveimg(p);
      end;//p

      xmustpaint:=true;
      end;

   end
else if m('saveico') then xsaveas(false)
else if m('saveres') then xsaveas(true)
else if m('copy') then
   begin
   if cancopy then clip__copyimage(ilist[low__aorb(ifocusindex,0,(imaster>=1))].o);
   end
else if m('copyraw') then
   begin
   if cancopyraw then clip__copyimage(ilist[low__aorb(ifocusindex,0,(imaster>=1))].i);
   end
else if m('paste') then
   begin
   if canpaste then xpushimg(xfindfocusindex,nil,'**paste**');
   end
else if m('open') then
   begin
   if canopen then xopenimg(xfindfocusindex);
   end
else if mv('shape.') then
   begin
   str1 :=shape;
   shape:=v;

   if strmatch(str1,'custom2') and strmatch(str1,shape) then
      begin
      if clip__canpasteimage then
         begin
         clip__pasteimage(icustommask2);
         mis__onecell(icustommask2);
         mis__tofile(icustommask2,xmaskfile(2),'img32',e);
         low__irollone(imaskid2);
         end;
      end
   else if strmatch(str1,'custom') and strmatch(str1,shape) then
      begin
      ilastmaskfile:=strdefb(strdefb(ilastmaskfile,ilastopenfile),ilastsavefile);
      if popopenmask(ilastmaskfile,ilastmaskfilter,'') then
         begin
         mis__fromfile(icustommask,ilastmaskfile,e);
         mis__onecell(icustommask);
         mis__tofile(icustommask,xmaskfile(1),'img32',e);
         low__irollone(imaskid);
         end;
      end;

   end

else if m('langid.custom') then xlangidCustom
else if mv('langid.')   then langid:=strint32(v)//14sep2025

else if m('flip')       then iflip:=not iflip
else if m('mirror')     then imirror:=not imirror
else if m('upscale')    then iupscale:=not iupscale
else if m('maskdel')    then imaskdel:=not imaskdel
else if m('master0')    then master:=0
else if m('master1')    then master:=1
else if m('master2')    then master:=2
else if m('master3')    then master:=3
else if m('rotate0')    then rotate:=0
else if m('rotate90')   then rotate:=90
else if m('rotate180')  then rotate:=180
else if m('rotate270')  then rotate:=270
else if m('quality0')   then pngquality:=0
else if m('quality1')   then pngquality:=1
else if m('quality2')   then pngquality:=2
else if m('pngquality') then
   begin
   int1:=pngquality+1;
   if (int1>2) then int1:=0;
   pngquality:=int1;
   end
else if mv('backmode.') then
   begin
   int1    :=backmode;
   backmode:=v32;

   if (int1=v32) and (v32=ilastbackmode) then
      begin
      int2:=ibackcolor;
      if gui.popcolor(int2) and low__setint(ibackcolor,int2) then xmustpaint:=true;
      end;

   if (backmode<>int1) then xmustpaint:=true;
   end
else if m('frame') then
   begin
   ishowframe:=not ishowframe;
   xmustpaint:=true;
   end;

//host
if xsettingschanged(false) then
   begin
   ohostmustupdate:=true;
   xmustpaint:=true;
   end;

//paint
if xmustpaint then paintnow;
except;end;
end;

function tmicon.popopenmask(var xfilename:string;var xfilterindex:longint;xcommonfolder:string):boolean;//12apr2021
var
   daction,xfilterlist:string;
begin
result:=false;
daction:='';

try
//filterlist
xfilterlist:=
pepng+
peimg32+
pegif+
peico+pecur+peani+
petea+
petga;

//get
result:=gui.xpopnav3(xfilename,xfilterindex,xfilterlist,strdefb(xcommonfolder,low__platimages),'open','','Open Mask',daction,true);
except;end;
end;

function tmicon.xpushimg(xindex:longint;s:tbasicimage;sfilename:string):boolean;
label
   skipend;
var
   e:string;
   d:tbasicimage;//pointer only
   a:tbasicimage;
   dsize:longint;

   function xcopyfrom(s:tobject):boolean;
   var
      dw,dh:longint;
      da:twinrect;
      b:tbasicimage;
   begin
   //defaults
   result:=false;
   b     :=nil;

   try
   //cls
   mis__cls(d,0,0,0,0);

   //calc
   low__scalecrop(misw(d),mish(d),misw(s),mish(s),dw,dh);

   da.left    :=(misw(d)-dw) div 2;
   da.right   :=da.left+dw-1;
   da.top     :=(mish(d)-dh) div 2;
   da.bottom  :=da.top+dh-1;

   //get
   case (misw(d)>=1024) and (mish(d)>=1024) of
   true:result:=mis__copyfast82432(da,da.left,da.top,da.right-da.left+1,da.bottom-da.top+1,misarea(s),d,s);
   else result:=mis__resample(da,da.left,da.top,da.right-da.left+1,da.bottom-da.top+1,misarea(s),d,s,true);
   end;//case

   //data id
   low__irollone(ilist[xindex].id);

   //successful
   result:=true;
   except;end;
   //free
   freeobj(@b);
   end;

   function dscale:longint;
   begin
   case xindex of
   0:result:=5;
   else result:=((640 div ilist[xindex].s) div 2)*2;
   end;//case

   //range
   result:=frcmin32(result,1);
   end;
begin
//defaults
result :=true;//pass-thru
a      :=nil;

//check
if not xvalidindex(xindex) then exit;

try
//init
a           :=misimg32(1,1);
dsize       :=ilist[xindex].s*dscale;
d           :=ilist[xindex].i;

//clear
missize(d,dsize,dsize);
mis__cls(d,0,0,0,0);

//get
if misempty(a) and (sfilename<>'') then
   begin
   if strmatch('**paste**',sfilename) then
      begin
      if not clip__pasteimage(a) then goto skipend;
      mis__onecell(a);
      xcopyfrom(a);
      end
   else if mis__fromfile(a,sfilename,e) then
      begin
      mis__onecell(a);
      xcopyfrom(a);
      end
   else
      begin
      missize(a,1,1);
      mis__cls(a,0,0,0,0);
      xcopyfrom(a);//06jun2025
      end;
   end;

if misempty(a) and (not misempty(s)) then xcopyfrom(s);

//special up scale case
if (xindex=0) and (not strmatch(sfilename,ximgfile(0))) then xpushimg(-1,a,'');

skipend:
except;end;
//free
freeobj(@a);
end;

procedure tmicon.xsyncresample;
var
   p:longint;
begin

if iupscale and (imaster>=1) and low__setstr(iscaleimgref,k64(ilist[0].id)) then
   begin
   //image0 -> iscaleimg
   miscopy(ilist[0].i,iscaleimg);

   //a light touch of blur
   for p:=1 to 2 do misblur82432b(iscaleimg,true,150,clnone);
   end;
end;

function tmicon.xfindindex(sx,sy:longint):longint;
var
   p:longint;
begin
result:=-1;

for p:=0 to high(ilist) do if area__within(ilist[p].a,sx,sy) then
   begin
   result:=p;
   break;
   end;
end;

function tmicon._onnotify(sender:tobject):boolean;
var
   xmustpaint:boolean;
   xcode,xtepcolor,int1:longint;
   xcode2,str1:string;
begin
//defaults
result      :=false;
xmustpaint  :=false;

try

//hover + focus + help
if gui.mousemoved or gui.mousedownstroke then
   begin

   //hover
   if low__setint(ihoverindex,xfindindex(mousemovexy.x,mousemovexy.y)) then xmustpaint:=true;

   if low__setbol(ilanghover,area__within2(ilangarea,mousemovexy))    then xmustpaint:=true;//14sep2024

   //focus
   if gui.mousedownstroke then
      begin
      inewfocus:=low__setint(ifocusindex,ihoverindex);
      if inewfocus then xmustpaint:=true;
      end;

   //help
   if (ihoverindex>=0) then
      begin

      case xcanchange(ihoverindex) of
      true:help:='Change Image|Click to load an image, or drag and drop an image onto this image, or right click for menu, or drag this image to another image'
      else help:='Change Image|This image is in Master mode, and is sourced directly from the Master image.  To change this image, change the Master image (far left).';
      end;

      end
   else help:='';

   end;

//dragdrop.start
if gui.mousemoved and (not gui.mousedownstroke) and (ifocusindex>=0) and (imaster<=0) and area__valid(ilist[ifocusindex].a) and gui.mousedragging and (not gui.dragdrop_active) then
   begin
   gui.dragdrop_start2(0,0,1,1,32,32,ilist[ifocusindex].o,intstr32(ifocusindex));
   end;

//action
if gui.mouseupstroke and (ifocusindex>=0) then
   begin

   //dragdrop.stop
   if gui.dragdrop_stop(str1) and (imaster<=0) then
      begin
      int1:=strint32(str1);
      if xvalidindex(int1) and xvalidindex(ihoverindex) and (int1<>ihoverindex) then xpushimg(ihoverindex,ilist[int1].i,'');
      end

   //open file
   else if gui.mouseleft then
      begin
      if xcanchange(ifocusindex) and (not inewfocus) and (not gui.dragdrop_active) then xopenimg(ifocusindex);
      end

   //showmenu
   else if gui.mouseright then showmenu2('menu.image');

   end
else if gui.mouseupstroke and ilanghover then
   begin

   showmenu2('langid');

   end;


//paint
if xmustpaint then paintnow;
except;end;
end;

procedure tmicon.xopenimg(xindex:longint);
begin
try
if xvalidindex(xindex) and gui.popopenimg(ilastopenfile,ilastopenfilter,'') then
   begin
   xloadimg(xindex,ilastopenfile);
   xsaveimg(xindex);
   paintnow;
   end;
except;end;
end;

function tmicon.xvalidindex(xindex:longint):boolean;
begin
result:=(xindex>=0) and (xindex<=high(ilist));
end;

function tmicon.xsafeindex(xindex:longint):longint;
begin
result:=frcrange32(xindex,0,high(ilist));
end;

function tmicon.ximgext:string;
begin
result:='img32';
end;

function tmicon.ximgfile(xindex:longint):string;
begin
result:=app__settingsfile('image'+intstr32(xindex)+'.'+ximgext);
end;

function tmicon.xmaskfile(xindex:longint):string;
begin
result:=app__settingsfile('mask'+insstr(intstr32(xindex),xindex<>1)+'.'+ximgext);
end;

procedure tmicon.xloadimg(xindex:longint;xfromfile:string);
begin
if xvalidindex(xindex) then
   begin
   if (xfromfile='') then xfromfile:=ximgfile(xindex);
   xpushimg(xindex,nil,xfromfile);
   end;
end;

procedure tmicon.xsaveimg(xindex:longint);
var
   e:string;
begin
if xvalidindex(xindex) then
   begin
   case misempty(ilist[xindex].i) of
   false:mis__tofile(ilist[xindex].i,ximgfile(xindex),ximgext,e);
   else  io__remfile(ximgfile(xindex));
   end;//case
   end;
end;

procedure tmicon.xclearimg(xindex:longint);
begin
if xvalidindex(xindex) then
   begin
   mis__cls(ilist[xindex].i,0,0,0,0);
   low__irollone(ilist[xindex].id);
   end;
end;

function tmicon._onaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
var
   xmustpaint:boolean;
begin
//handled
result:=true;

try
//update hoverindex in realtime
case (imaster>=1) of
true:xmustpaint:=low__setint(ihoverindex,0);
else xmustpaint:=low__setint(ihoverindex,xfindindex(cursorxy.x,cursorxy.y));
end;

//load image file to current selected image
if (xindex=0) and xvalidindex(ihoverindex) and xcanchange(ihoverindex) and io__fileexists(xfilename) then
   begin
   xloadimg(ihoverindex,xfilename);
   xsaveimg(ihoverindex);
   xmustpaint:=true;
   end;

if xmustpaint then paintnow;
except;end;
end;

//xxxxxxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111111111
procedure tmicon._onpaint(sender:tobject);
var
   a:tclientinfo;
   xusetab,xdetailsbottom,v,p,xsize,xhoverindex,xfocusindex,xnext,xzoom,hpad,vpad,dx,dy,dy0:longint;
   xtab,str1:string;
   xtmp:tstr8;
   xislang:boolean;

   procedure xdraw(xindex:longint;var dx,dy:longint);
   var
      ha,da:twinrect;
      tx,ty,vsep:longint;
      xcap:string;
      ximg:tbasicimage;
      xfocus:boolean;

      procedure mw(x:longint);//max width
      begin
      inc(x,ilist[xindex].a.left);
      if (x>ilist[xindex].a.right) then ilist[xindex].a.right:=x;
      end;
   begin
   //range
   xindex:=frcrange32(xindex,0,high(ilist));
   xfocus:=(xindex=xhoverindex) or (xindex=xfocusindex);

   //init
   vsep             :=3*xzoom;
   xcap             :=ilist[xindex].c;
   ximg             :=ilist[xindex].o;
   xsize            :=ilist[xindex].s*xzoom;
   ilist[xindex].a  :=area__make(dx,dy,dx,dy);

   if (xcap='') then
      begin
      xcap:=insstr('ICO: ',xindex=1)+insstr('Master  ',(xindex=0) and (imaster>=1))+insstr('PNG: ',xindex=0)+k64(ilist[xindex].s)+' px';
      end;

   //calc
   tx:=dx;
   ty:=dy-(2*a.zoom);
   mw(low__fonttextwidth2(a.fn,xcap));
   inc(dy,a.fnH);
   inc(dy,vsep);

   da:=area__make(dx,dy,dx+xsize-1,dy+xsize-1);

   //cls
//was:   if (xindex=xlistindex) then ldso2(area__grow(da,3*xzoom),clnone,clnone,a.bk_10,a.bk10,clnone,0,vishadestyle,false);

   //frame
   if ishowframe then
      begin
      ha:=area__grow(da,1);
      ldo(ha,a.hover2,false);
      ha:=area__grow(da,2);
      ldo(ha,a.hover2,false);
      end
   else ha:=da;

   //focus highlight
   if xfocus then
      begin
      ha.bottom:=da.bottom+5+(6*a.zoom);
      lds(area__make(ha.left,da.bottom+5,ha.right,ha.bottom),a.hover2,false);
      end;


   ldbEXCLUDE(true,low__aorbrect(da,ha,vimaintainhighlight),false);

   //title
   ldtTAB2(clnone,tbnone,a.ci,tx,ty,a.font,xcap,a.fn,a.f,false,false,false,false,a.r);

   //image
   v:=insint(igridsize,iflashON);
   case ibackmode of
   min32..0:ldc32(da,da.left,da.top,xsize+1,xsize,area__make(v,0,v+xsize-1,xsize-1),igrid,255,false);//checker
   else if (findbackcolor<>clnone) then lds(da,findbackcolor,false);
   end;//case

   if not misempty(ximg) then ldc32(da,da.left,da.top,xsize,xsize,misarea(ximg),ximg,255,false);

   mw(xsize);
   inc(dy,xsize);
   ilist[xindex].a.bottom:=dy;
   inc(dy,vsep);

   //bottom space
   inc(dy,2*vsep);

   //next
   xnext:=ilist[xindex].a.right;
   end;

   procedure xnextcol;
   begin
   dx:=xnext + round(1.3*hpad);
   dy:=dy0;
   end;

   function xlangid:string;
   var
      n,xcaption,xlabel:string;
      xcode,xindex:longint;
   begin

   if res__findlanginfo(ilangid,xcaption,xlabel,xcode,xindex) then n:=xcaption else n:='Custom';
   result  :='language is '+intstr32(ilangid)+' ('+n+')';

   end;

begin
try
//defaults
xtmp:=nil;

//init
infovars(a);
xzoom       :=vizoom;
hpad        :=30*xzoom;
vpad        :=30*xzoom;
dx          :=a.ci.left+round(2*hpad);
xnext       :=dx;
dy0         :=a.ci.top + round(3.5*vpad);
dy          :=dy0;
xhoverindex :=ihoverindex;
xfocusindex :=ifocusindex;

//cls
lds(a.cs,a.back,false);

//256
xdraw(0,dx,dy);

//64 .. 16
for p:=1 to high(ilist) do
begin
xnextcol;
xdraw(p,dx,dy);
end;

//information
dx:=ilist[1].a.left;
dy:=ilist[0].a.bottom-a.fnH+(2*a.fnH);
v :=11*a.fnH;//total text height -> over allow by 1 row for spacing

if ((dy-v)<ilist[1].a.bottom) then dy:=ilist[1].a.bottom+v;

xdetailsbottom:=dy+a.fnH;

for p:=(4+high(ilist)) downto -1 do
begin

xusetab :=1;
xislang :=false;

if (p=-1) then
   begin
   //str1:='Details';
   str1:='Format' +#9+ 'Size' +#9+ 'Bits' +#9+ 'Colors';
   //xusetab:=false;
   end
else if xvalidindex(p) then str1:=ilist[p].f +#9+ k64(ilist[p].s)+' x '+k64(ilist[p].s) +#9+ k64(misai(ilist[p].o).bpp) +#9+ k64(ilist[p].cc)

else if (p=(2+high(ilist))) then
   begin
   str1:='Format Storage Size';
   xusetab:=0;
   end
else if (p=(3+high(ilist))) then str1:='ICO'+#9+k64(iico_bytes)+' b'
else if (p=(4+high(ilist))) then
   begin
   str1:='RES'+#9+k64(ires_bytes)+' b'+#9+xlangid;
   xusetab :=2;
   xislang :=true;
   end
else                             str1:='';

if (str1<>'') then
   begin

   case xusetab of
   1    :xtab:='L50;R100;R70;R95;';
   2    :xtab:='L50;R100;L250;';
   else  xtab:='';
   end;//case

   if xislang then ilangarea:=area__make(dx,dy,dx+low__fonttextwidthTAB2(xtab,a.fn,str1),dy+a.fnH-1);

   case xislang and ilanghover of
   true:begin

      ldsoSHADE(ilangarea,int__splice24(0.15,a.font,a.back),a.font,clnone,0,'g-50',true,a.r);
      ldtTAB2(clnone,xtab,a.ci,dx,dy,a.back,str1,a.fn,a.f,false,false,false,false,a.r);

      end;
   else ldtTAB2(clnone,xtab,a.ci,dx,dy,a.font,str1,a.fn,a.f,false,false,false,false,a.r);
   end;//case

   end;

dec(dy,a.fnH);
end;

//links
dx:=ilist[0].a.left;
dy:=frcmin32(xdetailsbottom,ilist[0].a.bottom+(vpad div 2));

//corners
xparentcorners;
except;end;
//free
freeobj(@xtmp);
end;


//## tapp ######################################################################
constructor tapp.create;
const
   xscaleh   =0.75;
   xscalevpad=0.10;
var
   slabel,shelp,scmd,sshape:string;
   step,p:longint;
begin
if system_debug then dbstatus(38,'Debug 010 - 21may2021_528am');//yyyy


//check source code for know problems ------------------------------------------
//io__sourecode_checkall(['']);


//self
inherited create(strint32(app__info('width')),strint32(app__info('height')),true);
ibuildingcontrol:=true;
iloaded:=false;
isettingsref:='';
itoolbar1:=nil;
itoolbar2:=nil;
itoolbar3:=nil;

//need checkers
need_jpeg;
need_gif;
need_ico;

//init
itimer500 :=ms64;

//vars
iloaded:=false;


//controls
with rootwin do
begin
scroll:=false;
xhead;
xgrad;
xgrad2;
xstatus2.celltext[0]:=app__info('des');
xstatus2.cellalign[0]:=0;

with xtoolbar2 do
begin
oheadalign:=true;

add('Resample',tepEye20,0,'micon.upscale','Resample|Resample Master image to improve quality of a distorted or poor quality image');

add('Master',tepNew20,0,'micon.master1','Image Source|Dynamically source images from Master');
add('Master 2',tepNew20,0,'micon.master2','Image Source|Dynamically source images from Master and soften');
add('Master 3',tepNew20,0,'micon.master3','Image Source|Dynamically source images from Master and soften more');
add('Individual',tepNew20,0,'micon.master0','Image Source|Source images individually');

addsep;
add('Clear All',tepClose20,0,'micon.clear','Images|Clear all images');
add('Copy',tepCopy20,0,'micon.copy','Image|Copy image to Clipboard');
add('Copy Raw',tepCopy20,0,'micon.copyraw','Image|Copy raw image to Clipboard');
add('Paste',tepPaste20,0,'micon.paste','Image|Paste image from Clipboard');
add('Open',tepOpen20,0,'micon.open','Image|Open an image from file');

addsep;
add('Save ICO',tepSaveAs20,0,'micon.saveico','Save Icon|Save multi-resolution icon to file');
add('Save RES',tepSaveAs20,0,'micon.saveres','Save Resource|Save multi-resolution icon resource (mainicon) to file');
end;


//column #1
with xcols.makecol(0,120,false) do
begin
icore:=tmicon.create(client);
end;

//column #2
with xcols.makecol(1,20,true) do
begin
mtitleplain('Shape','Shape|Apply a mask shape to all images');

itoolbar1:=client.ntoolbar('');
with itoolbar1 do
begin
halign:=0;
oscaleh:=xscaleh;
oscalevpad:=xscalevpad;
for p:=0 to max32 do if icore.xshapeinfo(p,step,slabel,shelp,scmd,sshape) then ab(step,slabel,shelp,scmd) else break;
end;//toolbar

end;//column

//column #3
with xcols.makecol(2,20,true) do
begin

mtitleplain('Options','Options|Apply one or more options to all images');
itoolbar2:=client.ntoolbar('');
with itoolbar2 do
begin
halign:=0;
oscaleh:=xscaleh;
oscalevpad:=xscalevpad;
ab(tepMirror20,'Mirror','Mirror|Flip horizontally','micon.mirror');
ab(tepFlip20,'Flip','Flip|Flip vertically','micon.flip');
ab(tepRotate20,'0','Rotate|No rotate','micon.rotate0');
ab(tepRotate20,'90','Rotate|Rotate right 90 degrees','micon.rotate90');
ab(tepRotate20,'180','Rotate|Rotate right 180 degrees','micon.rotate180');
ab(tepRotate20,'270','Rotate|Rotate right 270 degrees','micon.rotate270');
ab(tep__yes(false),'Force','Mask Mode|Force image to adhere to selected mask, removing any image specific transparency','micon.maskdel');
ab(tep__yes(false),'High','Master|Set PNG quality to high','micon.quality0');
ab(tep__yes(false),'Medium','Master|Set PNG quality to medium','micon.quality1');
ab(tep__yes(false),'Low','Master|Set PNG quality to low','micon.quality2');
end;//toolbar

mtitleplain('Preview','Preview|Adjust preview display style');
itoolbar3:=client.ntoolbar('');
with itoolbar3 do
begin
halign:=0;
oscaleh:=xscaleh;
oscalevpad:=xscalevpad;
ab(tepOutline20,'Outline','Outline|Toggle outline guide for image boundary','micon.frame');

for p:=0 to max32 do if icore.xbackinfo(p,step,slabel,shelp,scmd) then ab(step,slabel,shelp,scmd) else break;

end;//toolbar

end;//column


end;


with rootwin.xhead do
begin
add('Copy',tepCopy20,0,'micon.copy','Image|Copy image to Clipboard');
add('Paste',tepPaste20,0,'micon.paste','Image|Paste image from Clipboard');
add('Open',tepOpen20,0,'micon.open','Image|Open an image from file');
addsep;
add('Save ICO',tepSaveAs20,0,'micon.saveico','Save Icon|Save multi-resolution icon to file');
add('Save RES',tepSaveAs20,0,'micon.saveres','Save Resource|Save multi-resolution icon resource (mainicon) to file');
addsep;
xaddoptions;
xaddhelp;
end;


//default page to show
rootwin.xhead.parentpage:='overview';

//events
itoolbar1.onclick:=__onclick;
itoolbar2.onclick:=__onclick;
itoolbar3.onclick:=__onclick;
rootwin.xhead.onclick:=__onclick;
rootwin.xhead.showmenuFill1:=xshowmenuFill1;
rootwin.xhead.showmenuClick1:=xshowmenuClick1;
rootwin.xhead.ocanshowmenu:=true;//use toolbar for special menu display - 18dec2021
rootwin.xtoolbar2.onclick:=__onclick;
rootwin.onaccept:=icore._onaccept;//drag and drop support

//start timer event
ibuildingcontrol:=false;
xloadsettings;

//finish
createfinish;
end;

destructor tapp.destroy;
begin
try
//settings
xautosavesettings;

//self
inherited destroy;
except;end;
end;

procedure tapp.ab(xtep:longint;xname,xhelp,xcmd:string);//add button
var
   t:tbasictoolbar;
begin
if      (itoolbar3<>nil) then t:=itoolbar3
else if (itoolbar2<>nil) then t:=itoolbar2
else                          t:=itoolbar1;

if (t<>nil) then
   begin
   with t do
   begin
   add(xname,xtep,0,xcmd,xhelp);
   newline;
   end;
   end;
end;

procedure tapp.xupdatebuttons;
var
   slabel,shelp,scmd,sshape:string;
   xcancopy,xcanpaste,xcansave,xcanopen:boolean;
   step,p:longint;
begin
try

//init
xcancopy                    :=icore.cancopy;
xcanpaste                   :=icore.canpaste;
xcansave                    :=icore.cansave;
xcanopen                    :=icore.canopen;


with rootwin.xtoolbar2 do
begin
benabled2['micon.upscale']  :=(icore.master>=1);

bmarked2['micon.upscale']   :=icore.upscale;
bmarked2['micon.master0']   :=(icore.master=0);
bmarked2['micon.master1']   :=(icore.master=1);
bmarked2['micon.master2']   :=(icore.master=2);
bmarked2['micon.master3']   :=(icore.master=3);

benabled2['micon.clear']    :=icore.canclear;
benabled2['micon.copy']     :=xcancopy;
benabled2['micon.copyraw']  :=icore.cancopyraw;
benabled2['micon.paste']    :=xcanpaste;
benabled2['micon.open']     :=xcanopen;

bhelp2['micon.copy']        :=icore.copyhint(false);
bhelp2['micon.copyraw']     :=icore.copyhint(true);

benabled2['micon.saveico']  :=xcansave;
benabled2['micon.saveres']  :=xcansave;
end;

with rootwin.xhead do
begin
bhelp2['micon.copy']        :=icore.copyhint(false);
benabled2['micon.copy']     :=xcancopy;
benabled2['micon.paste']    :=xcanpaste;
benabled2['micon.open']     :=xcanopen;
benabled2['micon.saveico']  :=xcansave;
benabled2['micon.saveres']  :=xcansave;
end;

//.shapes
for p:=0 to max32 do if icore.xshapeinfo(p,step,slabel,shelp,scmd,sshape) then itoolbar1.bmarked2[scmd]:=strmatch(icore.shape,sshape) else break;

//.options
with itoolbar2 do
begin
bmarked2['micon.flip']      :=icore.flip;
bmarked2['micon.mirror']    :=icore.mirror;
bmarked2['micon.rotate0']   :=(icore.rotate=0);
bmarked2['micon.rotate90']  :=(icore.rotate=90);
bmarked2['micon.rotate180'] :=(icore.rotate=180);
bmarked2['micon.rotate270'] :=(icore.rotate=270);

benabled2['micon.maskdel']:=icore.canforce;

btep2['micon.maskdel']:=tep__yes(icore.maskdel);
btep2['micon.quality0']:=tep__yes(icore.pngQuality=0);
btep2['micon.quality1']:=tep__yes(icore.pngQuality=1);
btep2['micon.quality2']:=tep__yes(icore.pngQuality=2);

bmarked2['micon.maskdel']:=icore.maskdel;
bmarked2['micon.quality0']:=(icore.pngQuality=0);
bmarked2['micon.quality1']:=(icore.pngQuality=1);
bmarked2['micon.quality2']:=(icore.pngQuality=2);
end;

//.settings
with itoolbar3 do
begin

for p:=0 to max32 do
begin
if not icore.xbackinfo0(p,scmd) then break;
bmarked2[scmd]:=(icore.backmode=p);
btep2[scmd]   :=tep__yes(icore.backmode=p);
end;

bmarked2['micon.frame']:=icore.showframe;

end;

except;end;
end;

procedure tapp.xcmd(sender:tobject;xcode:longint;xcode2:string);
label
   skipend;
var
   e:string;

   function m(x:string):boolean;
   begin
   result:=strmatch(x,xcode2);
   end;
begin//use for testing purposes only - 15mar2020
try
//defaults
e:='';

//init
if zzok(sender,7455) and (sender is tbasictoolbar) then
   begin
   //ours next
   xcode:=(sender as tbasictoolbar).ocode;
   xcode2:=strlow((sender as tbasictoolbar).ocode2);
   end;

//get
if icore.cancmd(xcode2) then icore.cmd(xcode2);

//successful
skipend:
except;end;
if (e<>'') then gui.popstatus(e,2);
end;


procedure tapp.xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
begin
try
//check
if zznil(xmenudata,5000) then exit;

except;end;
end;

function tapp.xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
result:=true;xcmd(nil,0,xcode2);
end;

procedure tapp.xloadsettings;
var
   a:tvars8;
begin
try
//defaults
a:=nil;
//check
if zznil(prgsettings,5001) then exit;

//init
a:=vnew2(950);
//filter
a.i['langid']         :=prgsettings.idef('langid',1033);//English-US - 15sep2025
a.i['png.quality']    :=prgsettings.idef('png.quality',0);
a.i['backmode']       :=prgsettings.idef('backmode',0);
a.i['backcolor']      :=prgsettings.idef('backcolor',rgba0__int(127,127,127));
a.b['showframe']      :=prgsettings.bdef('showframe',true);
a.b['autoresample']   :=prgsettings.bdef('autoresample',true);
a.b['smoothresample'] :=prgsettings.bdef('smoothresample',true);
a.s['shape']          :=prgsettings.sdef('shape','');
a.i['rotate']         :=prgsettings.idef('rotate',0);
a.b['flip']           :=prgsettings.bdef('flip',false);
a.b['mirror']         :=prgsettings.bdef('mirror',false);
a.i['master']         :=prgsettings.idef('master',0);
a.b['upscale']        :=prgsettings.bdef('upscale',false);
a.b['maskdel']        :=prgsettings.bdef('maskdel',true);//09jun2025
//sync
prgsettings.data:=a.data;

//set
icore.langid         :=a.i['langid'];
icore.pngquality     :=a.i['png.quality'];
icore.backmode       :=a.i['backmode'];
icore.backcolor      :=a.i['backcolor'];
icore.showframe      :=a.b['showframe'];
icore.shape          :=a.s['shape'];
icore.rotate         :=a.i['rotate'];
icore.flip           :=a.b['flip'];
icore.mirror         :=a.b['mirror'];
icore.master         :=a.i['master'];
icore.upscale        :=a.b['upscale'];
icore.maskdel        :=a.b['maskdel'];

except;end;
//free
freeobj(@a);
iloaded:=true;
end;

procedure tapp.xsavesettings;
var
   a:tvars8;
begin
try
//check
if not iloaded then exit;

//defaults
a:=nil;
a:=vnew2(951);

//get
a.i['langid']         :=icore.langid;//14sep2025
a.i['png.quality']    :=icore.pngquality;
a.i['backmode']       :=icore.backmode;
a.i['backcolor']      :=icore.backcolor;
a.b['showframe']      :=icore.showframe;
a.s['shape']          :=icore.shape;
a.i['rotate']         :=icore.rotate;
a.b['flip']           :=icore.flip;
a.b['mirror']         :=icore.mirror;
a.i['master']         :=icore.master;
a.b['upscale']        :=icore.upscale;
a.b['maskdel']        :=icore.maskdel;

//set
prgsettings.data:=a.data;
siSaveprgsettings;
except;end;
//free
freeobj(@a);
end;

procedure tapp.xautosavesettings;
begin
if iloaded and low__setstr(isettingsref,icore.settingsref) then xsavesettings;
end;

procedure tapp.__onclick(sender:tobject);
begin
try;xcmd(sender,0,'');except;end;
end;

procedure tapp.__ontimer(sender:tobject);//._ontimer
begin
try
//timer500
if iloaded and ((ms64>=itimer500) or icore.ohostmustupdate) then
   begin
   //reset
   icore.ohostmustupdate:=false;

   //savesettings
   xautosavesettings;

   //update buttons
   xupdatebuttons;

   //reset
   itimer500:=ms64+500;
   end;

//timer
if iloaded then icore.xtimer;

//debug tests
if system_debug then debug_tests;
except;end;
end;

function make__shape32(s,scustom,scustom2:tobject;xshape:string;xoverridemask:boolean):boolean;//10jun2025
label
   skipend;
var
   a:tbasicimage;//pointer only
   dm,sm:tbasicimage;
   int1,sw,sh:longint;

   procedure xload(const x:array of byte);
   var
      e:string;
   begin
   mis__fromadata(sm,x,e);
   end;

   procedure mload(const s256,s64,s48,s32,s24,s16:array of byte);
   begin
   case sw of
   256..max32:xload(s256);
   64        :xload(s64);
   48        :xload(s48);
   32        :xload(s32);
   24        :xload(s24);
   16        :xload(s16);
   else       xload(s64);
   end;//case
   end;
begin
//defaults
result:=false;
sm    :=nil;
dm    :=nil;

//check
if not misok32(s,sw,sh) then exit;

try
//init
xshape:=strlow(xshape);

//check
if (xshape='asis') then
   begin
   result:=true;
   goto skipend;
   end;

//solid
if (xshape='square') then
   begin
   mask__setval(s,255);
   result:=true;
   goto skipend;
   end;

//transparent
if (xshape='transparent') then
   begin
   mask__setval(s,255);
   mask__feather2(s,s,0,clTopLeft,false,int1);
   result:=true;
   goto skipend;
   end;

//get
sm:=misimg32(1,1);

//.circle
if      (xshape='circle')    then mload(template_circle_256,template_circle_64,template_circle_48,template_circle_32,template_circle_24,template_circle_16)
else if (xshape='circle2')   then xload(template_circle2_256)
else if (xshape='circle3')   then xload(template_circle3_256)

//.squircle
else if (xshape='squircle')  then mload(template_squircle_256,template_squircle_64,template_squircle_48,template_squircle_32,template_squircle_24,template_squircle_16)
else if (xshape='squircle2') then mload(template_squircle2_256,template_squircle2_64,template_squircle2_48,template_squircle2_32,template_squircle2_24,template_squircle2_16)
else if (xshape='squircle3') then mload(template_squircle3_256,template_squircle3_64,template_squircle3_48,template_squircle3_32,template_squircle3_24,template_squircle3_16)
else if (xshape='squircle4') then xload(template_squircle4_256)

//.diamond
else if (xshape='diamond')   then mload(template_diamond_256,template_diamond_64,template_diamond_48,template_diamond_32,template_diamond_24,template_diamond_16)
else if (xshape='diamond2')  then mload(template_diamond2_256,template_diamond2_64,template_diamond2_48,template_diamond2_32,template_diamond2_24,template_diamond2_16)

//.square
else if (xshape='square2')   then xload(template_square2_256)
else if (xshape='square3')   then xload(template_square3_256)

//.rings
else if (xshape='rings')     then mload(template_rings_256,template_rings_64,template_rings_48,template_rings_32,template_rings_24,template_rings_16)

//.custom
else if (xshape='custom')  then miscopy(scustom,sm)
else if (xshape='custom2') then miscopy(scustom2,sm);

//fallback
if misempty(sm) then
   begin
   missize(sm,sw,sh);
   mis__cls(sm,0,0,0,255);
   end;

//scale "sm" down to "dm"
if (misw(sm)<>sw) or (mish(sm)<>sh) then
   begin
   dm:=misimg32(sw,sh);
   mis__resample(misarea(dm),0,0,sw,sh,misarea(sm),dm,sm,false);//do not use smooth(TRUE) as this causes loss of faint/subtle mask values - 10jun2025
   a :=dm;
   end
else a:=sm;

//set
if xoverridemask then mask__copy(a,s) else mask__add(a,s);

//successful
result:=true;
skipend:
except;end;
//free
freeobj(@sm);
freeobj(@dm);
end;

function mask__add(s,d:tobject):boolean;
label//extracts 8bit alpha from a32 and copies it to a8
     //note: strancols adds transparency to existing mask as it copies it over
     //note: sremove=0..255 = removes original mask as its copied over
   skipend;
var
   sx,sy,sw,sh,sbits,dbits,dw,dh:longint;
   sr8,dr8:pcolorrow8;
   sr24,dr24:pcolorrow24;
   sr32,dr32:pcolorrow32;

   procedure xadd(var d:byte;const s:byte);
   begin
   d:=smallest32(d,s);
   end;
begin
//defaults
result:=false;

try
//check
if not misok82432(s,sbits,sw,sh) then exit;
if not misok82432(d,dbits,dw,dh) then exit;
if (sw>dw) or (sh>dh) then exit;

//get
//.dy
for sy:=0 to (sh-1) do
begin
if not misscan82432(s,sy,sr8,sr24,sr32) then goto skipend;
if not misscan82432(d,sy,dr8,dr24,dr32) then goto skipend;

//.32 + 32
if (sbits=32) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do xadd(dr32[sx].a,sr32[sx].a);
   end
//.32 + 24
else if (sbits=32) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.32 + 8
else if (sbits=32) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do xadd(dr8[sx],sr32[sx].a);
   end
//.24 + 32
else if (sbits=24) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do dr32[sx].a:=255;
   end
//.24 + 24
else if (sbits=24) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.24 + 8
else if (sbits=24) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do dr8[sx]:=255;
   end
//.8 + 32
else if (sbits=8) and (dbits=32) then
   begin
   for sx:=0 to (sw-1) do xadd(dr32[sx].a,sr8[sx]);
   end
//.8 + 24
else if (sbits=8) and (dbits=24) then
   begin
   result:=true;
   goto skipend;
   end
//.8 + 8
else if (sbits=8) and (dbits=8) then
   begin
   for sx:=0 to (sw-1) do xadd(dr8[sx],sr8[sx]);
   end;
end;//dy
//successful
result:=true;
skipend:
except;end;
end;

function mis__resample(da_clip:twinrect;ddx,ddy,ddw,ddh:currency;sa:twinrect;d,s:tobject;xsmoothresample:boolean):boolean;
begin
result:=mis__copyAVE82432(da_clip,ddx,ddy,ddw,ddh,sa,d,s,xsmoothresample);
end;

function mis__bwTOba32(s:tobject):boolean;//black and white -> black and alpha
label
   skipend;
var
   sr32:pcolorrow32;
   c32:tcolor32;
   vlum,da,sx,sy,sw,sh:longint;
begin
//defaults
result:=false;

//check
if not misok32(s,sw,sh) then exit;

try
//init

//get
for sy:=0 to (sh-1) do
begin

if not misscan32(s,sy,sr32) then goto skipend;

for sx:=0 to (sw-1) do
begin
//get
c32 :=sr32[sx];
vlum:=c32__lum(c32);
//.treat all shades of white as fully white
//was: if (vlum>=240) then vlum:=255;

//.convert brightness into alpha value
da:=255-vlum;

//set
c32.r:=0;
c32.g:=0;
c32.b:=0;
c32.a:=da;
sr32[sx]:=c32;
end;//sx
end;//sy

//successful
result:=true;
skipend:
except;end;
end;

end.
