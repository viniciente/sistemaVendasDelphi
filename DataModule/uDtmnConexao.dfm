object dtmConexao: TdtmConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 484
  Width = 666
  object fdConexao: TFDConnection
    Params.Strings = (
      'Server=DC-TR-06-VM\SERVERCURSO'
      'Database=Vendas'
      'OSAuthent=Yes'
      'User_Name=DOMTEC\devmv'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 168
    Top = 104
  end
end
