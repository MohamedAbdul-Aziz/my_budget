import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsPt extends AppStrings {
  const AppStringsPt();

  @override
  String get localeName => 'pt';

  @override
  String get appTitle => 'Meu Orçamento';

  @override
  String get add => 'Adicionar';

  @override
  String get undo => 'Desfazer';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get nothingRecordedYet => 'Nada registrado ainda';

  @override
  String get emptyMonthHint =>
      'Toque em Adicionar para registrar sua primeira despesa ou receita '
      'deste mês.';

  @override
  String get yourMonths => 'Seus meses';

  @override
  String spentIn(String month) => 'Gasto em $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count despesa',
    other: '$count despesas',
  );

  @override
  String get quickExpense => 'Despesa rápida';

  @override
  String get expenseSaved => 'Despesa salva';

  @override
  String get newExpense => 'Nova despesa';

  @override
  String get editExpense => 'Editar despesa';

  @override
  String get when => 'Quando';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get pickADate => 'Escolher uma data';

  @override
  String get category => 'Categoria';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get noteHint => 'Foi para quê?';

  @override
  String get addExpense => 'Adicionar despesa';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Categorias';

  @override
  String get newCategory => 'Nova categoria';

  @override
  String get editCategory => 'Editar categoria';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get categoryName => 'Nome';

  @override
  String get color => 'Cor';

  @override
  String get icon => 'Ícone';

  @override
  String get builtIn => 'Padrão';

  @override
  String get custom => 'Personalizada';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String deleteCategoryTitle(String name) => 'Excluir $name?';

  @override
  String get deleteCategoryBody =>
      'As despesas desta categoria vão para Outros. Nada é excluído.';

  @override
  String get settings => 'Configurações';

  @override
  String get appearance => 'Aparência';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get currency => 'Moeda';

  @override
  String get currencySymbol => 'Símbolo';

  @override
  String get currencySymbolHint => 'Aparece ao lado de cada valor';

  @override
  String get currencyOther => 'Outra';

  @override
  String get reminders => 'Lembretes';

  @override
  String get dailyReminder => 'Lembrete diário';

  @override
  String get dailyReminderHint =>
      'Um aviso para registrar o que você gastou hoje';

  @override
  String get reminderTime => 'Horário';

  @override
  String get notificationsBlocked =>
      'As notificações deste app estão desativadas. Permita-as nas configurações do aparelho.';

  @override
  String get reminderNotificationTitle => 'Registre os gastos de hoje';

  @override
  String get reminderNotificationBody =>
      'Reserve um momento para adicionar o que você gastou hoje.';

  @override
  String get security => 'Segurança';

  @override
  String get appLock => 'Bloqueio do app';

  @override
  String get appLockHint =>
      'Pede digital, rosto ou bloqueio de tela ao abrir o app';

  @override
  String get appLockUnavailable =>
      'Configure um bloqueio de tela neste aparelho para usar';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlockToContinue => 'Desbloqueie para ver seu orçamento';

  @override
  String get confirmItsYou => 'Confirme que é você para alterar o bloqueio';

  @override
  String get storedOnThisDevice =>
      'Suas despesas ficam salvas neste aparelho. Entre para fazer backup '
      'delas.';

  @override
  String get account => 'Conta';

  @override
  String get accountOptional =>
      'A conta é opcional. O app funciona por completo sem ela.';

  @override
  String get signIn => 'Entrar';

  @override
  String get signOut => 'Sair';

  @override
  String get signedIn => 'Conectado';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get noAccountYet => 'Ainda não tem conta? Crie uma';

  @override
  String get haveAnAccount => 'Já tem conta? Entre';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get passwordRules => 'Pelo menos 6 caracteres';

  @override
  String get confirmEmail => 'Confirme seu e-mail';

  @override
  String codeSentTo(String email) =>
      'Enviamos um código para $email. Digite-o abaixo para terminar de criar '
      'sua conta.';

  @override
  String get confirmationCode => 'Código';

  @override
  String get confirm => 'Confirmar';

  @override
  String get resendCode => 'Enviar um novo código';

  @override
  String get codeResent => 'Um novo código está a caminho';

  @override
  String get useDifferentEmail => 'Usar outro e-mail';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get resetPassword => 'Redefinir senha';

  @override
  String resetCodeSentTo(String email) =>
      'Enviamos um código para $email. Digite-o com uma nova senha para sua conta.';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get saveNewPassword => 'Salvar nova senha';

  @override
  String get backToSignIn => 'Voltar para entrar';

  @override
  String get backupHint =>
      'Faça backup para guardar uma cópia das suas despesas na sua conta. '
      'Restaurar traz essa cópia para este celular sem apagar nada que já '
      'esteja aqui.';

  @override
  String get backUpNow => 'Fazer backup agora';

  @override
  String get autoBackup => 'Backup automático';

  @override
  String get autoBackupHint =>
      'Sempre que você sai do app, as novas alterações vão para o backup da sua conta.';

  @override
  String get restoreData => 'Restaurar';

  @override
  String get backingUp => 'Fazendo backup…';

  @override
  String get restoring => 'Restaurando…';

  @override
  String get backupDone => 'Backup concluído';

  @override
  String get restoreDone => 'Restauração concluída';

  @override
  String get neverSynced => 'Sem backup ainda';

  @override
  String lastSynced(String when) => 'Última sincronização: $when';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountTitle => 'Excluir sua conta?';

  @override
  String get deleteAccountBody =>
      'Isso exclui para sempre sua conta e o backup das suas despesas salvo '
      'nela. Não dá para desfazer. As despesas deste celular continuam aqui, '
      'e você pode seguir usando o app sem conta.';

  @override
  String get deletingAccount => 'Excluindo sua conta…';

  @override
  String get accountDeleted => 'Sua conta foi excluída';

  @override
  String get home => 'Início';

  @override
  String get analyses => 'Análises';

  @override
  String get vsLastMonth => 'Comparado ao mês passado';

  @override
  String get noComparison => 'Sem dados no mês passado';

  @override
  String get dailySpending => 'Gasto diário';

  @override
  String get dailyAverage => 'Média por dia';

  @override
  String get topDay => 'Dia mais alto';

  @override
  String get byCategory => 'Gasto por categoria';

  @override
  String get noSpendingThisMonth => 'Nenhum gasto neste mês ainda.';

  @override
  String get monthlyTrend => 'Últimos 6 meses';

  @override
  String lastMonthTotal(String amount) => 'Mês passado: $amount';

  @override
  String get budgets => 'Orçamentos';

  @override
  String get monthlyBudget => 'Orçamento mensal';

  @override
  String get setMonthlyBudget => 'Defina um orçamento mensal';

  @override
  String get setBudgetHint =>
      'Veja quanto sobra e receba um aviso antes de gastar demais.';

  @override
  String get setBudget => 'Definir';

  @override
  String get editBudget => 'Editar orçamento';

  @override
  String get removeBudget => 'Remover';

  @override
  String get save => 'Salvar';

  @override
  String amountLeft(String amount) => 'Restam $amount';

  @override
  String amountOver(String amount) => '$amount acima do orçamento';

  @override
  String spentOfLimit(String spent, String limit) => '$spent gastos de $limit';

  @override
  String amountSpent(String amount) => '$amount gastos';

  @override
  String budgetUsed(String percent) => '$percent do orçamento usado';

  @override
  String get categoryBudgets => 'Orçamentos por categoria';

  @override
  String get categoryBudgetsHint =>
      'Limite quanto você gasta em uma categoria.';

  @override
  String categoryBudgetTitle(String name) => 'Orçamento de $name';

  @override
  String get setLimit => 'Definir limite';

  @override
  String get closeToLimit => 'Perto do limite';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Os orçamentos se repetem todo mês. Você recebe um aviso quando o gasto '
      'passa de $nearing e outro ao chegar a $reached.';

  @override
  String get budgetAlertTitle => 'Alerta de orçamento';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Ver';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Você usou $percent do seu orçamento mensal';

  @override
  String get monthlyBudgetUsedUp => 'Você usou todo o seu orçamento mensal';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Você passou $amount do seu orçamento mensal';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Você usou $percent do seu orçamento de $name';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Você usou todo o seu orçamento de $name';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Você passou $amount do seu orçamento de $name';

  @override
  String get dataManagement => 'Gerenciar dados';

  @override
  String get dataManagementHint =>
      'Arquivos que você mesmo guarda. Funcionam offline e sem conta.';

  @override
  String get backUpToFile => 'Fazer backup dos meus dados';

  @override
  String get backUpToFileHint =>
      'Um arquivo de backup completo para importar depois';

  @override
  String get exportCsv => 'Exportar como CSV';

  @override
  String get exportCsvHint => 'Para Excel ou Google Sheets';

  @override
  String get exportPdf => 'Exportar como PDF';

  @override
  String get exportPdfHint => 'Um relatório para ler, imprimir ou compartilhar';

  @override
  String get importData => 'Importar dados';

  @override
  String get importDataHint => 'Restaurar de um arquivo de backup';

  @override
  String get preparingFile => 'Preparando seu arquivo…';

  @override
  String get importingData => 'Importando…';

  @override
  String get fileSaved => 'Arquivo salvo';

  @override
  String get importDone => 'Importação concluída';

  @override
  String get importNothingNew =>
      'Este celular já tinha tudo o que está no backup';

  @override
  String get fileReady => 'Seu arquivo está pronto';

  @override
  String get shareFile => 'Compartilhar';

  @override
  String get shareFileHint => 'WhatsApp, e-mail, Google Drive e mais';

  @override
  String get saveToPhone => 'Salvar neste celular';

  @override
  String get saveToPhoneHint => 'Escolha onde guardar';

  @override
  String get importTitle => 'Importar este backup?';

  @override
  String get importMergeHint =>
      'Mesclar mantém tudo o que está neste celular e adiciona o que falta. '
      'Quando um registro é diferente, vale a alteração mais recente.';

  @override
  String get merge => 'Mesclar';

  @override
  String get replaceEverything => 'Substituir tudo';

  @override
  String get replaceTitle => 'Substituir tudo neste celular?';

  @override
  String get replaceBody =>
      'Tudo neste celular que não estiver no backup será apagado, e a versão '
      'do backup de cada registro será usada. Não dá para desfazer.';

  @override
  String get replace => 'Substituir';

  @override
  String get colDate => 'Data';

  @override
  String get colMonth => 'Mês';

  @override
  String get colAmount => 'Valor';

  @override
  String get colNote => 'Nota';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transações';

  @override
  String get colTotal => 'Total';

  @override
  String get colShare => 'Parcela';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get reportTitle => 'Meu Orçamento: relatório de despesas';

  @override
  String get reportPeriod => 'Período';

  @override
  String get reportTotal => 'Total gasto';

  @override
  String get reportMonthlyAverage => 'Média por mês';

  @override
  String get reportByMonth => 'Gasto por mês';

  @override
  String get reportAllExpenses => 'Todas as despesas';

  @override
  String get reportEmpty => 'Nenhuma despesa registrada ainda.';

  @override
  String get reportPageTemplate => 'Página {page} de {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} e ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} e '
              '${personCount(people)}';
    return date == null
        ? 'Este backup tem $contents.'
        : 'Backup de $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count categoria',
    other: '$count categorias',
  );

  @override
  String reportGenerated(String when) => 'Gerado em $when';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Alimentação',
    'cat_transport' => 'Transporte',
    'cat_bills' => 'Contas',
    'cat_shopping' => 'Compras',
    'cat_health' => 'Saúde e exercício',
    'cat_entertainment' => 'Lazer',
    'cat_work' => 'Trabalho',
    'cat_other' => 'Outros',
    'cat_salary' => 'Salário',
    'cat_freelance' => 'Freelance',
    'cat_investments' => 'Investimentos',
    'cat_gifts' => 'Presentes',
    'cat_income_other' => 'Outras receitas',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Não foi possível salvar neste aparelho. Tente de novo.',
    FailureCode.notFound => 'Esse item não existe mais.',
    FailureCode.unknown => 'Algo deu errado.',
    FailureCode.amountRequired => 'Digite um valor maior que zero.',
    FailureCode.amountTooLarge => 'Esse valor é grande demais.',
    FailureCode.amountInvalid => 'Digite um valor válido.',
    FailureCode.categoryRequired => 'Escolha uma categoria.',
    FailureCode.categoryNameRequired => 'Dê um nome à categoria.',
    FailureCode.categoryNameTaken => 'Você já tem uma categoria com este nome.',
    FailureCode.categoryNameTooLong =>
      'O nome deve ter menos de 30 caracteres.',
    FailureCode.categoryProtected => 'Esta categoria não pode ser excluída.',
    FailureCode.currencySymbolInvalid => 'Use de 1 a 4 caracteres.',
    FailureCode.network =>
      'Sem conexão. Verifique sua internet e tente de novo.',
    FailureCode.emailInvalid => 'Digite um e-mail válido.',
    FailureCode.passwordTooShort =>
      'A senha precisa de pelo menos 6 caracteres.',
    FailureCode.invalidCredentials => 'E-mail ou senha incorretos.',
    FailureCode.emailTaken => 'Já existe uma conta com este e-mail.',
    FailureCode.emailNotConfirmed =>
      'Primeiro confirme seu e-mail com o código que enviamos.',
    FailureCode.codeInvalid => 'Esse código está errado ou expirou.',
    FailureCode.signInRequired => 'Entre de novo e tente mais uma vez.',
    FailureCode.syncOtherAccount =>
      'Os dados deste celular estão ligados a outra conta.',
    FailureCode.syncFailed =>
      'Não foi possível sincronizar com sua conta. Tente de novo.',
    FailureCode.accountDeletionFailed =>
      'Não foi possível excluir sua conta. Tente de novo.',
    FailureCode.backupNotRecognized =>
      'Este arquivo não é um backup do Meu Orçamento.',
    FailureCode.pastedNotRecognized =>
      'O texto colado não são dados que o app consiga ler. Copie a resposta inteira da IA e tente de novo, ou peça para ela corrigir.',
    FailureCode.backupTooNew =>
      'Este backup é de uma versão mais nova do Meu Orçamento. Atualize o '
          'app e tente de novo.',
    FailureCode.backupDamaged =>
      'Este arquivo de backup está danificado, então nada foi importado.',
    FailureCode.fileUnavailable =>
      'Não foi possível abrir esse arquivo. Tente escolhê-lo de novo.',
    FailureCode.storageFull => 'Não há espaço livre suficiente neste celular.',
    FailureCode.exportFailed =>
      'Não foi possível criar o arquivo. Tente de novo.',
    FailureCode.shareUnavailable =>
      'Não foi possível abrir o menu de compartilhar.',
    FailureCode.saveFailed =>
      'Não foi possível salvar o arquivo. Tente de novo.',
    FailureCode.tooManyAttempts =>
      'Muitas tentativas. Espere um pouco e tente de novo.',
    FailureCode.titleRequired => 'Dê um nome.',
    FailureCode.titleTooLong => 'O nome deve ter menos de 40 caracteres.',
    FailureCode.dueDayInvalid => 'Escolha quando vence.',
    FailureCode.alreadyPaid => 'Esse pagamento já está registrado.',
    FailureCode.personRequired => 'Escolha uma pessoa.',
    FailureCode.personNameRequired => 'Digite um nome.',
    FailureCode.personNameTooLong => 'O nome deve ter menos de 40 caracteres.',
    FailureCode.phoneInvalid => 'Digite um telefone válido.',
    FailureCode.transactionSettled =>
      'Transações acertadas não podem ser alteradas.',
    FailureCode.nothingToSettle => 'Não há nada para acertar.',
    FailureCode.settlementAlreadyLogged =>
      'Este acerto já está no seu orçamento.',
  };

  @override
  String get expenseDeleted => 'Despesa excluída';

  @override
  String get expenseRestored => 'Despesa restaurada';

  @override
  String categoryAdded(String name) => '$name adicionado';

  @override
  String get categoryUpdated => 'Categoria atualizada';

  @override
  String categoryDeleted(String name) => '$name excluído';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name excluída: ${expenseCount(count)} foram para Outros';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name excluída: ${transactionCount(count)} foram para Outras receitas';

  @override
  String get expense => 'Despesa';

  @override
  String get income => 'Receita';

  @override
  String get search => 'Pesquisar';

  @override
  String get searchHint => 'Pesquise notas ou valores';

  @override
  String get searchPrompt =>
      'Encontre qualquer transação pela nota ou pelo valor, ou filtre por tipo, categoria e data.';

  @override
  String get noSearchResults => 'Nenhuma transação encontrada';

  @override
  String get allTypes => 'Tudo';

  @override
  String get anyCategory => 'Qualquer categoria';

  @override
  String get anyDate => 'Qualquer data';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get transactionType => 'Despesa ou receita';

  @override
  String get quickIncome => 'Receita rápida';

  @override
  String get newIncome => 'Nova receita';

  @override
  String get editIncome => 'Editar receita';

  @override
  String get addIncome => 'Adicionar receita';

  @override
  String get incomeNoteHint => 'De onde veio?';

  @override
  String get totalIncome => 'Receita total';

  @override
  String get totalExpenses => 'Despesa total';

  @override
  String get netBalance => 'Saldo líquido';

  @override
  String get savingsRate => 'Taxa de poupança';

  @override
  String get savingsRateNoIncome =>
      'Adicione receitas para ver sua taxa de poupança';

  @override
  String get expenseCategories => 'Categorias de despesa';

  @override
  String get incomeCategories => 'Categorias de receita';

  @override
  String get deleteIncomeCategoryBody =>
      'As receitas desta categoria vão para Outras receitas. Nada é excluído.';

  @override
  String get incomeDeleted => 'Receita excluída';

  @override
  String get incomeRestored => 'Receita restaurada';

  @override
  String get colType => 'Tipo';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count transação',
    other: '$count transações',
  );

  @override
  String get recurringPayments => 'Pagamentos recorrentes';

  @override
  String get newRecurring => 'Novo pagamento recorrente';

  @override
  String get editRecurring => 'Editar pagamento recorrente';

  @override
  String get addRecurring => 'Adicionar pagamento';

  @override
  String get recurringTitle => 'Nome';

  @override
  String get recurringTitleHint => 'Aluguel, Netflix, academia…';

  @override
  String get amount => 'Valor';

  @override
  String get repeats => 'Repete';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get yearly => 'Anual';

  @override
  String get dueOn => 'Vence em';

  @override
  String get dueDayOfMonth => 'Dia do mês';

  @override
  String get dueMonthLabel => 'Mês';

  @override
  String get dueDayLabel => 'Dia';

  @override
  String get shortMonthHint => 'Em meses mais curtos, cai no último dia.';

  @override
  String get whenDue => 'No vencimento';

  @override
  String get autoDeduct => 'Débito automático';

  @override
  String get remindMe => 'Lembrar-me';

  @override
  String get autoDeductHint =>
      'Registrado como despesa automaticamente no vencimento.';

  @override
  String get remindMeHint =>
      'Você confirma cada pagamento antes de ele ser registrado.';

  @override
  String get statusPaid => 'Pago';

  @override
  String get statusUpcoming => 'Próximo';

  @override
  String get statusOverdue => 'Atrasado';

  @override
  String get markAsPaid => 'Marcar pago';

  @override
  String get dueToday => 'Vence hoje';

  @override
  String dueOnDate(String date) => 'Vence em $date';

  @override
  String nextDueOn(String date) => 'Próximo em $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Venceu em $date'
      : '${paymentCount(count)} atrasados desde $date';

  @override
  String everyWeekday(String weekday) => 'Toda $weekday';

  @override
  String monthlyOnDay(String day) => 'Todo mês no dia $day';

  @override
  String yearlyOn(String date) => 'Todo ano em $date';

  @override
  String get monthlyAverage => 'Por mês';

  @override
  String get monthlyAverageHint =>
      'Todos os seus pagamentos recorrentes, em média';

  @override
  String get noRecurringYet => 'Nenhum pagamento recorrente ainda';

  @override
  String get noRecurringHint =>
      'Adicione aluguel, contas e assinaturas uma vez só. Todo mês você verá '
      'o que está pago e o que ainda falta.';

  @override
  String get paymentsToConfirm => 'Pagamentos a confirmar';

  @override
  String get seeAll => 'Ver tudo';

  @override
  String get deleteRecurringBody =>
      'Ele para de se repetir. Pagamentos já registrados continuam nas suas '
      'transações.';

  @override
  String recurringPaid(String name) => '$name marcado como pago';

  @override
  String recurringReceived(String name) => '$name marcado como recebido';

  @override
  String get statusReceived => 'Recebido';

  @override
  String get markAsReceived => 'Marcar recebido';

  @override
  String get autoAdd => 'Crédito automático';

  @override
  String get autoAddHint =>
      'Registrado como receita automaticamente no vencimento.';

  @override
  String get monthlyIncomeAverage => 'Receita por mês';

  @override
  String get recurringPaymentUndone => 'Pagamento removido';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: '$count pagamento recorrente foi registrado automaticamente',
    other: '$count pagamentos recorrentes foram registrados automaticamente',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count pagamento',
    other: '$count pagamentos',
  );

  @override
  String get colPaidThrough => 'Pago até';

  // People & debts

  @override
  String get people => 'Pessoas';

  @override
  String get peopleAndDebts => 'Pessoas e dívidas';

  @override
  String get person => 'Pessoa';

  @override
  String get personName => 'Nome';

  @override
  String get phone => 'Telefone';

  @override
  String get phoneOptional => 'Telefone (opcional)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Situação';

  @override
  String get owesYou => 'Deve a você';

  @override
  String get youOwe => 'Você deve';

  @override
  String get owedToYou => 'Devem a você';

  @override
  String get settledUp => 'Acertado';

  @override
  String get iPaidForThem => 'Eu paguei por essa pessoa';

  @override
  String get theyPaidForMe => 'Pagou por mim';

  @override
  String get theyPaidYou => 'Pagou você';

  @override
  String get youPaidThem => 'Você pagou';

  @override
  String get openStatus => 'Em aberto';

  @override
  String get settledStatus => 'Acertado';

  @override
  String get settledOn => 'Acertado em';

  @override
  String get createdOn => 'Criado';

  @override
  String get lastEdited => 'Última edição';

  @override
  String get colEdits => 'Edições';

  @override
  String get activeTransactions => 'Transações em aberto';

  @override
  String get settledHistory => 'Histórico de acertos';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterOwedToMe => 'Me devem';

  @override
  String get filterIOwe => 'Eu devo';

  @override
  String get filterSettled => 'Acertados';

  @override
  String get addPerson => 'Adicionar pessoa';

  @override
  String get addPersonHint => 'Alguém com quem você divide gastos';

  @override
  String get newPerson => 'Nova pessoa';

  @override
  String get editPerson => 'Editar pessoa';

  @override
  String get deletePerson => 'Excluir pessoa';

  @override
  String get quickTransaction => 'Transação rápida';

  @override
  String get quickTransactionHint =>
      'Registre quem pagou, com alguém que você já adicionou';

  @override
  String get noPeopleYet => 'Nenhuma pessoa ainda';

  @override
  String get noPeopleHint =>
      'Adicione as pessoas com quem você divide gastos para saber quem deve '
      'a quem.';

  @override
  String get nobodyHere => 'Ninguém corresponde a este filtro.';

  @override
  String get addPersonFirst => 'Adicione uma pessoa primeiro.';

  @override
  String get newTransaction => 'Nova transação';

  @override
  String get editTransaction => 'Editar transação';

  @override
  String get transactionDetails => 'Detalhes da transação';

  @override
  String get debtNoteHint => 'Foi para quê?';

  @override
  String get changeHistory => 'Histórico de alterações';

  @override
  String get edited => 'Editado';

  @override
  String get settleUp => 'Acertar';

  @override
  String get settle => 'Acertar';

  @override
  String get noDebtsYet => 'Nada registrado ainda';

  @override
  String get noDebtsHint =>
      'Adicione o que você pagou por essa pessoa ou o que ela pagou por você.';

  @override
  String get settleEven =>
      'Estas transações se anulam, então ninguém precisa pagar nada.';

  @override
  String get logSettlementTitle =>
      'Registrar este acerto no seu orçamento mensal?';

  @override
  String get loggedInBudget => 'No seu orçamento';

  @override
  String get deleteTransactionTitle => 'Excluir esta transação?';

  @override
  String get deleteTransactionBody =>
      'Ela será retirada do saldo com esta pessoa.';

  @override
  String get deletePersonBody =>
      'As transações e o histórico de acertos dela também serão excluídos. O '
      'que você registrou no seu orçamento continua.';

  @override
  String get settledLocked => 'Acertada, então não pode mais ser alterada.';

  @override
  String get personUpdated => 'Pessoa atualizada';

  @override
  String get debtDeleted => 'Transação excluída';

  @override
  String get settledUpNotice => 'Tudo acertado';

  @override
  String get settlementLogged => 'Adicionado ao seu orçamento';

  @override
  String personOwesYou(String name) => '$name deve a você';

  @override
  String youOwePerson(String name) => 'Você deve a $name';

  @override
  String settledWith(String name) => 'Tudo acertado com $name';

  @override
  String settleUpFor(String amount) => 'Acertar $amount';

  @override
  String settleTitle(String name) => 'Acertar com $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name paga $amount a você para zerar tudo.';

  @override
  String settleYouPay(String name, String amount) =>
      'Você paga $amount a $name para zerar tudo.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} vão para o histórico de acertos.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount será adicionado como receita em Outras receitas. Você pode '
      'movê-lo para outra categoria depois.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount será adicionado como despesa em Outros. Você pode movê-lo '
      'para outra categoria depois.';

  @override
  String settlementNote(String name) => 'Acerto com $name';

  @override
  String settledGroupTitle(String date) => 'Acertado em $date';

  @override
  String deletePersonTitle(String name) => 'Excluir $name?';

  @override
  String editedOn(String date) => 'Editado em $date';

  @override
  String wasValues(String values) => 'Antes: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count pessoa',
    other: '$count pessoas',
  );

  @override
  String get importFromAi => 'De outro app';

  @override
  String get importFromAiHint =>
      'Converta seus dados com ChatGPT, Gemini, Claude ou outra IA';

  @override
  String get aiImportTitle => 'Importar de outro app';

  @override
  String get aiImportIntro =>
      'Um chat de IA pode transformar dados de outro app ou de uma planilha num arquivo que o My Budget importa.';

  @override
  String get aiImportStep1 => 'Copie o prompt.';

  @override
  String get aiImportStep2 =>
      'Cole-o no ChatGPT, Gemini, Claude ou outra IA e anexe ou cole seus dados.';

  @override
  String get aiImportStep3 =>
      'Copie a resposta da IA e cole aqui, ou salve como arquivo e escolha-o.';

  @override
  String get copyPrompt => 'Copiar prompt';

  @override
  String get pasteAnswer => 'Colar resposta';

  @override
  String get chooseFile => 'Escolher arquivo';

  @override
  String get aiImportPrivacy =>
      'Seus dados vão para o serviço de IA que você escolher. Você verá o que será importado antes de qualquer mudança.';

  @override
  String get promptCopied => 'Prompt copiado';

  @override
  String get askTitle => 'Pergunte sobre seus gastos';

  @override
  String get askHint => 'Toque numa pergunta para ver a resposta.';

  @override
  String get askCompareMonths => 'Comparar meses';

  @override
  String get askTopCategory => 'Categoria principal';

  @override
  String get askVsLastMonth => 'vs mês passado';

  @override
  String get askBiggestExpense => 'Maior despesa';

  @override
  String get askTopDay => 'Dia mais caro';

  @override
  String get askWeekday => 'Dia de mais gasto';

  @override
  String get askMonthEnd => 'Estimativa do mês';

  @override
  String get askSaved => 'Economizei?';

  @override
  String get askBudgetLeft => 'Orçamento restante';

  @override
  String get askHighestLowest => 'Mês mais alto e mais baixo';

  @override
  String get askCount => 'Quantas despesas';

  @override
  String get askTopIncome => 'Maior receita';

  @override
  String get otherCategories => 'Outras';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'O maior gasto foi em $category: $amount ($percent do mês).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Você gastou $amount a mais em $month do que em $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Você gastou $amount a menos em $month do que em $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Você gastou o mesmo em $month e em $other.';

  @override
  String answerNothingIn(String month) => 'Nenhum gasto em $month.';

  @override
  String answerRise(String category, String amount) =>
      'Maior alta: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Maior queda: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Maior despesa: $amount em $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Dia mais caro: $date, com $amount gastos.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Dia da semana com mais gastos: $weekday ($amount este mês).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'Nesse ritmo (cerca de $average por dia) você vai gastar uns $amount até o fim do mês.';

  @override
  String answerMonthTotal(String amount) =>
      'Este mês já terminou: você gastou $amount no total.';

  @override
  String answerSaved(String amount, String income) =>
      'Você economizou $amount dos $income que recebeu.';

  @override
  String answerOverspent(String amount) =>
      'Você gastou $amount a mais do que recebeu.';

  @override
  String get answerNoIncome => 'Nenhuma receita registrada este mês.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Restam $amount do seu orçamento mensal ($percent usado).';

  @override
  String answerBudgetOver(String amount) =>
      'Você passou $amount do seu orçamento mensal.';

  @override
  String get answerNoBudget => 'Você ainda não definiu um orçamento mensal.';

  @override
  String answerOverLimit(String names) => 'Acima do limite: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Mês mais alto: $high ($highAmount). Mais baixo: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Você registrou ${expenseCount(count)}, $average em média cada.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'A maior parte da receita veio de $category: $amount ($percent).';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => 'Libra egípcia',
    'USD' => 'Dólar americano',
    'EUR' => 'Euro',
    'SAR' => 'Rial saudita',
    'AED' => 'Dirham dos EAU',
    'KWD' => 'Dinar kuwaitiano',
    'QAR' => 'Rial catariano',
    'BHD' => 'Dinar bareinita',
    'OMR' => 'Rial omanense',
    'JOD' => 'Dinar jordaniano',
    'IQD' => 'Dinar iraquiano',
    'LBP' => 'Libra libanesa',
    'SYP' => 'Libra síria',
    'YER' => 'Rial iemenita',
    'SDG' => 'Libra sudanesa',
    'LYD' => 'Dinar líbio',
    'MAD' => 'Dirham marroquino',
    'TND' => 'Dinar tunisiano',
    'DZD' => 'Dinar argelino',
    'GBP' => 'Libra esterlina',
    'TRY' => 'Lira turca',
    'IRR' => 'Rial iraniano',
    'PKR' => 'Rupia paquistanesa',
    'INR' => 'Rupia indiana',
    'RUB' => 'Rublo russo',
    'UAH' => 'Hryvnia ucraniana',
    'PLN' => 'Zloty polonês',
    'CHF' => 'Franco suíço',
    'BRL' => 'Real brasileiro',
    'CAD' => 'Dólar canadense',
    'AUD' => 'Dólar australiano',
    'CNY' => 'Yuan chinês',
    'JPY' => 'Iene japonês',
    'KRW' => 'Won sul-coreano',
    'IDR' => 'Rupia indonésia',
    'MYR' => 'Ringgit malaio',
    'VND' => 'Dong vietnamita',
    'NGN' => 'Naira nigeriana',
    _ => null,
  };
}
