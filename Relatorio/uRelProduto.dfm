object frmRelProduto: TfrmRelProduto
  Left = 0
  Top = 0
  Caption = 'Relatorio Produto'
  ClientHeight = 463
  ClientWidth = 805
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Relatorio: TRLReport
    Left = -13
    Top = -8
    Width = 794
    Height = 1123
    DataSource = dtsProduto
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    object Cabecalho: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 64
      BandType = btHeader
    end
    object lblLIstagemProduto: TRLLabel
      Left = 38
      Top = 48
      Width = 235
      Height = 27
      Caption = 'Listagem de Produtos'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Arial Black'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RLDraw2: TRLDraw
      Left = 38
      Top = 76
      Width = 712
      Height = 20
      DrawKind = dkLine
      Pen.Width = 2
    end
    object RLBand2: TRLBand
      Left = 38
      Top = 136
      Width = 718
      Height = 27
      object RLDBText1: TRLDBText
        Left = 0
        Top = 6
        Width = 57
        Height = 16
        DataField = 'produtoId'
        DataSource = dtsProduto
        Text = ''
      end
      object RLDBText2: TRLDBText
        Left = 80
        Top = 6
        Width = 38
        Height = 16
        DataField = 'Nome'
        DataSource = dtsProduto
        Text = ''
      end
      object RLDBText3: TRLDBText
        Left = 498
        Top = 6
        Width = 70
        Height = 16
        DataField = 'Quantidade'
        DataSource = dtsProduto
        Text = ''
      end
      object RLDBText4: TRLDBText
        Left = 625
        Top = 6
        Width = 30
        Height = 16
        DataField = 'valor'
        DataSource = dtsProduto
        DisplayMask = 'R$#,##0.00'
        Text = ''
      end
    end
    object Rodape: TRLBand
      Left = 38
      Top = 163
      Width = 718
      Height = 45
      BandType = btFooter
      object RLSystemInfo1: TRLSystemInfo
        Left = 3
        Top = 26
        Width = 198
        Height = 16
        Info = itFullDate
        Text = ''
      end
      object RLDraw1: TRLDraw
        Left = 0
        Top = 0
        Width = 718
        Height = 17
        Align = faClientTop
        DrawKind = dkLine
        Pen.Width = 2
      end
      object RLSystemInfo2: TRLSystemInfo
        Left = 644
        Top = 26
        Width = 20
        Height = 16
        Alignment = taRightJustify
        Info = itPageNumber
        Text = ''
      end
      object RLSystemInfo3: TRLSystemInfo
        Left = 680
        Top = 26
        Width = 9
        Height = 16
        Alignment = taRightJustify
        Info = itLastPageNumber
        Text = ''
      end
      object RLLabel1: TRLLabel
        Left = 656
        Top = 26
        Width = 18
        Height = 16
        Alignment = taRightJustify
        Caption = '/'
      end
      object lblPaginas: TRLLabel
        Left = 597
        Top = 26
        Width = 51
        Height = 16
        Caption = 'Paginas'
        Transparent = False
      end
    end
    object RLBand1: TRLBand
      Left = 38
      Top = 102
      Width = 718
      Height = 34
      BandType = btColumnHeader
      object RLPanel1: TRLPanel
        Left = 0
        Top = 0
        Width = 718
        Height = 34
        Align = faClient
        Color = 7027215
        ParentColor = False
        Transparent = False
        object RLLabel3: TRLLabel
          Left = 80
          Top = 12
          Width = 115
          Height = 16
          Caption = 'Nome do Produto'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
        object RLLabel2: TRLLabel
          Left = 0
          Top = 12
          Width = 49
          Height = 16
          Caption = 'Codigo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
        object RLLabel4: TRLLabel
          Left = 416
          Top = 12
          Width = 152
          Height = 16
          Caption = 'Quantidade do Estoque'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
        object RLLabel5: TRLLabel
          Left = 625
          Top = 12
          Width = 38
          Height = 16
          Caption = 'Valor'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
      end
    end
  end
  object QryProdutos: TFDQuery
    Connection = dtmConexao.fdConexao
    SQL.Strings = (
      'SELECT produtos.produtoId,'
      '       produtos.nome,'
      '       produtos.valor,'
      '       produtos.quantidade'
      'FROM produtos'
      'ORDER BY Nome')
    Left = 664
    Top = 232
    object QryProdutosprodutoId: TFDAutoIncField
      FieldName = 'produtoId'
      Origin = 'produtoId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryProdutosnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object QryProdutosvalor: TFMTBCDField
      FieldName = 'valor'
      Origin = 'valor'
      DisplayFormat = 'R$##,##0.00'
      Precision = 18
      Size = 5
    end
    object QryProdutosquantidade: TIntegerField
      FieldName = 'quantidade'
      Origin = 'quantidade'
    end
  end
  object dtsProduto: TDataSource
    DataSet = QryProdutos
    Left = 688
    Top = 288
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 
      'FortesReport Community Edition v4.0.1.2 \251 Copyright '#194#169' 1999-2' +
      '021 Fortes Inform'#195#161'tica'
    DisplayName = 'Documento PDF'
    Left = 619
    Top = 288
  end
end
