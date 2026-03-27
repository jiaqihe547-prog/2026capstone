import { DeviceInfo } from '../model/DeviceInfo';
import { SceneInfo, SceneAction } from '../model/SceneInfo';
import { CommonConstants } from '../constant/CommonConstants';

// 全局响应式状态类（单例模式，整个项目共用这一个状态）
@Observed
export class AppState {
  // ---------------- 核心状态数据 ----------------
  // 智能设备列表
  deviceList: DeviceInfo[] = [];
  // 场景列表
  sceneList: SceneInfo[] = [];
  // 当前选中的设备（用于详情页）
  selectedDevice: DeviceInfo | null = null;
  // 分布式连接状态
  isDistributedConnected: boolean = false;

  // ---------------- 单例模式（全局唯一实例） ----------------
  private static instance: AppState;
  static getInstance(): AppState {
    if (!AppState.instance) {
      AppState.instance = new AppState();
    }
    return AppState.instance;
  }

  // ---------------- 初始化模拟数据（用于测试，不用连真实设备） ----------------
  initMockData(): void {
    // 1. 初始化模拟设备：客厅主灯、卧室台灯、客厅插座
    this.deviceList = [
      new DeviceInfo('d1', 'Living room light', CommonConstants.DEVICE_TYPE_LIGHT, 'Living room'),
      new DeviceInfo('d2', 'Bedroom lamp', CommonConstants.DEVICE_TYPE_LIGHT, 'Bedroom'),
      new DeviceInfo('d3', 'Living room socket', CommonConstants.DEVICE_TYPE_SOCKET, 'Living room')
    ];

    // 2. 初始化模拟场景：离家模式、回家模式
    this.sceneList = [
      // 离家模式：关闭所有设备
      new SceneInfo(
        CommonConstants.SCENE_ID_AWAY,
        'Leaving home model',
        '🏠',
        [
          new SceneAction('d1', false),
          new SceneAction('d2', false),
          new SceneAction('d3', false)
        ]
      ),
      // 回家模式：打开客厅主灯和插座
      new SceneInfo(
        CommonConstants.SCENE_ID_HOME,
        'Back home model',
        '🚪',
        [
          new SceneAction('d1', true, 80),
          new SceneAction('d3', true)
        ]
      )
    ];
  }
}