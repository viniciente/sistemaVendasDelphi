unit uCadAcaoAcesso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.DBCtrls, Vcl.ExtCtrls, cAcaoAcesso, uEnum, uDtmnConexao;

type
  TfrmCadAcaoAcesso = class(TfrmTelaHeranca)
    edtAcaoAcessoId: TEdit;
    edtDescricao: TEdit;
    edtChave: TEdit;
    lblCodigo: TLabel;
    lblDescricao: TLabel;
    lblChave: TLabel;
    FDQuery1acaoAcessoId: TFDAutoIncField;
    FDQuery1descricao: TStringField;
    FDQuery1chave: TStringField;
    procedure btnAlterarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure dsListagemStateChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    oAcaoAcesso:TAcaoAcesso;
    function Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    function Apagar:Boolean;  override;
  end;

var
  frmCadAcaoAcesso: TfrmCadAcaoAcesso;

implementation

{$R *.dfm}

{$REGION'Override'}
function TfrmCadAcaoAcesso.Apagar: Boolean;
begin
  Result := False;
  // Carrega o ID do registro selecionado no Grid
  if oAcaoAcesso.Selecionar(FDQuery1.FieldByName('acaoAcessoId').AsInteger) then
  begin
    // Chama o método apagar do objeto
    Result := oAcaoAcesso.Apagar;

    // Se deletou, atualiza a grade para sumir da tela
    if Result then
      FDQuery1.Refresh;
  end;
end;

function TfrmCadAcaoAcesso.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if EstadoDoCadastro=ecInserir then
    Result:=oAcaoAcesso.Inserir
  else if EstadoDoCadastro=ecAlterar then
    Result:=oAcaoAcesso.Atualizar;
end;

{$ENDREGION}

{$REGION'btns'}
procedure TfrmCadAcaoAcesso.btnAlterarClick(Sender: TObject);
begin
  //pega o id que esta na query
  if oAcaoAcesso.Selecionar(FDQuery1.FieldByName('acaoAcessoId').AsInteger) then begin
    //se encontra os registro preenche os edt com as informações
    edtAcaoAcessoId.Text:=oAcaoAcesso.codigo.ToString();
    edtDescricao.Text   :=oAcaoAcesso.descricao;
    edtChave.Text       :=oAcaoAcesso.chave;
  end
  else begin
    // se n achar nada, cancela a operação
    btnCancelar.Click;
    Abort;
  end;

  //púxa as infromações da tela de herença (pai)
  inherited;
end;

procedure TfrmCadAcaoAcesso.btnGravarClick(Sender: TObject);
begin
  //assume o valor 0 para mostrar que é um novo cadastro
  if edtAcaoAcessoId.Text<>EmptyStr then
    oAcaoAcesso.codigo:=StrToInt(edtAcaoAcessoId.Text)
  else
    oAcaoAcesso.codigo:=0;

  //passa os os valores para os campos na tela
  oAcaoAcesso.descricao :=edtDescricao.Text;
  oAcaoAcesso.chave     :=edtChave.Text;

  //verifica se ja tem uma "chave" igual no banco, inpedindo que se repita
  if oAcaoAcesso.ChaveExiste(edtChave.Text, oAcaoAcesso.codigo) then begin
    MessageDlg('Chave já cadastrado', mtInformation, [mbOK], 0);
    edtChave.SetFocus;
    Abort;
  end;

  inherited;
end;

procedure TfrmCadAcaoAcesso.btnNovoClick(Sender: TObject);
begin
  inherited;
  // define id 0 para indicar novo registro
  edtAcaoAcessoId.Text := '0';
  //coloca o cursor direto no edt descricao, ja começa digitando nele
  edtDescricao.SetFocus;
end;

{$ENDREGION}

procedure TfrmCadAcaoAcesso.dsListagemStateChange(Sender: TObject);
begin
  inherited;
  //função para habilitar/desabilitar botões
  ControlarBotoes;
end;

procedure TfrmCadAcaoAcesso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  //verifica se o objeto ainda esta na memoria
  if Assigned(oAcaoAcesso) then
  // se estiver ele, limpa ela, evita de acessar um endereço de memoria que não existe mais
     FreeAndNil(oAcaoAcesso);
end;

procedure TfrmCadAcaoAcesso.FormCreate(Sender: TObject);
begin
  inherited;
  //cria o objeto e passa a conexão com o banco para ela
  oAcaoAcesso:=TAcaoAcesso.Create(dtmConexao.FDConexao);
  //define o campo padrão para buscas e ordenação do grid
  indiceAtual:='descricao'
end;

end.
