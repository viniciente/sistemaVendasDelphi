unit uDtmnConexao;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.IniFiles;

type
  TdtmConexao = class(TDataModule)
    FDConexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConfigurarConexaoDinamicamente;
    procedure CriarBancoSeNaoExistir;
    procedure CriarTabelasSeNaoExistirem;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmConexao : TdtmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses cAtualizacaoTabelaMSSQL;

procedure TdtmConexao.ConfigurarConexaoDinamicamente;
var
  LIni: TIniFile;
  CaminhoArquivo: string;
begin
  // Define o caminho: mesma pasta do executável + nome config.ini
  CaminhoArquivo := ExtractFilePath(ParamStr(0)) + 'config.ini';

  LIni := TIniFile.Create(CaminhoArquivo);
  try
    // Se o arquivo NÃO existir, vamos escrever os valores padrão de Vendas nele
    if not FileExists(CaminhoArquivo) then
    begin
      LIni.WriteString('BANCO', 'Driver', 'MSSQL');
      LIni.WriteString('BANCO', 'Servidor', 'DC-TR-06-VM\SERVERCURSO');
      LIni.WriteString('BANCO', 'NomeBanco', 'Vendas');
      LIni.WriteString('BANCO', 'AutenticacaoWindows', 'Yes');
      LIni.WriteString('BANCO', 'Usuario', 'DOMTEC\devmv');
    end;

    // Agora lemos do arquivo e passamos exatamente para as propriedades do FireDAC
    FDConexao.Params.Values['DriverID']  := LIni.ReadString('BANCO', 'Driver', 'MSSQL');
    FDConexao.Params.Values['Server']    := LIni.ReadString('BANCO', 'Servidor', 'DC-TR-06-VM\SERVERCURSO');
    FDConexao.Params.Values['Database']  := LIni.ReadString('BANCO', 'NomeBanco', 'Vendas');
    FDConexao.Params.Values['OSAuthent'] := LIni.ReadString('BANCO', 'AutenticacaoWindows', 'Yes');
    FDConexao.Params.Values['User_Name'] := LIni.ReadString('BANCO', 'Usuario', 'DOMTEC\devmv');

    FDConexao.LoginPrompt := False;
  finally
    LIni.Free;
  end;
end;

procedure TdtmConexao.CriarBancoSeNaoExistir;
var
  NomeBanco: String;
begin

  NomeBanco :=
    FDConexao.Params.Values['Database'];

  // conecta no MASTER primeiro
  FDConexao.Params.Values['Database'] := 'master';

  FDConexao.Connected := True;

  // cria banco se não existir
  FDConexao.ExecSQL(
    'IF NOT EXISTS ('+
    ' SELECT * FROM sys.databases '+
    ' WHERE name = ' + QuotedStr(NomeBanco) +
    ') '+
    'BEGIN '+
    ' CREATE DATABASE [' + NomeBanco + '] '+
    'END'
  );

  FDConexao.Connected := False;

  // reconecta no banco correto
  FDConexao.Params.Values['Database'] :=
    NomeBanco;

  FDConexao.Connected := True;

end;

procedure TdtmConexao.CriarTabelasSeNaoExistirem;
var
  oAtualizacao: TAtualizacaoTabelaMSSQL;
begin
  // Garante que a conexao esta ativa no banco correto antes de criar as tabelas
  if not FDConexao.Connected then
    FDConexao.Connected := True;

  oAtualizacao := TAtualizacaoTabelaMSSQL.Create(FDConexao);
  try
    oAtualizacao.Executar;
  finally
    FreeAndNil(oAtualizacao);
  end;
end;

procedure TdtmConexao.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexaoDinamicamente;
  CriarBancoSeNaoExistir;
  CriarTabelasSeNaoExistirem;
end;

end.
