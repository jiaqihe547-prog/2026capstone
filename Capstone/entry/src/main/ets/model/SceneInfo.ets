import { DeviceInfo } from './DeviceInfo';

// 场景动作数据模型类：定义一个场景要执行的单个设备动作
@Observed
export class SceneAction {
  // 要控制的设备ID
  deviceId: string;
  // 设备的目标开关状态
  targetState: boolean;
  // 设备的目标亮度（仅灯光设备需要）
  targetBrightness?: number;

  // 构造函数
  constructor(deviceId: string, targetState: boolean, targetBrightness?: number) {
    this.deviceId = deviceId;
    this.targetState = targetState;
    this.targetBrightness = targetBrightness;
  }
}

// 场景数据模型类：定义一个完整的场景（如“离家模式”）
@Observed
export class SceneInfo {
  // 场景唯一ID
  id: string;
  // 场景名称（如“离家模式”）
  name: string;
  // 场景图标（用Emoji表示，如“🏠”）
  icon: string;
  // 场景要执行的动作列表
  actions: SceneAction[];

  // 构造函数
  constructor(id: string, name: string, icon: string, actions: SceneAction[]) {
    this.id = id;
    this.name = name;
    this.icon = icon;
    this.actions = actions;
  }
}