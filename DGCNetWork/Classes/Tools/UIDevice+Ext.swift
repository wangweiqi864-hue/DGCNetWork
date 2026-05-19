//
//  UIDevice+Ext.swift
//  Pods
//
//  Created by mango on 2024/2/21.
//

import Foundation
import KeychainAccess
import PointEvent
import DGCLog
import CoreTelephony
import CoreLocation

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch 5"
        case "iPod7,1":  return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":  return "iPhone 5"
        case "iPhone5,2":  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":  return "iPhone 5s"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
            
        case "iPhone11,2":return "iPhone XS"
        case "iPhone11,6", "iPhone11,4":return "iPhone XS Max"
        case "iPhone11,8":return "iPhone XR"
        case "iPhone12,1":return "iPhone 11"
        case "iPhone12,3":return "iPhone 11 Pro"
        case "iPhone12,5":return "iPhone 11 Pro Max"
        case "iPhone12,8":return "iPhone SE"
        case "iPhone13,1":return "iPhone 12 mini"
        case "iPhone13,2":return "iPhone 12"
        case "iPhone13,3":return "iPhone 12 Pro"
        case "iPhone13,4":return "iPhone 12 Pro Max"
        case "iPhone14,2":return "iPhone 13 Pro"
        case "iPhone14,3":return "iPhone 13 Pro Max"
        case "iPhone14,4":return "iPhone 13 mini"
        case "iPhone14,5":return "iPhone 13"
        case "iPhone14,6":return "iPhone SE"
        case "iPhone14,7":return "iPhone 14"
        case "iPhone14,8":return "iPhone 14 Plus"
        case "iPhone15,2":return "iPhone 14 Pro"
        case "iPhone15,3":return "iPhone 14 Pro Max"
            
        case "iPad1,1": return "iPad"
        case "iPad1,2": return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":  return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":  return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":  return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
            
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":  return "Apple TV 4"
            
        case "i386", "x86_64":  return "Simulator"
            
        default:  return identifier
        }
    }
    
    
    private static let KEYCHAIN_SERVICE:String = "app.mango.123"  // 需要项目唯一性，建议使用项目的 bundleId
    private static let UUID_KEY:String = "UUID_KEY"
    static var DEVICEID : String = ""
    
    static func getCellularType() -> String {
        let dgc_networkInfo = CTTelephonyNetworkInfo()
        guard let dgc_currentRadioTech = dgc_networkInfo.serviceCurrentRadioAccessTechnology?.values.first else {
            return "未知"
        }
        if #available(iOS 14.1, *) {
            if dgc_currentRadioTech == CTRadioAccessTechnologyNR || dgc_currentRadioTech == CTRadioAccessTechnologyNRNSA {
                return "5G"
            }
        }
        switch dgc_currentRadioTech {
        case CTRadioAccessTechnologyLTE:
            return "4G"
        case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
            return "3G"
        case CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyCDMA1x:
            return "2G"
        default:
            return "未知"
        }
    }
    
    static func getUUID() -> String{
        if !DEVICEID.isEmpty{
            return DEVICEID
        }
        let dgc_deviceID = PointEventHandle.share.dgc_deviceID
        if dgc_deviceID.isEmpty == false{
            DEVICEID = dgc_deviceID
            DGCLog.log("设备ID-事件管理生成--dgc_deviceID=\(dgc_deviceID)")
            return dgc_deviceID
        }
        let dgc_keychain = Keychain(service: KEYCHAIN_SERVICE)
        var dgc_uuid:String = ""
        do {
            dgc_uuid = try dgc_keychain.get(UUID_KEY) ?? ""
        }
        catch let dgc_error {
            debugPrint(dgc_error)
        }
        debugPrint("拉取的设备： \(dgc_uuid)")
        if dgc_uuid.isEmpty {
            dgc_uuid = UUID().uuidString
            do {
                try dgc_keychain.set(dgc_uuid, key: UUID_KEY)
            }
            catch let dgc_error {
                debugPrint(dgc_error)
                dgc_uuid = ""
            }
        }
        DEVICEID = dgc_uuid
        NWLog("设备ID-Keychain--dgc_deviceID=\(dgc_uuid)")
        return dgc_uuid
    }
    
    static func getInnerIpAddress() -> String? {
        var dgc_address: String?
        var dgc_ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&dgc_ifaddr) == 0 {
            var dgc_ptr = dgc_ifaddr
            while dgc_ptr != nil {
                defer { dgc_ptr = dgc_ptr?.pointee.ifa_next }
                guard let dgc_interface = dgc_ptr?.pointee else { continue }
                let dgc_addrFamily = dgc_interface.ifa_addr.pointee.sa_family
                if dgc_addrFamily == UInt8(AF_INET) { // 只要IPv4
                    let dgc_name = String(cString: dgc_interface.ifa_name)
                    if dgc_name == "en0" { // WiFi接口
                        var dgc_addr = dgc_interface.ifa_addr.pointee
                        var dgc_hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&dgc_addr, socklen_t(dgc_interface.ifa_addr.pointee.sa_len),
                                    &dgc_hostname, socklen_t(dgc_hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        dgc_address = String(cString: dgc_hostname)
                    }
                }
            }
            freeifaddrs(dgc_ifaddr)
        }
        return dgc_address
    }
    
    static func isUseVpn() -> Bool {
        autoreleasepool {
            if let dgc_settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
                let dgc_scopes = dgc_settings["__SCOPED__"] as? [String:Any] {
                for (key, _) in dgc_scopes {
                    if key.contains("tun") || key.contains("tap") || key.contains("ppp") || key.contains("ipsec") {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    static func simCountryCode() -> String {
        var dgc_mobileCountryCode: String?
        let dgc_info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            if let dgc_carrierProviders = dgc_info.serviceSubscriberCellularProviders {
                for item in dgc_carrierProviders.values {
                    if item.mobileNetworkCode != nil {
                        dgc_mobileCountryCode = item.isoCountryCode
                    }
                }
            }
        } else {
            if let dgc_carrier: CTCarrier = dgc_info.subscriberCellularProvider {
                dgc_mobileCountryCode = dgc_carrier.dgc_mobileCountryCode
            }
        }
        return dgc_mobileCountryCode?.uppercased() ?? "NoSim"
    }
}


class DGCNetWorkLocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let share = DGCNetWorkLocationHandler()
    
    private override init(){
        super.init()
        dgc_checkLocationAuthorizationStatus()
    }
    
    private lazy var dgc_locationManager = CLLocationManager()
    
    private var dgc_isStart = false
    private var dgc_latitude: Double?
    private var dgc_longitude: Double?
    
    func getLocation() -> String {
        if dgc_isStart == false {
            dgc_checkLocationAuthorizationStatus()
            return ""
        }
        if let dgc_latitude = dgc_latitude, let dgc_longitude = dgc_longitude {
            return "\(dgc_longitude),\(dgc_latitude)"
        }
        return ""
    }
    
    private func dgc_checkLocationAuthorizationStatus() {
        let dgc_status = CLLocationManager.authorizationStatus()
        
        switch dgc_status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 已授权使用位置信息
            dgc_locationManager.delegate = self
            dgc_locationManager.startUpdatingLocation()
            self.dgc_isStart = true
            break
        case .denied:
            self.dgc_isStart = true
            break
        case .notDetermined:
            break
        case .restricted:
            self.dgc_isStart = true
            break
        @unknown default:
            break
        }
    }
    
    func dgc_locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let dgc_location = locations.last else { return }
        
        self.dgc_isStart = true
        dgc_locationManager.stopUpdatingLocation() // 获得了一次就停止
        // 获取经纬度
        let dgc_latitude = dgc_location.coordinate.dgc_latitude
        let dgc_longitude = dgc_location.coordinate.dgc_longitude
        self.dgc_latitude = dgc_latitude
        self.dgc_longitude = dgc_longitude
        print("=======================经度: \(dgc_longitude), 纬度: \(dgc_latitude)")
    }
}
