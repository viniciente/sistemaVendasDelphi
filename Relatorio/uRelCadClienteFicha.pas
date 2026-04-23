unit uRelCadClienteFicha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDtmnConexao, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, RLReport, RLFilters, RLPDFFilter, Vcl.Imaging.pngimage, Vcl.StdCtrls;

type
  TfrmRelCadClienteFicha = class(TForm)
    QryCliente: TFDQuery;
    dtsCliente: TDataSource;
    Relatorio: TRLReport;
    Cabecalho: TRLBand;
    lblLIstagemCategoria: TRLLabel;
    RLDraw2: TRLDraw;
    RLPDFFilter1: TRLPDFFilter;
    RLBand2: TRLBand;
    Rodape: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLDraw1: TRLDraw;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLLabel1: TRLLabel;
    lblPaginas: TRLLabel;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel3: TRLLabel;
    RLDBText6: TRLDBText;
    RLLabel4: TRLLabel;
    RLDBText7: TRLDBText;
    RLLabel5: TRLLabel;
    RLDBText8: TRLDBText;
    RLLabel10: TRLLabel;
    RLDBText9: TRLDBText;
    RLLabel11: TRLLabel;
    RLDBText10: TRLDBText;
    RLDraw3: TRLDraw;
    RLAngleLabel1: TRLAngleLabel;
    RLImage1: TRLImage;
    QryClienteclienteId: TFDAutoIncField;
    QryClientenome: TStringField;
    QryClientecep: TStringField;
    QryClienteendereco: TStringField;
    QryClientecidade: TStringField;
    QryClientebairro: TStringField;
    QryClienteestado: TStringField;
    QryClienteemail: TStringField;
    QryClientetelefone: TStringField;
    QryClientedataNascimento: TSQLTimeStampField;
    QryClientecpf_cnpj: TStringField;
    QryClientestatusDescricao: TStringField;
    QryClientetipoPessoa: TStringField;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel14: TRLLabel;
    RLDBText11: TRLDBText;
    lblCEPValor: TRLLabel;
    RLLabelDocValor: TRLLabel;
    RLLabelTelValor: TRLLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RLBand2BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelCadClienteFicha: TfrmRelCadClienteFicha;

implementation


{$R *.dfm}

procedure TfrmRelCadClienteFicha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  QryCliente.Close;
end;

procedure TfrmRelCadClienteFicha.FormCreate(Sender: TObject);
begin
  QryCliente.Open;
end;

procedure TfrmRelCadClienteFicha.RLBand2BeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  vTipo, vDoc, vFormatado, vCEP, vTel, vTelFormatado: string;
begin
  //mascara cnpj/cpf
  vTipo := UpperCase(Trim(QryCliente.FieldByName('tipoPessoa').AsString));
  vDoc  := Trim(QryCliente.FieldByName('cpf_cnpj').AsString);
  vFormatado := vDoc;

  if (Pos('FISICA', vTipo) > 0) then
  begin
    RLLabel14.Caption := 'CPF:';
    if Length(vDoc) = 11 then
      vFormatado := Copy(vDoc,1,3)+'.'+Copy(vDoc,4,3)+'.'+
                    Copy(vDoc,7,3)+'-'+Copy(vDoc,10,2);
  end
  else
  begin
    RLLabel14.Caption := 'CNPJ:';
    if Length(vDoc) = 14 then
      vFormatado := Copy(vDoc,1,2)+'.'+Copy(vDoc,3,3)+'.'+
                    Copy(vDoc,6,3)+'/'+Copy(vDoc,9,4)+'-'+Copy(vDoc,13,2);
  end;
  RLLabelDocValor.Caption := vFormatado;

  //mascara cep
  vCEP := Trim(QryCliente.FieldByName('cep').AsString);
  if Length(vCEP) = 8 then
    lblCEPValor.Caption := Copy(vCEP,1,5)+'-'+Copy(vCEP,6,3)
  else
    lblCEPValor.Caption := vCEP;

  //mascara telefone
  vTel := Trim(QryCliente.FieldByName('telefone').AsString);
  vTelFormatado := vTel;

  if (Length(vTel) > 0) and (vTel[1] = '0') then
    // 0800 000 0000
    vTelFormatado := Copy(vTel,1,4)+' '+Copy(vTel,5,3)+' '+Copy(vTel,8,4)
  else if Length(vTel) = 11 then
    // (11) 98888-7777
    vTelFormatado := '('+Copy(vTel,1,2)+') '+Copy(vTel,3,5)+'-'+Copy(vTel,8,4)
  else if Length(vTel) = 10 then
    // (11) 3333-4444
    vTelFormatado := '('+Copy(vTel,1,2)+') '+Copy(vTel,3,4)+'-'+Copy(vTel,7,4);

  // Aponta pro RLLabel que você vai criar no lugar do RLDBText4
  // (veja instrução abaixo)
  RLLabelTelValor.Caption := vTelFormatado;
end;
end.
