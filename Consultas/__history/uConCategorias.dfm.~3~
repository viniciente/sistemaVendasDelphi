inherited frmConCategorias: TfrmConCategorias
  Caption = 'CONSULTA DE CATEGORIAS'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel2: TPanel
    inherited grdPesquisa: TDBGrid
      Font.Color = clBlack
      ParentFont = False
      Columns = <
        item
          Expanded = False
          FieldName = 'categoriasId'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'descricao'
          Visible = True
        end>
    end
  end
  inherited fdqry1: TFDQuery
    Active = True
    SQL.Strings = (
      'SELECT categoriasId,'
      '  descricao'
      'FROM categorias')
    Left = 383
    object fdqry1categoriasId: TFDAutoIncField
      DisplayLabel = 'Codigo'
      FieldName = 'categoriasId'
      Origin = 'categoriasId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fdqry1descricao: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 30
    end
  end
end
