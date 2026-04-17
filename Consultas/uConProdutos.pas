unit uConProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHerancaConsulta, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  Vcl.ExtCtrls;

type
  TfrmConProdutos = class(TfrmTelaHerancaConsulta)
    fdqry1produtoId: TFDAutoIncField;
    fdqry1nome: TStringField;
    fdqry1descricao: TStringField;
    fdqry1valor: TFMTBCDField;
    fdqry1quantidade: TIntegerField;
    fdqry1categoriasId: TIntegerField;
    fdqry1DescricaoCategoria: TStringField;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConProdutos: TfrmConProdutos;

implementation

{$R *.dfm}

procedure TfrmConProdutos.FormCreate(Sender: TObject);
begin
  aCampoId := 'produtosId';
  IndiceAtual := 'nome';

  inherited;
end;

end.
