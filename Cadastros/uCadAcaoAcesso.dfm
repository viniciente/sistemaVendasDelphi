inherited frmCadAcaoAcesso: TfrmCadAcaoAcesso
  Caption = 'Cadastro de Ac'#227'o de Acesso'
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    inherited pnlRodape: TPanel
      inherited dbnvgrNavigator: TDBNavigator
        Hints.Strings = ()
      end
    end
    inherited pgcPrincipal: TPageControl
      inherited tsListagem: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 740
        ExplicitHeight = 373
        inherited dbgrdListagem: TDBGrid
          DataSource = dsListagem
          Columns = <
            item
              Expanded = False
              FieldName = 'acaoAcessoId'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'descricao'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'chave'
              Visible = True
            end>
        end
      end
      inherited tsManutencao: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 740
        ExplicitHeight = 373
        object lblCodigo: TLabel
          Left = 35
          Top = 37
          Width = 33
          Height = 13
          Caption = 'Codigo'
        end
        object lblDescricao: TLabel
          Left = 35
          Top = 83
          Width = 46
          Height = 13
          Caption = 'Descri'#231#227'o'
        end
        object lblChave: TLabel
          Left = 35
          Top = 123
          Width = 31
          Height = 13
          Caption = 'Chave'
        end
        object edtAcaoAcessoId: TEdit
          Left = 35
          Top = 56
          Width = 121
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object edtDescricao: TEdit
          Left = 35
          Top = 96
          Width = 334
          Height = 21
          TabOrder = 1
        end
        object edtChave: TEdit
          Left = 35
          Top = 136
          Width = 334
          Height = 21
          TabOrder = 2
        end
      end
    end
  end
  inherited FDQuery1: TFDQuery
    Active = True
    SQL.Strings = (
      'SELECT '
      '    acaoAcessoId, '
      '    descricao, '
      '    chave '
      'FROM acaoAcesso'
      'ORDER BY descricao')
    object FDQuery1acaoAcessoId: TFDAutoIncField
      DisplayLabel = 'Codigo'
      FieldName = 'acaoAcessoId'
      Origin = 'acaoAcessoId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQuery1descricao: TStringField
      DisplayLabel = 'Descricao'
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 100
    end
    object FDQuery1chave: TStringField
      DisplayLabel = 'Chave'
      FieldName = 'chave'
      Origin = 'chave'
      Required = True
      Size = 60
    end
  end
end
