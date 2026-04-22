unit uConClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHerancaConsulta, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ImgList, System.ImageList;

type
  TfrmConClientes = class(TfrmTelaHerancaConsulta)
    fdqry1clienteId: TFDAutoIncField;
    fdqry1nome: TStringField;
    fdqry1statusId: TIntegerField;
    fdqry1statusNome: TStringField;
    imglStatus: TImageList;
    fdqry1endereco: TStringField;
    fdqry1cidade: TStringField;
    fdqry1bairro: TStringField;
    fdqry1cep: TStringField;
    fdqry1telefone: TStringField;
    fdqry1email: TStringField;
    fdqry1datanascimento: TSQLTimeStampField;
    Panel4: TPanel;
    Image1: TImage;
    lblStatusAtivo: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    lblStatusBloqueado: TLabel;
    lblStatusAtencao: TLabel;
    lblStatusInativo: TLabel;
    lblStatusProspecto: TLabel;
    procedure grdPesquisaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure grdPesquisaDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConClientes: TfrmConClientes;

implementation

{$R *.dfm}

procedure TfrmConClientes.FormCreate(Sender: TObject);
begin
  aCampoId := 'clienteId';
  IndiceAtual := 'nome';
  inherited;
end;

procedure TfrmConClientes.grdPesquisaDblClick(Sender: TObject);
begin
  inherited;
  aRetornarIdSelecionado:=fdqry1.FieldByName(aCampoId).AsVariant;
end;

procedure TfrmConClientes.grdPesquisaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  vStatusId: Integer;
begin
  inherited;
  if Column.FieldName = 'statusId' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    vStatusId := Column.Field.AsInteger;
    // statusId: 1=Ativo 2=Bloqueado 3=Atencao 4=Inativo 5=Prospecto
    // imglStatus deve ter as imagens nessa ordem (index 0 a 4)
    if (vStatusId >= 1) and (vStatusId <= imglStatus.Count) then
      imglStatus.Draw(
        TDBGrid(Sender).Canvas,
        Rect.Left + (Rect.Width div 2) - 8,
        Rect.Top + (Rect.Height div 2) - 8,
        vStatusId - 1
      );
  end;
end;

end.

