inherited frmConClientes: TfrmConClientes
  Caption = 'CONSULTE SEUS CLIENTES'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 508
    inherited mskPesquisa: TMaskEdit
      ExplicitLeft = 1
      ExplicitTop = 19
    end
  end
  inherited Panel2: TPanel
    ExplicitTop = 41
    inherited grdPesquisa: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'clienteId'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Visible = True
        end>
    end
  end
  inherited Panel3: TPanel
    ExplicitLeft = 0
    ExplicitTop = 227
    ExplicitWidth = 508
  end
  inherited fdqry1: TFDQuery
    Active = True
    SQL.Strings = (
      ''
      'select clienteId,'
      '       nome,'
      '       endereco,'
      '       cidade,'
      '       bairro,'
      '       cep,'
      '       telefone,'
      '       email,'
      '       datanascimento'
      'from clientes')
    Left = 399
    Top = 8
    object fdqry1clienteId: TFDAutoIncField
      DisplayLabel = 'Codigo'
      FieldName = 'clienteId'
      Origin = 'clienteId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fdqry1nome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object fdqry1endereco: TStringField
      FieldName = 'endereco'
      Origin = 'endereco'
      Size = 60
    end
    object fdqry1cidade: TStringField
      FieldName = 'cidade'
      Origin = 'cidade'
      Size = 50
    end
    object fdqry1bairro: TStringField
      FieldName = 'bairro'
      Origin = 'bairro'
      Size = 40
    end
    object fdqry1cep: TStringField
      FieldName = 'cep'
      Origin = 'cep'
      Size = 10
    end
    object fdqry1telefone: TStringField
      FieldName = 'telefone'
      Origin = 'telefone'
      Size = 14
    end
    object fdqry1email: TStringField
      FieldName = 'email'
      Origin = 'email'
      Size = 100
    end
    object fdqry1datanascimento: TSQLTimeStampField
      FieldName = 'datanascimento'
      Origin = 'datanascimento'
    end
  end
  inherited dsListagem: TDataSource
    Top = 8
  end
end
