unit uDtmGrafico;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDtmGrafico = class(TDataModule)
    qryProdutoEstoque: TFDQuery;
    qryVendaPorCliente: TFDQuery;
    qryVendaPorClienteLabel: TStringField;
    qryVendaPorClienteValue: TFMTBCDField;
    qryProdutoEstoqueLabel: TStringField;
    qryProdutoEstoqueValue: TIntegerField;
    qry10ProdutosMaisVendidos: TFDQuery;
    qry10ProdutosMaisVendidosLabel: TStringField;
    qry10ProdutosMaisVendidosValue: TFMTBCDField;
    qryVendaUltimaSemana: TFDQuery;
    qryVendaUltimaSemanaLabel: TSQLTimeStampField;
    qryVendaUltimaSemanaValue: TFMTBCDField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DtmGrafico: TDtmGrafico;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
