import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/affiliate_model.dart';

class AffiliateService {
  final supabase = Supabase.instance.client;

  Future<List<AffiliateModel>> fetchAffiliates() async {
    final response = await supabase.from('affiliates').select();

    return (response as List).map((json) => AffiliateModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      username: json['username'],
      password: json['password'],
      point: json['point'],
      referralCode: json['referral_code'],
    )).toList();
  }
}
