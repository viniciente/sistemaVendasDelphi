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
  aCampoId := 'produtoId';
  IndiceAtual := 'nome';

    fdqry1.SQL.Clear;
  fdqry1.SQL.Add('SELECT p.produtoId,');
  fdqry1.SQL.Add('       p.nome,');
  fdqry1.SQL.Add('       p.descricao,');
  fdqry1.SQL.Add('       p.valor,');
  fdqry1.SQL.Add('       p.quantidade,');
  fdqry1.SQL.Add('       p.categoriasId,');
  fdqry1.SQL.Add('       c.descricao AS DescricaoCategoria');
  fdqry1.SQL.Add('FROM produtos AS p');
  fdqry1.SQL.Add('LEFT JOIN categorias AS c ON c.categoriasId = p.categoriasId');
  fdqry1.SQL.Add('ORDER BY p.nome');

  inherited;
end;

end.
