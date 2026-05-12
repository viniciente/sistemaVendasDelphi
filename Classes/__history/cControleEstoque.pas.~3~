unit cControleEstoque;

interface

uses System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Dialogs,
     FireDAC.Stan.Intf, FireDAC.Stan.Option,
      FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
      FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
      FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
      FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
      System.SysUtils;
      // lista de Units

type
  TControleEstoque = class
  private
    FdConexao:TFDConnection;
    F_ProdutoId:Integer;
    F_Quantidade:Double;
  public
    constructor Create(aConexao: TFDConnection);
    destructor Destroy; override;
    function BaixarEstoque: Boolean;
    function RetornarEstoque: Boolean;
  published
    property ProdutoId:Integer     read F_ProdutoId    write F_ProdutoId;
    property Quantidade:Double     read F_Quantidade   write F_Quantidade;
  end;

implementation

{$region 'Constructor and Destructor'}
constructor TControleEstoque.Create(aConexao:TFDConnection);
begin
  FdConexao:=aConexao;
end;

destructor TControleEstoque.Destroy;
begin

  inherited;
end;
{$endRegion}

function TControleEstoque.BaixarEstoque: Boolean;
var
  Qry: TFDQuery;
  vEhServico: Boolean;
begin
  Result := True;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := FdConexao;

    // Verifica se é serviço ANTES de baixar estoque
    Qry.SQL.Text := 'SELECT p.categoriasId FROM produtos p WHERE p.produtoId = :pId';
    Qry.ParamByName('pId').AsInteger := ProdutoId;
    Qry.Open;

    vEhServico := (not Qry.IsEmpty) and (Qry.FieldByName('categoriasId').AsInteger = 46);
    Qry.Close;

    // Serviço não tem estoque — sai sem fazer nada
    if vEhServico then
      Exit;

    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE produtos SET quantidade = quantidade - :qtdeBaixa WHERE produtoId = :produtoId');
    Qry.ParamByName('produtoId').AsInteger := ProdutoId;
    Qry.ParamByName('qtdeBaixa').AsFloat   := Quantidade;
    try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    except
      FdConexao.Rollback;
      Result := False;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

function TControleEstoque.RetornarEstoque: Boolean;
var
  Qry: TFDQuery;
  vEhServico: Boolean;
begin
  Result := True;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := FdConexao;

    // Mesma verificação no retorno — estorno de venda cancelada
    Qry.SQL.Text := 'SELECT p.categoriasId FROM produtos p WHERE p.produtoId = :pId';
    Qry.ParamByName('pId').AsInteger := ProdutoId;
    Qry.Open;

    vEhServico := (not Qry.IsEmpty) and (Qry.FieldByName('categoriasId').AsInteger = 46);
    Qry.Close;

    if vEhServico then
      Exit;

    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE produtos SET quantidade = quantidade + :qtdeRetorno WHERE produtoId = :produtoId');
    Qry.ParamByName('produtoId').AsInteger := ProdutoId;
    Qry.ParamByName('qtdeRetorno').AsFloat := Quantidade;
    try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    except
      FdConexao.Rollback;
      Result := False;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

end.

