unit UTelaHeranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uEnum, uDtmnConexao, RxToolEdit, RxCurrEdit, Vcl.Buttons,
  FireDAC.UI.Intf, FireDAC.Stan.Def,cUsuarioLogado,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, System.IniFiles,
  System.IOUtils;

type
  TfrmTelaHeranca = class(TForm)
    pnlFundo: TPanel;
    pnlRodape: TPanel;
    dbnvgrNavigator: TDBNavigator;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    btnFechar: TBitBtn;
    pgcPrincipal: TPageControl;
    tsListagem: TTabSheet;
    pnlListagemTopo: TPanel;
    lblIndice: TLabel;
    maskPesquisar: TMaskEdit;
    btnPesquisar: TBitBtn;
    dbgrdListagem: TDBGrid;
    tsManutencao: TTabSheet;
    dsListagem: TDataSource;
    FDQuery1: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgrdListagemTitleClick(Column: TColumn);
    procedure dbgrdListagemDblClick(Sender: TObject);
    procedure dbgrdListagemKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure maskPesquisarChange(Sender: TObject);
    procedure dbgrdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  private
    { Private declarations }
    procedure ControlarIndiceTab(pgcPrincipal: TPageControl; Indice: Integer);
    function RetomarCampoTraduzido(Campo: string): string;
    procedure ExibirLabelIndice(Campo: string; aLabel: TLabel);
    function ExisteCampoObrigatorio: Boolean;
    procedure DesabilitarEditPK;
    procedure LimparEdits;
    procedure SalvarConfiguracaoGrid(pGrid: TDBGrid);
    procedure CarregarConfiguracaoGrid(pGrid: TDBGrid);
    procedure CentralizarColunas;
  public
    { Public declarations }
    SelectOriginal:string;
    EstadoDoCadastro: TEstadoDoCadastro;
    IndiceAtual: string;
    function Apagar: Boolean; virtual;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; virtual;
    procedure BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
    procedure ControlarBotoes; virtual;
    function SomenteNumeros (aSentenca:String): string;
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

{$R *.dfm}

uses Unit2, cFuncao;

{$REGION 'OBSERVAÇÔES'}
//TAG: 1 - CHAVE PRIMARIA
//TAG: 2 - CAMPOS OBRIGATORIOS
{$ENDREGION}

{$REGION 'Metodo SomenteNumeros'}

function TfrmTelaHeranca.SomenteNumeros(aSentenca:string):string;
var I:Integer;
begin
  Result:='';
  for I:=1 to Length(aSentenca) do
  begin
  //verifica se o caractere na posição I é numero de 0 a 9
  if aSentenca[I] in ['0'..'9'] then
    Result := Result+aSentenca[i]
  end;
end;

{$ENDREGION}

procedure TfrmTelaHeranca.ControlarBotoes;
var
  EditandoOuInserindo: Boolean;
  TemDados: Boolean;
begin
  btnNovo.Enabled    := FDQuery1.State = dsBrowse;
  btnApagar.Enabled  := (FDQuery1.State = dsBrowse) and not FDQuery1.IsEmpty;
  btnAlterar.Enabled := (FDQuery1.State = dsBrowse) and not FDQuery1.IsEmpty;
  btnGravar.Enabled  := FDQuery1.State in [dsInsert, dsEdit];
  btnCancelar.Enabled := FDQuery1.State in [dsInsert, dsEdit];

  // Verifica se o Dataset está em modo de Edição ou Inserção
  EditandoOuInserindo := FDQuery1.State in [dsEdit, dsInsert];

  // Verifica se o Dataset não está vazio (para poder apagar/alterar)
  TemDados := not FDQuery1.IsEmpty;

  // Botões de Ação Principal
  btnNovo.Enabled    := not EditandoOuInserindo;
  btnAlterar.Enabled := (not EditandoOuInserindo) and TemDados;
  btnApagar.Enabled  := (not EditandoOuInserindo) and TemDados;

  // Botões de Confirmação
  btnGravar.Enabled   := EditandoOuInserindo;
  btnCancelar.Enabled := EditandoOuInserindo;

  // Navegação e Abas
  dbnvgrNavigator.Enabled := not EditandoOuInserindo;
  pgcPrincipal.Pages[0].TabVisible := not EditandoOuInserindo;

  // Se estiver editando, pula para a aba de Manutenção automaticamente
  if EditandoOuInserindo then
    pgcPrincipal.ActivePageIndex := 1
  else
    pgcPrincipal.ActivePageIndex := 0;
end;

procedure TfrmTelaHeranca.ControlarIndiceTab(pgcPrincipal: TPageControl; Indice: Integer);
begin
  if (pgcPrincipal.Pages[Indice].TabVisible) then
    pgcPrincipal.TabIndex := Indice;
end;

function TfrmTelaHeranca.RetomarCampoTraduzido(Campo: string): string;
var i: Integer;
begin
  for i := 0 to FDQuery1.Fields.Count - 1 do begin
    if LowerCase(FDQuery1.Fields[i].FieldName) = LowerCase(Campo) then begin
      Result := FDQuery1.Fields[i].DisplayLabel;
      Break;
    end;
  end;
end;

procedure TfrmTelaHeranca.ExibirLabelIndice(Campo: string; aLabel: TLabel);
begin
  aLabel.Caption := RetomarCampoTraduzido(Campo);
end;

function TfrmTelaHeranca.ExisteCampoObrigatorio: Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to ComponentCount - 1 do begin
    if (Components[i] is TLabeledEdit) then begin
      if ((TLabeledEdit(Components[i]).Tag = 2) and (TLabeledEdit(Components[i]).Text = EmptyStr)) then begin
        MessageDlg(TLabeledEdit(Components[i]).EditLabel.Caption + ' é um campo obrigatório', mtInformation, [mbOK], 0);
        TLabeledEdit(Components[i]).SetFocus;
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TfrmTelaHeranca.DesabilitarEditPK;
var i: Integer;
begin
  for i := 0 to ComponentCount - 1 do begin
    if (Components[i] is TLabeledEdit) then begin
      if (TLabeledEdit(Components[i]).Tag = 1) then begin
        TLabeledEdit(Components[i]).Enabled := False;
      end;
    end;
  end;
end;

procedure TfrmTelaHeranca.LimparEdits;
var i: Integer;
begin
  for i := 0 to ComponentCount - 1 do begin
    if (Components[i] is TLabeledEdit) then
      TLabeledEdit(Components[i]).Text := EmptyStr
    else if (Components[i] is TEdit) then
      TEdit(Components[i]).Text := ''
    else if (Components[i] is TMemo) then
      TMemo(Components[i]).Text := ''
    else if (Components[i] is TDBLookupComboBox) then
      TDBLookupComboBox(Components[i]).KeyValue := null
    else if (Components[i] is TCurrencyEdit) then
      TCurrencyEdit(Components[i]).Value := 0
    else if (Components[i] is TDateEdit) then
      TDateEdit(Components[i]).Date := 0
    else if (Components[i] is TMaskEdit) then
      TMaskEdit(Components[i]).Text := '';
  end;
end;

{$REGION 'METODOS VIRTUAIS'}
function TfrmTelaHeranca.Apagar: Boolean;
begin
  ShowMessage('DELETADO');
  Result := True;
end;

function TfrmTelaHeranca.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if (EstadoDoCadastro = ecInserir) then
    ShowMessage('Inserir')
  else if (EstadoDoCadastro = ecAlterar) then
    ShowMessage('Alterado');
  Result := True;
end;
{$ENDREGION}

procedure TfrmTelaHeranca.btnNovoClick(Sender: TObject);
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, dtmConexao.FDConexao) then
  begin
     MessageDlg('Usuario: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  EstadoDoCadastro := ecInserir;
  LimparEdits;
  FDQuery1.Insert;
  ControlarBotoes;
end;

procedure TfrmTelaHeranca.btnPesquisarClick(Sender: TObject);
var I:Integer;
    TipoCampo:TFieldType;
    NomeCampo, SQLBase:string;
    WhereOrAnd: string;
    CondicaoSQL:string;
begin
  // Verificação de Permissão
  if not TUsuariologado.TenhoAcesso(oUsuarioLogado.codigo, Self.Name+'_'+TBitBtn(Sender).Name, dtmConexao.FDConexao) then
  begin
    MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
    Abort;
  end;

  // Se a pesquisa estiver vazia, restaura o SelectOriginal
if maskPesquisar.Text='' then
  begin
    FDQuery1.Close;
    FDQuery1.SQL.Text := SelectOriginal;
    FDQuery1.Open;
    Exit;
  end;

  SQLBase := SelectOriginal;
    I := Pos('order by', LowerCase(SQLBase));
    if I > 0 then
      SQLBase := Copy(SQLBase, 1, I - 1);

  // Localiza o campo selecionado
  TipoCampo := ftUnknown;
  for I := 0 to FDQuery1.FieldCount-1 do
  begin
    if FDQuery1.Fields[i].FieldName = IndiceAtual then
    begin
      TipoCampo := FDQuery1.Fields[i].DataType;

      // Usa Origin para evitar erro de coluna ambígua em SQL com JOIN
      if FDQuery1.Fields[i].Origin <> '' then
        NomeCampo := FDQuery1.Fields[i].Origin
      else
        NomeCampo := FDQuery1.Fields[i].FieldName;

      Break;
    end;
  end;

  // Verifica se já existe WHERE no SQL original
  if Pos('where', LowerCase(SQLBase)) > 0 then
    WhereOrAnd := ' AND '
  else
    WhereOrAnd := ' WHERE ';

  // Monta a Condição SQL baseada no tipo de dado
  if (TipoCampo in [ftString, ftWideString, ftMemo]) then
  begin
    CondicaoSQL := WhereOrAnd + NomeCampo + ' LIKE ' + QuotedStr('%' + maskPesquisar.Text + '%');
  end
  else if (TipoCampo in [ftInteger, ftSmallint, ftAutoInc, ftLargeint]) then
  begin
    if strToIntDef(maskPesquisar.Text, -1) <> -1 then
      CondicaoSQL := WhereOrAnd + NomeCampo + ' = ' + maskPesquisar.Text
    else
      CondicaoSQL := '';
  end
  else if (TipoCampo in [ftDate, ftDateTime, ftTimeStamp]) then
  begin
    // Garante que a data seja tratada corretamente pelo SQL
    CondicaoSQL := WhereOrAnd + ' CAST(' + NomeCampo + ' as date) = ' + QuotedStr(maskPesquisar.Text);
  end
  else if (TipoCampo in [ftFloat, ftCurrency, ftFMTBcd]) then
  begin
    // Troca vírgula por ponto para o banco de dados entender o decimal
    CondicaoSQL := WhereOrAnd + NomeCampo + ' = ' + StringReplace(maskPesquisar.Text, ',', '.', [rfReplaceAll]);
  end;

  // 6. Executa a nova Query
  FDQuery1.Close;
  // Remova espaços extras que podem confundir o banco
  FDQuery1.SQL.Text := Trim(SQLBase) + ' ' + Trim(CondicaoSQL);

  if NomeCampo <> '' then
    FDQuery1.SQL.Add(' ORDER BY ' + NomeCampo);

  try
    FDQuery1.Open;
  except
    on E: Exception do
    begin
      // Se der erro, mostra o SQL que foi gerado para você debugar
      ShowMessage('Erro no SQL: ' + E.Message + #13 + FDQuery1.SQL.Text);
    end;
  end;

  maskPesquisar.Text := '';
  maskPesquisar.SetFocus;
end;

procedure TfrmTelaHeranca.btnAlterarClick(Sender: TObject);
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, dtmConexao.FDConexao) then
  begin
     MessageDlg('Usuario: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  //verifica se a query esta aberta
  if FDQuery1.Active and (not FDQuery1.IsEmpty) then
  begin
    // coloca o banco em modo de edição
    FDQuery1.Edit;

    // muda para a aba de Manutenção
    pgcPrincipal.ActivePageIndex := 1;
  end;

  ControlarBotoes;
  EstadoDoCadastro := ecAlterar;
end;

procedure TfrmTelaHeranca.btnApagarClick(Sender: TObject);
begin
  // 1. Verificação de Segurança: O objeto foi criado?
  if not Assigned(oUsuarioLogado) then
  begin
    MessageDlg('Erro Crítico: Sessão do usuário não inicializada. Recomenda-se reiniciar o sistema.', mtError, [mbOK], 0);
    Abort;
  end;

  // 3. Execução da Exclusão
  try
    if (Apagar) then
    begin
      ControlarBotoes;
      LimparEdits;
      FDQuery1.Refresh;
      ShowMessage('Registro excluído com sucesso!');
    end
    else
    begin
      MessageDlg('Erro ao Apagar: O registro pode estar sendo usado por outro processo.', mtError, [mbOK], 0);
    end;
  finally
    EstadoDoCadastro := ecNenhum;
  end;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  if FDQuery1.Active then
    FDQuery1.Cancel;
  ControlarBotoes;
  EstadoDoCadastro := ecNenhum;
  LimparEdits;
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.dbgrdListagemDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TfrmTelaHeranca.dbgrdListagemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  // 1. Define as cores de fundo (Zebrado)
  if not (gdSelected in State) then
  begin
    if Odd(TDBGrid(Sender).DataSource.DataSet.RecNo) then
      TDBGrid(Sender).Canvas.Brush.Color := $00F2F2F2 // Cinza quase branco
    else
      TDBGrid(Sender).Canvas.Brush.Color := $00E1E1E1; // Cinza um pouco mais escuro

    // FORÇA A COR DA FONTE para preto nas linhas normais
    TDBGrid(Sender).Canvas.Font.Color := clBlack;
  end
  else
  begin
    // 2. Cores para a linha SELECIONADA (Fundo azul com letra branca, por exemplo)
    TDBGrid(Sender).Canvas.Brush.Color := clHighlight; // Cor padrão de seleção do Windows
    TDBGrid(Sender).Canvas.Font.Color := clHighlightText; // Branco padrão de seleção
  end;

  // Aplica a cor definida no fundo
  TDBGrid(Sender).Canvas.FillRect(Rect);

  // 3. Pinta o texto.
  // O DefaultDrawColumnCell agora usará as cores de Canvas que definimos acima.
  TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmTelaHeranca.dbgrdListagemKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TfrmTelaHeranca.btnGravarClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, dtmConexao.FDConexao) then
  begin
     MessageDlg('Usuario: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort
  end;

  if (ExisteCampoObrigatorio) then
    Abort;

  try
    try
      if Gravar(EstadoDoCadastro) then
      begin
        FDQuery1.Refresh;
        ControlarIndiceTab(pgcPrincipal, 0);
        ControlarBotoes;
        EstadoDoCadastro := ecNenhum;
        LimparEdits;
      end
      else
        MessageDlg('A gravação não pôde ser concluída.', mtWarning, [mbOK], 0);
    except
      on E: Exception do
        MessageDlg('Erro ao gravar: ' + E.Message, mtError, [mbOK], 0);
    end;
  finally
  end;
end;

procedure TfrmTelaHeranca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SalvarConfiguracaoGrid(dbgrdListagem);
  if FDQuery1.Active then
    FDQuery1.Close;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
var i:Integer;
begin
  FDQuery1.Connection := dtmConexao.FDConexao;
  dsListagem.DataSet := FDQuery1;
  dbgrdListagem.DataSource := dsListagem;
  dbgrdListagem.Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines,
    dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack];

  for i := 0 to dbgrdListagem.Columns.Count - 1 do
  begin
    dbgrdListagem.Columns[i].Title.Font.Color := clWhite;
    dbgrdListagem.Columns[i].Title.Font.Style := [fsBold]
  end;
  CentralizarColunas;
end;

procedure TfrmTelaHeranca.dbgrdListagemTitleClick(Column: TColumn);
begin
  IndiceAtual := Column.FieldName;
  FDQuery1.IndexFieldNames := IndiceAtual;
  ExibirLabelIndice(IndiceAtual, lblIndice);
end;

procedure TfrmTelaHeranca.FormShow(Sender: TObject);
begin
  CarregarConfiguracaoGrid(dbgrdListagem);

  if FDQuery1.SQL.Text <> EmptyStr then
  begin
    FDQuery1.IndexFieldNames := IndiceAtual;
    ExibirLabelIndice(IndiceAtual, lblIndice);
    SelectOriginal := FDQuery1.SQL.Text;

    FDQuery1.Close;
    FDQuery1.Open;
  end;

  ControlarIndiceTab(pgcPrincipal, 0);
  lblIndice.Caption := IndiceAtual;
  DesabilitarEditPK;

  EstadoDoCadastro := ecNenhum;
  ControlarBotoes;
end;

{$REGION 'PESQUISA'}

procedure TfrmTelaHeranca.maskPesquisarChange(Sender: TObject);
var Date:TDateTime;
begin

  if(trim(TMaskEdit(Sender).Text) = '')then
    Exit;

  if(FDQuery1.FieldByName(IndiceAtual).DataType in [ftString, ftWideString] )then
  begin
    FDQuery1.Locate(IndiceAtual, TMaskEdit(Sender).Text, [loPartialKey])
  end

  else if(FDQuery1.FieldByName(IndiceAtual).DataType in [ftFloat, ftCurrency, ftFMTBcd] )then
  begin
   try
     FDQuery1.Locate(IndiceAtual, TMaskEdit(Sender).Text, [])
   except

   end;
  end

  else if(FDQuery1.FieldByName(IndiceAtual).DataType in [ftDate, ftDateTime, ftTimeStamp] )then
  begin
   if TryStrToDate(TMaskEdit(Sender).Text, Date) then
   begin
     FDQuery1.Locate(IndiceAtual, Date, []);
   end
  end
  else
     FDQuery1.Locate(IndiceAtual, TMaskEdit(Sender).Text, [])
end;

{$ENDREGION}

{$REGION 'Bloqueio de CTRL+DEL'}

procedure TfrmTelaHeranca.BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 46) then
    Key := 0;
end;

{$ENDREGION}

{$REGION 'CONFIGURAÇÃO GRID'}

procedure TfrmTelaHeranca.SalvarConfiguracaoGrid(pGrid: TDBGrid);
var
  Ini: TIniFile;
  i: Integer;
  NomeArquivo: string;
begin
  // Monta o nome: grid_1.ini, grid_2.ini, etc.
  NomeArquivo := ExtractFilePath(Application.ExeName) +
                 'grid_' + IntToStr(oUsuarioLogado.codigo) + '.ini';

  Ini := TIniFile.Create(NomeArquivo);
  try
    for i := 0 to pGrid.Columns.Count - 1 do
    begin
      // Usamos o Self.Name como Seção para separar as telas dentro do arquivo
      Ini.WriteInteger(Self.Name + '_Width', pGrid.Columns[i].FieldName, pGrid.Columns[i].Width);
      Ini.WriteInteger(Self.Name + '_Index', pGrid.Columns[i].FieldName, pGrid.Columns[i].Index);
      Ini.WriteBool(Self.Name + '_Visible',  pGrid.Columns[i].FieldName, pGrid.Columns[i].Visible);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmTelaHeranca.CarregarConfiguracaoGrid(pGrid: TDBGrid);
var
  Ini: TIniFile;
  i, vPos: Integer;
  NomeArquivo: string;
  vFieldName: string;
begin
  NomeArquivo := ExtractFilePath(Application.ExeName) +
                 'grid_' + IntToStr(oUsuarioLogado.codigo) + '.ini';

  if not FileExists(NomeArquivo) then Exit;

  Ini := TIniFile.Create(NomeArquivo);
  try
    // 1º Passo: Ajusta Largura e Visibilidade (Isso não afeta a ordem)
    for i := 0 to pGrid.Columns.Count - 1 do
    begin
      vFieldName := pGrid.Columns[i].FieldName;
      pGrid.Columns[i].Width := Ini.ReadInteger(Self.Name + '_Width', vFieldName, pGrid.Columns[i].Width);
      pGrid.Columns[i].Visible := Ini.ReadBool(Self.Name + '_Visible', vFieldName, pGrid.Columns[i].Visible);
    end;

    // 2º Passo: O Segredo da Ordem.
    // Em vez de percorrer de 0 a Count-1, vamos forçar o Index de cada FieldName
    // conforme o valor gravado.
    for i := 0 to pGrid.Columns.Count - 1 do
    begin
      for vPos := 0 to pGrid.Columns.Count - 1 do
      begin
        vFieldName := pGrid.Columns[vPos].FieldName;
        // Busca qual deveria ser o índice correto dessa coluna
        if Ini.ReadInteger(Self.Name + '_Index', vFieldName, -1) = i then
        begin
          pGrid.Columns[vPos].Index := i;
          Break; // Achou a coluna que deve estar na posição 'i', pula para a próxima posição
        end;
      end;
    end;

  finally
    Ini.Free;
  end;
end;

procedure TfrmTelaHeranca.CentralizarColunas;
var
  I: Integer;
begin
  for I := 0 to dbgrdListagem.Columns.Count - 1 do
  begin
    // Centraliza o texto das linhas
    dbgrdListagem.Columns[I].Alignment := taCenter;

    // Centraliza o texto do título
    dbgrdListagem.Columns[I].Title.Alignment := taCenter;
  end;
end;

{$ENDREGION}

end.
