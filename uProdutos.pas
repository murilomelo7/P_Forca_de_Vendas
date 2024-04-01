unit uProdutos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Edit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type

  TProdutos = record
    codigo: Integer;
    nome: String;
    preco: Double;
    estoque: Integer;
  end;

  TfrmProdutos = class(TForm)
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    Layout1: TLayout;
    btnVoltar: TSpeedButton;
    btnInserirProduto: TSpeedButton;
    Label1: TLabel;
    Layout2: TLayout;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    tbInserir: TTabItem;
    Layout4: TLayout;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    edt_Codigo: TEdit;
    Label4: TLabel;
    edt_Nome: TEdit;
    Label5: TLabel;
    edt_Preco: TEdit;
    Layout5: TLayout;
    btn_Salvar: TSpeedButton;
    tbEditar: TTabItem;
    Layout6: TLayout;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Layout7: TLayout;
    Label7: TLabel;
    edt_Codigo_edicao: TEdit;
    Label8: TLabel;
    edt_nome_edicao: TEdit;
    Label9: TLabel;
    edt_preco_edicao: TEdit;
    btn_salvar_edica: TButton;
    btnDeletar: TButton;
    FDConnection1: TFDConnection;
    FDQProdutos: TFDQuery;
    ListViewProdutos: TListView;
    Label10: TLabel;
    edt_Estoque: TEdit;
    Label11: TLabel;
    edt_Estoque_edicao: TEdit;
    Layout8: TLayout;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    procedure atualizaProdutosdoBanco();
    procedure insereProdutonaLista(produto: TProdutos);
    procedure editaProdutoBanco(produto: TProdutos);
    procedure deletaProduto(id_produto: Integer);
    procedure insereProdutoBanco(produto: TProdutos);
    procedure btn_SalvarClick(Sender: TObject);
    procedure btnInserirProdutoClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure ListViewProdutosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    function buscarProdutonoBanco(id_produto: Integer): TProdutos;
    procedure btn_salvar_edicaClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.fmx}

procedure TfrmProdutos.atualizaProdutosdoBanco;
var
  vProdutos: TProdutos;
begin
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('select * from produtos');

  if edtPesquisa.Text <> '' then
  begin
   ShowMessage('asd.');
    FDQProdutos.SQL.Add('where nome like :pesquisa or preco = :pesquisa');
    FDQProdutos.ParamByName('pesquisa').AsString := edtPesquisa.Text;
  end;

  FDQProdutos.Open();

  FDQProdutos.First;

  ListViewProdutos.Items.Clear;

  while not FDQProdutos.Eof do
  begin
    // Atribua diretamente aos campos do registro
    vProdutos.codigo := FDQProdutos.FieldByName('codigo').AsInteger;
    vProdutos.nome := FDQProdutos.FieldByName('nome').AsString;
    vProdutos.preco := FDQProdutos.FieldByName('preco').AsFloat;
    vProdutos.estoque := FDQProdutos.FieldByName('estoque').AsInteger;

    insereProdutonaLista(vProdutos);

    FDQProdutos.Next;
  end;

end;

procedure TfrmProdutos.insereProdutonaLista(produto: TProdutos);
begin
  // Insere cliente por cliente na lista
  with ListViewProdutos.Items.Add do
  begin

    TListItemText(Objects.FindDrawable('txtCodigoProduto')).Text :=
      IntToStr(produto.codigo);
    TListItemText(Objects.FindDrawable('txtNomeProduto')).Text := produto.nome;
    TListItemText(Objects.FindDrawable('txtPrecoProduto')).Text :=
      FloatToStr(produto.preco);
    TListItemText(Objects.FindDrawable('txtEstoqueProduto')).Text :=
      IntToStr(produto.estoque);
  end;

end;

procedure TfrmProdutos.ListViewProdutosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  vProduto: TProdutos;
  id_produto: Integer;
begin
  // Chamar a tela de edi��o

  // pegar o indice do listview

  id_produto := StrToInt(TListItemText(ListViewProdutos.Items[ItemIndex]
    .Objects.FindDrawable('txtCodigoProduto')).Text);

  vProduto := buscarProdutonoBanco(id_produto);

  edt_Codigo_edicao.Text := IntToStr(vProduto.codigo);
  edt_nome_edicao.Text := vProduto.nome;
  edt_preco_edicao.Text := FloatToStr(vProduto.preco);
  edt_Estoque_edicao.Text := IntToStr(vProduto.estoque);

  TabControl1.TabIndex := 2;

end;

procedure TfrmProdutos.SpeedButton1Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure TfrmProdutos.SpeedButton2Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure TfrmProdutos.btnDeletarClick(Sender: TObject);
var
  id_produto: Integer;
begin

  id_produto := StrToInt(edt_Codigo_edicao.Text);

  deletaProduto(id_produto);

  ShowMessage('Produto deletado com sucesso.');

  TabControl1.TabIndex := 0;

  atualizaProdutosdoBanco;
end;

procedure TfrmProdutos.btnInserirProdutoClick(Sender: TObject);
begin
  TabControl1.TabIndex := 1;
end;

procedure TfrmProdutos.btnPesquisarClick(Sender: TObject);
begin
  atualizaProdutosdoBanco;
end;

procedure TfrmProdutos.btnVoltarClick(Sender: TObject);
begin
  frmProdutos.Close;
end;

procedure TfrmProdutos.btn_SalvarClick(Sender: TObject);
var
  vProduto: TProdutos;
begin
  vProduto.codigo := StrToInt(edt_Codigo.Text);
  vProduto.nome := edt_Nome.Text;
  vProduto.preco := StrToFloat(edt_Preco.Text);
  vProduto.estoque := StrToInt(edt_Estoque.Text);

  // Chamar procedimento para inserir o produto no banco
  insereProdutoBanco(vProduto);
  TabControl1.TabIndex := 0;
end;

procedure TfrmProdutos.btn_salvar_edicaClick(Sender: TObject);
var
  vProduto: TProdutos;
begin
  // Buscar os dados dos edits e salvar no banco
  vProduto.codigo := StrToInt(edt_Codigo_edicao.Text);
  vProduto.nome := edt_nome_edicao.Text;
  vProduto.preco := StrToFloat(edt_preco_edicao.Text);
  vProduto.estoque := StrToInt(edt_Estoque_edicao.Text);

  editaProdutoBanco(vProduto);

  ShowMessage('Produto alterado com sucesso.');

  TabControl1.TabIndex := 0;
  atualizaProdutosdoBanco;
end;

procedure TfrmProdutos.editaProdutoBanco(produto: TProdutos);
begin
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('update produtos set ');
  FDQProdutos.SQL.Add('   nome = :nome, ');
  FDQProdutos.SQL.Add('   preco = :preco, ');
  FDQProdutos.SQL.Add('   estoque = :estoque ');
  FDQProdutos.SQL.Add('where codigo = :codigo');

  FDQProdutos.ParamByName('codigo').AsInteger := produto.codigo;
  FDQProdutos.ParamByName('nome').AsString := produto.nome;
  FDQProdutos.ParamByName('preco').AsFloat := produto.preco;
  FDQProdutos.ParamByName('estoque').AsInteger := produto.estoque;

  FDQProdutos.ExecSQL;
end;

procedure TfrmProdutos.deletaProduto(id_produto: Integer);
begin

  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('delete from produtos ');
  FDQProdutos.SQL.Add('where codigo = :codigo');

  FDQProdutos.ParamByName('codigo').AsInteger := id_produto;

  FDQProdutos.ExecSQL;

end;

procedure TfrmProdutos.insereProdutoBanco(produto: TProdutos);
begin
  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('INSERT INTO PRODUTOS (CODIGO, NOME, PRECO, ESTOQUE)');
  FDQProdutos.SQL.Add(' VALUES (:CODIGO, :NOME, :PRECO, :ESTOQUE)');
  FDQProdutos.ParamByName('codigo').AsInteger := produto.codigo;
  FDQProdutos.ParamByName('nome').AsString := produto.nome;
  FDQProdutos.ParamByName('preco').AsFloat := produto.preco;
  FDQProdutos.ParamByName('estoque').AsInteger := produto.estoque;
  FDQProdutos.ExecSQL;
end;

function TfrmProdutos.buscarProdutonoBanco(id_produto: Integer): TProdutos;
var
  vProduto: TProdutos;
begin

  FDQProdutos.Close;
  FDQProdutos.SQL.Clear;
  FDQProdutos.SQL.Add('select * from produtos ');
  FDQProdutos.SQL.Add('where codigo = :codigo');
  FDQProdutos.ParamByName('codigo').AsInteger := id_produto;

  FDQProdutos.Open();

  vProduto.codigo := id_produto;
  vProduto.nome := FDQProdutos.FieldByName('nome').AsString;
  vProduto.preco := FDQProdutos.FieldByName('preco').AsFloat;
  vProduto.estoque := FDQProdutos.FieldByName('estoque').AsInteger;

  Result := vProduto;

end;

end.
