unit cArquivoIni;

interface

uses System.Classes,
     Vcl.Controls,
     Vcl.ExtCtrls,
     Vcl.Dialogs,
     System.SysUtils,
     System.IniFiles,
     Vcl.Forms;

type
  TArquivoIni = class
  private

  public
    class function ArquivoIni:string; static;
    class function LerIni(aSecao:String; aEntrada:string):String; static;
    class procedure AtualizarIni (asecao, aEntrada, aValor: string); static;

  end;

implementation

{ TArquivoIni }

class function TArquivoIni.ArquivoIni: string;
begin
  result:= ChangeFileExt(Application.ExeName, '.INI' )
end;

class procedure TArquivoIni.AtualizarIni(asecao, aEntrada, aValor: string);
var Ini:TIniFile;
begin
  try
    Ini := TIniFile.Create(ArquivoIni);
    Ini.WriteString(asecao, aEntrada, aValor);
  finally
    Ini.Free;
  end;
end;

class function TArquivoIni.LerIni(aSecao, aEntrada: string): String;
var Ini:TIniFile;
begin
  try
    Ini := TIniFile.Create(ArquivoIni);
    Result := Ini.ReadString(aSecao, aEntrada, 'NÂO ENCONTRADO' );
  finally
    Ini.Free;
  end;
end;

end.
