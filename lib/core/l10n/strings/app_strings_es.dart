import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsEs extends AppStrings {
  const AppStringsEs();

  @override
  String get localeName => 'es';

  @override
  String get appTitle => 'Mi Presupuesto';

  @override
  String get add => 'Añadir';

  @override
  String get undo => 'Deshacer';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get nothingRecordedYet => 'Aún no hay nada registrado';

  @override
  String get emptyPeriodHint =>
      'Toca Añadir para registrar un gasto o ingreso en este periodo.';

  @override
  String get periodDay => 'Día';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mes';

  @override
  String get periodYear => 'Año';

  @override
  String get previousPeriod => 'Anterior';

  @override
  String get nextPeriod => 'Siguiente';

  @override
  String get yourMonths => 'Tus meses';

  @override
  String spentIn(String month) => 'Gastado en $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count gasto',
    other: '$count gastos',
  );

  @override
  String get quickExpense => 'Gasto rápido';

  @override
  String get expenseSaved => 'Gasto guardado';

  @override
  String get newExpense => 'Nuevo gasto';

  @override
  String get editExpense => 'Editar gasto';

  @override
  String get when => 'Cuándo';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get pickADate => 'Elegir una fecha';

  @override
  String get category => 'Categoría';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get noteHint => '¿Para qué fue?';

  @override
  String get addExpense => 'Añadir gasto';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Categorías';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get editCategory => 'Editar categoría';

  @override
  String get addCategory => 'Añadir categoría';

  @override
  String get categoryName => 'Nombre';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icono';

  @override
  String get builtIn => 'Predefinida';

  @override
  String get custom => 'Personalizada';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String deleteCategoryTitle(String name) => '¿Eliminar $name?';

  @override
  String get deleteCategoryBody =>
      'Los gastos de esta categoría pasarán a Otros. No se elimina nada.';

  @override
  String get settings => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get currency => 'Moneda';

  @override
  String get currencySymbol => 'Símbolo';

  @override
  String get currencySymbolHint => 'Se muestra junto a cada importe';

  @override
  String get currencyOther => 'Otra';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get dailyReminderHint => 'Un aviso para anotar lo que gastaste hoy';

  @override
  String get reminderTime => 'Hora';

  @override
  String get notificationsBlocked =>
      'Las notificaciones de esta app están desactivadas. Actívalas en los ajustes del teléfono.';

  @override
  String get reminderNotificationTitle => 'Anota los gastos de hoy';

  @override
  String get reminderNotificationBody =>
      'Tómate un momento para añadir lo que gastaste hoy.';

  @override
  String get security => 'Seguridad';

  @override
  String get appLock => 'Bloqueo de la app';

  @override
  String get appLockHint =>
      'Pide tu huella, tu cara o el bloqueo de pantalla al abrir la app';

  @override
  String get appLockUnavailable =>
      'Configura un bloqueo de pantalla en este teléfono para usarlo';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlockToContinue => 'Desbloquea para ver tu presupuesto';

  @override
  String get confirmItsYou => 'Confirma que eres tú para cambiar el bloqueo';

  @override
  String get storedOnThisDevice =>
      'Tus gastos se guardan en este dispositivo. Inicia sesión para hacer '
      'una copia de seguridad.';

  @override
  String get account => 'Cuenta';

  @override
  String get accountOptional =>
      'La cuenta es opcional. La app funciona por completo sin ella.';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signedIn => 'Sesión iniciada';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get noAccountYet => '¿Aún no tienes cuenta? Crea una';

  @override
  String get haveAnAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordRules => 'Al menos 6 caracteres';

  @override
  String get confirmEmail => 'Confirma tu correo';

  @override
  String codeSentTo(String email) =>
      'Enviamos un código a $email. Escríbelo abajo para terminar de crear '
      'tu cuenta.';

  @override
  String get confirmationCode => 'Código';

  @override
  String get confirm => 'Confirmar';

  @override
  String get resendCode => 'Enviar un código nuevo';

  @override
  String get codeResent => 'Un código nuevo va en camino';

  @override
  String get useDifferentEmail => 'Usar otro correo';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String resetCodeSentTo(String email) =>
      'Enviamos un código a $email. Escríbelo junto con una contraseña nueva para tu cuenta.';

  @override
  String get newPassword => 'Contraseña nueva';

  @override
  String get saveNewPassword => 'Guardar contraseña nueva';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String get backupHint =>
      'Haz una copia de seguridad para guardar tus gastos en tu cuenta. '
      'Restaurar trae esa copia a este teléfono sin borrar nada de lo que ya '
      'hay.';

  @override
  String get backUpNow => 'Hacer copia ahora';

  @override
  String get autoBackup => 'Copia automática';

  @override
  String get autoBackupHint =>
      'Cada vez que sales de la app, los cambios nuevos se guardan en tu cuenta.';

  @override
  String get restoreData => 'Restaurar';

  @override
  String get backingUp => 'Haciendo copia…';

  @override
  String get restoring => 'Restaurando…';

  @override
  String get backupDone => 'Copia completada';

  @override
  String get restoreDone => 'Restauración completada';

  @override
  String get neverSynced => 'Aún sin copia de seguridad';

  @override
  String lastSynced(String when) => 'Última sincronización: $when';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountBody =>
      'Esto elimina para siempre tu cuenta y la copia de tus gastos guardada '
      'en ella. No se puede deshacer. Los gastos de este teléfono se quedan '
      'aquí y puedes seguir usando la app sin cuenta.';

  @override
  String get deletingAccount => 'Eliminando tu cuenta…';

  @override
  String get accountDeleted => 'Tu cuenta se eliminó';

  @override
  String get home => 'Inicio';

  @override
  String get analyses => 'Análisis';

  @override
  String get vsLastMonth => 'Comparado con el mes pasado';

  @override
  String get noComparison => 'Sin datos del mes pasado';

  @override
  String get dailySpending => 'Gasto diario';

  @override
  String get dailyAverage => 'Promedio por día';

  @override
  String get topDay => 'Día más alto';

  @override
  String get byCategory => 'Gasto por categoría';

  @override
  String get noSpendingThisMonth => 'Aún no hay gastos este mes.';

  @override
  String get monthlyTrend => 'Últimos 6 meses';

  @override
  String lastMonthTotal(String amount) => 'Mes pasado: $amount';

  @override
  String get budgets => 'Presupuestos';

  @override
  String get monthlyBudget => 'Presupuesto mensual';

  @override
  String get setMonthlyBudget => 'Fija un presupuesto mensual';

  @override
  String get setBudgetHint =>
      'Mira cuánto te queda y recibe un aviso antes de gastar de más.';

  @override
  String get setBudget => 'Fijar';

  @override
  String get editBudget => 'Editar presupuesto';

  @override
  String get removeBudget => 'Quitar';

  @override
  String get save => 'Guardar';

  @override
  String amountLeft(String amount) => 'Quedan $amount';

  @override
  String amountOver(String amount) => '$amount por encima del presupuesto';

  @override
  String spentOfLimit(String spent, String limit) => '$spent gastado de $limit';

  @override
  String amountSpent(String amount) => '$amount gastado';

  @override
  String budgetUsed(String percent) => '$percent del presupuesto usado';

  @override
  String get categoryBudgets => 'Presupuestos por categoría';

  @override
  String get categoryBudgetsHint =>
      'Pon un límite a lo que gastas en una categoría.';

  @override
  String categoryBudgetTitle(String name) => 'Presupuesto de $name';

  @override
  String get setLimit => 'Fijar límite';

  @override
  String get closeToLimit => 'Cerca de su límite';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Los presupuestos se repiten cada mes. Recibirás un aviso cuando el '
      'gasto supere el $nearing y otro al llegar al $reached.';

  @override
  String get budgetAlertTitle => 'Aviso de presupuesto';

  @override
  String get ok => 'Aceptar';

  @override
  String get view => 'Ver';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Has usado el $percent de tu presupuesto mensual';

  @override
  String get monthlyBudgetUsedUp => 'Has usado todo tu presupuesto mensual';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Te pasaste $amount de tu presupuesto mensual';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Has usado el $percent de tu presupuesto de $name';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Has usado todo tu presupuesto de $name';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Te pasaste $amount de tu presupuesto de $name';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get dataManagementHint =>
      'Archivos que guardas tú. Funcionan sin conexión y sin cuenta.';

  @override
  String get backUpToFile => 'Copia de seguridad de mis datos';

  @override
  String get backUpToFileHint =>
      'Un archivo de copia completo que puedes importar después';

  @override
  String get exportCsv => 'Exportar como CSV';

  @override
  String get exportCsvHint => 'Para Excel o Google Sheets';

  @override
  String get exportPdf => 'Exportar como PDF';

  @override
  String get exportPdfHint => 'Un informe para leer, imprimir o compartir';

  @override
  String get importData => 'Importar datos';

  @override
  String get importDataHint => 'Restaurar desde un archivo de copia';

  @override
  String get preparingFile => 'Preparando tu archivo…';

  @override
  String get importingData => 'Importando…';

  @override
  String get fileSaved => 'Archivo guardado';

  @override
  String get importDone => 'Importación completada';

  @override
  String get importNothingNew =>
      'Este teléfono ya tenía todo lo que hay en la copia';

  @override
  String get fileReady => 'Tu archivo está listo';

  @override
  String get shareFile => 'Compartir';

  @override
  String get shareFileHint => 'WhatsApp, correo, Google Drive y más';

  @override
  String get saveToPhone => 'Guardar en este teléfono';

  @override
  String get saveToPhoneHint => 'Elige dónde guardarlo';

  @override
  String get importTitle => '¿Importar esta copia?';

  @override
  String get importMergeHint =>
      'Combinar conserva todo lo de este teléfono y añade lo que falta. '
      'Cuando un registro es distinto, gana el cambio más reciente.';

  @override
  String get merge => 'Combinar';

  @override
  String get replaceEverything => 'Reemplazar todo';

  @override
  String get replaceTitle => '¿Reemplazar todo en este teléfono?';

  @override
  String get replaceBody =>
      'Se borrará todo lo de este teléfono que no esté en la copia, y se '
      'usará la versión de la copia de cada registro. No se puede deshacer.';

  @override
  String get replace => 'Reemplazar';

  @override
  String get colDate => 'Fecha';

  @override
  String get colMonth => 'Mes';

  @override
  String get colAmount => 'Importe';

  @override
  String get colNote => 'Nota';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transacciones';

  @override
  String get colTotal => 'Total';

  @override
  String get colShare => 'Porcentaje';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get reportTitle => 'Mi Presupuesto: informe de gastos';

  @override
  String get reportPeriod => 'Periodo';

  @override
  String get reportTotal => 'Total gastado';

  @override
  String get reportMonthlyAverage => 'Promedio por mes';

  @override
  String get reportByMonth => 'Gasto por mes';

  @override
  String get reportAllExpenses => 'Todos los gastos';

  @override
  String get reportEmpty => 'Aún no hay gastos registrados.';

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
        ? '${expenseCount(expenses)} y ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} y '
              '${personCount(people)}';
    return date == null
        ? 'Esta copia tiene $contents.'
        : 'Copia del $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count categoría',
    other: '$count categorías',
  );

  @override
  String reportGenerated(String when) => 'Generado el $when';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Comida',
    'cat_transport' => 'Transporte',
    'cat_bills' => 'Facturas',
    'cat_shopping' => 'Compras',
    'cat_health' => 'Salud y deporte',
    'cat_entertainment' => 'Ocio',
    'cat_work' => 'Trabajo',
    'cat_other' => 'Otros',
    'cat_salary' => 'Sueldo',
    'cat_freelance' => 'Freelance',
    'cat_investments' => 'Inversiones',
    'cat_gifts' => 'Regalos',
    'cat_income_other' => 'Otros ingresos',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'No se pudo guardar en este dispositivo. Inténtalo de nuevo.',
    FailureCode.notFound => 'Ese elemento ya no existe.',
    FailureCode.unknown => 'Algo salió mal.',
    FailureCode.amountRequired => 'Escribe un importe mayor que cero.',
    FailureCode.amountTooLarge => 'Ese importe es demasiado grande.',
    FailureCode.amountInvalid => 'Escribe un importe válido.',
    FailureCode.categoryRequired => 'Elige una categoría.',
    FailureCode.categoryNameRequired => 'Ponle un nombre a la categoría.',
    FailureCode.categoryNameTaken => 'Ya tienes una categoría con este nombre.',
    FailureCode.categoryNameTooLong =>
      'El nombre debe tener menos de 30 caracteres.',
    FailureCode.categoryProtected => 'Esta categoría no se puede eliminar.',
    FailureCode.currencySymbolInvalid => 'Usa de 1 a 4 caracteres.',
    FailureCode.network =>
      'No se pudo conectar. Revisa tu conexión e inténtalo de nuevo.',
    FailureCode.emailInvalid => 'Escribe un correo válido.',
    FailureCode.passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres.',
    FailureCode.invalidCredentials => 'Correo o contraseña incorrectos.',
    FailureCode.emailTaken => 'Ya existe una cuenta con este correo.',
    FailureCode.emailNotConfirmed =>
      'Primero confirma tu correo con el código que te enviamos.',
    FailureCode.codeInvalid => 'Ese código es incorrecto o ha caducado.',
    FailureCode.signInRequired => 'Vuelve a iniciar sesión y prueba otra vez.',
    FailureCode.syncOtherAccount =>
      'Los datos de este teléfono están vinculados a otra cuenta.',
    FailureCode.syncFailed =>
      'No se pudo sincronizar con tu cuenta. Inténtalo de nuevo.',
    FailureCode.accountDeletionFailed =>
      'No se pudo eliminar tu cuenta. Inténtalo de nuevo.',
    FailureCode.backupNotRecognized =>
      'Este archivo no es una copia de Mi Presupuesto.',
    FailureCode.pastedNotRecognized =>
      'El texto pegado no son datos que la app pueda leer. Copia la respuesta completa de la IA e inténtalo de nuevo, o pídele que la corrija.',
    FailureCode.backupTooNew =>
      'Esta copia es de una versión más nueva de Mi Presupuesto. Actualiza '
          'la app y vuelve a intentarlo.',
    FailureCode.backupDamaged =>
      'Este archivo de copia está dañado, así que no se importó nada.',
    FailureCode.fileUnavailable =>
      'No se pudo abrir ese archivo. Prueba a elegirlo de nuevo.',
    FailureCode.storageFull => 'No hay suficiente espacio en este teléfono.',
    FailureCode.exportFailed =>
      'No se pudo crear el archivo. Inténtalo de nuevo.',
    FailureCode.shareUnavailable => 'No se pudo abrir el menú de compartir.',
    FailureCode.saveFailed =>
      'No se pudo guardar el archivo. Inténtalo de nuevo.',
    FailureCode.tooManyAttempts =>
      'Demasiados intentos. Espera un momento y vuelve a intentarlo.',
    FailureCode.titleRequired => 'Ponle un nombre.',
    FailureCode.titleTooLong => 'El nombre debe tener menos de 40 caracteres.',
    FailureCode.dueDayInvalid => 'Elige cuándo vence.',
    FailureCode.alreadyPaid => 'Ese pago ya está registrado.',
    FailureCode.personRequired => 'Elige una persona.',
    FailureCode.personNameRequired => 'Escribe un nombre.',
    FailureCode.personNameTooLong =>
      'El nombre debe tener menos de 40 caracteres.',
    FailureCode.phoneInvalid => 'Escribe un número de teléfono válido.',
    FailureCode.transactionSettled =>
      'Las transacciones saldadas no se pueden cambiar.',
    FailureCode.nothingToSettle => 'No hay nada que saldar.',
    FailureCode.settlementAlreadyLogged =>
      'Esta liquidación ya está en tu presupuesto.',
    FailureCode.questionRequired => 'Escribe una pregunta.',
    FailureCode.questionTooLong =>
      'La pregunta debe tener menos de 500 caracteres.',
    FailureCode.summaryTooLarge =>
      'Tus datos son demasiado grandes para resumirlos para el asistente.',
    FailureCode.aiUnavailable =>
      'El asistente no está disponible ahora. Inténtalo más tarde.',
    FailureCode.aiBusy => 'El asistente está ocupado. Inténtalo en un minuto.',
    FailureCode.aiDailyLimit =>
      'Ya hiciste las 20 preguntas de hoy. Inténtalo mañana.',
  };

  @override
  String get expenseDeleted => 'Gasto eliminado';

  @override
  String get expenseRestored => 'Gasto restaurado';

  @override
  String categoryAdded(String name) => '$name añadido';

  @override
  String get categoryUpdated => 'Categoría actualizada';

  @override
  String categoryDeleted(String name) => '$name eliminado';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name eliminada: ${expenseCount(count)} pasaron a Otros';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name eliminada: ${transactionCount(count)} pasaron a Otros ingresos';

  @override
  String get expense => 'Gasto';

  @override
  String get income => 'Ingreso';

  @override
  String get search => 'Buscar';

  @override
  String get searchHint => 'Busca notas o importes';

  @override
  String get searchPrompt =>
      'Encuentra cualquier movimiento por su nota o importe, o filtra por tipo, categoría y fecha.';

  @override
  String get noSearchResults => 'Ningún movimiento coincide';

  @override
  String get allTypes => 'Todo';

  @override
  String get anyCategory => 'Cualquier categoría';

  @override
  String get anyDate => 'Cualquier fecha';

  @override
  String get clearFilters => 'Quitar filtros';

  @override
  String get transactionType => 'Gasto o ingreso';

  @override
  String get quickIncome => 'Ingreso rápido';

  @override
  String get newIncome => 'Nuevo ingreso';

  @override
  String get editIncome => 'Editar ingreso';

  @override
  String get addIncome => 'Añadir ingreso';

  @override
  String get incomeNoteHint => '¿De dónde vino?';

  @override
  String get totalIncome => 'Ingresos totales';

  @override
  String get totalExpenses => 'Gastos totales';

  @override
  String get netBalance => 'Balance neto';

  @override
  String get savingsRate => 'Tasa de ahorro';

  @override
  String get savingsRateNoIncome => 'Añade ingresos para ver tu tasa de ahorro';

  @override
  String get expenseCategories => 'Categorías de gastos';

  @override
  String get incomeCategories => 'Categorías de ingresos';

  @override
  String get deleteIncomeCategoryBody =>
      'Los ingresos de esta categoría pasarán a Otros ingresos. No se '
      'elimina nada.';

  @override
  String get incomeDeleted => 'Ingreso eliminado';

  @override
  String get incomeRestored => 'Ingreso restaurado';

  @override
  String get colType => 'Tipo';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count transacción',
    other: '$count transacciones',
  );

  @override
  String get recurringPayments => 'Pagos recurrentes';

  @override
  String get newRecurring => 'Nuevo pago recurrente';

  @override
  String get editRecurring => 'Editar pago recurrente';

  @override
  String get addRecurring => 'Añadir pago';

  @override
  String get recurringTitle => 'Nombre';

  @override
  String get recurringTitleHint => 'Alquiler, Netflix, gimnasio…';

  @override
  String get amount => 'Importe';

  @override
  String get repeats => 'Se repite';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get dueOn => 'Vence';

  @override
  String get dueDayOfMonth => 'Día del mes';

  @override
  String get dueMonthLabel => 'Mes';

  @override
  String get dueDayLabel => 'Día';

  @override
  String get shortMonthHint => 'En los meses más cortos, cae en el último día.';

  @override
  String get whenDue => 'Al vencer';

  @override
  String get autoDeduct => 'Cobro automático';

  @override
  String get remindMe => 'Recordarme';

  @override
  String get autoDeductHint =>
      'Se registra como gasto automáticamente el día que vence.';

  @override
  String get remindMeHint =>
      'Tendrás que confirmar cada pago antes de que se registre.';

  @override
  String get statusPaid => 'Pagado';

  @override
  String get statusUpcoming => 'Próximo';

  @override
  String get statusOverdue => 'Vencido';

  @override
  String get markAsPaid => 'Marcar pago';

  @override
  String get dueToday => 'Vence hoy';

  @override
  String dueOnDate(String date) => 'Vence el $date';

  @override
  String nextDueOn(String date) => 'Próximo: $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Vencía el $date'
      : '${paymentCount(count)} vencidos desde el $date';

  @override
  String everyWeekday(String weekday) => 'Cada $weekday';

  @override
  String monthlyOnDay(String day) => 'Cada mes el día $day';

  @override
  String yearlyOn(String date) => 'Cada año el $date';

  @override
  String get monthlyAverage => 'Cada mes';

  @override
  String get monthlyAverageHint => 'Todos tus pagos recurrentes, en promedio';

  @override
  String get noRecurringYet => 'Aún no hay pagos recurrentes';

  @override
  String get noRecurringHint =>
      'Añade alquiler, facturas y suscripciones una sola vez. Cada mes verás '
      'qué está pagado y qué falta por pagar.';

  @override
  String get paymentsToConfirm => 'Pagos por confirmar';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get deleteRecurringBody =>
      'Dejará de repetirse. Los pagos ya registrados se quedan en tus '
      'transacciones.';

  @override
  String recurringPaid(String name) => '$name marcado como pagado';

  @override
  String recurringReceived(String name) => '$name marcado como recibido';

  @override
  String get statusReceived => 'Recibido';

  @override
  String get markAsReceived => 'Marcar recibido';

  @override
  String get autoAdd => 'Ingreso automático';

  @override
  String get autoAddHint =>
      'Se registra como ingreso automáticamente el día que vence.';

  @override
  String get monthlyIncomeAverage => 'Ingresos al mes';

  @override
  String get recurringPaymentUndone => 'Pago quitado';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: 'Se registró $count pago recurrente automáticamente',
    other: 'Se registraron $count pagos recurrentes automáticamente',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count pago',
    other: '$count pagos',
  );

  @override
  String get colPaidThrough => 'Pagado hasta';

  // People & debts

  @override
  String get people => 'Personas';

  @override
  String get peopleAndDebts => 'Personas y deudas';

  @override
  String get person => 'Persona';

  @override
  String get personName => 'Nombre';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneOptional => 'Teléfono (opcional)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Estado';

  @override
  String get owesYou => 'Te debe';

  @override
  String get youOwe => 'Debes';

  @override
  String get owedToYou => 'Te deben';

  @override
  String get settledUp => 'Saldado';

  @override
  String get iPaidForThem => 'Pagué por esta persona';

  @override
  String get theyPaidForMe => 'Pagó por mí';

  @override
  String get theyPaidYou => 'Te pagó';

  @override
  String get youPaidThem => 'Le pagaste';

  @override
  String get openStatus => 'Abierto';

  @override
  String get settledStatus => 'Saldado';

  @override
  String get settledOn => 'Saldado el';

  @override
  String get createdOn => 'Creado';

  @override
  String get lastEdited => 'Última edición';

  @override
  String get colEdits => 'Ediciones';

  @override
  String get activeTransactions => 'Transacciones activas';

  @override
  String get settledHistory => 'Historial saldado';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterOwedToMe => 'Me deben';

  @override
  String get filterIOwe => 'Debo';

  @override
  String get filterSettled => 'Saldados';

  @override
  String get addPerson => 'Añadir persona';

  @override
  String get addPersonHint => 'Alguien con quien compartes gastos';

  @override
  String get newPerson => 'Nueva persona';

  @override
  String get editPerson => 'Editar persona';

  @override
  String get deletePerson => 'Eliminar persona';

  @override
  String get quickTransaction => 'Transacción rápida';

  @override
  String get quickTransactionHint =>
      'Anota quién pagó, con alguien que ya añadiste';

  @override
  String get noPeopleYet => 'Aún no hay personas';

  @override
  String get noPeopleHint =>
      'Añade a las personas con quienes compartes gastos para saber quién le '
      'debe a quién.';

  @override
  String get nobodyHere => 'Nadie coincide con este filtro.';

  @override
  String get addPersonFirst => 'Primero añade una persona.';

  @override
  String get newTransaction => 'Nueva transacción';

  @override
  String get editTransaction => 'Editar transacción';

  @override
  String get transactionDetails => 'Detalles de la transacción';

  @override
  String get debtNoteHint => '¿Para qué fue?';

  @override
  String get changeHistory => 'Historial de cambios';

  @override
  String get edited => 'Editado';

  @override
  String get settleUp => 'Saldar';

  @override
  String get settle => 'Saldar';

  @override
  String get noDebtsYet => 'Aún no hay nada registrado';

  @override
  String get noDebtsHint =>
      'Añade lo que pagaste por esta persona o lo que pagó por ti.';

  @override
  String get settleEven =>
      'Estas transacciones se compensan, así que nadie tiene que pagar nada.';

  @override
  String get logSettlementTitle =>
      '¿Registrar esta liquidación en tu presupuesto mensual?';

  @override
  String get loggedInBudget => 'En tu presupuesto';

  @override
  String get deleteTransactionTitle => '¿Eliminar esta transacción?';

  @override
  String get deleteTransactionBody => 'Se quitará del saldo con esta persona.';

  @override
  String get deletePersonBody =>
      'También se eliminan sus transacciones y su historial saldado. Lo que '
      'registraste en tu presupuesto se queda.';

  @override
  String get settledLocked => 'Saldada, así que ya no se puede cambiar.';

  @override
  String get personUpdated => 'Persona actualizada';

  @override
  String get debtDeleted => 'Transacción eliminada';

  @override
  String get settledUpNotice => 'Todo saldado';

  @override
  String get settlementLogged => 'Añadido a tu presupuesto';

  @override
  String personOwesYou(String name) => '$name te debe';

  @override
  String youOwePerson(String name) => 'Le debes a $name';

  @override
  String settledWith(String name) => 'Todo saldado con $name';

  @override
  String settleUpFor(String amount) => 'Saldar $amount';

  @override
  String settleTitle(String name) => '¿Saldar cuentas con $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name te paga $amount para dejarlo todo en cero.';

  @override
  String settleYouPay(String name, String amount) =>
      'Le pagas $amount a $name para dejarlo todo en cero.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} pasarán al historial saldado.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount se añadirá como ingreso en Otros ingresos. Puedes moverlo a '
      'otra categoría después.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount se añadirá como gasto en Otros. Puedes moverlo a otra '
      'categoría después.';

  @override
  String settlementNote(String name) => 'Liquidación con $name';

  @override
  String settledGroupTitle(String date) => 'Saldado el $date';

  @override
  String deletePersonTitle(String name) => '¿Eliminar a $name?';

  @override
  String editedOn(String date) => 'Editado el $date';

  @override
  String wasValues(String values) => 'Antes: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count persona',
    other: '$count personas',
  );

  @override
  String get importFromAi => 'Desde otra app';

  @override
  String get importFromAiHint =>
      'Convierte tus datos con ChatGPT, Gemini, Claude u otra IA';

  @override
  String get aiImportTitle => 'Importar desde otra app';

  @override
  String get aiImportIntro =>
      'Un chat de IA puede convertir los datos de otra app o de una hoja de cálculo en un archivo que My Budget puede importar.';

  @override
  String get aiImportStep1 => 'Copia el prompt.';

  @override
  String get aiImportStep2 =>
      'Pégalo en ChatGPT, Gemini, Claude u otra IA y adjunta o pega tus datos.';

  @override
  String get aiImportStep3 =>
      'Copia la respuesta de la IA y pégala aquí, o guárdala como archivo y elígelo.';

  @override
  String get copyPrompt => 'Copiar prompt';

  @override
  String get pasteAnswer => 'Pegar respuesta';

  @override
  String get chooseFile => 'Elegir archivo';

  @override
  String get aiImportPrivacy =>
      'Tus datos se envían al servicio de IA que elijas. Verás lo que se importará antes de cambiar nada.';

  @override
  String get promptCopied => 'Prompt copiado';

  @override
  String get askTitle => 'Pregunta por tus gastos';

  @override
  String get askHint => 'Toca una pregunta para ver la respuesta.';

  @override
  String get askCompareMonths => 'Comparar meses';

  @override
  String get askTopCategory => 'Categoría principal';

  @override
  String get askVsLastMonth => 'vs mes pasado';

  @override
  String get askBiggestExpense => 'Mayor gasto';

  @override
  String get askTopDay => 'Día más caro';

  @override
  String get askWeekday => 'Día de más gasto';

  @override
  String get askMonthEnd => 'Estimación fin de mes';

  @override
  String get askSaved => '¿Ahorré?';

  @override
  String get askBudgetLeft => 'Presupuesto restante';

  @override
  String get askHighestLowest => 'Mes más alto y más bajo';

  @override
  String get askCount => 'Cuántos gastos';

  @override
  String get askTopIncome => 'Mayor ingreso';

  @override
  String get askAi => 'Pregunta a la IA';

  @override
  String get assistantTitle => 'Asistente de IA';

  @override
  String get assistantEmpty =>
      'Pregunta lo que quieras sobre tus gastos de los últimos tres meses.';

  @override
  String get assistantHint => 'Escribe una pregunta';

  @override
  String get assistantSend => 'Enviar';

  @override
  String get assistantSignInBody =>
      'Inicia sesión para usar el asistente de IA. Cada cuenta puede hacer 20 preguntas al día.';

  @override
  String get assistantConsentTitle => 'Antes de preguntar';

  @override
  String get assistantConsentBody =>
      'Para responder, la app envía tu pregunta, tus últimos mensajes y un resumen de tus totales de los últimos tres meses (por categoría, ingresos, gastos y presupuestos) a través de nuestro servidor al proveedor de IA Groq. Nunca se envían descripciones, notas ni nombres de personas. No guardamos tus preguntas ni las respuestas; nuestro servidor solo cuenta cuántas preguntas haces cada día. Puedes dejar de compartir en cualquier momento.';

  @override
  String get assistantConsentAgree => 'Acepto';

  @override
  String get assistantStopSharing => 'Dejar de compartir';

  @override
  String get assistantDisclaimer =>
      'Las respuestas de la IA pueden ser incorrectas. Comprueba las cifras importantes.';

  @override
  List<String> get assistantSuggestions => [
    '¿Dónde puedo ahorrar?',
    '¿Cómo va este mes frente al anterior?',
    '¿Voy bien con mi presupuesto?',
  ];

  @override
  String get otherCategories => 'Otras';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Lo que más gastaste: $category, $amount ($percent del mes).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Gastaste $amount más en $month que en $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Gastaste $amount menos en $month que en $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Gastaste lo mismo en $month y en $other.';

  @override
  String answerNothingIn(String month) => 'No hubo gastos en $month.';

  @override
  String answerRise(String category, String amount) =>
      'Mayor subida: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Mayor bajada: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Mayor gasto: $amount en $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Día más caro: $date, con $amount gastados.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Día de la semana con más gasto: $weekday ($amount este mes).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'A este ritmo (unos $average al día) gastarás alrededor de $amount a fin de mes.';

  @override
  String answerMonthTotal(String amount) =>
      'Este mes ya terminó: gastaste $amount en total.';

  @override
  String answerSaved(String amount, String income) =>
      'Ahorraste $amount de los $income que ganaste.';

  @override
  String answerOverspent(String amount) =>
      'Gastaste $amount más de lo que ganaste.';

  @override
  String get answerNoIncome => 'No hay ingresos registrados este mes.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Quedan $amount de tu presupuesto mensual ($percent usado).';

  @override
  String answerBudgetOver(String amount) =>
      'Te pasaste $amount de tu presupuesto mensual.';

  @override
  String get answerNoBudget => 'Aún no has definido un presupuesto mensual.';

  @override
  String answerOverLimit(String names) => 'Superaron su límite: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Mes más alto: $high ($highAmount). Más bajo: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Registraste ${expenseCount(count)}, $average de media cada uno.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'La mayor parte de tus ingresos vino de $category: $amount ($percent).';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => 'Libra egipcia',
    'USD' => 'Dólar estadounidense',
    'EUR' => 'Euro',
    'SAR' => 'Riyal saudí',
    'AED' => 'Dírham de los EAU',
    'KWD' => 'Dinar kuwaití',
    'QAR' => 'Riyal catarí',
    'BHD' => 'Dinar bareiní',
    'OMR' => 'Rial omaní',
    'JOD' => 'Dinar jordano',
    'IQD' => 'Dinar iraquí',
    'LBP' => 'Libra libanesa',
    'SYP' => 'Libra siria',
    'YER' => 'Rial yemení',
    'SDG' => 'Libra sudanesa',
    'LYD' => 'Dinar libio',
    'MAD' => 'Dírham marroquí',
    'TND' => 'Dinar tunecino',
    'DZD' => 'Dinar argelino',
    'GBP' => 'Libra esterlina',
    'TRY' => 'Lira turca',
    'IRR' => 'Rial iraní',
    'PKR' => 'Rupia pakistaní',
    'INR' => 'Rupia india',
    'RUB' => 'Rublo ruso',
    'UAH' => 'Grivna ucraniana',
    'PLN' => 'Esloti polaco',
    'CHF' => 'Franco suizo',
    'BRL' => 'Real brasileño',
    'CAD' => 'Dólar canadiense',
    'AUD' => 'Dólar australiano',
    'CNY' => 'Yuan chino',
    'JPY' => 'Yen japonés',
    'KRW' => 'Won surcoreano',
    'IDR' => 'Rupia indonesia',
    'MYR' => 'Ringgit malayo',
    'VND' => 'Dong vietnamita',
    'NGN' => 'Naira nigeriano',
    _ => null,
  };
}
