import { DeviceInfo } from '../model/DeviceInfo';
import { AppState } from '../state/AppState';

// 设备管理类：负责所有设备的增删改查、状态控制
export class DeviceManager {
  // 获取全局状态实例
  private appState: AppState = AppState.getInstance();

  // ---------------- 基础查询方法 ----------------
  // 获取所有设备列表
  getDeviceList(): DeviceInfo[] {
    return this.appState.deviceList;
  }

  // 根据设备ID获取单个设备
  getDeviceById(deviceId: string): DeviceInfo | undefined {
    return this.appState.deviceList.find(device => device.id === deviceId);
  }

  // ---------------- 设备控制方法 ----------------
  // 切换设备开关状态
  toggleDevice(deviceId: string): void {
    const device = this.getDeviceById(deviceId);
    if (device) {
      device.isOn = !device.isOn;
      console.info('DeviceManager', `设备【${device.name}】状态切换为：${device.isOn ? '开启' : '关闭'}`);
    }
  }

  // 调节灯光亮度（仅对灯光设备有效）
  adjustBrightness(deviceId: string, brightness: number): void {
    const device = this.getDeviceById(deviceId);
    if (device && device.type === 'light') {
      // 限制亮度范围在0-100之间
      device.brightness = Math.max(0, Math.min(100, brightness));
      console.info('DeviceManager', `设备【${device.name}】亮度调节为：${device.brightness}%`);
    }
  }
}