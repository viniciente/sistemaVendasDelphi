unit uDtmnConexao;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.IniFiles, Vcl.Forms;

type
  TdtmConexao = class(TDataModule)
    FDConexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConfigurarConexao;
    procedure GerarConfigIniPadrao(const aCaminho: string);
    procedure CriarBancoSeNaoExistir;
    procedure CriarTabelasSeNaoExistirem;
  public
    { Public declarations }
  end;

var
  dtmConexao: TdtmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  Vcl.Dialogs,
  cAtualizacaoTabelaMSSQL;

procedure TdtmConexao.GerarConfigIniPadrao(const aCaminho: string);
var
  LArquivo: TStringList;
begin
  LArquivo := TStringList.Create;
  try
    LArquivo.Add('; =========================================================');
    LArquivo.Add('; Arquivo de configuração do sistema');
    LArquivo.Add('; Edite os campos abaixo com as informações do seu servidor');
    LArquivo.Add('; =========================================================');
    LArquivo.Add('');
    LArquivo.Add('[BANCO]');
    LArquivo.Add('');
    LArquivo.Add('; Driver do banco de dados (não alterar)');
    LArquivo.Add('Driver=MSSQL');
    LArquivo.Add('');
    LArquivo.Add('; Endereço do servidor SQL Server');
    LArquivo.Add('; Exemplos: MEUSERVIDOR\SQLEXPRESS  ou  192.168.1.10\SQLEXPRESS');
    LArquivo.Add('Servidor=MEUSERVIDOR\SQLEXPRESS');
    LArquivo.Add('');
    LArquivo.Add('; Nome do banco de dados (será criado automaticamente se não existir)');
    LArquivo.Add('NomeBanco=Vendas');
    LArquivo.Add('');
    LArquivo.Add('; Usar autenticação do Windows? (Yes = Sim / No = Não)');
    LArquivo.Add('; Se No, preencha Usuario e Senha abaixo');
    LArquivo.Add('AutenticacaoWindows=No');
    LArquivo.Add('');
    LArquivo.Add('; Usuário do SQL Server (usado quando AutenticacaoWindows=No)');
    LArquivo.Add('Usuario=sa');
    LArquivo.Add('');
    LArquivo.Add('; Senha do SQL Server (usado quando AutenticacaoWindows=No)');
    LArquivo.Add('Senha=');

    LArquivo.SaveToFile(aCaminho);
  finally
    LArquivo.Free;
  end;
end;

procedure TdtmConexao.ConfigurarConexao;
var
  LIni: TIniFile;
  LCaminho: string;
  LDriver, LServidor, LBanco, LAuthWindows, LUsuario, LSenha: string;
begin
  LCaminho := ExtractFilePath(ParamStr(0)) + 'config.ini';

  // Se não existir, cria o arquivo padrão e orienta o cliente
  if not FileExists(LCaminho) then
  begin
    GerarConfigIniPadrao(LCaminho);
    raise Exception.Create(
      'Arquivo de configuração criado em:' + sLineBreak +
      LCaminho + sLineBreak + sLineBreak +
      'Por favor, edite o arquivo config.ini com as ' +
      'informações do seu servidor SQL Server e abra o sistema novamente.'
    );
  end;

  LIni := TIniFile.Create(LCaminho);
  try
    LDriver       := LIni.ReadString('BANCO', 'Driver',               'MSSQL');
    LServidor     := LIni.ReadString('BANCO', 'Servidor',             '');
    LBanco        := LIni.ReadString('BANCO', 'NomeBanco',            'Vendas');
    LAuthWindows  := LIni.ReadString('BANCO', 'AutenticacaoWindows',  'No');
    LUsuario      := LIni.ReadString('BANCO', 'Usuario',              'sa');
    LSenha        := LIni.ReadString('BANCO', 'Senha',                '');
  finally
    LIni.Free;
  end;

  // Validação mínima: servidor não pode estar em branco
  if Trim(LServidor) = '' then
    raise Exception.Create(
      'O campo "Servidor" está em branco no config.ini.' + sLineBreak +
      'Preencha com o endereço do seu SQL Server e tente novamente.'
    );

  // Aplica os parâmetros no componente FireDAC
  FDConexao.Params.Clear;
  FDConexao.Params.Values['DriverID']  := LDriver;
  FDConexao.Params.Values['Server']    := LServidor;
  FDConexao.Params.Values['Database']  := LBanco;
  FDConexao.Params.Values['OSAuthent'] := LAuthWindows;

  // Autenticação SQL Server (usuário/senha) ou Windows
  if UpperCase(Trim(LAuthWindows)) = 'YES' then
  begin
    // Autenticação Windows: não precisa de usuário/senha
    FDConexao.Params.Values['OSAuthent'] := 'Yes';
  end
  else
  begin
    FDConexao.Params.Values['OSAuthent'] := 'No';
    FDConexao.Params.Values['User_Name'] := LUsuario;
    FDConexao.Params.Values['Password']  := LSenha;
  end;

  FDConexao.LoginPrompt := False;
end;

procedure TdtmConexao.CriarBancoSeNaoExistir;
var
  LNomeBanco: string;
begin
  LNomeBanco := FDConexao.Params.Values['Database'];

  // Conecta primeiro no master para poder criar o banco
  FDConexao.Params.Values['Database'] := 'master';
  FDConexao.Connected := True;

  FDConexao.ExecSQL(
    'IF NOT EXISTS (' +
    '  SELECT * FROM sys.databases WHERE name = ' + QuotedStr(LNomeBanco) +
    ') ' +
    'BEGIN ' +
    '  CREATE DATABASE [' + LNomeBanco + '] ' +
    'END'
  );

  // Desconecta e volta para o banco correto
  FDConexao.Connected := False;
  FDConexao.Params.Values['Database'] := LNomeBanco;
  FDConexao.Connected := True;
end;

procedure TdtmConexao.CriarTabelasSeNaoExistirem;
var
  oAtualizacao: TAtualizacaoTabelaMSSQL;
begin
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
  try
    ConfigurarConexao;
    CriarBancoSeNaoExistir;
    CriarTabelasSeNaoExistirem;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      // Encerra a aplicação se não conseguir conectar,
      // pois não faz sentido continuar sem banco.
      Application.Terminate;
    end;
  end;
end;

end.
