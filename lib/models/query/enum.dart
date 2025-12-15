enum TransactionType {
  all,
  sale,
  voidTrans,
  failed,
}

extension TransactionTypeExtension on TransactionType {
  int getType() {
    switch (this) {
      case TransactionType.all:
        return 0;
      case TransactionType.sale:
        return 1;
      case TransactionType.voidTrans:
        return 2;
      case TransactionType.failed:
        return 3;
    }
  }
}
