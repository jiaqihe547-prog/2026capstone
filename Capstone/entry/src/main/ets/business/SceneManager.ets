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

  // ---------------- 场景执行方法 ----------------
  // 执行指定场景（核心功能）
  executeScene(sceneId: string): void {
    const scene = this.getSceneById(sceneId);
    if (!scene) {
      console.warn('SceneManager', `未找到ID为【${sceneId}】的场景`);
      return;
    }

    console.info('SceneManager', `开始执行场景：【${scene.name}】`);
    // 遍历场景的动作列表，逐个执行
    scene.actions.forEach(action => {
      // 找到对应的设备
      const device = this.appState.deviceList.find(d => d.id === action.deviceId);
      if (device) {
        // 更新设备开关状态
        device.isOn = action.targetState;
        // 如果是灯光设备，同时更新亮度
        if (action.targetBrightness !== undefined && device.type === 'light') {
          device.brightness = action.targetBrightness;
        }
        console.info('SceneManager', `设备【${device.name}】已更新状态`);
      }
    });
    console.info('SceneManager', `场景【${scene.name}】执行完成`);
  }
}