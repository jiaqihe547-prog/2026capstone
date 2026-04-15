import { SceneInfo } from '../model/SceneInfo';
import { AppState } from '../state/AppState';
import { DeviceManager } from './DeviceManager';

// 场景管理类：负责场景的查询、执行
export class SceneManager {
  // 获取全局状态实例
  private appState: AppState = AppState.getInstance();
  // 引入设备管理类，用来执行场景里的设备动作
  private deviceManager: DeviceManager = new DeviceManager();

  // ---------------- 基础查询方法 ----------------
  // 获取所有场景列表
  getSceneList(): SceneInfo[] {
    return this.appState.sceneList;
  }

  // 根据场景ID获取单个场景
  getSceneById(sceneId: string): SceneInfo | undefined {
    return this.appState.sceneList.find(scene => scene.id === sceneId);
  }

  // ---------------- Scene execution method ----------------
  // Execute the specified scenario (core function)
  executeScene(sceneId: string): void {
    const scene = this.getSceneById(sceneId);
    if (!scene) {
      console.warn('SceneManager', `Can't find id:【${sceneId}】 scene`);
      return;
    }

    console.info('SceneManager', `Start execution scenario: 【${scene.name}】`);
    // Traverse the action list of the scene and execute them one by one
    scene.actions.forEach(action => {
      // Find the corresponding device
      const device = this.appState.deviceList.find(d => d.id === action.deviceId);
      if (device) {
        // Update the switch status of the device
        device.isOn = action.targetState;
        // 如果是灯光设备，同时更新亮度
        if (action.targetBrightness !== undefined && device.type === 'light') {
          device.brightness = action.targetBrightness;
        }
        console.info('SceneManager', `Device【${device.name}】 has updated status`);
      }
    });
    console.info('SceneManager', `Scene【${scene.name}】 execution is completed`);
  }
}