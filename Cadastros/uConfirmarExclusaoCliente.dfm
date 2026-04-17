object frmConfirmarExclusaoCliente: TfrmConfirmarExclusaoCliente
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Atencao - Cliente possui vendas cadastradas'
  ClientHeight = 500
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 0
    object lblAviso: TLabel
      Left = 12
      Top = 8
      Width = 696
      Height = 16
      Caption = 'Este cliente possui vendas cadastradas. As vendas abaixo serao excluidas junto com o cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNomeCliente: TLabel
      Left = 12
      Top = 34
      Width = 696
      Height = 16
      Caption = 'Cliente: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 460
    Width = 720
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnExcluirTudo: TBitBtn
      Left = 12
      Top = 6
      Width = 220
      Height = 28
      Caption = 'Excluir Vendas e Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnExcluirTudoClick
    end
    object btnCancelar: TBitBtn
      Left = 608
      Top = 6
      Width = 100
      Height = 28
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object dbgrdVendas: TDBGrid
    Left = 0
    Top = 60
    Width = 720
    Height = 400
    Align = alClient
    DataSource = dtsVendas
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines,
      dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit,
      dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'vendaId'
        Title.Caption = 'Venda #'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dataVenda'
        Title.Caption = 'Data'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nomeProduto'
        Title.Caption = 'Produto'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'quantidade'
        Title.Caption = 'Qtde'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'valorUnitario'
        Title.Caption = 'Vlr Unit.'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'totalProduto'
        Title.Caption = 'Total Produto'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'totalVenda'
        Title.Caption = 'Total Venda'
        Width = 100
        Visible = True
      end>
  end
  object QryVendas: TFDQuery
    Left = 640
    Top = 80
  end
  object dtsVendas: TDataSource
    DataSet = QryVendas
    Left = 640
    Top = 140
  end
end
