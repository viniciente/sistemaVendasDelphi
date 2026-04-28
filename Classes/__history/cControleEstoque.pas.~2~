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
var Qry:TFDQuery;
begin
  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;

    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE produtos '+
                '   SET quantidade = quantidade - :qtdeBaixa '+
                ' WHERE produtoId=:produtoId ');
    Qry.ParamByName('produtoId').AsInteger :=ProdutoId;
    Qry.ParamByName('qtdeBaixa').AsFloat   :=Quantidade;
    Try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    Except
      FdConexao.Rollback;
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;


function TControleEstoque.RetornarEstoque: Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=FdConexao;

    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE produtos '+
                '   SET quantidade = quantidade + :qtdeRetorno '+
                ' WHERE produtoId=:produtoId ');
    Qry.ParamByName('produtoId').AsInteger :=ProdutoId;
    Qry.ParamByName('qtdeRetorno').AsFloat :=Quantidade;
    Try
      FdConexao.StartTransaction;
      Qry.ExecSQL;
      FdConexao.Commit;
    Except
      FdConexao.Rollback;
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

end.

