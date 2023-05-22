class DashboardResponse {
   Status? status;
   Data? data;

  DashboardResponse({
    this.status,
    this.data,
  });

  DashboardResponse.fromJson(Map<String, dynamic> json){
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() => {
    'status' : status?.toJson(),
    'data' : data?.toJson()
  };
}

class Status {
  final String? type;
  final String? message;
  final int? code;
  final String? error;

  Status({
    this.type,
    this.message,
    this.code,
    this.error,
  });

  Status.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        message = json['message'] as String?,
        code = json['code'] as int?,
        error = json['error'] as String?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'message' : message,
    'code' : code,
    'error' : error
  };
}

class Data {
  final User? user;

  Data({
    this.user,
  });

  Data.fromJson(Map<String, dynamic> json)
      : user = (json['user'] as Map<String,dynamic>?) != null ? User.fromJson(json['user'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'user' : user?.toJson()
  };
}

class User {
  final int? id;
  final int? plan;
  final String? name;
  final String? planName;
  final String? profilePic;
  final String? referralCode;
  final int? referredBy;
  final Contact? contact;
  final Deposits? deposits;
  final TotalEarnings? totalEarnings;
  final AdditionalEarnings? additionalEarnings;
  final Wallets? wallets;
  final PlanCredits? planCredits;
  final PoolPoints? poolPoints;

  User({
    this.id,
    this.plan,
    this.name,
    this.planName,
    this.profilePic,
    this.referralCode,
    this.referredBy,
    this.contact,
    this.deposits,
    this.totalEarnings,
    this.additionalEarnings,
    this.wallets,
    this.planCredits,
    this.poolPoints,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        plan = json['plan'] as int?,
        name = json['name'] as String?,
        planName = json['plan_name'] as String?,
        profilePic = json['profile_pic'] as String?,
        referralCode = json['referral_code'] as String?,
        referredBy = json['referred_by'] as int?,
        contact = (json['contact'] as Map<String,dynamic>?) != null ? Contact.fromJson(json['contact'] as Map<String,dynamic>) : null,
        deposits = (json['deposits'] as Map<String,dynamic>?) != null ? Deposits.fromJson(json['deposits'] as Map<String,dynamic>) : null,
        totalEarnings = (json['total_earnings'] as Map<String,dynamic>?) != null ? TotalEarnings.fromJson(json['total_earnings'] as Map<String,dynamic>) : null,
        additionalEarnings = (json['additional_earnings'] as Map<String,dynamic>?) != null ? AdditionalEarnings.fromJson(json['additional_earnings'] as Map<String,dynamic>) : null,
        wallets = (json['wallets'] as Map<String,dynamic>?) != null ? Wallets.fromJson(json['wallets'] as Map<String,dynamic>) : null,
        planCredits = (json['plan_credits'] as Map<String,dynamic>?) != null ? PlanCredits.fromJson(json['plan_credits'] as Map<String,dynamic>) : null,
        poolPoints = (json['pool_points'] as Map<String,dynamic>?) != null ? PoolPoints.fromJson(json['pool_points'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'plan' : plan,
    'name' : name,
    'plan_name' : planName,
    'profile_pic' : profilePic,
    'referral_code' : referralCode,
    'referred_by' : referredBy,
    'contact' : contact?.toJson(),
    'deposits' : deposits?.toJson(),
    'total_earnings' : totalEarnings?.toJson(),
    'additional_earnings' : additionalEarnings?.toJson(),
    'wallets' : wallets?.toJson(),
    'plan_credits' : planCredits?.toJson(),
    'pool_points' : poolPoints?.toJson()
  };
}

class Contact {
  final String? countryCode;
  final String? mobile;
  final String? email;

  Contact({
    this.countryCode,
    this.mobile,
    this.email,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : countryCode = json['country_code'] as String?,
        mobile = json['mobile'] as String?,
        email = json['email'] as String?;

  Map<String, dynamic> toJson() => {
    'country_code' : countryCode,
    'mobile' : mobile,
    'email' : email
  };
}

class Deposits {
  final String? walletAddress;

  Deposits({
    this.walletAddress,
  });

  Deposits.fromJson(Map<String, dynamic> json)
      : walletAddress = json['wallet_address'] as String?;

  Map<String, dynamic> toJson() => {
    'wallet_address' : walletAddress
  };
}

class TotalEarnings {
  final dynamic totalBonus;
  final String? ltgBalance;
  final String? levelBalance;
  final String? poolBalance;
  final String? defiBalance;
  final String? upgradeCreditsBalance;

  TotalEarnings({
    this.totalBonus,
    this.ltgBalance,
    this.levelBalance,
    this.poolBalance,
    this.defiBalance,
    this.upgradeCreditsBalance,
  });

  TotalEarnings.fromJson(Map<String, dynamic> json)
      : totalBonus = json['total_bonus'] as dynamic,
        ltgBalance = json['ltg_balance'] as String?,
        levelBalance = json['level_balance'] as String?,
        poolBalance = json['pool_balance'] as String?,
        defiBalance = json['defi_balance'] as String?,
        upgradeCreditsBalance = json['upgrade_credits_balance'] as String?;

  Map<String, dynamic> toJson() => {
    'total_bonus' : totalBonus,
    'ltg_balance' : ltgBalance,
    'level_balance' : levelBalance,
    'pool_balance' : poolBalance,
    'defi_balance' : defiBalance,
    'upgrade_credits_balance' : upgradeCreditsBalance
  };
}

class AdditionalEarnings {
  final String? itcconnectBalance;

  AdditionalEarnings({
    this.itcconnectBalance,
  });

  AdditionalEarnings.fromJson(Map<String, dynamic> json)
      : itcconnectBalance = json['itcconnect_balance'] as String?;

  Map<String, dynamic> toJson() => {
    'itcconnect_balance' : itcconnectBalance
  };
}

class Wallets {
  final String? eWalletBalance;
  final String? bonusWalletBalance;
  final String? gameWalletBalance;
  final String? upgradeCreditsWalletBalance;
  final String? archCoinsWalletBalance;
  final String? winWallet;

  Wallets({
    this.eWalletBalance,
    this.bonusWalletBalance,
    this.gameWalletBalance,
    this.upgradeCreditsWalletBalance,
    this.archCoinsWalletBalance,
    this.winWallet,
  });

  Wallets.fromJson(Map<String, dynamic> json)
      : eWalletBalance = json['e_wallet_balance'] as String?,
        bonusWalletBalance = json['bonus_wallet_balance'] as String?,
        gameWalletBalance = json['game_wallet_balance'] as String?,
        upgradeCreditsWalletBalance = json['upgrade_credits_wallet_balance'] as String?,
        archCoinsWalletBalance = json['arch_coins_wallet_balance'] as String?,
        winWallet = json['win_wallet'] as String?;

  Map<String, dynamic> toJson() => {
    'e_wallet_balance' : eWalletBalance,
    'bonus_wallet_balance' : bonusWalletBalance,
    'game_wallet_balance' : gameWalletBalance,
    'upgrade_credits_wallet_balance' : upgradeCreditsWalletBalance,
    'arch_coins_wallet_balance' : archCoinsWalletBalance,
    'win_wallet' : winWallet
  };
}

class PlanCredits {
  final StarPlans? starPlans;
  final ElitePlans? elitePlans;

  PlanCredits({
    this.starPlans,
    this.elitePlans,
  });

  PlanCredits.fromJson(Map<String, dynamic> json)
      : starPlans = (json['star_plans'] as Map<String,dynamic>?) != null ? StarPlans.fromJson(json['star_plans'] as Map<String,dynamic>) : null,
        elitePlans = (json['elite_plans'] as Map<String,dynamic>?) != null ? ElitePlans.fromJson(json['elite_plans'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'star_plans' : starPlans?.toJson(),
    'elite_plans' : elitePlans?.toJson()
  };
}

class StarPlans {
  final String? plan1;
  final String? plan2;
  final String? plan3;
  final String? plan4;
  final String? plan5;
  final String? plan6;
  final String? plan7;

  StarPlans({
    this.plan1,
    this.plan2,
    this.plan3,
    this.plan4,
    this.plan5,
    this.plan6,
    this.plan7,
  });

  StarPlans.fromJson(Map<String, dynamic> json)
      : plan1 = json['plan_1'] as String?,
        plan2 = json['plan_2'] as String?,
        plan3 = json['plan_3'] as String?,
        plan4 = json['plan_4'] as String?,
        plan5 = json['plan_5'] as String?,
        plan6 = json['plan_6'] as String?,
        plan7 = json['plan_7'] as String?;

  Map<String, dynamic> toJson() => {
    'plan_1' : plan1,
    'plan_2' : plan2,
    'plan_3' : plan3,
    'plan_4' : plan4,
    'plan_5' : plan5,
    'plan_6' : plan6,
    'plan_7' : plan7
  };
}

class ElitePlans {
  final String? plan8;
  final String? plan9;
  final String? plan10;
  final String? plan11;
  final String? plan12;

  ElitePlans({
    this.plan8,
    this.plan9,
    this.plan10,
    this.plan11,
    this.plan12,
  });

  ElitePlans.fromJson(Map<String, dynamic> json)
      : plan8 = json['plan_8'] as String?,
        plan9 = json['plan_9'] as String?,
        plan10 = json['plan_10'] as String?,
        plan11 = json['plan_11'] as String?,
        plan12 = json['plan_12'] as String?;

  Map<String, dynamic> toJson() => {
    'plan_8' : plan8,
    'plan_9' : plan9,
    'plan_10' : plan10,
    'plan_11' : plan11,
    'plan_12' : plan12
  };
}

class PoolPoints {
  final ElitePoolPoints? elitePoolPoints;
  final GamePoolPoints? gamePoolPoints;

  PoolPoints({
    this.elitePoolPoints,
    this.gamePoolPoints,
  });

  PoolPoints.fromJson(Map<String, dynamic> json)
      : elitePoolPoints = (json['elite_pool_points'] as Map<String,dynamic>?) != null ? ElitePoolPoints.fromJson(json['elite_pool_points'] as Map<String,dynamic>) : null,
        gamePoolPoints = (json['game_pool_points'] as Map<String,dynamic>?) != null ? GamePoolPoints.fromJson(json['game_pool_points'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'elite_pool_points' : elitePoolPoints?.toJson(),
    'game_pool_points' : gamePoolPoints?.toJson()
  };
}

class ElitePoolPoints {
  final Self? self;
  final Level? level;

  ElitePoolPoints({
    this.self,
    this.level,
  });

  ElitePoolPoints.fromJson(Map<String, dynamic> json)
      : self = (json['self'] as Map<String,dynamic>?) != null ? Self.fromJson(json['self'] as Map<String,dynamic>) : null,
        level = (json['level'] as Map<String,dynamic>?) != null ? Level.fromJson(json['level'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'self' : self?.toJson(),
    'level' : level?.toJson()
  };
}

class Self {
  final int? plan8;
  final int? plan9;
  final int? plan10;
  final int? plan11;
  final int? plan12;

  Self({
    this.plan8,
    this.plan9,
    this.plan10,
    this.plan11,
    this.plan12,
  });

  Self.fromJson(Map<String, dynamic> json)
      : plan8 = json['plan_8'] as int?,
        plan9 = json['plan_9'] as int?,
        plan10 = json['plan_10'] as int?,
        plan11 = json['plan_11'] as int?,
        plan12 = json['plan_12'] as int?;

  Map<String, dynamic> toJson() => {
    'plan_8' : plan8,
    'plan_9' : plan9,
    'plan_10' : plan10,
    'plan_11' : plan11,
    'plan_12' : plan12
  };
}

class Level {
  final int? plan8;
  final int? plan9;
  final int? plan10;
  final int? plan11;
  final int? plan12;

  Level({
    this.plan8,
    this.plan9,
    this.plan10,
    this.plan11,
    this.plan12,
  });

  Level.fromJson(Map<String, dynamic> json)
      : plan8 = json['plan_8'] as int?,
        plan9 = json['plan_9'] as int?,
        plan10 = json['plan_10'] as int?,
        plan11 = json['plan_11'] as int?,
        plan12 = json['plan_12'] as int?;

  Map<String, dynamic> toJson() => {
    'plan_8' : plan8,
    'plan_9' : plan9,
    'plan_10' : plan10,
    'plan_11' : plan11,
    'plan_12' : plan12
  };
}

class GamePoolPoints {
  final SelfDash? self;
  final LevelDash? level;

  GamePoolPoints({
    this.self,
    this.level,
  });

  GamePoolPoints.fromJson(Map<String, dynamic> json)
      : self = (json['self'] as Map<String,dynamic>?) != null ? SelfDash.fromJson(json['self'] as Map<String,dynamic>) : null,
        level = (json['level'] as Map<String,dynamic>?) != null ? LevelDash.fromJson(json['level'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'self' : self?.toJson(),
    'level' : level?.toJson()
  };
}

class SelfDash {
  final int? plan1;
  final int? plan2;
  final int? plan3;
  final int? plan4;
  final int? plan5;
  final int? plan6;
  final int? plan7;

  SelfDash({
    this.plan1,
    this.plan2,
    this.plan3,
    this.plan4,
    this.plan5,
    this.plan6,
    this.plan7,
  });

  SelfDash.fromJson(Map<String, dynamic> json)
      : plan1 = json['plan_1'] as int?,
        plan2 = json['plan_2'] as int?,
        plan3 = json['plan_3'] as int?,
        plan4 = json['plan_4'] as int?,
        plan5 = json['plan_5'] as int?,
        plan6 = json['plan_6'] as int?,
        plan7 = json['plan_7'] as int?;

  Map<String, dynamic> toJson() => {
    'plan_1' : plan1,
    'plan_2' : plan2,
    'plan_3' : plan3,
    'plan_4' : plan4,
    'plan_5' : plan5,
    'plan_6' : plan6,
    'plan_7' : plan7
  };
}

class LevelDash {
  final int? plan1;
  final int? plan2;
  final int? plan3;
  final int? plan4;
  final int? plan5;
  final int? plan6;
  final int? plan7;

  LevelDash({
    this.plan1,
    this.plan2,
    this.plan3,
    this.plan4,
    this.plan5,
    this.plan6,
    this.plan7,
  });

  LevelDash.fromJson(Map<String, dynamic> json)
      : plan1 = json['plan_1'] as int?,
        plan2 = json['plan_2'] as int?,
        plan3 = json['plan_3'] as int?,
        plan4 = json['plan_4'] as int?,
        plan5 = json['plan_5'] as int?,
        plan6 = json['plan_6'] as int?,
        plan7 = json['plan_7'] as int?;

  Map<String, dynamic> toJson() => {
    'plan_1' : plan1,
    'plan_2' : plan2,
    'plan_3' : plan3,
    'plan_4' : plan4,
    'plan_5' : plan5,
    'plan_6' : plan6,
    'plan_7' : plan7
  };
}