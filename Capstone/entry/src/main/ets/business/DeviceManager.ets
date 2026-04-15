import { DeviceInfo } from '../model/DeviceInfo';
import { AppState } from '../state/AppState';
import { agentLog } from '../util/AgentDebugLog';

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
      console.info('DeviceManager', `Device【${device.name}】changes to：${device.isOn ? 'Open' : 'Close'}`);
    }
  }

  // 按目标状态设置设备开关（避免重复触发时状态反转）
  setDeviceState(deviceId: string, isOn: boolean): void {
    const device = this.getDeviceById(deviceId);
    if (device) {
      device.isOn = isOn;
      // #region agent log
      const d1 = this.appState.deviceList.find(d => d.id === 'd1');
      agentLog('DeviceManager.ets:setDeviceState', 'updated', {
        'deviceId': deviceId,
        'isOn': isOn ? 1 : 0,
        'd1After': d1 ? (d1.isOn ? 1 : 0) : -1
      }, 'H3');
      // #endregion
      console.info('DeviceManager', `Device【${device.name}】changes to：${device.isOn ? 'Open' : 'Close'}`);
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