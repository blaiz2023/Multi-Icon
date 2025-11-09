program multiicon;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  main,
  gossgui,
  gossdat,
  gossimg,
  gossio,
  gossnet,
  gossroot,
  gosssnd,
  gosswin,
  gosszip,
  gossjpg;
  { you can add units after this }


//{$R *.RES}
//include multi-format icon - Delphi 3 can't compile an icon of 256x256 @ 32 bit -> resource error/out of memory error - 19nov2024
{$R multiicon-256.res}

//include app version information
{$R ver.res}

begin
//(1)false=event driven disabled, (2)false=file handle caching disabled, (3)true=gui app mode
app__boot(true,false,not isconsole);
end.
