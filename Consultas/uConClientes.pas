unit uConClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHerancaConsulta, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  Vcl.ExtCtrls;

type
  TfrmConClientes = class(TfrmTelaHerancaConsulta)
    fdqry1clienteId: TFDAutoIncField;
    fdqry1nome: TStringField;
    fdqry1endereco: TStringField;
    fdqry1cidade: TStringField;
    fdqry1bairro: TStringField;
    fdqry1cep: TStringField;
    fdqry1telefone: TStringField;
    fdqry1email: TStringField;
    fdqry1datanascimento: TSQLTimeStampField;
    procedure FormCreate(Sender: TObject);
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

end.
