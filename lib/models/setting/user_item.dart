/// 用户管理中的用户类型
class UserItem {
  /// 用户角色：0 = 普通用户, 1 = 主管, 2 = 管理员
  final int role;

  /// 用户名
  final String userName;

  /// 用户 ID
  final String userId;

  /// 用户状态：1 = 启用, 0 = 禁用, -1 = 删除
  final int status;

  UserItem({
    required this.role,
    required this.userName,
    required this.userId,
    required this.status,
  });

  /// 从 JSON 创建
  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      role: json['role'] ?? 0,
      userName: json['userName'] ?? '',
      userId: json['userId']?.toString() ?? '',
      status: json['status'] ?? 0,
    );
  }

  /// 转 JSON
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'userName': userName,
      'userId': userId,
      'status': status,
    };
  }

  /// 获取用户类型
  UserType get userType {
    switch (role) {
      case 1:
        return UserType.manager;
      case 2:
        return UserType.admin;
      default:
        return UserType.normal;
    }
  }

  /// 获取用户状态
  UserStatus get userStatus {
    switch (status) {
      case -1:
        return UserStatus.deleted;
      case 0:
        return UserStatus.disabled;
      default:
        return UserStatus.enabled;
    }
  }
}

/// 用户角色枚举
enum UserType { normal, manager, admin }

/// 用户状态枚举
enum UserStatus { enabled, disabled, deleted }
