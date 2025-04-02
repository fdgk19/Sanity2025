class FirestorePath {
  static String user(String uid) => 'users/$uid';
  static String users() => 'users';
  static String post(String pid) => 'posts/$pid';
  static String posts() => 'posts';
  static String sections(String pid) => 'posts/$pid/sections';
  static String section(String pid, String sid) => 'posts/$pid/sections/$sid';
  static String notification(String nid) => 'notifications/$nid';
  static String notifications() => 'notifications';
  static String subscription(String sid) => 'subscriptions/$sid';
  static String subscriptions() => 'subscriptions';
}