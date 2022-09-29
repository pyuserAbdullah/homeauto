import '../utils/custom_exception.dart';
import '../utils/network_util.dart';
import '/utils/api_response.dart';

class SharedDevices {
  int? status;
  String? message;
  int? total;
  List<Info>? info;

  SharedDevices({this.status, this.message, this.total, this.info});

  SharedDevices.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    if (json['info'] != null) {
      info = <Info>[];
      json['info'].forEach((v) {
        info!.add(new Info.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String? id;
  String? userId;
  String? homeId;
  String? roomId;
  String? userRole;
  String? shared;
  String? deviceId;
  String? deviceName;
  String? active;

  Info(
      {this.id,
      this.userId,
      this.homeId,
      this.roomId,
      this.userRole,
      this.shared,
      this.deviceId,
      this.deviceName,
      this.active});

  Info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    homeId = json['home_id'];
    roomId = json['room_id'];
    userRole = json['user_role'];
    shared = json['shared'];
    deviceId = json['device_id'];
    deviceName = json['device_name'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['home_id'] = this.homeId;
    data['room_id'] = this.roomId;
    data['user_role'] = this.userRole;
    data['shared'] = this.shared;
    data['device_id'] = this.deviceId;
    data['device_name'] = this.deviceName;
    data['active'] = this.active;
    return data;
  }
}

class RequestSharedDevices {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseURL = 'http://care-engg.com/api/device';
  static final deviceInfoURL = baseURL + "/shared";

  Future<SharedDevices> getDevicesInfo(String user) async {
    return _netUtil
        .post(deviceInfoURL, body: {"user_id": user}).then((dynamic res) {
      print(res.toString());
      if (res["status"] == 0) throw new FormException(res["message"]);
      return SharedDevices.fromJson(res);
    });
  }
}

abstract class SharedDevicesContract {
  void onSharedDeviceSuccess(SharedDevices deviceInfo);
  void onSharedDeviceError();
}

class SharedDevicesPresenter {
  SharedDevicesContract _view;
  RequestSharedDevices api = new RequestSharedDevices();
  SharedDevicesPresenter(this._view);

  doGetSharedDevices(String user_id) async {
    try {
      var devicesInfo = await api.getDevicesInfo(user_id);
      if (devicesInfo == null) {
        _view.onSharedDeviceError();
      } else {
        _view.onSharedDeviceSuccess(devicesInfo);
      }
    } on Exception catch (error) {
      print(error.toString());
      _view.onSharedDeviceError();
    }
  }
}
